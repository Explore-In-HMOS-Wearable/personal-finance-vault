import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import Dao from '../data/rdbDao/RDBDao';
import { KeyValueDao } from '../data/keyValueDao/KeyValueDao';

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
    onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
        this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
        hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
    }

    onDestroy(): void {
        hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
    }

    onWindowStageCreate(windowStage: window.WindowStage): void {
        // Main window is created, set main page for this ability
        hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
        windowStage.loadContent('Main', (err) => {

            // Initialize KVStore
            KeyValueDao.initKVManager(this.context)
                .then(() => {
                    hilog.info(0x0000, 'testTag', 'KVStore initialized successfully');
                    // You can do more operations here if needed after init
                })
                .catch((err: BusinessError) => {
                    hilog.error(0x0000, 'testTag', 'KVStore initialization failed: %{public}s', err.message);
                });

            // Initialize RDB
            Dao.createDB(this.context)
                .then(() => {
                    hilog.info(0x0000, 'testTag', 'RDB initialized and table created successfully');
                })
                .catch((err: BusinessError) => {
                    hilog.error(0x0000, 'testTag', 'RDB initialization failed: %{public}s', err.message);
                });

            hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');

            if (err) {
                hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
                return;
            }
            hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
        });
    }

    onWindowStageDestroy(): void {
        // Main window is destroyed, release UI related resources
        hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
    }

    onForeground(): void {
        // Ability has brought to foreground
        hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
    }

    onBackground(): void {
        // Ability has back to background
        hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
    }
}