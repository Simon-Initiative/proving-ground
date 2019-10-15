// frozen.ts

export type Array<T> = Readonly<T[]>;

//export function push<T extends Array<T>>(arr: Array<T>, item: T): Array<T> {
    
//}

export interface Freezable {
}

export function create<T extends Freezable>(params: T) : T {
    return params as T;
}

export function merge<T extends Freezable>(obj: T, changes: Partial<T>) : T {
    return Object.assign({}, obj, changes) as T;
}

