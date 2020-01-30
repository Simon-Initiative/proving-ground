import { createStore, applyMiddleware } from 'redux';
import { composeWithDevTools } from 'redux-devtools-extension';
import { createLogger } from 'redux-logger';
import thunk from 'redux-thunk';
import rootReducer, { State } from 'state';

export function configureStore(initialState?: State) {
  const logger = createLogger({
    stateTransformer: state => {
      const newState = {};

      // automatically converts any immutablejs objects to JS representation
      for (const i of Object.keys(state)) {
        if ((state[i]).toJS) {
          newState[i] = state[i].toJS();
        } else {
          newState[i] = state[i];
        }
      }
      return newState;
    },
  });

  let middleware;
  if (process.env.NODE_ENV === 'development') {
    middleware = composeWithDevTools(applyMiddleware(thunk, logger));
  } else {
    middleware = composeWithDevTools(applyMiddleware(thunk));
  }

  const store = initialState
    ? createStore(rootReducer, initialState, middleware)
    : createStore(rootReducer, middleware);

  if ((module as any).hot) {
    (module as any).hot.accept('./index', () => {
      const nextReducer = require('./index');
      store.replaceReducer(nextReducer);
    });
  }

  return store;
}
