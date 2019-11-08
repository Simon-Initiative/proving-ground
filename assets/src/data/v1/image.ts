import * as Immutable from 'immutable';
import { augment, ensureIdGuidPresent } from '../common';

export type ImageParams = {
  
  id?: string,
  
  src?: string,
  
  height?: number,
  
  width?: number,
  
  guid?: string,
};

const defaultContent = {
  contentType: 'Image',
  elementType: 'image',
  
  id: null,
  
  src: null,
  
  height: 300,
  
  width: 300,
  
  guid: '',
};

export class Image extends Immutable.Record(defaultContent) {

  contentType: 'Image';
  elementType: 'image';
  
  id: string;
  
  src: string;
  
  height: number;
  
  width: number;
  
  guid: string;

  constructor(params?: ImageParams) {
    super(augment(params));
  }

  with(values: ImageParams) {
    return this.merge(values) as this;
  }

  clone() : Image {
    return ensureIdGuidPresent(this);
  }
}
