import { Element, Text } from 'slate';

export type ModelElement
  = Paragraph | HeadingOne | HeadingTwo | HeadingThree | HeadingFour | HeadingFive | HeadingSix | Image | YouTube
  | Audio | Table | TableHead | TableBody | TableFooter | TableRow | TableHeader | TableData | OrderedList | UnorderedList
  | ListItem | Math | MathLine | Code | CodeLine | Blockquote | Example | Hyperlink | Definition | Citation;

export type BlockElement 
  = Paragraph | HeadingOne | HeadingTwo | HeadingThree | HeadingFour | HeadingFive | HeadingSix | Image | YouTube
  | Audio | Table | TableHead | TableBody | TableFooter | TableRow | TableHeader | TableData | OrderedList | UnorderedList
  | ListItem | Math | MathLine | Code | CodeLine | Blockquote | Example;


export interface Identifiable {
  id: string;
}

export interface Paragraph extends Element, Identifiable {
  type: 'p';
}

export interface HeadingOne extends Element, Identifiable {
  type: 'h1';
}

export interface HeadingTwo extends Element, Identifiable {
  type: 'h2';
}

export interface HeadingThree extends Element, Identifiable {
  type: 'h3';
}

export interface HeadingFour extends Element, Identifiable {
  type: 'h4';
}

export interface HeadingFive extends Element, Identifiable {
  type: 'h5';
}

export interface HeadingSix extends Element, Identifiable {
  type: 'h6';
}

export interface Image extends Element, Identifiable {
  type: 'img';
  src: string; 
  height: string;
  width: string;
  alt: string;
}

export interface YouTube extends Element, Identifiable {
  type: 'youtube';
  src: string; 
  height: string;
  width: string;
  alt: string;
}

export interface Audio extends Element, Identifiable {
  type: 'audio';
  src: string; 
  alt: string;
}

export interface Table extends Element, Identifiable {
  type: 'table';
}

export interface TableHead extends Element, Identifiable {
  type: 'thead';
}
export interface TableBody extends Element, Identifiable {
  type: 'tbody';
}

export interface TableFooter extends Element, Identifiable {
  type: 'tfoot';
}

export interface TableRow extends Element, Identifiable {
  type: 'tr';
}

export interface TableHeader extends Element, Identifiable {
  type: 'th';
}

export interface TableData extends Element, Identifiable {
  type: 'td';
}

export interface OrderedList extends Element, Identifiable {
  type: 'ol';
}

export interface UnorderedList extends Element, Identifiable {
  type: 'ul';
}

export interface ListItem extends Element, Identifiable {
  type: 'li';
}

export interface Math extends Element, Identifiable {
  type: 'math';
}

export interface MathLine extends Element, Identifiable {
  type: 'math_line';
}

export interface Code extends Element, Identifiable {
  type: 'code';
  language: string;
  startingLineNumber: number;
}

export interface CodeLine extends Element, Identifiable {
  type: 'code_line';
}

export interface Blockquote extends Element, Identifiable {
  type: 'blockquote';
}

export interface Example extends Element, Identifiable {
  type: 'example';
}

// Inlines

export interface Hyperlink extends Element, Identifiable {
  type: 'a';
  href: string;
  target: string;
}

export interface Definition extends Element, Identifiable {
  type: 'dfn';
  definition: string;
}

export interface Citation extends Element, Identifiable {
  type: 'cite';
  ordinal: number;
}

// Marksd

export enum Marks {
  em = "em",
  strong = "strong",
  code = "code",
  del = "del",
  mark = "mark",
  var = "var",
  sub = "sub",
  sup = "sup"
}




