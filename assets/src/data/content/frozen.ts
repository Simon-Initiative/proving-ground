// frozen.ts

export interface Freezable {
}

export function create<T extends Freezable>(params: T) : T {
    return params as T;
}

export function merge<T extends Freezable>(obj: T, changes: Partial<T>) : T {
    return Object.assign({}, obj, changes) as T;
}
