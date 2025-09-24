import { KVRepositoryImpl } from '../../../data/repository/KVRepositoryImpl';
import { RDBRepositoryImpl } from '../../../data/repository/RDBRepositoryImpl';
import { Operation } from '../../../domain/model/Operation';

export class DashboardViewModel {
    private repository = new RDBRepositoryImpl();
    private kvRepository = KVRepositoryImpl.getInstance(); // shared KV store

    async getLast5Operations(): Promise<Operation[]> {
        return await this.repository.getLast5Operations();
    }

    async getAllOperations(): Promise<Operation[]> {
        return await this.repository.getAllOperations();
    }

    resetUserPassword(newPassword: string) {
        this.kvRepository.setUserPassword(newPassword);
    }

    async backupUser(backupFileName: string) {
        await this.kvRepository.backupStore(backupFileName);
    }

    async removeBackup(backupFileName: string) {
        await this.kvRepository.deleteBackup(backupFileName);
    }
}
