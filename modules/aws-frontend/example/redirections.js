const normalizeUri = uri => uri === '/' ? '/index' : uri;

const routes = {
  '/index': '/index.html',
  '/about': '/about.html',
  '/faq': '/faq.html',
};

exports.handler = async event => {
  const request = event.Records[0].cf.request;
  const uri = normalizeUri(request.uri);

  const foundRoute = routes[uri];
  if (foundRoute) {
    request.uri = foundRoute;
    return request;
  }

  return request;
};
