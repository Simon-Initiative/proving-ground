import * as React from 'react';
import * as Immutable from 'immutable';
import * as ReactDOM from 'react-dom';
import { EditorComponent as Editor } from './component/editor/Editor';
import { persist, getSnippets, createSnippet } from 'data/persistence';
import { Code, create, Snippet, Math } from 'data/content/types';
import { OrderedMap } from 'immutable';
import { Editor as SlateEditor, Node, Command } from 'slate';
import { insertImage, insertYouTube } from './editor/utils';
import { Maybe } from 'tsmonad';
import guid from 'utils/guid';
import $ from 'jquery';


interface MainProps {
  packageId: string;
  id: string;
  title: string;
  content: Node[];
}

type Header = {
  text: string;
  node: Node;
};
  
interface MainState {
  snippets: Maybe<Snippet[]>;
  headers: Header[];
}

function wrapLink(editor, href) {
  editor.wrapInline({
    type: 'link',
    data: { href },
  })

  editor.moveToEnd()
}
function wrapDefinition(editor, definition) {
  editor.wrapInline({
    type: 'definition',
    data: { definition },
  })

  editor.moveToEnd()
}

/**
 * A change helper to standardize unwrapping links.
 *
 * @param {Editor} editor
 */

function unwrapLink(editor) {
  editor.unwrapInline('link')
}

function unwrapDefinition(editor) {
  editor.unwrapInline('definition')
}
  
export default class Main extends React.Component<MainProps, MainState> {

  editor : SlateEditor = null;
  snippetId = null;

  constructor(props) {
    super(props);

    this.onEdit = this.onEdit.bind(this);
    this.onDone = this.onDone.bind(this);
    this.onPublish = this.onPublish.bind(this);

    this.state = {
      snippets: Maybe.nothing(),
      headers: []
    };
  }


  hasLinks = () => {
    const { value } = this.editor;
    return value.inlines.some(inline => inline.type === 'link')
  }


  hasDefinition = () => {
    const { value } = this.editor;
    return value.inlines.some(inline => inline.type === 'definition')
  }


  onClickLink = () => {
    
    const { editor } = this
    const { value } = editor
    const has = this.hasLinks();

    if (has) {
      editor.command(unwrapLink)
    } else if (value.selection.isExpanded) {
      const href = window.prompt('Enter the URL of the link:')

      if (href == null) {
        return
      }

      editor.command(wrapLink, href);

    } else {
      const href = window.prompt('Enter the URL of the link:')

      if (href == null) {
        return
      }

      const text = window.prompt('Enter the text for the link:')

      if (text == null) {
        return
      }

      editor
        .insertText(text)
        .moveFocusBackward(text.length)
        .command(wrapLink, href)
    }
  };

  onClickDefinition = () => {
    
    const { editor } = this
    const { value } = editor
    const has = this.hasDefinition();

    if (has) {
      editor.command(unwrapDefinition)
    } else if (value.selection.isExpanded) {
      const href = window.prompt('Enter the definition:')

      if (href == null) {
        return
      }

      editor.command(wrapDefinition, href);

    } 
  };

  getHeaders(nodes) {

    const n = nodes
      .filter(n => n.type.startsWith('heading'))
      .map(n => ({ text: n.nodes.get(0).text, node: n }))
      .toArray();

    return n;
  }

  componentDidMount() {
    getSnippets().then(s => {
      this.snippetId = s.length > 0 ? s[0].id : null;
      this.setState({ snippets: Maybe.just(s) });
    });
  }

  onDone() {
    const { packageId, id } = this.props;
    (window as any).location = `/packages/${packageId}/show`;
  }

  onPublish() {
    const { packageId, id } = this.props;
    (window as any).location = `/packages/${packageId}/activities/${id}/publish`;
  }

  onEdit(obj: any) {

    const o = obj;

    const nodes = o.document.nodes;
    persist(this.props.id, { nodes });



    this.setState({
      headers: this.getHeaders(obj.document.nodes),
    });
  }

