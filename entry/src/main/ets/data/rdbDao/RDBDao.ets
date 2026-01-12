import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { Operation } from '../../domain/model/Operation';

let store: relationalStore.RdbStore | undefined;

const STORE_CONFIG: relationalStore.StoreConfig = {
  name: 'rdb.db',
  securityLevel: relationalStore.SecurityLevel.S1
};

export class RDBDao {
  createDB(context: Context): Promise<void> {
    return new Promise((resolve, reject) => {
      relationalStore.getRdbStore(context, STORE_CONFIG,
        (err: BusinessError, rdbStore: relationalStore.RdbStore) => {
          if (err) {
            hilog.error(0, 'testTag', 'getRdbStore failed: Cause: %{public}s', JSON.stringify(err));
            reject(err);
            return;
          }
          store = rdbStore;
          store.executeSql('CREATE TABLE IF NOT EXISTS operations (id INTEGER PRIMARY KEY,code INTEGER, name TEXT, amount INTEGER);',
            (sqlErr) => {
              if (sqlErr) {
                hilog.error(0, 'testTag', 'Table creation failed:  Cause: %{public}s', JSON.stringify(err));
                reject(sqlErr);
                return;
              }
              hilog.info(0, 'testTag', 'Table created successfully.');
              resolve();
            });
        }
      );
    });
  }

  /**
   * Insert a row into the table.
   * @param table Table name.
   * @param data  { key: string, value: string }
   */
  async insert(code: number, name: string, amount: number): Promise<void> {
    if (!store) {
      return Promise.reject(new Error('Store not initialized'));
    }

    const sql = `INSERT INTO operations (code, name, amount) VALUES (?, ?, ?)`;
    return store.executeSql(sql, [code, name, amount])
      .then(() => hilog.info(0, 'testTag', `Inserted successfully: `))
      .catch((err: BusinessError) => {
        hilog.error(0, 'testTag', 'Insert failed. Cause: %{public}s', JSON.stringify(err));
      });
  }

  /**
   * Query the database.
   * @param sql SQL query string.
   */
  query(limit: number): Promise<Operation[]> {
    return new Promise((resolve, reject) => {
      if (!store) {
        reject(new Error('Store not initialized'));
        return;
      }

      // Build SQL dynamically
      let sql = 'SELECT id, code, name, amount FROM operations ORDER BY id DESC';
      if (limit > 0) {
        sql += ` LIMIT ${limit}`;
      }

      store.querySql(sql, (err, resultSet) => {
        if (err) {
          hilog.error(0, 'testTag', 'Query failed. Cause: %{public}s', JSON.stringify(err));
          reject(err);
          return;
        }

        const results: Operation[] = [];
        while (resultSet.goToNextRow()) {
          const row: Operation = {
            id: resultSet.getLong(0) ?? -1,
            code: resultSet.getLong(1) ?? 0,
            name: resultSet.getString(2) ?? '',
            amount: resultSet.getLong(3) ?? 0
          };
          results.push(row);
        }
        resultSet.close();

        resolve(results);
      });
    });
  }

  update(table: string, data: Record<string, number>, where: string): Promise<void> {
    if (!store) {
      return Promise.reject(new Error('Store not initialized'));
    }
    const setClause = Object.entries(data)
      .map((entry) => {
        const k = entry[0];
        const v = entry[1];
        return `${k} = ${v}`;
      })
      .join(', ');
    const sql = `UPDATE ${table} SET ${setClause} WHERE ${where}`;
    return store.executeSql(sql)
      .then(() => hilog.info(0, 'testTag', 'Updated successfully'))
      .catch((err: BusinessError) => {
        hilog.error(0, 'testTag', 'Update failed. Cause: %{public}s', JSON.stringify(err));
      });
  }

  delete(code: number): Promise<void> {
    if (!store) {
      return Promise.reject(new Error('Store not initialized'));
    }
    const sql = `DELETE FROM operations WHERE code = ?`;
    return store.executeSql(sql, [code])
      .then(() => hilog.info(0, 'testTag', 'Deleted successfully'))
      .catch((err: BusinessError) => {
        hilog.error(0, 'testTag', 'Delete failed. Cause: %{public}s', JSON.stringify(err));
      });
  }
}

const dao = new RDBDao();

export default dao;
