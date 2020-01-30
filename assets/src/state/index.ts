import { combineReducers } from 'redux';
import { counter, CounterState } from 'state/counter';
import { valueOr } from 'utils/common';

export interface State {
  counter: CounterState;
}

export default combineReducers<State>({
  counter,
});

export function initState(json: any = {}) {
  return {
    counter: new CounterState(json.counter),
  };
}
