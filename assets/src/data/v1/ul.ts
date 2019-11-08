import * as Immutable from 'immutable';
import { augment, ensureIdGuidPresent } from '../common';

export type UlParams = {
  
  id?: string,
  
  guid?: string,
};

const defaultContent = {
  contentType: 'Ul',
  elementType: 'ul',
  
  id: null,
  
  guid: '',
};

export class Ul extends Immutable.Record(defaultContent) {

  contentType: 'Ul';
  elementType: 'ul';
  
  id: string;
  
  guid: string;

  constructor(params?: UlParams) {
    super(augment(params));
  }

  with(values: UlParams) {
    return this.merge(values) as this;
  }

  clone() : Ul {
    return ensureIdGuidPresent(this);
  }
}
