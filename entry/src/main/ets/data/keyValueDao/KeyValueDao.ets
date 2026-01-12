import { distributedKVStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';

const APP_ID = 'com.dtse.personal_finance_vault';
const STORE_ID = 'credentials';

export class KeyValueDao {
  private static kvManager: distributedKVStore.KVManager | undefined = undefined;
  private static kvStore: distributedKVStore.SingleKVStore | undefined = undefined;

  static async initKVManager(context: Context): Promise<void> {
    if (KeyValueDao.kvManager) {
      return;
    }

    try {
      const config: distributedKVStore.KVManagerConfig = {
        context,
        bundleName: APP_ID
      };
      KeyValueDao.kvManager = distributedKVStore.createKVManager(config);
      console.info('[KeyValueDao] KVManager created successfully');
    } catch (e) {
      const err = e as BusinessError;
      console.error(`[KeyValueDao] Failed to create KVManager. code=${err.code}, msg=${err.message}`);
    }
  }

  static async getKVStore(): Promise<distributedKVStore.SingleKVStore> {
    if (KeyValueDao.kvStore) {
      return KeyValueDao.kvStore;
    }

    return new Promise((resolve, reject) => {
      if (!KeyValueDao.kvManager) {
        reject(new Error('[KeyValueDao] KVManager not initialized'));
        return;
      }

      const options: distributedKVStore.Options = {
        createIfMissing: true,
        encrypt: true,
        backup: false,
        autoSync: false,
        kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION,
        securityLevel: distributedKVStore.SecurityLevel.S3
      };

      KeyValueDao.kvManager.getKVStore<distributedKVStore.SingleKVStore>(
        STORE_ID,
        options,
        (err, store) => {
          if (err) {
            console.error(`[KeyValueDao] Failed to get KVStore. msg=${err.message}`);
            reject(err);
            return;
          }
          KeyValueDao.kvStore = store as distributedKVStore.SingleKVStore;
          console.info('[KeyValueDao] Encrypted KVStore obtained successfully');
          resolve(KeyValueDao.kvStore);
        }
      );
    });
  }

  static async put(key: string, value: string | Uint8Array | number | boolean): Promise<void> {
    const store = await KeyValueDao.getKVStore();
    return new Promise((resolve, reject) => {
      store.put(key, value, (err) => {
        if (err) {
          console.error(`[KeyValueDao] Failed to put data. key=${key}, err=${err}`);
          reject(err);
          return;
        }
        console.info(`[KeyValueDao] Data put successfully: ${key}=${value}`);
        resolve();
      });
    });
  }

  static async get(key: string): Promise<string | number | boolean | Uint8Array | null> {
    const store = await KeyValueDao.getKVStore();
    return new Promise((resolve, reject) => {
      store.get(key, (err, data) => {
        if (err) {
          if (err.message.includes('Not found')) {
            resolve(null);
            return;
          }
          console.error(`[KeyValueDao] Failed to get data. key=${key}, err=${err}`);
          reject(err);
          return;
        }
        console.info(`[KeyValueDao] Data retrieved: ${key}=${data}`);
        resolve(data ?? null);
      });
    });
  }

  static async delete(key: string): Promise<void> {
    const store = await KeyValueDao.getKVStore();
    return new Promise((resolve, reject) => {
      store.delete(key, (err) => {
        if (err) {
          console.error(`[KeyValueDao] Failed to delete data. key=${key}, err=${err}`);
          reject(err);
          return;
        }
        console.info(`[KeyValueDao] Data deleted: ${key}`);
        resolve();
      });
    });
  }

  static async closeStore(): Promise<void> {
    if (!KeyValueDao.kvManager) {
      return;
    }
    KeyValueDao.kvStore = undefined;
    await new Promise<void>((resolve, reject) => {
      KeyValueDao.kvManager!.closeKVStore(APP_ID, STORE_ID, (err) => {
        if (err) {
          console.error(`[KeyValueDao] Failed to close KVStore. err=${err}`);
          reject(err);
          return;
        }
        console.info('[KeyValueDao] KVStore closed successfully');
        resolve();
      });
    });
  }

  static async deleteStore(): Promise<void> {
    if (!KeyValueDao.kvManager) {
      return;
    }
    KeyValueDao.kvStore = undefined;
    await new Promise<void>((resolve, reject) => {
      KeyValueDao.kvManager!.deleteKVStore(APP_ID, STORE_ID, (err) => {
        if (err) {
          console.error(`[KeyValueDao] Failed to delete KVStore. err=${err}`);
          reject(err);
          return;
        }
        console.info('[KeyValueDao] KVStore deleted successfully');
        resolve();
      });
    });
  }

  static async backupStore(backupFileName: string): Promise<void> {
    const store = await KeyValueDao.getKVStore();
    return new Promise((resolve, reject) => {
      store.backup(backupFileName, (err) => {
        if (err) {
          console.error(`[KeyValueDao] Failed to backup KVStore. err=${err}`);
          reject(err);
        } else {
          console.info(`[KeyValueDao] KVStore backed up successfully -> ${backupFileName}`);
          resolve();
        }
      });
    });
  }

  static async restoreStore(backupFileName: string): Promise<void> {
    const store = await KeyValueDao.getKVStore();
    return new Promise((resolve, reject) => {
      store.restore(backupFileName, (err) => {
        if (err) {
          console.error(`[KeyValueDao] Failed to restore KVStore. err=${err}`);
          reject(err);
        } else {
          console.info(`[KeyValueDao] KVStore restored successfully <- ${backupFileName}`);
          resolve();
        }
      });
    });
  }

  static async deleteBackup(backupFileName: string): Promise<void> {
    if (!KeyValueDao.kvStore) {
      throw new Error('[KeyValueDao] KVStore not initialized');
    }
    return KeyValueDao.kvStore!.deleteBackup([backupFileName]).then(
      (data) => {
        console.info(`[KeyValueDao] Backup deleted successfully: filename=${data[0]}, result=${data[1]}`);
      },
      (err: BusinessError) => {
        console.error(`[KeyValueDao] Failed to delete backup. err=${err}`);
      }
    );
  }
}
