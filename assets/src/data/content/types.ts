import * as Immutable from 'immutable';

export type InlineData = Link | InlineMath | Cite | Definition | Input;
export type InlineStyle = 'bold' | 'italic' | 'mark' | 'strikethrough' | 'underline' | 'code' | 'sub' | 'sup';
export type BlockStyle = 
  'paragraph' 
  | 'heading-one'
  | 'heading-two'
  | 'heading-three'
  | 'heading-four'
  | 'heading-five'
  | 'heading-six'
  | 'table'
  | 'tr'
  | 'td'
  | 'th'
  | 'thead'
  | 'tbody'
  | 'list'
  | 'table'
  | 'image'
  | 'math'
  | 'math_line'
  | 'youtube'
  | 'example'
  | 'audio'
  | 'code'
  | 'code_line'
  | 'quote'
  | 'custom'
  | 'multiple_choice'
  | 'stem'
  | 'choice_feedback'
  | 'choice'
  | 'question'
  | 'feedback'
  | 'hint';

export type BlockData = 
  Paragraph | Header1 | Header2 | Header3 | Header4 | Header5 | 
  List | Table | Image | Math | YouTube | Audio | Code | CodeLine | Quote | Custom;

export function getData<BlockData>(data) : BlockData {
  if (data.toJSON !== undefined) {
    return data.toJSON() as BlockData;
  }
  return (data as BlockData);
}

export function create<BlockData>(params: BlockData) : BlockData {
  return (params as BlockData);
}

export function mutate<BlockData>(obj: BlockData, changes: Object) : BlockData {
  return Object.assign({}, obj, changes) as BlockData;
}



export interface Link {
  object: 'link';
  src: string;
  target: string;
};

export interface InlineMath {
  object: 'math';
  content: string;
  format: 'latex' | 'mathml';
};

export interface Cite {
  object: 'cite';
  entryRef: string;
};

export interface Definition {
  object: 'definition';
  definition: string;
};

export interface Input {
  object: 'input';
  inputRef: string;
}


export interface CodeLine {
  object: 'code_line';
}


export interface Taggable {
  tags: string[];
}

export interface Identifiable {
  id: string;
}

export interface Paragraph extends Taggable, Identifiable {
  object: 'paragraph';
};

export interface Header1 extends Taggable, Identifiable {
  object: 'paragraph';
};

export interface Header2 extends Taggable, Identifiable {
  object: 'paragraph';
};

export interface Header3 extends Taggable, Identifiable {
  object: 'paragraph';
};

export interface Header4 extends Taggable, Identifiable {
  object: 'paragraph';
};

export interface Header5 extends Taggable, Identifiable {
  object: 'paragraph';
};


export interface List extends Taggable, Identifiable {
  object: 'list';
  ordered: boolean;
};

export interface Table extends Taggable, Identifiable {
  object: 'table';
};

export interface Image extends Taggable, Identifiable {
  object: 'image';
  src: string;
  height?: string;
  width?: string;
  alt: string;
  caption: string;
};

export interface YouTube extends Taggable, Identifiable {
  object: 'youtube';
  src: string;
  height?: string;
  width?: string;
};

export interface Audio extends Taggable, Identifiable {
  object: 'audio';
  src: string;
};

export interface Math extends Taggable, Identifiable {
  object: 'math';
  format: 'latex' | 'mathml';
};

export interface Code extends Taggable, Identifiable {
  object: 'code';
  language: string;
};

export interface Quote extends Taggable, Identifiable {
  object: 'quote';
};

export interface Custom extends Taggable, Identifiable {
  object: 'custom';
};

export interface Snippet {
  id?: string;
  name: string;
  content: Object;
}

