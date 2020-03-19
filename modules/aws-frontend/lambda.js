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

const cspValue = Object.entries(JSON.parse(`${csp_json_string}`)).map(([key, value]) => {
  `$${key} $${value}`
}).join('; ');

exports.handler = async (event, context) => {
  const response = event.Records[0].cf.response;
  const headers = response.headers;

  const setHeader = (key, value) => {
    headers[key] = [{key, value}];
  };

  if (headers[Header.AMAZON_LAST_MODIFIED]) {
    setHeader(Header.LAST_MODIFIED, headers[Header.AMAZON_LAST_MODIFIED][0].value);
  }
  setHeader(Header.STRICT_TRANSPORT_SECURITY, 'max-age=31536000');
  setHeader(Header.CONTENT_SECURITY_POLICY, cspValue);
  setHeader(Header.FRAME_OPTIONS, `${header_frame_options}`);
  setHeader(Header.CONTENT_TYPE_OPTIONS, 'nosniff');
  setHeader(Header.REFERRER_POLICY, 'no-referrer');

  return response;
};
