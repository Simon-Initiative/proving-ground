import * as React from 'react';

import { ModelElement } from './model';


function assertNever(x: never): never {
  throw new Error("Unexpected object: " + x);
}

 
export const Code = props => {
  return (
    <pre {...props.attributes}>
      <code>{props.children}</code>
    </pre>
  );
}

export const P = props => {
  return <p {...props.attributes}>{props.children}</p>;
}

export const H1 = props => {
  return <h1 {...props.attributes}>{props.children}</h1>;
}

export const H2 = props => {
  return <h2 {...props.attributes}>{props.children}</h2>;
}

export const H3 = props => {
  return <h3 {...props.attributes}>{props.children}</h3>;
}

export const H4 = props => {
  return <h4 {...props.attributes}>{props.children}</h4>;
}

export const H5 = props => {
  return <h5 {...props.attributes}>{props.children}</h5>;
}

export const H6 = props => {
  return <h6 {...props.attributes}>{props.children}</h6>;
}

export function editorFor(element: ModelElement, props) : JSX.Element {
  switch (element.type) {    
    case 'code':
      return <Code {...props} />;
    case 'p':
      return <P {...props} />;
    case 'h1':
      return <H1 {...props} />;
    case 'h2':
      return <H2 {...props} />;
    case 'h3':
      return <H3 {...props} />;
    case 'h4':
      return <H4 {...props} />;
    case 'h5':
      return <H5 {...props} />;
    case 'h6':
      return <H6 {...props} />;
    case 'youtube':
    case 'audio':
    case 'img':
    case 'table':
    case 'tr':
    case 'thead':
    case 'tbody':
    case 'tfoot':
    case 'td':
    case 'th':
    case 'ol':
    case 'ul':
    case 'li':
    case 'math':
    case 'math_line':
    case 'code_line':
    case 'blockquote':
    case 'example':
    case 'a':
    case 'dfn':
    case 'cite':
      return <span {...props.attributes}>Not implemented</span>;
    default:
      assertNever(element);
  }
}