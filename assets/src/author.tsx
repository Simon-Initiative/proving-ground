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
  
export default class Main extends React.Component<MainProps, MainState> {

  editor : SlateEditor = null;
  snippetId = null;

  constructor(props) {
    super(props);

    this.onEdit = this.onEdit.bind(this);

    this.state = {
      snippets: Maybe.nothing(),
      headers: this.getHeaders(Value.fromJSON({ document: props.content }).document.nodes),
    };
  }

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

  onEdit(obj: Value) {

    const o = obj.toJSON();
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
      <div style={ { position: 'fixed' } }>
        <div className="ui link list">
          {items}
        </div>
      </div>
    );
  }

  renderToolbar() {

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
      const cell = (text) => Block.create({ type: 'cell', nodes: [ p(text )]});
      const row = (t1, t2) => Block.create({ type: 'row', nodes: [ cell(t1), cell(t2) ]});
      const nodes = 
        [ row('A', 'B'), row('A', 'B') ];

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


    const addDelivery = () => {
      const block = Block.create({ type: 'question' });
      this.editor.insertBlock(block);
    }

      
    return (
      <div>
        <p></p>
        <p></p>
          <div style={ { display: 'flex ', justifyContent: 'flex-end' } }>
            <div style={ { marginRight: '75px' } }>
            <div className="ui" style={ { position: 'fixed' } }>
              <div className="ui icon small basic vertical buttons" role="group" aria-label="First group">
                <button onClick={addCode} type="button" className="ui button"><i className={'code icon'} /></button>
                <button onClick={addMath} type="button" className="ui button"><i className={'calculator icon'} /></button>
                <button onClick={addImage} type="button" className="ui button"><i className={'image outline icon'} /></button>
                <button onClick={addYouTube} type="button" className="ui button"><i className={'youtube icon'} /></button>
                <button onClick={addTable} type="button" className="ui button"><i className={'table icon'} /></button>
                <button onClick={addExample} type="button" className="ui button"><i className={'balance scale icon'} /></button>
                <button onClick={addQuestion} type="button" className="ui button"><i className={'question icon'} /></button>
                <button onClick={addDelivery} type="button" className="ui button"><i className={'graduation cap icon'} /></button>
                <button onClick={addOrdered} type="button" className="ui button"><i className={'list ol icon'} /></button>
                <button onClick={addUnordered} type="button" className="ui button"><i className={'list ul icon'} /></button>
              </div>
            </div>
        </div>
        </div>
      </div>
    );
  }

  renderSnippets() {

    const createSnippetHandler = (e) => {
      e.preventDefault()
      if (!this.editor.value.selection.isCollapsed) {
        const title = window.prompt('Enter the name of this snippet:');
        if (!title) return;
        const { anchor, focus } = this.editor.value.selection;
        const nodes = this.editor.value.document.getFragmentAtRange({ anchor, focus });
        const content = { nodes };
        const id = guid();
        const snippet = { title, content, id };
        createSnippet(snippet);

        this.state.snippets.lift(s => {
          this.setState({
            snippets: Maybe.just([snippet, ...s])
          });
        });
      }
    };

    const insertSnippet = (e) => {
      e.preventDefault();

      this.state.snippets.lift(snippets => {
        const s = snippets
          .filter(s => s.id == this.snippetId)[0];
        const fragment = Document.fromJSON((s.content as any).nodes);
        this.editor.insertFragment(fragment);
      });
      
    };

    const mapper = s => <option key={s.id} value={s.id}>{s.title}</option>


    const options = this.state.snippets.
      caseOf({
        just: (sn => sn.map(mapper)) as any,
        nothing: () => <option>Loading...</option>
      });

    return (
      <div className="btn-group mr-2" role="group" aria-label="First group">
        <div className="input-group mb-1 mt-1">
          <select
            onChange={e => this.snippetId = e.target.value}
            style={ { width: '200px' } } className="form-control form-control-sm" id="inputGroupSelect03">
            {options}
          </select>
          <div className="input-group-append">
            <button onClick={insertSnippet} type="button" className="btn btn-sm"><i className={'fa fa-plus'} /></button>
            <button onClick={createSnippetHandler} type="button" className="btn btn-sm"><i className={'fa fa-save'} /></button>
          </div>
        </div>
      </div>
    );
  }

  render() {
    const { title, content } = this.props;
    
    return (
      
      <div>
        <h3>{title}</h3>
        <div className="ui segment">
        
          <div className="ui right rail">
            {this.renderOutline()}
          </div>
          
          <div className="ui left attached rail">
            {this.renderToolbar()}
          </div>
          

          <div id="editor">
            <Editor 
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
    <Main id={context.id} title={context.title} content={context.content} />, 
    document.getElementById(id));
}