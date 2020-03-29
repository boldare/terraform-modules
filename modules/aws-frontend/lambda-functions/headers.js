const Header = {
  AMAZON_LAST_MODIFIED: 'X-Amz-Meta-Last-Modified',
  LAST_MODIFIED: 'Last-Modified',
  STRICT_TRANSPORT_SECURITY: 'Strict-Transport-Security',
  CONTENT_SECURITY_POLICY: 'Content-Security-Policy',
  FRAME_OPTIONS: 'X-Frame-Options',
  CONTENT_TYPE_OPTIONS: 'X-Content-Type-Options',
  REFERRER_POLICY: 'Referrer-Policy',
};

for (const key in Header) {
  if (Header.hasOwnProperty(key)) {
    Header[key] = Header[key].toLowerCase();
  }
}

const contentSecurityPolicyHeader = Object.entries(JSON.parse(`${csp_json_string}`))
  .map(([key, value]) => {
    `$${key} $${value}`;
  }).join('; ');

const headerOverrides = JSON.parse(`${custom_headers_json_string}`) || {};

const responseHeaders = Object.entries({
  /* Safe defaults */
  [Header.CONTENT_SECURITY_POLICY]: contentSecurityPolicyHeader,
  [Header.STRICT_TRANSPORT_SECURITY]: 'max-age=31536000',
  [Header.FRAME_OPTIONS]: 'deny',
  [Header.CONTENT_TYPE_OPTIONS]: 'nosniff',
  [Header.REFERRER_POLICY]: 'no-referrer',
  ...headerOverrides,
});

exports.handler = async (event, context) => {
  const response = event.Records[0].cf.response;
  const headers = response.headers;

  const setHeader = (key, value) => {
    headers[key] = [{ key, value }];
  };

  if (headers[Header.AMAZON_LAST_MODIFIED]) {
    setHeader(Header.LAST_MODIFIED, headers[Header.AMAZON_LAST_MODIFIED][0].value);
  }

  for (let [key, value] of responseHeaders){
    setHeader(key, value);
  }

  return response;
};
