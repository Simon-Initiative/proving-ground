import * as React from 'react';

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
