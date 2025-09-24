import { Operation } from '../../domain/model/Operation';
import { RDBRepository } from '../../domain/repository/RDBRepository';
import Dao from '../rdbDao/RDBDao';

export class RDBRepositoryImpl implements RDBRepository {

    async insertOperation(code: number, name: string, amount: number): Promise<void> {
        return await Dao.insert(code, name, amount);
    }

    async getLast5Operations(): Promise<Operation[]> {
        return Dao.query(5);
    }

    getAllOperations(): Promise<Operation[]> {
        return Dao.query(0);
    }

}