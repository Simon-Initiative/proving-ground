import { Block, Editor } from 'slate';

const normalize = (editor : Editor, error) => {
  console.log('other error: ' + error.code);
  console.log(error.node.type);
  if (error.code === 'child_type_invalid') {
    return editor.setNodeByKey(error.child.key, { type: 'paragraph' })
  } else if (error.code === 'last_child_type_invalid') {
    const paragraph = Block.create('paragraph');
    if (error.node.nodes.size === 1 && error.node.nodes.get(0).object === 'text') {
      return editor
        .replaceNodeByKey(error.node.key, paragraph);
    }
    return editor.insertNodeByKey(error.node.key, error.node.nodes.size, paragraph)
  }
};

const standardContent = {
  last: { type: 'paragraph' },
  nodes: [
    {
      match: [
        { type: 'paragraph' },
        { type: 'image' },
        { type: 'youtube' },
        { type: 'code' },
        { type: 'math' },
        { type: 'table' },
        { type: 'ordered-list' },
        { type: 'unordered-list' },
      ],
    }
  ],
  normalize
};

export const schema = {
  document: {
    last: { type: 'paragraph' },
    nodes: [
      {
        match: [
          { type: 'heading-one' }, 
          { type: 'heading-two' }, 
          { type: 'heading-three' }, 
          { type: 'heading-four' }, 
          { type: 'heading-five' }, 
          { type: 'heading-six' }, 
          { type: 'paragraph' }, 
          { type: 'image' }, 
          { type: 'code' }, 
          { type: 'math' },
          { type: 'youtube' },
          { type: 'ordered-list' },
          { type: 'unordered-list' },
          { type: 'table' },
          { type: 'example' },
          { type: 'multiple_choice' },
          { type: 'question' },
        ],
      },
    ],
    normalize
  },
  blocks: {
    paragraph: {
      
    },
    table: {
      nodes: [
        {
          match: [{ type: 'thead' }, { type: 'tbody' }],
        },
      ],
    },
    thead: {
      nodes: [
        {
          match: [{ type: 'tr' }],
        },
      ],
    },
    tbody: {
      nodes: [
        {
          match: [{ type: 'tr' }],
        },
      ],
    },
    tr: {
      nodes: [
        {
          match: [{ type: 'td' }, { type: 'th' }],
        },
      ],
    },
    td: {
      nodes: [
        {
          match: [{ type: 'paragraph' },{ type: 'image' }],
        },
      ],
    },
    th: {
      nodes: [
        {
          match: [{ type: 'paragraph' },{ type: 'image' }],
        },
      ],
    },
    multiple_choice: {
      nodes: [
        {
          match: { type: 'stem' },
          min: 1,
          max: 1,
        },
        {
          match: { type: 'choice_feedback' },
          min: 1,
          max: 6,
        },
        {
          match: { type: 'hint' },
          min: 0,
          max: 3,
        }
      ],
      normalize: (editor : Editor, error) => {
        console.log('mc error: ' + error.code);
      },
    },
    choice_feedback: {
      nodes: [
        {
          match: { type: 'choice' },
          min: 1,
          max: 1,
        },
        {
          match: { type: 'feedback' },
          min: 1,
          max: 1,
        },
      ],
      normalize: (editor : Editor, error) => {
        console.log('choice_feedback error: ' + error.code);
      },
    },
    stem: standardContent,
    choice: standardContent,
    feedback: standardContent,
    hint: standardContent,
    example: {
      nodes: [
        {
          match: [{ type: 'variant' }],
        },
      ],
    },
    variant: standardContent,
    code: {
      nodes: [
        {
          match: [{ type: 'code_line' }],
        },
      ],
    },
    code_line: {
      marks: [],
      inlines: [],
      nodes: [
        {
          match: { object: 'text' },
          
        },
      ],
    },
    math: {
      nodes: [
        {
          match: [{ type: 'math_line' }],
        },
      ],
    },
    math_line: {
      marks: [],
      inlines: [],
      nodes: [
        {
          match: { object: 'text' },
        },
      ],
    },
    image: {
      isVoid: true,
    },
    youtube: {
      isVoid: true,
    },
    question: {
      isVoid: true,
    }
  },
}
