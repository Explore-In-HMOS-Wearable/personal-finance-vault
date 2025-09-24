export interface KVRepository {
    isThereAnyUser(): Promise<boolean>;
    getUserPassword(): Promise<string>;
    setUserPassword(password: string): void;
    backupStore(backupFileName: string): Promise<void> ;
    restoreStore(backupFileName: string): Promise<void>;
    deleteBackup(backupFileName: string): Promise<void>;
}