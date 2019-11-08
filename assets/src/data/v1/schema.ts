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
    
        Li: {
        nodes: [{ match: [
            
                { type: 'paragraph'},
            
        ]}]
    },
    
        Ul: {
        nodes: [{ match: [
            
                { type: 'li'},
            
        ]}]
    },
    
        Image: {
        nodes: [{ match: [
            
        ]}]
    },
    
        Paragraph: {
        nodes: [{ match: [
            
                { type: 'text'},
            
        ]}]
    },
    
  },
}
