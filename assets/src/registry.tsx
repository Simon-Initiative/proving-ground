import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { Provider } from 'react-redux';
import { maybe } from 'tsmonad';
import { CountDisplay } from 'components/CountDisplay';
import { CounterButtons } from 'components/CounterButtons';
import { configureStore } from 'state/store';

export const registry = {
    'CountDisplay': CountDisplay,
    'CounterButtons': CounterButtons, 
};

export type ComponentName = keyof typeof registry;

const store = configureStore();

(window as any).mountComponent = (id: string, componentName: ComponentName, props: any = {}) => {
    maybe(registry[componentName]).lift((Component) => {
      // ReactDOM.render(
      //   React.createElement(component),
      //   document.getElementById(id),
      // );

      ReactDOM.render(
        <Provider store={store}>
          <Component {...props} />
        </Provider>,
        document.getElementById(id),
      );
    });
};
