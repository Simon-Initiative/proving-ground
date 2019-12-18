import * as React from 'react';
import * as Immutable from 'immutable';
import { Editor } from 'slate';
import { CodeBlock, CodeBlockLine } from './CodeBlock';
import { MathBlock, MathBlockLine } from './MathBlock';
import { InlineData, InlineStyle, BlockStyle, BlockData, Link, getData, Definition } from 'data/content/types';
import { Image } from './Image';
import { MultipleChoice, Choice, Feedback, Stem } from './MultipleChoice';
import YouTube from './YouTube';
import { Example } from './Example';
import { DeliveryQuestion } from './DeliveryQuestion';

// Slate plugin to allow Ctrl plus a character to
// toggle character styling
function markHotkey(options) {
  const { type, key } = options;

  return {
    onKeyDown(event, editor, next) {
      // If it doesn't match our `key`, let other plugins handle it.
      if (!(event.ctrlKey || event.metaKey) || event.key !== key) return next();

      // Prevent the default characters from being inserted.
      event.preventDefault();

      // Toggle the mark `type`.
      editor.toggleMark(type);
    },
  };
}

export const plugins = [
  markHotkey({ key: 'b', type: 'bold' }),
  markHotkey({ key: '`', type: 'code' }),
  markHotkey({ key: 'i', type: 'italic' }),
  markHotkey({ key: '~', type: 'strikethrough' }),
  markHotkey({ key: 'u', type: 'underline' }),
  markHotkey({ key: 'h', type: 'mark' }),
];

export function renderBlock(props, editor, next) {
  const { node, attributes, children } = props;

  const onDataEdit = (data: BlockData) => {

    const kvs = Object.keys(data).map(k => [k, data[k]]);
    const dataMap = Immutable.Map<any, any>(kvs as any);
    const selection = editor.value.selection;
    editor
      .replaceNodeByKey(node.key, node.merge({ data: dataMap }) as any)
      .select(selection);
  };
  
  switch (node.type as BlockStyle) {
    case 'heading-one':
      return <h1 class="ui header" {...attributes}>{children}</h1>
    case 'heading-two':
      return <h2 class="ui header" {...attributes}>{children}</h2>
    case 'heading-three':
      return <h3 class="ui header" {...attributes}>{children}</h3>
    case 'heading-four':
      return <h4 class="ui header" {...attributes}>{children}</h4>
    case 'heading-five':
      return <h5 class="ui header" {...attributes}>{children}</h5>
    case 'heading-six':
      return <h6 class="ui header" {...attributes}>{children}</h6>
    case 'paragraph':
      return <p {...attributes}>{children}</p>;
    case 'quote':
      return <blockquote {...attributes}>{children}</blockquote>;
    case 'code':
      return <CodeBlock {...props} />
    case 'code_line':
      return <CodeBlockLine {...props} />
    case 'math':
      return <MathBlock {...props} />
    case 'math_line':
      return <MathBlockLine {...props} />
    case 'image':
      return <Image {...props} />
    case 'youtube':
      return <YouTube {...props} />
    case 'table':
      return (
        <table {...attributes} className="ui celled compact table">
          {children}
        </table>
      );
    case 'tr':
      return <tr {...attributes}>{children}</tr>
    case 'td':
      return <td {...attributes}>{children}</td>
    case 'th':
      return <th {...attributes}>{children}</th>  
    case 'thead':
      return <thead {...attributes}>{children}</thead>  
    case 'tbody':
      return <tbody {...attributes}>{children}</tbody>  
    case 'example':
      return <Example {...props}/>;
    case 'multiple_choice':
      return <MultipleChoice {...props}/>;
    case 'choice':
      return <Choice {...props} radioName="Stem"/>;
    case 'feedback':
      return <Feedback {...props} radioName="Stem"/>;
    case 'stem':
      return <Stem {...props} label="Stem"/>;
    case 'question':
      return <DeliveryQuestion {...props} />;
    default:
      return next();
  }
}

// Slate mark rendering
export function renderMark(props, editor, next) {
  switch (props.mark.type as InlineStyle) {
    case 'sub':
      return <sub>{props.children}</sub>;
    case 'sup':
      return <sup>{props.children}</sup>;
    case 'bold':
      return <strong>{props.children}</strong>;
    case 'underline':
      return <u>{props.children}</u>;
    case 'code':
      return <code>{props.children}</code>;
    case 'italic':
      return <em>{props.children}</em>;
    case 'strikethrough':
      return <del>{props.children}</del>;
    case 'mark':
      return <mark>{props.children}</mark>;
    default:
      return next();
  }
}


// Slate inline rendering
export function renderInline(extras, props, editor: Editor, next) {
  const { onInlineClick, context, parentProps, parent } = extras;
  const { attributes, children, node } = props;

  const onClick = (e) => {
    e.preventDefault();
    onInlineClick(node);
  };

  const standardProps = {
    context,
    attrs: attributes,
    onClick,
    node,
    editor,
  };

  const blue = { color: 'blue' };
  const green = { color: 'green' };

  switch (node.type) {
    case 'link': {
      return <span 
        class="definition" 
        data-title="Hyperlink" 
        data-content={getData<Link>(node.data).href} 
        style={blue} {...attributes}>{children}</span>;
    }
    case 'definition': {
      return <span 
        class="definition" 
        data-title="Definition" 
        data-content={getData<Definition>(node.data).definition} 
        style={green} {...attributes}>{children}</span>;
    }

    default: {
      return next();
    }
  }
}
