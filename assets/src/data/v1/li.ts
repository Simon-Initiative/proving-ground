import * as Immutable from 'immutable';
import { augment, ensureIdGuidPresent } from '../common';

export type LiParams = {
  
  id?: string,
  
  guid?: string,
};

const defaultContent = {
  contentType: 'Li',
  elementType: 'li',
  
  id: null,
  
  guid: '',
};

export class Li extends Immutable.Record(defaultContent) {

  contentType: 'Li';
  elementType: 'li';
  
  id: string;
  
  guid: string;

  constructor(params?: LiParams) {
    super(augment(params));
  }

  with(values: LiParams) {
    return this.merge(values) as this;
  }

  clone() : Li {
    return ensureIdGuidPresent(this);
  }
}
