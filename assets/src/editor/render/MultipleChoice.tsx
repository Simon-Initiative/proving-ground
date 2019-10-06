import * as React from 'react';

export function MultipleChoice(props) {
  const { editor, node, isFocused } = props;
  
  const exampleStyle = {
    marginLeft: '30px',
    marginRight: '10px',
    border: '1px solid #eeeeee',
    borderLeft: '2px solid darkblue',
    position: 'relative',
    paddingLeft: '5px',
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
        <span style={ label }>Multiple Choice</span>
      </div>
      {props.children}
    </div>
  );
}


export function Choice(props) {
  const { editor, node, isFocused, radioName } = props;

  const parentStyle = {
    position: 'relative'
  };

  return (
    <div {...props.attributes} style={ parentStyle }>
      <div
        contentEditable={false}
        style={{ position: 'absolute', left: '8px' }}
      >
        <div className="form-check">
          <input 
            className="form-check-input" 
            type="radio" 
            name={radioName} 
            value="option1" />
        </div>
      </div>
      <div style={ { paddingLeft: '30px'} }>
        {props.children}
      </div>
    </div>
  );
}

export function Stem(props) {
  const { editor, node, isFocused, label } = props;

  const parentStyle = {
    position: 'relative'
  };

  return (
    <div {...props.attributes} style={ parentStyle }>
      {props.children}
    </div>
  );
}

export function Feedback(props) {
  const { editor, node, isFocused, label } = props;

  const parentStyle = {
    position: 'relative',
    marginLeft: '75px',
    marginRight: '20px',
    padding: '4px',
    backgroundColor: '#faedc8',
  };

  return (
    <div {...props.attributes} style={ parentStyle }>
      {props.children}
    </div>
  );
}
