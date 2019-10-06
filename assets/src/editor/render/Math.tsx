import * as React from 'react';


let pendingScripts = [];
let pendingCallbacks = [];
let needsProcess = false;

/**
 * Process math in a script node using MathJax
 * @param {MathJax}  MathJax
 * @param {DOMNode}  script
 * @param {Function} callback
 */
function process(mathJax, script, callback) {
  pendingScripts.push(script);
  pendingCallbacks.push(callback);
  if (!needsProcess) {
    needsProcess = true;
    setTimeout(() => doProcess(mathJax), 0);
  }
}

function doProcess(mathJax) {
  mathJax.Hub.Queue(() => {
    const oldElementScripts = mathJax.Hub.elementScripts;
    mathJax.Hub.elementScripts = element => pendingScripts;

    try {
      return mathJax.Hub.Process(null, () => {
        // Trigger all of the pending callbacks before clearing them
        // out.
        for (const callback of pendingCallbacks) {
          callback();
        }

        pendingScripts = [];
        pendingCallbacks = [];
        needsProcess = false;
      });
    } catch (e) {
      // IE8 requires `catch` in order to use `finally`
      throw e;
    } finally {
      mathJax.Hub.elementScripts = oldElementScripts;
    }
  });
}



export interface Math {
  node: any;
  script: any;
}

export interface MathProps {
  isSelected: boolean;
  attrs: any;
  inline: boolean;
  data: string;
  onClick: (e) => void;
}

/**
 * React component to render maths using mathjax
 * @type {ReactClass}
 */
export class Math extends React.Component<MathProps, { isMathJaxReady: boolean }> {
  MathJax: any;

  constructor(props) {
    super(props);

    this.MathJax = (window as any).MathJax;

    this.state = {
      isMathJaxReady: this.MathJax !== undefined && this.MathJax.isReady,
    };

    this.clear = this.clear.bind(this);
    this.typeset = this.typeset.bind(this);
    this.setScriptText = this.setScriptText.bind(this);
  }

  componentDidMount() {

    let handle = null;
    const check = () => {
      if (this.MathJax !== undefined) {
        clearInterval(handle);
        this.MathJax.Hub.Register.StartupHook(
          'End',
          () => this.setState({ isMathJaxReady: true }));
      }
    }

    if (this.state.isMathJaxReady) {
      this.typeset(false);
    } else {
      handle = setInterval(check, 50);
    }

  }

  /**
   * Update the jax, force update if the display mode changed
   */
  componentDidUpdate(prevProps) {
    if (this.state.isMathJaxReady) {
      const forceUpdate = prevProps.inline !== this.props.inline;
      this.typeset(forceUpdate);
    }
  }

  /**
   * Prevent update when the tex has not changed
   */
  shouldComponentUpdate(nextProps, nextState, nextContext) {
    return (
      nextState.isMathJaxReady !== this.state.isMathJaxReady
      || nextProps.data !== this.props.data
      || nextProps.isSelected !== this.props.isSelected
      || nextProps.inline !== this.props.inline
      || nextContext.MathJax !== this.context.MathJax
    );
  }

  /**
   * Clear the math when unmounting the node
   */
  componentWillUnmount() {
    this.clear();
  }

  /**
   * Clear the jax
   */
  clear() {
    if (!this.script || !this.MathJax) {
      return;
    }

    const jax = this.MathJax.Hub.getJaxFor(this.script);
    if (jax) {
      jax.Remove();
    }
  }

  /**
   * Update math in the node.
   * @param {Boolean} forceUpdate
   */
  typeset(forceUpdate) {
    const { data } = this.props;

    if (!this.MathJax) {
      return;
    }

    const text = data;

    if (forceUpdate) {
      this.clear();
    }

    if (!forceUpdate && this.script) {
      this.MathJax.Hub.Queue(() => {
        const jax = this.MathJax.Hub.getJaxFor(this.script);

        if (jax) {
          jax.Text(text, () => { });
        } else {
          const script = this.setScriptText(text);
          process(this.MathJax, script, () => { });
        }
      });


    } else {
      const script = this.setScriptText(text);
      process(this.MathJax, script, () => { });
    }
  }

  /**
   * Create a script
   * @param  {String} text
   * @return {DOMNode} script
   */
  setScriptText(text) {
    const { inline } = this.props;

    if (!this.script) {
      this.script = document.createElement('script');

      const tex = 'math/tex; ';
      const mml = 'math/mml; ';
      let type = tex;
      if (text.startsWith('<')) {
        type = mml;
      }

      this.script.type = type + (inline ? '' : 'mode=display');
      (this.node as any).appendChild(this.script);
    }

    if ('text' in this.script) {
      // IE8, etc
      this.script.text = text;
    } else {
      this.script.textContent = text;
    }

    return this.script;
  }

  render() {
    const { isSelected, onClick, attrs } = this.props;

    const style =  {
      marginLeft: '5px',
      marginRight: '5px',
      paddingLeft: '2px',
      paddingRight: '2px',
      paddingTop: '1px',
      paddingBottom: '1px',
    };

    const classes = 'mathRenderer ' + (isSelected ? 'selectedMath' : '');
    return <span {...attrs} style={ style } onClick={onClick} ref={n => this.node = n} />;
  }
}

