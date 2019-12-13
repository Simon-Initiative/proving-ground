import * as Immutable from 'immutable';
import { InlineData, InlineStyle, BlockStyle } from 'data/content/types';
import { Editor, Text, Range } from 'slate';
import { Maybe } from 'tsmonad';
import { create, Image, YouTube } from 'data/content/types';

export type ValuePair = [any, any];


/**
 * Get the extension of the URL, using the URL API.
 *
 * @param {String} url
 * @return {String}
 */

export function getExtension(url) {
  return new URL(url).pathname.split('.').pop()
}

/**
 * A change function to standardize inserting images.
 *
 * @param {Editor} editor
 * @param {String} src
 * @param {Range} target
 */

export function insertImage(editor, src, target) {
  if (target) {
    editor.select(target);
  }

  editor.insertBlock({
    type: 'image',
    data: create<Image>({ src, alt: '', caption: '', object: 'image', id: '', tags: [] }),
  });
}

export function insertYouTube(editor, src, target) {
  if (target) {
    editor.select(target);
  }

  editor.insertBlock({
    type: 'youtube',
    data: create<YouTube>({ src, object: 'youtube', id: '', tags: [] }),
  });
}


// Helper routine to turn the current selection into an inline
function wrapInlineWithData(editor, wrapper) {
  editor.wrapInline({
    type: wrapper.contentType,
    data: { value: wrapper },
  });

  editor.moveToEnd();
}

// Remove the inline specified by the given key
export function removeInline(editor: Editor, key: string): Editor {
  return editor.removeNodeByKey(key);
}

// Inserting an inline adds an inline as new content
export function insertInline(editor: Editor, wrapper: InlineData): Editor {
  //const inline = Node.create({ data: { value: wrapper }, type: wrapper.object });
  //return editor.insertInline(inline);
  return editor;
}

// Applying an inline turns the current selection into an inline
export function applyInline(editor: Editor, wrapper: InlineData): Editor {
  return editor.command(wrapInlineWithData, wrapper);
}

// Returns true if the slate editor contains one block and
// the text in that block is empty or contains all spaces
export function isEffectivelyEmpty(editor: Editor): boolean {
  const nodes = editor.value.document.nodes;
  return nodes.size === 1
    && nodes.get(0).object === 'text'
    && nodes.get(0).text.trim() === '';
}

// Returns true if the selection is collapsed and the cursor is
// positioned in the last block and no text other than spaces
// follows the cursor
export function isCursorAtEffectiveEnd(editor: Editor): boolean {
  const node = (editor.value.document.nodes
    .get(editor.value.document.nodes.size - 1) as any);
  const { key, text } = node;

  const selection = editor.value.selection;

  return selection.isCollapsed
    && key === selection.anchor.key
    && text.trim().length <= selection.anchor.offset;
}

// Returns true if the selection is collapsed and is at the
// very beginning of the first block
export function isCursorAtBeginning(editor: Editor): boolean {
  const key = (editor.value.document.nodes.get(0) as any).key;
  const selection = editor.value.selection;
  return selection.isCollapsed
    && key === selection.anchor.key
    && selection.anchor.offset === 0;
}

// Find a specific node by its key
function findNodeByKey(editor: Editor, key: string): Maybe<any> {
  const predicate = b => b.key === key;
  return findNodeByPredicate(editor, predicate);
}

// Find an input ref inline by its input attribute
function findInputRef(editor: Editor, input: string): Maybe<any> {
  const predicate = b => b.object === 'inline'
    && b.data.get('value').contenType === 'InputRef'
    && b.data.get('value').input === input;
  return findNodeByPredicate(editor, predicate);
}

// Flexible find a node by a supplied predicate
function findNodeByPredicate(editor: Editor,
  predicate: (node: any) => boolean): Maybe<any> {

  const nodes = editor.value.document.nodes.toArray();
  for (let i = 0; i < nodes.length; i += 1) {
    const b = nodes[i] as any;
    if (predicate(b)) {
      return Maybe.just(b);
    }
    const inner = b.nodes.toArray();
    for (let j = 0; j < inner.length; j += 1) {
      const m = inner[j];
      if (predicate(m)) {
        return Maybe.just(m);
      }
    }
  }
  return Maybe.nothing();
}

// Find a collection of nodes based on a predicate
function findNodesByPredicate(editor: Editor,
  predicate: (node: any) => boolean): Immutable.List<any> {

  const found = [];
  const nodes = editor.value.document.nodes.toArray();
  for (let i = 0; i < nodes.length; i += 1) {
    const b = nodes[i] as any;
    if (predicate(b)) {
      found.push(b);
    }
    const inner = b.nodes.toArray();
    for (let j = 0; j < inner.length; j += 1) {
      const m = inner[j];
      if (predicate(m)) {
        found.push(m);
      }
      if (m.object === 'inline') {
        const inlines = m.nodes.toArray();
        for (let k = 0; k < inlines.length; k += 1) {
          const inlineNode = inlines[k];
          if (predicate(inlineNode)) {
            found.push(inlineNode);
          }
        }
      }
    }
  }
  return Immutable.List(found);
}

