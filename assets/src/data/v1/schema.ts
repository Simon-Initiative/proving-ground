import { Block, Editor } from 'slate';

export const schema = {
  document: {
    last: { type: 'paragraph' },
    nodes: [
      {
        match: [
          
            { type: 'paragaph,' },
          
            { type: 'image,' },
          
            { type: 'ul' },
          
        ],
      },
    ],
  },
  blocks: {
    
        li: {
        nodes: [{ match: [
            
                { type: 'paragraph'},
            
        ]}]
    },
    
        ul: {
        nodes: [{ match: [
            
                { type: 'li'},
            
        ]}]
    },
    
        image: {
        nodes: [{ match: [
            
        ]}]
    },
    
        paragraph: {
        nodes: [{ match: [
            
                { type: 'text'},
            
        ]}]
    },
    
  },
}
