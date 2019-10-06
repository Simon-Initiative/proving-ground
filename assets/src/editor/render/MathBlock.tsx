import * as React from 'react';
import { mutate, getData, Math } from 'data/content/types';
import { Math as MathRenderer } from './Math';

export function MathBlock(props) {
  const { editor, node } = props;
  const math = getData<Math>(node.data);

  const [preview, setPreview] = React.useState(true);
  
  function onChange(event) {
    editor.setNodeByKey(node.key, { data: mutate<Math>(math, { format: event.target.value }) })
  }

  const blockStyle = {
    fontFamily: 'Menlo, Monaco, Courier New, monospace',
    marginLeft: '20px',
    marginRight: '20px',
    padding: '9px',
    border: '1px solid #eeeeee',
    borderLeft: '2px solid darkblue',
    position: 'relative',
    minHeight: '60px'
  } as any;

  const label = {
    textTransform: 'uppercase',
    color: 'lightgray',
  } as any;

  return (
    <div style={ blockStyle }>
      <pre>
        <code {...props.attributes}>{props.children}</code>
      </pre>
      <div
        style={{ position: 'absolute', top: '5px', right: '100px' }}
        contentEditable={false}>
          <MathRenderer 
            onClick={() => {}}
            inline={true}
            isSelected={false}
            data={node.text}
            attrs={props.attributes} />
      </div>
      <div
        contentEditable={false}
        style={{ position: 'absolute', top: '5px', right: '30px' }}
      >
        <span style={ label }>Math</span>
      </div>
      <div
        contentEditable={false}
        style={{ position: 'absolute', bottom: '5px', right: '25px' }}
      >
        <select value={math.format} onChange={onChange}>
          <option value="latex">Latex</option>
          <option value="mathml">MathML</option>
        </select>
      </div>
    </div>
  )
}

export function MathBlockLine(props) {
  return <div {...props.attributes}>{props.children}</div>
}
