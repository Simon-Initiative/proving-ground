import * as React from 'react';
import { mutate, getData, Image as ImageData } from 'data/content/types';


export function Example(props) {
  const { editor, node, isFocused } = props;
  const image = getData<ImageData>(node.data);
  
  const exampleStyle = {
    marginLeft: '20px',
    marginRight: '20px',
    padding: '9px',
    border: '1px solid #eeeeee',
    borderLeft: '2px solid red',
    position: 'relative'
  };

  const label = {
    textTransform: 'uppercase',
    color: 'lightgray',
  } as any;

  return (
    <div {...props.attributes} style={ exampleStyle }>
      <div
        contentEditable={false}
        style={{ position: 'absolute', top: '5px', right: '15px' }}
      >
        <span style={ label }>Example</span>
      </div>
      {props.children}
    </div>
  );
}
