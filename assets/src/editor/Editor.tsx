import * as React from 'react';
import * as ReactDOM from 'react-dom';
import * as Immutable from 'immutable';
import { Maybe } from 'tsmonad';
import { Editor as EditorCore } from 'slate';
import { renderMark, renderInline, plugins, renderBlock } from './render/render';
import * as editorUtils from './utils';

import Prism from 'prismjs';

export interface EditorProps {
  onInit: (editor) => void;
  onSelectInline: (inline: Maybe<any>) => void;
  onLink: () => void;
  onDefinition: () => void;
  onSnippet: () => void;
  orderedIds: Immutable.Map<string, number>;
  onEdit: (obj: Object) => void;
  model: Object;
}

export interface EditorState {
  value: any;
}

function getContent(token) {
  if (typeof token === 'string') {
    return token
  } else if (typeof token.content === 'string') {
    return token.content
  } else {
    return token.content.map(getContent).join('')
  }
}

const MarkButton = ({ editor, type, icon }) => {
  const { value } = editor
  const isActive = value.activeMarks.some(mark => mark.type === type)
  const activeStyle = isActive 
    ? { color: "blue" } : { };

  return (
    <button onMouseDown={event => {
      event.preventDefault()
      editor.toggleMark(type)
    }}
    style={activeStyle}
    className="ui button secondary"><i className={`${icon} icon`}></i></button>
  );
}


const ActionButton = ({ editor, icon, onClick }) => {
  const { value } = editor
  
  return (
    <button onMouseDown={event => {
      event.preventDefault();
      onClick();
    }}
    className="ui button secondary"><i className={`${icon} icon`}></i></button>
  );
}

const HoverMenu = React.forwardRef((e, ref) => {
  const editor = (e as any).editor;
  const onLink = (e as any).onLink;
  const onDefinition = (e as any).onDefinition;
  const onSnippet = (e as any).onSnippet;
  const root = window.document.getElementById('app')

  const style = {
    position: 'absolute',
    zIndex: 1,
    top: '0px',
    left: '0px',
    marginTop: '-6px',
    borderRadius: '4px',
    transition: 'opacity 0.75s',
  } as any;

  return ReactDOM.createPortal(
    <div ref={(ref as any)} style={ { opacity: 0, position: 'relative' }}>
      <div 
        style={style}
        className="ui small icon buttons"
        ref={(ref as any)}>

        <MarkButton editor={editor} type="bold" icon="bold" />
        <MarkButton editor={editor} type="italic" icon="italic" />
        <MarkButton editor={editor} type="code" icon="code" />
        <ActionButton onClick={onLink} editor={editor} icon="linkify" />
        <ActionButton onClick={onDefinition} editor={editor} icon="book" />
        <ActionButton onClick={onSnippet} editor={editor} icon="save outline" />
        
      </div>
    </div>, root
  )
})


export class Editor extends React.Component<EditorProps, EditorState> {

  editor: any;

  constructor(props) {
    super(props);

    this.slateOnFocus = this.slateOnFocus.bind(this);
    
    this.state = {
      value: props.model
    };

  }

  menuRef = React.createRef()

  /**
   * On update, update the menu.
   */

  componentDidMount = () => {
    this.props.onInit(this.editor);
    this.updateMenu()
  }

  componentDidUpdate = () => {
    console.log('did update')
    this.updateMenu()
  }

  /**
   * Update the menu's absolute position.
   */

  updateMenu = () => {
    let menu = this.menuRef.current;
    if (!menu) return;

    menu = menu as any;

    const { value } = this.state;
    const { fragment, selection } = value;

    if (selection.isBlurred || selection.isCollapsed || fragment.text === '') {
      (menu as any).removeAttribute('style');
      return;
    }

    const native = window.getSelection();
    const range = native.getRangeAt(0);
    const rect = (range as any).getBoundingClientRect();
    (menu as any).style.opacity = 1;
    (menu as any).style.position = 'relative';
    (menu as any).style.top =
      (rect as any).top + (window as any).pageYOffset - 150 + 'px';
    
    const left = (rect as any).left +
    window.pageXOffset -
    (menu as any).offsetWidth / 2 +
    (rect as any).width / 2
    - 150;

    (menu as any).style.left = `${left}px`
  }

  renderEditor = (props, editor, next) => {
    const children = next()
    const passed = {
      editor: editor,
      onLink: this.props.onLink,
      onDefinition: this.props.onDefinition,
      onSnippet: this.props.onSnippet,
    };
    return (
      <React.Fragment>
        {children}
        <HoverMenu ref={this.menuRef} {...passed}  />
      </React.Fragment>
    )
  }

  onChange = ({ value }) => {

    const v: any = value;

    const edited = v.document !== this.state.value.document;
    const updateSelection = v.selection !== this.state.value.selection;

    // Always update local state with the new slate value
    this.setState({ value }, () => {

      if (edited) {
        // But only notify our parent of an edit when something
        // has actually changed
        this.props.onEdit(v);

        // We must always broadcast the latest version of the editor
        //this.props.onUpdateEditor(this.editor);
        //this.editor.focus();

      } else if (updateSelection) {

        // Broadcast the fact that the editor updated
       // this.props.onUpdateEditor(this.editor);

        // Based on the new selection, update whether or not
        // the cursor is 'in' an inline or not
        this.props.onSelectInline(
          editorUtils.getEntityAtCursor(this.editor as any));
      }

    });

  }

