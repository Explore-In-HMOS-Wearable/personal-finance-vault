import { Constants } from '../../../core/constants/Constants';
import { RDBRepositoryImpl } from '../../../data/repository/RDBRepositoryImpl';
import { OperationType } from '../models/OperationType';

export class InsertViewModel {
    private repository = new RDBRepositoryImpl();

    getOperationTypes(): OperationType[] {
        return Constants.OPERATION_TYPES;
    }

    getTypeNameByCode(code: number): string {
        return Constants.OPERATION_TYPES.find(type => type.code === code)?.name ?? 'Expense';
    }

    getTypeColorByCode(code: number): string {
        return Constants.OPERATION_TYPES.find(type => type.code === code)?.colorCode ?? '#4a4a4a';
    }

    async insertOperation(code: number, name: string, amount: number) {
        await this.repository.insertOperation(code, name, amount);
    }
}