import React, { useState, useMemo, useRef, useEffect, useCallback } from 'react'
import { Slate, Editable, ReactEditor, withReact, useSlate } from 'slate-react'
import { Editor, createEditor, Node } from 'slate'
import { withHistory } from 'slate-history'
import { Marks, ModelElement } from './interfaces';
import * as Editors from './elements';
import { Button, Icon, Menu, Portal } from './utils'
import { Range } from 'slate'


export type EditorProps = {
  onEdit: (value) => void;
  value: Node[];
}

export const EditorComponent = (props: EditorProps) => {
  const [value, setValue] = useState(props.value)
  const [selection, setSelection] = useState(null)
  const editor = useMemo(
    () => withFormatting(withHistory(withReact(createEditor()))),
    []
  )


  const renderElement = useCallback(props => {

    const model = props.element as ModelElement;
    
    switch (model.type) {    
      case 'code':
        return <Editors.Code {...props} />;
      case 'p':
        return <Editors.P {...props} />;
      case 'h1':
        return <Editors.H1 {...props} />;
      case 'h2':
        return <Editors.H2 {...props} />;
      case 'h3':
        return <Editors.H3 {...props} />;
      case 'h4':
        return <Editors.H4 {...props} />;
      case 'h5':
        return <Editors.H5 {...props} />;
      case 'h6':
        return <Editors.H6 {...props} />;
      case 'youtube':
      case 'audio':
      case 'img':
      case 'table':
      case 'tr':
      case 'thead':
      case 'tbody':
      case 'tfoot':
      case 'td':
      case 'th':
      case 'ol':
      case 'ul':
      case 'li':
      case 'math':
      case 'math_line':
      case 'code_line':
      case 'blockquote':
      case 'example':
      case 'a':
      case 'dfn':
      case 'cite':
        return <span {...props.attributes}>Not implemented</span>;
      default:
        assertNever(model);
    }
  }, []);

  return (
    <Slate
      editor={editor}
      value={value}
      selection={selection}
      onChange={(value, selection) => {
        setValue(value as any)
        setSelection(selection)
      }}
    >
      <HoveringToolbar />
      <Editable
        renderElement={renderElement}
        renderLeaf={props => <Leaf {...props} />}
        placeholder="Enter some text..."
        onDOMBeforeInput={event => {
          switch ((event as any).inputType) {
            case 'formatBold':
              return editor.exec({ type: 'toggle_format', format: 'bold' })
            case 'formatItalic':
              return editor.exec({ type: 'toggle_format', format: 'italic' })
            case 'formatUnderline':
              return editor.exec({
                type: 'toggle_format',
                format: 'underlined',
              })
          }
        }}
      />
    </Slate>
  )
}

const withFormatting = editor => {
  const { exec } = editor

  editor.exec = command => {
    switch (command.type) {
      case 'toggle_format': {
        const { format } = command
        const isActive = isFormatActive(editor, format)
        Editor.setNodes(
          editor,
          { [format]: isActive ? null : true },
          { match: 'text', split: true }
        )
        break
      }

      default: {
        exec(command)
        break
      }
    }
  }

  return editor
}

const isFormatActive = (editor, format) => {
  const [match] = Editor.nodes(editor, {
    match: { [format]: true },
    mode: 'all',
  })
  return !!match
}

function assertNever(x: never): never {
  throw new Error("Unexpected object: " + x);
}


const Leaf = ({ attributes, children, leaf }) => {

  const markup = 
    Object
      .keys(Marks)
      .reduce((m, k) => leaf[k] !== undefined ? React.createElement(Marks[k], m) : m, children);

  return <span {...attributes}>{markup}</span>
}

const HoveringToolbar = () => {
  const ref = useRef()
  const editor = useSlate()

  useEffect(() => {
    const el = ref.current as any;
    const { selection } = editor

    if (!el) {
      return
    }

    if (
      !selection ||
      !ReactEditor.isFocused(editor) ||
      Range.isCollapsed(selection) ||
      Editor.text(editor, selection) === ''
    ) {
      el.removeAttribute('style')
      return
    }

    const domSelection = window.getSelection()
    const domRange = domSelection.getRangeAt(0)
    const rect = domRange.getBoundingClientRect()
    el.style.opacity = 1
    el.style.top = `${rect.top + window.pageYOffset - el.offsetHeight}px`
    el.style.left = `${rect.left +
      window.pageXOffset -
      el.offsetWidth / 2 +
      rect.width / 2}px`
  })

  return (
    <Portal>
      <Menu
        ref={ref}
        style={`
          padding: 8px 7px 6px;
          position: absolute;
          z-index: 1;
          top: -10000px;
          left: -10000px;
          margin-top: -6px;
          opacity: 0;
          background-color: #222;
          border-radius: 4px;
          transition: opacity 0.75s;
        `}
      >
        <FormatButton format="strong" icon="format_bold" />
        <FormatButton format="em" icon="format_italic" />
        <FormatButton format="mark" icon="format_underlined" />
      </Menu>
    </Portal>
  )
}

const FormatButton = ({ format, icon }) => {
  const editor = useSlate()
  return (
    <Button
      reversed
      active={isFormatActive(editor, format)}
      onMouseDown={event => {
        event.preventDefault()
        editor.exec({ type: 'toggle_format', format })
      }}
    >
      <Icon>{icon}</Icon>
    </Button>
  )
}

