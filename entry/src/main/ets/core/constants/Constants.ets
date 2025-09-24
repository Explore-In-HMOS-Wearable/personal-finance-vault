import { OperationType } from '../../features/add/models/OperationType';

export class Constants {
    static readonly SQL_TABLE_NAME: string = 'operations';
    static readonly SQL_CREATE_TABLE: string =
        'CREATE TABLE IF NOT EXISTS operations (code INTEGER PRIMARY KEY, name TEXT, amount INTEGER);';
    static readonly DOMAIN: string = 'VaultTAG';
    static readonly SQL_INIT_USER_TABLE: string = 'INSERT INTO user_info VALUES(1)';
    static readonly SQL_QUERY_TABLE: string = 'SELECT * FROM migration_table WHERE id = 1';
    static readonly EMPTY_STRING: string = '';
    static readonly PROGRESS_MAX: number = 100;
    static readonly PROGRESS_STEP: number = 20;
    static readonly PERCENT_WIDTH: string = '100%';
    static readonly PERCENT_NINETY_WIDTH: string = '90%';
    static readonly NUMBER_100: number = 100;
    static readonly NUMBER_400: number = 400;
    static readonly NUMBER_500: number = 500;
    static readonly BACKUP_NAME: string = 'user_backup';
    static readonly OPERATION_TYPES: OperationType[] = [
        { name: 'Investment', colorCode: '#ccaa02', code: 0 },
        { name: 'Expense', colorCode: '#cc1d02', code: -1 },
        { name: 'Income', colorCode: '#27cc02', code: 1 }
    ];
}
