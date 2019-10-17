import * as React from 'react';
import * as Immutable from 'immutable';
import * as ReactDOM from 'react-dom';
import { Editor } from './editor/Editor';
import { persist, getSnippets, createSnippet } from 'data/persistence';
import { Code, create, Snippet, Math } from 'data/content/types';
import { OrderedMap } from 'immutable';
import { Block, Document, Editor as SlateEditor, Value, Node } from 'slate';
import { insertImage, insertYouTube } from './editor/utils';
import { Maybe } from 'tsmonad';
import guid from 'utils/guid';
import $ from 'jquery';


interface MainProps {
  packageId: string;
  id: string;
  title: string;
  content: Object;
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
      headers: this.getHeaders(Value.fromJSON({ document: props.content }).document.nodes),
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

  onEdit(obj: Value) {

    const o = obj.toJSON();

    console.log(JSON.stringify(o, null, 2));

    const nodes = o.document.nodes;
    persist(this.props.id, { nodes });



    this.setState({
      headers: this.getHeaders(obj.document.nodes),
    });
  }

  renderOutline() {

    const indents = {
      'heading-one': '0px',
      'heading-two': '0px',
      'heading-three': '0px',
      'heading-four': '10px',
      'heading-five': '20px',
      'heading-six': '30px', 
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
    const fragment = Document.fromJSON((s.content as any).nodes);
    this.editor.insertFragment(fragment);
  };

  renderToolbar2() {

    const add = (data, nodes) => {
      const block = Block.create({ data, type: data.object, nodes });
      this.editor.insertBlock(block);
    };

  

    const addCode = add.bind(this, create<Code>(
      { object: 'code', tags: [], id: guid(), language: 'javascript' }),
      [ { object: 'block', type: 'code_line', nodes: [ { object: 'text', text: 'var x = 5;' }] }],
      );
    
    const addMath = add.bind(this, create<Math>(
      { object: 'math', tags: [], id: guid(), format: 'latex' }),
      [ { object: 'block', type: 'math_line', nodes: [ { object: 'text', text: '{N}\\choose{k} \\cdot p^kq^{N-k}'}] }],
      );

    const addImage = event => {
      event.preventDefault()
      const src = window.prompt('Enter the URL of the image:')
      if (!src) return
      this.editor.command(insertImage, src)
    }
    
    const addYouTube = event => {
      event.preventDefault()
      const src = window.prompt('Enter the YouTube id:')
      if (!src) return
      this.editor.command(insertYouTube, src)
    }
  
    const addOrdered = () => {
      (this.editor as any).toggleList({ type: 'ordered-list'});
    };

    const addUnordered = () => {
      (this.editor as any).toggleList({ type: 'unordered-list'});
    };

    const addTable = () => {

      const p = (text) => Block.create({ type: 'paragraph', nodes: [{ object: 'text', text}]});
      const td = (text) => Block.create({ type: 'td', nodes: [ p(text )]});
      const th = (text) => Block.create({ type: 'th', nodes: [ p(text )]});
      
      const thead = (t) => 
        Block.create({ type: 'thead', nodes: [tr(th, t)]});
      
      const tr = (f, t) => 
        Block.create({ type: 'tr', nodes: t.map(e => f(e))});

      const tbody = (d) => 
        Block.create({ type: 'tbody', nodes: d.map(e => tr(td, e))});

      const nodes = 
        [ 
          thead(['ID', 'Title', 'Description']), 
          tbody([
            ['1', 'Jaws', 'Shark scares beachgoers'],
            ['2', 'Rocky', 'A nobody gets his chance'],
            ['3', 'The Godfather', 'Crime pays'],
          ])];

      const block = Block.create({ data: {}, type: 'table', nodes });
      this.editor.insertBlock(block);
    }

    const addQuestion = () => {

      const p = (text) => Block.create({ type: 'paragraph', nodes: [{ object: 'text', text}]});
      const choice = (text) => Block.create({ type: 'choice', nodes: [ p(text )]});
      const feedback = (text) => Block.create({ type: 'feedback', nodes: [ p(text )]});
      const choice_feedback = (c, f) => Block.create({ type: 'choice_feedback', nodes: [ choice(c), feedback(f)]});
      const stem = (text) => Block.create({ type: 'stem', nodes: [ p(text )]});
      const nodes = 
        [ stem('Which of the following...'), choice_feedback('A', 'Correct!'), choice_feedback('B', 'Incorrect'), choice_feedback('C', 'Incorrect') ];

      const block = Block.create({ data: {}, type: 'multiple_choice', nodes });
      this.editor.insertBlock(block);
    }

    const addExample = () => {

      const p = (text) => Block.create({ type: 'paragraph', nodes: [{ object: 'text', text}]});
      const nodes = 
        [ p('') ];

      const block = Block.create({ data: {}, type: 'example', nodes });
      this.editor.insertBlock(block);
    }


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
            <a className="item" onClick={addImage}>From URL</a>
            <a className="item disabled">Upload</a>
            <a className="item disabled">From Media Library</a>
            <div className="header"><i className="youtube icon"></i>Youtube</div>
            <a className="item" onClick={addYouTube}>From ID</a>
            <a className="item disabled">Browse</a>
          </div>
        </div>
        <div className="ui dropdown item">
          <i className="dropdown icon"></i>
          Lists
          <div className="menu">
            <a className="item" onClick={addTable}><i className="table ol icon"></i>Table</a>
            <div className="divider"></div>
            <a className="item" onClick={addOrdered}><i className="list ol icon"></i>Ordered</a>
            <a className="item" onClick={addUnordered}><i className="list ul icon"></i>Unordered</a>
          </div>
        </div>
        <div className="ui dropdown item">
          <i className="dropdown icon"></i>
          Questions
          <div className="menu">
            <a className="item" onClick={addQuestion}>Multiple choice</a>
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
            <a className="item" onClick={addExample}><i className="balance scale icon"></i> Example</a>
            <a className="item" onClick={addCode}><i className="code icon"></i> Code Block</a>
            <a className="item" onClick={addMath}><i className="calculator icon"></i> Math</a>
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
              onLink={this.onClickLink}
              onDefinition={this.onClickDefinition}
              onSnippet={this.createSnippetHandler}
              onInit={(e) => this.editor = e}
              onSelectInline={() => {}}
              onEdit={this.onEdit}
              orderedIds={OrderedMap<string, number>()}
              model={content}/>
          </div>
        </div>
      </div>
    );
  }
}

(window as any).mountAuthor = (id, context) => {
  ReactDOM.render(
    <Main packageId={context.package} id={context.id} title={context.title} content={context.content} />, 
    document.getElementById(id));
}