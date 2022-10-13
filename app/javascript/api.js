const fetchFactory = ({ url, method, csrfToken, body }) => {
  if (csrfToken == null) {
    console.warn('csrfToken is missing for fetchFactory');
  }
  if (url == null) {
    console.warn('url is missing for fetchFactory');
  }
  if (method == null) {
    console.warn('method is missing for fetchFactory');
  }

  body = body != null ? JSON.stringify(body) : undefined;

  return fetch(url, {
    method,
    headers: {
      'X-CSRF-Token': csrfToken,
      'Content-Type': 'application/json',
      Accept: 'application/json',
    },
    body,
  });
};

export const patch = ({ url, csrfToken, body }) => {
  return fetchFactory({ url, csrfToken, body, method: 'PATCH' });
};
