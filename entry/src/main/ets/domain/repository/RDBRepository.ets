import { Operation } from '../model/Operation';

export interface RDBRepository{
    getLast5Operations(): Promise<Operation[]>;
    getAllOperations(): Promise<Operation[]>;
    insertOperation(code: number, name: string, amount: number): Promise<void>;
}