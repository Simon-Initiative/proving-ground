import * as React from 'react';
import { mutate, getData, Code } from 'data/content/types';

export function CodeBlock(props) {
  const { editor, node } = props;
  const code = getData<Code>(node.data);
  
  function onChange(event) {
    editor.setNodeByKey(node.key, { data: mutate<Code>(code, { language: event.target.value }) })
  }

  const codeStyle = {
    fontFamily: 'Menlo, Monaco, Courier New, monospace',
    padding: '9px',
    marginLeft: '20px',
    marginRight: '20px',
    border: '1px solid #eeeeee',
    borderLeft: '2px solid darkblue',
    minHeight: '60px',
    position: 'relative',
  } as any;

  const label = {
    textTransform: 'uppercase',
    color: 'lightgray',
  } as any;

  return (
    <div className="ui segment" style={ codeStyle }>
      <pre >
        <code {...props.attributes}>{props.children}</code>
      </pre>
      <div
        contentEditable={false}
        style={{ position: 'absolute', top: '5px', right: '30px' }}
      >
        <span style={ label }>Code Block</span>
      </div>
      <div
        contentEditable={false}
        style={{ position: 'absolute', bottom: '5px', right: '25px' }}
      >
        <select value={code.language} onChange={onChange}>
          <option value="python">Python Sucks</option>
          <option value="css">CSS</option>
          <option value="js">JavaScript</option>
          <option value="html">HTML</option>
        </select>
      </div>
    </div>
  )
}

export function CodeBlockLine(props) {
  return <div {...props.attributes}>{props.children}</div>
}
