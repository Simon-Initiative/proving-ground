
// another.ts
import * as F from './frozen';


interface Link extends F.Freezable {
    readonly src: string;
    readonly target?: string;
    tags?: F.Array<string>;
};
F.create<Link>({ src: 'test'})


const link = F.create<Link>({ src: 'test', tags: ['one', 'two', 'three'] });
const updated = F.merge<Link>(link, { src: 'updated' });  // Good!

updated.src = "test"