  renderOutline() {

    const indents = {
      'h1': '0px',
      'h2': '0px',
      'h3': '0px',
      'h4': '10px',
      'h5': '20px',
      'h6': '30px', 
    };

    const onClick = (h: Header) => this.editor
      .moveAnchorToStartOfNode(h.node)
      .moveFocusToStartOfNode(h.node)
      .focus();

    const items = this.state.headers.map(h => <a className="item" 
      onClick={onClick.bind(this, h)} 
      style={ { marginLeft: indents[h.node.object] } }>{h.text}</a>);

    return (
      <div>
        <div className="ui link list">
          {items}
        </div>
      </div>
    );
  }


  createSnippetHandler = () => {
    
    if (!this.editor.value.selection.isCollapsed) {
      const name = window.prompt('Enter the name of this snippet:');
      if (!name) return;
      const { anchor, focus } = this.editor.value.selection;
      const nodes = this.editor.value.document.getFragmentAtRange({ anchor, focus });
      const content = { nodes };
      const id = guid();
      const snippet = { name, content, id };
      createSnippet(snippet);

      this.state.snippets.lift(s => {
        this.setState({
          snippets: Maybe.just([snippet, ...s])
        });
      });
    }
  };

  insertSnippet = (s) => {
    //const fragment = Document.fromJSON((s.content as any).nodes);
    //this.editor.insertFragment(fragment);
  };

  renderToolbar2() {
    
    const add = (obj) => {
      //this.editor.exec()
    };

    const noOp = () => {}

    const snippets = this.state.snippets.caseOf({
    just: s => s.map(sn => <a className="item" onClick={this.insertSnippet.bind(this, sn)}>{sn.name}</a>),
      nothing: () => [],
    });

    return (
      <div className="ui" style={ { marginLeft: '140px', position: 'fixed' } }>
      <div className="ui secondary mini vertical menu">
        <div className="ui item">
          <i className="wrench  icon"></i>
          <b>Toolbox</b>
        </div>
        <div className="ui dropdown item">
          <i className="dropdown icon"></i>
          Media
          <div className="menu">
            <div className="header"><i className="image icon"></i>Images</div>
            <a className="item" onClick={noOp}>From URL</a>
            <a className="item disabled">Upload</a>
            <a className="item disabled">From Media Library</a>
            <div className="header"><i className="youtube icon"></i>Youtube</div>
            <a className="item" onClick={noOp}>From ID</a>
            <a className="item disabled">Browse</a>
          </div>
        </div>
        <div className="ui dropdown item">
          <i className="dropdown icon"></i>
          Lists
          <div className="menu">
            <a className="item" onClick={noOp}><i className="table ol icon"></i>Table</a>
            <div className="divider"></div>
            <a className="item" onClick={noOp}><i className="list ol icon"></i>Ordered</a>
            <a className="item" onClick={noOp}><i className="list ul icon"></i>Unordered</a>
          </div>
        </div>
        <div className="ui dropdown item">
          <i className="dropdown icon"></i>
          Questions
          <div className="menu">
            <a className="item" onClick={noOp}>Multiple choice</a>
            <a className="item disabled">Check all that apply</a>
            <a className="item disabled">Ordering</a>
            <a className="item disabled">Fill in the blank</a>
          </div>
        </div>
        <div className="ui dropdown item">
          <i className="dropdown icon"></i>
          Library
          <div className="menu">
            {snippets}
          </div>
        </div>
        <div className="ui dropdown item">
          More
          <i className="dropdown icon"></i>
          <div className="menu">
            <a className="item" onClick={noOp}><i className="code icon"></i> Code Block</a>
            <a className="item" onClick={noOp}><i className="calculator icon"></i> Math</a>
            <a className="item" onClick={noOp}><i className="flask icon"></i> A/B Test</a>
          </div>
        </div>
      </div>
      
      </div>
    );
  }

  render() {
    const { title, content } = this.props;
    
    return (
      
      <div id="root">
        <h3>{title}</h3>
        <div className="ui segment">
        
          <div className="ui right rail">
            <div style={ { position: 'fixed' } }>
              {this.renderOutline()}
            </div>
          </div>
          <div className="ui left rail">
            {this.renderToolbar2()}
          </div>

          <div id="editor">
            <Editor 
              onEdit={this.onEdit}
              value={content}/>
          </div>
        </div>
      </div>
    );
  }
}

(window as any).mountAuthor = (id, context) => {
  ReactDOM.render(
    <Main packageId={context.package} id={context.id} title={context.title} content={context.content.nodes} />, 
    document.getElementById(id));
}