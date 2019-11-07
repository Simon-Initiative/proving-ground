import * as F from 'data/types/frozen.ts';

export interface Image extends F.Freezable {

  
  readonly id: string
  
  readonly src: string
  
  readonly height: number
  
  readonly width: number
  
};
