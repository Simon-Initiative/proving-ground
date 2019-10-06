import * as React from 'react';

const choices = [
  { text: 'dog', feedback: 'Correct!', score: 1 },
  { text: 'donut', feedback: 'A donut is not an animal', score: 0 },
  { text: 'apricot', feedback: 'Sorry, not an animal', score: 0 },
  { text: 'cigar', feedback: 'Incorrect, a cigar is not an animal', score: 0 },
]

let pendingAnswer = null;

export function DeliveryQuestion(props) {

  const [answer, setAnswer] = React.useState(null);

  const answered = answer !== null;

  const exampleStyle = {
    marginLeft: '30px',
    marginRight: '10px',
    border: '1px solid #eeeeee',
    borderLeft: '2px solid darkblue',
    position: 'relative',
    padding: '15px',
  };

  const label = {
    textTransform: 'uppercase',
    color: 'lightgray',
  } as any;

  const input = (c, i) => (
    <div key={i} className="form-check">
      <input 
        onClick={() => pendingAnswer = i}
        className="form-check-input" 
        type="radio"
        disabled={answered}
        name="one"/>
      <span>{c.text}</span>
    </div>
  )

  const feedbackStyles = [
    { margin: '10px', padding: '5px', backgroundColor: 'darkred', color: 'white' },
    { margin: '10px', padding: '5px', backgroundColor: 'darkgreen', color: 'white' },
  ];

  const feedback = answered 
    ? <div style={ feedbackStyles[choices[answer].score] }>{choices[answer].feedback}</div>
    : null;

  const submitOrReset = answered
    ? <button onClick={() => setAnswer(null)} className="btn btn-primary">Reset</button>
    : <button onClick={() => setAnswer(pendingAnswer)} className="btn btn-primary">Submit</button>

  return (
    <div {...props.attributes} style={ exampleStyle }>
      <div
        style={{ position: 'absolute', top: '5px', right: '15px' }}
      >
        <span style={ label }>Multiple Choice</span>
      </div>
      
      <p>
        Which of the following is a type of animal?
      </p>

      {choices.map((c, i) => input(c, i))}

      {feedback}

      <div style={ { marginTop: '10px' }}>
        {submitOrReset}
      </div>

      <div
        style={{ position: 'absolute', bottom: '5px', right: '15px' }}
      >
        <button onClick={() => setAnswer(null)} className="btn btn-link">Edit</button>
      </div>
    </div>
  );
}
