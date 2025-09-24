import { KVRepository } from '../../domain/repository/KVRepository';
import { KeyValueDao } from '../keyValueDao/KeyValueDao';
import { distributedKVStore } from '@kit.ArkData';

export class KVRepositoryImpl implements KVRepository {
    private static instance: KVRepositoryImpl;
    keyValueStore: distributedKVStore.SingleKVStore | null = null;

    private constructor() {
    }

    static getInstance(): KVRepositoryImpl {
        if (!KVRepositoryImpl.instance) {
            KVRepositoryImpl.instance = new KVRepositoryImpl();
        }
        return KVRepositoryImpl.instance;
    }

    async init(): Promise<void> {
        if (!this.keyValueStore) {
            this.keyValueStore = await KeyValueDao.getKVStore();
        }
    }

    async isThereAnyUser(): Promise<boolean> {
        if (this.keyValueStore) {
            const storedUser = await KeyValueDao.get('password');
            return storedUser ? true : false;
        }
        return false;
    }

    async getUserPassword(): Promise<string> {
        const value = await KeyValueDao.get('password');
        return typeof value === 'string' ? value : '';
    }

    setUserPassword(password: string): void {
        KeyValueDao.put('password', password);
    }

    async backupStore(fileName: string) {
        await KeyValueDao.backupStore(fileName);
    }

    async restoreStore(fileName: string) {
        await KeyValueDao.restoreStore(fileName);
    }

    async deleteBackup(fileName: string) {
        await KeyValueDao.deleteBackup(fileName);
    }
}
