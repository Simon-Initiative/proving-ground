
const fetch = (window as any).fetch;

import { Snippet } from 'data/content/types';

function handleError(error: { status: string, statusText: string, message: string }, reject) {
  // The status text is the human-readable server response code from the `fetch` Response object
  if (error.statusText === 'Unauthorized') {
    
  } else {
    reject(error);
  }
}

export type HttpRequestParams = {
  method?: string,
  url: string,
  body?: string | FormData,
  headers?: Object,
  query?: Object,
  hasTextResult?: boolean,
};

export function authenticatedFetch(params: HttpRequestParams): Promise<any> {

  const method = params.method ? params.method : 'GET';
  const headers = params.headers;
  const hasTextResult = params.hasTextResult ? params.hasTextResult : false;

  const { body, url, query } = params;

  let queryString = '';
  if (query && Object.keys(query).length > 0) {
    // convert query params to encoded url string
    queryString = '?' + Object.keys(query)
      .map(k => encodeURIComponent(k) + '=' + encodeURIComponent(query[k]))
      .join('&');
  }

  return new Promise((resolve, reject) => {
    fetch(url + queryString, {
          method,
          headers,
          body,
    })
    .then((response: Response) => {
      if (!response.ok) {
        response.text().then((text) => {
          // Error responses from the server should always return
          // objects of type { message: string }
          let message;
          try {
            message = JSON.parse(text);
            if (message.message !== undefined) {
              message = message.message;
            }
          } catch (e) {
            message = text;
          }
          reject({
            status: response.status,
            statusText: response.statusText,
            message,
          });
        });
      } else {
        resolve(hasTextResult ? response.text() : response.json());
      }
      })
      .catch((error: { status: string, statusText: string, message: string }) => {
        handleError(error, reject);
      });
  });
}



export function persist(id: string, contents: Object): Promise<any> {
  
  const url = `/api/edit/${id}`;

  const body = JSON.stringify(contents);
  const method = 'POST';
  const headers = {
    'Content-Type': 'application/json',
  };

  return new Promise((resolve, reject) => {
    authenticatedFetch({ url, body, method, headers })
    .then((json) => {
      resolve((json as any).saved);
    });
  });
}

export function getSnippets(): Promise<Snippet[]> {
  
  const url = `/api/snippets`;
  const method = 'GET';
  const headers = {
    'Content-Type': 'application/json',
  };

  return new Promise((resolve, reject) => {
    authenticatedFetch({ url, method, headers })
    .then((json) => {
      resolve((json as Snippet[]));
    });
  });
}

export function createSnippet(snippet: Snippet): Promise<any> {
  
  const url = `/api/snippets`;
  const method = 'POST';
  const { title, content } = snippet;
  const body = JSON.stringify({ snippet: { title, content }});
  const headers = {
    'Content-Type': 'application/json',
  };

  return new Promise((resolve, reject) => {
    authenticatedFetch({ url, body, method, headers })
    .then((json) => {
      resolve((json as Snippet[]));
    });
  });
}


