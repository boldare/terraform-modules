import os
import shutil
import boto3
import certbot.main
import logging
from datetime import datetime
import OpenSSL

logging.getLogger('boto3').setLevel(logging.CRITICAL)
logging.getLogger('botocore').setLevel(logging.CRITICAL)
logging.getLogger('s3transfer').setLevel(logging.CRITICAL)
logging.getLogger('urllib3').setLevel(logging.CRITICAL)

# Let’s Encrypt acme-v02 server that supports wildcard certificates
CERTBOT_SERVER = 'https://acme-v02.api.letsencrypt.org/directory'

# Temp dir of Lambda runtime
CERTBOT_DIR = '/tmp/certbot'


def rm_tmp_dir():
    if os.path.exists(CERTBOT_DIR):
        try:
            shutil.rmtree(CERTBOT_DIR)
        except NotADirectoryError:
            os.remove(CERTBOT_DIR)

def renew_certs():
    return certbot.main.main([
        # Override directory paths so script doesn't have to be run as root
        '--config-dir', CERTBOT_DIR,
        '--work-dir', CERTBOT_DIR,
        '--logs-dir', CERTBOT_DIR,

        # Refresh a cert
        'renew'
    ])

def get_cert_expiration_date(certificate_path):
    cert_file = open(certificate_path)
    cert_content = cert_file.read()
    cert_file.close()
    cert = OpenSSL.crypto.load_certificate(OpenSSL.crypto.FILETYPE_PEM, cert_content)
    return datetime.strptime(cert.get_notAfter().decode("utf-8"), "%Y%m%d%H%M%SZ")

def get_cert_expires_in_days(certificate_path):
    cert_expiration = get_cert_expiration_date(certificate_path)
    return (cert_expiration - datetime.now()).days

def obtain_certs(email, domains):
    certbot_args = [
        # Override directory paths so script doesn't have to be run as root
        '--config-dir', CERTBOT_DIR,
        '--work-dir', CERTBOT_DIR,
        '--logs-dir', CERTBOT_DIR,

        # Obtain a cert but don't install it
        'certonly',

        # Run in non-interactive mode
        '--non-interactive',

        # Agree to the terms of service
        '--agree-tos',
        '--manual-public-ip-logging-ok',

        # Email of domain administrator
        '--email', email,

        # Use dns challenge with route53
        '--dns-route53',
        '--dns-route53-propagation-seconds', '30',

        '--preferred-challenges', 'dns',

        # Use this server instead of default acme-v01
        '--server', CERTBOT_SERVER,

        # Domains to provision certs for (comma separated)
        '--domains', domains,
    ]
    return certbot.main.main(certbot_args)


# /tmp/certbot
# ├── live
# │   └── [domain]
# │       ├── README
# │       ├── cert.pem
# │       ├── chain.pem
# │       ├── fullchain.pem
# │       └── privkey.pem
def upload_certs(cert_dir, s3_bucket, s3_prefix):
    client = boto3.client('s3')
    for dirpath, _dirnames, filenames in os.walk(cert_dir):
        for filename in filenames:
            local_path = os.path.join(dirpath, filename)
            relative_path = os.path.relpath(local_path, cert_dir)
            s3_key = os.path.join(s3_prefix, filename)
            print(f'Uploading: {local_path} => s3://{s3_bucket}/{s3_key}')
            client.upload_file(local_path, s3_bucket, s3_key)


def download_certs(cert_dir, s3_bucket, s3_prefix):
    s3_resource = boto3.resource('s3')
    bucket = s3_resource.Bucket(s3_bucket)

    for obj in bucket.objects.filter(Prefix=s3_prefix):
        dest = os.path.join(cert_dir, os.path.basename(obj.key))
        os.makedirs(os.path.dirname(dest), exist_ok=True)
        print(f'Downloading: s3://{s3_bucket}/{obj.key} => {dest}')
        bucket.download_file(obj.key, dest)


def guarded_handler(event, context):
    # Input parameters
    email = os.environ['EMAIL']
    domains = os.environ['DOMAINS']
    s3_bucket = os.environ['S3_BUCKET']  # The S3 bucket to publish certificates
    s3_prefix = os.environ['S3_PREFIX']  # The S3 key prefix to publish certificates

    base_domain = domains.split(',')[0]
    cert_dir = os.path.join(CERTBOT_DIR, 'live', base_domain)
    renewal_config_path = os.path.join(CERTBOT_DIR, 'renewal', base_domain + '.conf')
    os.makedirs(cert_dir, exist_ok=True)

    download_certs(cert_dir, s3_bucket, s3_prefix)

    if len(os.listdir(cert_dir)) == 0 or get_cert_expires_in_days(os.path.join(cert_dir, 'cert.pem')) < 30:
        shutil.rmtree(cert_dir)
        obtain_certs(email, domains)
    else:
        return 'No need to update certificates.'

    upload_certs(cert_dir, s3_bucket, s3_prefix)

    return 'Certificates obtained and uploaded successfully.'


def lambda_handler(event, context):
    try:
        rm_tmp_dir()
        return guarded_handler(event, context)
    finally:
        rm_tmp_dir()