  shouldComponentUpdate(
    nextProps: EditorProps, nextState: EditorState) : boolean {
    return this.state.value !== nextState.value;
  }

  slateOnFocus(e) {
    //this.props.onUpdateEditor(this.editor);
  }

  renderDecoration = (props, editor, next) => {
    const { children, decoration, attributes } = props

    switch (decoration.type) {
      case 'comment':
        return (
          <span {...attributes} style={{ color: 'darkgreen' }}>
            {children}
          </span>
        )
      case 'keyword':
        return (
          <span {...attributes} style={{ color: 'darkblue', fontWeight: 'bold' }}>
            {children}
          </span>
        )
      case 'tag':
        return (
          <span {...attributes} style={{ fontWeight: 'bold' }}>
            {children}
          </span>
        )
      case 'punctuation':
        return (
          <span {...attributes} style={{ opacity: '0.75' }}>
            {children}
          </span>
        )
      default:
        return next()
    }
  }


  onKeyDown = (event, editor, next) => {

    const { value } = editor
    const { startBlock } = value

    if (event.key === 'Enter' && startBlock.type === 'code') {
      editor.insertText('\n')
      return
    }

    switch (event.key) {
      case ' ':
        return this.onSpace(event, editor, next)
      case 'Backspace':
        return this.onBackspace(event, editor, next)
      case 'Enter':
        return this.onEnter(event, editor, next)
      default:
        return next()
    }
  }

  getType = chars => {
    switch (chars) {
      case '#':
        return 'heading-three'
      case '##':
        return 'heading-four'
      case '###':
        return 'heading-five'
      default:
        return null
    }
  }


  /**
   * On space, if it was after an auto-markdown shortcut, convert the current
   * node into the shortcut's corresponding type.
   *
   * @param {Event} event
   * @param {Editor} editor
   * @param {Function} next
   */

  onSpace = (event, editor, next) => {
    const { value } = editor
    const { selection } = value
    if (selection.isExpanded) return next()

    const { startBlock } = value
    const { start } = selection
    const chars = startBlock.text.slice(0, start.offset).replace(/\s*/g, '')
    const type = this.getType(chars)
    if (!type) return next()
    
    event.preventDefault()

    editor.setBlocks(type)

    editor.moveFocusToStartOfNode(startBlock).delete()
  }

  /**
   * On backspace, if at the start of a non-paragraph, convert it back into a
   * paragraph node.
   *
   * @param {Event} event
   * @param {Editor} editor
   * @param {Function} next
   */

  onBackspace = (event, editor, next) => {
    return next()
  
  }

  /**
   * On return, if at the end of a node type that should not be extended,
   * create a new paragraph below it.
   *
   * @param {Event} event
   * @param {Editor} editor
   * @param {Function} next
   */

  onEnter = (event, editor, next) => {
    const { value } = editor
    const { selection } = value
    const { start, end, isExpanded } = selection
    if (isExpanded) return next()

    const { startBlock } = value
    if (start.offset === 0 && startBlock.text.length === 0)
      return this.onBackspace(event, editor, next)
    if (end.offset !== startBlock.text.length) return next()

    if (
      startBlock.type !== 'heading-one' &&
      startBlock.type !== 'heading-two' &&
      startBlock.type !== 'heading-three' &&
      startBlock.type !== 'heading-four' &&
      startBlock.type !== 'heading-five' &&
      startBlock.type !== 'heading-six' &&
      startBlock.type !== 'block-quote'
    ) {
      return next()
    }

    event.preventDefault()
    editor.splitBlock().setBlocks('paragraph')
  }


  /**
   * Decorate code blocks with Prism.js highlighting.
   *
   * @param {Node} node
   * @return {Array}
   */

  decorateNode = (node, editor, next) => {
    const others = next() || []
    if (node.type !== 'code') return others

    const language = node.data.get('language')
    const texts = Array.from(node.texts())
    const string = texts.map(([n]) => n.text).join('\n')
    const grammar = Prism.languages[language]
    const tokens = Prism.tokenize(string, grammar)
    const decorations = []
    let startEntry = texts.shift()
    let endEntry = startEntry
    let startOffset = 0
    let endOffset = 0
    let start = 0

    for (const token of tokens) {
      startEntry = endEntry
      startOffset = endOffset

      const startText = startEntry[0];
      const startPath = startEntry[1];
      const content = getContent(token)
      const newlines = content.split('\n').length - 1
      const length = content.length - newlines
      const end = start + length

      let available = startText.text.length - startOffset
      let remaining = length

      endOffset = startOffset + remaining

      while (available < remaining && texts.length > 0) {
        endEntry = texts.shift()
        const endText = endEntry[0];
         
        remaining = length - available
        available = endText.text.length
        endOffset = remaining
      }

      const endText = endEntry[0];
      const endPath = endEntry[1];

      if (typeof token !== 'string') {
        const dec = {
          type: token.type,
          anchor: {
            key: startText.key,
            path: startPath,
            offset: startOffset,
          },
          focus: {
            key: endText.key,
            path: endPath,
            offset: endOffset,
          },
        }

        decorations.push(dec)
      }

      start = end
    }

    return [...others, ...decorations]
  }

  render(): JSX.Element {
    const { onSelectInline } = this.props;

    const onInlineClick = (node: any) => {
      onSelectInline(Maybe.just(node));
    };

    const extras = {
      onInlineClick,
    };

    return (
      <div>
        
      </div>
    );
  }
}