// For an inline specified by a given key, update its data wrapper
// with the supplied wrapper
export function updateInlineData(editor: Editor, key: string, wrapper: InlineData): Editor {

  const selection = editor.value.selection;

  return findNodeByKey(editor, key).caseOf({
    just: (n) => {
      if (n.object === 'inline') {
        return editor
          .replaceNodeByKey(key, n.merge({ data: { value: wrapper } }) as any)
          .select(selection);
      }
      return editor;
    },
    nothing: () => editor,
  });

}

export function toggleMark(e: Editor, style: InlineStyle) {
  e.toggleMark(style)
    .focus();
}

// Helper to determine if a selection is not collapsed and
// that only bare (i.e. non inline) text is selected
export function bareTextSelected(editor: Maybe<Editor>): boolean {
  return editor.caseOf({
    just: (e) => {

      if (e.value.selection.isCollapsed) {
        return false;
      }
      const s = e.value.selection;
      
      //const range = new Range({ anchor: s.anchor, focus: s.focus });
      return true;
    },
    nothing: () => false,
  });
}

// Helper to determine if no text is selected
export function noTextSelected(editor: Maybe<Editor>): boolean {
  return editor.caseOf({
    just: e => e.value.selection.isCollapsed,
    nothing: () => false,
  });
}

// Is the current selection inside an inline?
export function cursorInEntity(editor: Maybe<Editor>): boolean {
  return editor.caseOf({
    just: e => getEntityAtCursor(e).caseOf({
      just: i => true,
      nothing: () => false,
    }),
    nothing: () => false,
  });
}

// Accesses the plain text from a selection with a single
// paragraph of continguous text.  If the selection spans
// multiple content blocks (i.e. paragraphs) we return Nothing. If
// the block is not found or the selection offsets exceed the
// length of the raw text for the block, we return nothing.
// Otherwise, we return just the raw underlying text substring.

export function extractParagraphSelectedText(editor: Maybe<Editor>): Maybe<string> {
  return editor.caseOf({
    just: (e) => {
      const selection = e.value.selection;
      if (selection.isCollapsed || selection.anchor.key !== selection.focus.key) {
        return Maybe.nothing();
      }
      const from = selection.isBackward
        ? selection.anchor.offset
        : selection.focus.offset;
      const to = selection.isBackward
        ? selection.focus.offset
        : selection.anchor.offset;

      return findNodeByKey(e, selection.anchor.key).caseOf({
        just: (n) => {
          return Maybe.just((n.text as string).substring(from, to));
        },
        nothing: () => Maybe.nothing(),
      });

    },
    nothing: () => Maybe.nothing(),
  });
}

// Remove an inline
export function removeInlineEntity(editor: Editor, key: string): Editor {

  return findNodeByKey(editor, key).caseOf({
    just: (n) => {
      if (n.object === 'inline') {
        return editor
          .removeNodeByKey(key);
      }
      return editor;
    },
    nothing: () => editor,
  });

}

// Updates the wrappers for all input ref inlines
export function updateAllInputRefs(
  editor: Editor, itemMap: Object): Editor {

  const predicate = b => b.object === 'inline'
    && b.data.get('value').contenType === 'InputRef';
  const inputRefs = findNodesByPredicate(editor, predicate);

  return inputRefs.toArray().reduce(
    (editor, ref) => {
      const updated = itemMap[(ref as any).data.get('value').input];
      return updated !== undefined
        ? editor.replaceNodeByKey(ref.key, updated)
        : editor;
    },
    editor,
  );
}

// Remove an input ref given its input (item id) value
export function removeInputRef(editor: Editor, itemId: string): Editor {
  return findInputRef(editor, itemId).caseOf({
    just: n => editor.removeNodeByKey(n.key),
    nothing: () => editor,
  });
}

// Access the inline present at the users current selection
export function getEntityAtCursor(editor: Editor): Maybe<any> {

  const s = editor.value.selection;

  if (s.anchor.key === null) {
    return Maybe.nothing();
  }
  if (s.anchor.key !== s.focus.key || !s.isCollapsed) {
    return Maybe.nothing();
  }

  const b = editor.value.document.nodes.get(s.anchor.path.get(0)) as any;

  if (b === undefined) {
    return Maybe.nothing();
  }
  const inner = b.nodes.get(s.anchor.path.get(1));

  if (inner === undefined) {
    return Maybe.nothing();
  }

  if (inner.object === 'inline') {
    return Maybe.just(inner);
  }

  return Maybe.nothing();
}

// Access the set of style names active in the current selection
export function getActiveStyles(e: Editor): Immutable.Set<string> {
  return Immutable.Set<string>(e.value.activeMarks.toArray().map(m => m.type));
}

