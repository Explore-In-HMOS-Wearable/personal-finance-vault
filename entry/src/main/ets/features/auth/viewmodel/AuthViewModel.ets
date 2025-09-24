import { KVRepositoryImpl } from '../../../data/repository/KVRepositoryImpl';

export class AuthViewModel {
    private repository = KVRepositoryImpl.getInstance();

    async initKeyValueRepository() {
        await this.repository.init();
    }

    async isThereAnyUser(): Promise<boolean> {
        return await this.repository.isThereAnyUser();
    }

    createUser(input: string) {
        this.repository.setUserPassword(input);
    }

    async loginUser(input: string): Promise<boolean> {
        const password = await this.repository.getUserPassword();
        return password === input;
    }

    async restoreUserFromBackup(backupFileName: string) {
        await this.repository.restoreStore(backupFileName);
    }
}
