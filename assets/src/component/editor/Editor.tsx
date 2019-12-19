import React, { useState, useMemo, useRef, useEffect, useCallback } from 'react'
import { Slate, Editable, ReactEditor, withReact, useSlate } from 'slate-react'
import { Editor, Transforms, createEditor, Text, Node } from 'slate'
import { withHistory } from 'slate-history'
import { Marks, ModelElement, schema} from './interfaces';
import { editorFor } from './elements';
import { Button, Menu, Portal } from './utils'
import { Range } from 'slate'

const withEmbeds = editor => {
  const { isVoid } = editor
  editor.isVoid = element => (schema[element.type].isVoid ? true : isVoid(element))
  return editor
}

export type EditorProps = {
  onEdit: (value) => void;
  value: Node[];
}

export const EditorComponent = (props: EditorProps) => {
  const [value, setValue] = useState(props.value)
  const editor = useMemo(() => withEmbeds(withHistory(withReact(createEditor()))), [])

  const renderElement = useCallback(props => {
    const model = props.element as ModelElement;
    return editorFor(model, props);
  }, []);

  return (
    <Slate
      editor={editor as any}
      value={value}
      onChange={value => {
        setValue(value as any)
        props.onEdit(value);
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

const toggleFormat = (editor, format) => {
  const isActive = isFormatActive(editor, format)
  Transforms.setNodes(
    editor,
    { [format]: isActive ? null : true },
    { match: Text.isText, split: true }
  )
}

const isFormatActive = (editor, format) => {
  const [match] = Editor.nodes(editor, {
    match: n => n[format] === true,
    mode: 'all',
  })
  return !!match
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
      Editor.string(editor, selection) === ''
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
        style={{
          padding: "8px 7px 6px",
          position: "absolute",
          zIndex: "1",
          top: "-10000px",
          left: "-10000px",
          marginTop: "-6px",
          opacity: "0",
          backgroundColor: "#222",
          borderRadius: "4px",
          transition: "opacity 0.75s"
        }}
      >
        <FormatButton format="strong" icon="bold" />
        <FormatButton format="em" icon="italic" />
        <FormatButton format="code" icon="code" />
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
      <i className={`${icon} icon`}></i>
    </Button>
  )
}

