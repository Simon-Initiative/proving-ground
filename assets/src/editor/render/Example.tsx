import * as React from 'react';
import { mutate, getData, Image as ImageData } from 'data/content/types';


export function Example(props) {
  const { editor, node, isFocused } = props;
  const image = getData<ImageData>(node.data);

  const [activeTab, setActiveTab] = React.useState("setup");
  
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

  const setup = (
    <div>
      <h5>How to use this A/B Test</h5>

      <p>Place content in both the <b>Variant A</b> and <b>Variant B</b> sections
      of this experiment. </p>

      <p>At course delivery, students will be randomly assigned one of the two 
        options based on the following selected strategy:
      </p>

      <select>
      <option>Random on each page view</option>
      <option disabled>Random, but locked in to one option </option>
        <option disabled>Random, but in conjunction with other tests on this page </option>
      </select>
    </div>
  );

  let active = setup;

  if (activeTab === 'a') {
    active = props.children[0];
  } else if (activeTab == 'b') {
    active = props.children[1];
  }

  return (
    <div {...props.attributes} style={ exampleStyle }>
      <div
        contentEditable={false}
        style={{ position: 'absolute', top: '5px', right: '15px' }}
      >
        <span style={ label }>A/B Test</span>
      </div>
      <div className="ui grid">
        <div className="four wide column">
          <div className="ui vertical fluid tabular menu">
            <a onClick={() => setActiveTab('setup')} className={`item ${activeTab === 'setup' ? 'active' : ''}`}>
              Setup
            </a>
            <a onClick={() => setActiveTab('a')} className={`item ${activeTab === 'a' ? 'active' : ''}`}>
              Variant A
            </a>
            <a onClick={() => setActiveTab('b')} className={`item ${activeTab === 'b' ? 'active' : ''}`}>
              Variant B
            </a>
          </div>
        </div>
        <div className="twelve wide stretched column">
          {active}
        </div>
      </div>
    </div>
  );
}
