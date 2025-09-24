import { Operation } from '../../../domain/model/Operation';
import { DashboardViewModel } from '../viewmodel/DashboardViewModel';
import { LastOperations } from './components/LastOperations';
import { Settings } from './components/Settings';
import { PieChart } from './components/PieChart';
import { Constants } from '../../../core/constants/Constants';

@Builder
export function DashboardPageBuilder() {
    DashboardPage();
}

@Component
struct DashboardPage {
    @Consume('NavPathStack') pageStack: NavPathStack;
    viewModel: DashboardViewModel = new DashboardViewModel();
    @State operations: Operation[] = [];

    async aboutToAppear(): Promise<void> {
        this.operations = await this.viewModel.getAllOperations();
    }

    build() {
        NavDestination() {
            Swiper() {
                PieChart({
                    operations: this.operations,
                    onAddButtonClick: () => {
                        this.pageStack.pushPathByName('InsertOperation', null, async () => {
                            this.operations = await this.viewModel.getAllOperations();
                            this.operations = [...this.operations];
                        });
                    }
                })
                LastOperations({
                    operations: this.operations
                })
                Settings({
                    onResetPassword: async (newPassword: string) => {
                        this.viewModel.resetUserPassword(newPassword);
                    },
                    onBackupUser: async () => {
                        await this.viewModel.backupUser(Constants.BACKUP_NAME);
                    },
                    onRemoveBackup: async () => {
                        await this.viewModel.removeBackup(Constants.BACKUP_NAME);
                    }
                })
            }
            .backgroundColor(Color.Black)
            .width('100%')
            .height('100%')
        }
        .hideTitleBar(true)
        .hideBackButton(true)
        .width('100%')
        .height('100%')
        .onBackPressed(() => {
            return true
        })
    }
}
