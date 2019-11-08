import * as Immutable from 'immutable';
import { augment, ensureIdGuidPresent } from '../common';

export type ParagraphParams = {
  
  id?: string,
  
  guid?: string,
};

const defaultContent = {
  contentType: 'Paragraph',
  elementType: 'paragraph',
  
  id: null,
  
  guid: '',
};

export class Paragraph extends Immutable.Record(defaultContent) {

  contentType: 'Paragraph';
  elementType: 'paragraph';
  
  id: string;
  
  guid: string;

  constructor(params?: ParagraphParams) {
    super(augment(params));
  }

  with(values: ParagraphParams) {
    return this.merge(values) as this;
  }

  clone() : Paragraph {
    return ensureIdGuidPresent(this);
  }
}
