import { ArcButton, ArcButtonOptions } from '@ohos.arkui.advanced.ArcButton';
import { Constants } from '../../../core/constants/Constants';
import { AuthViewModel } from '../viewmodel/AuthViewModel';

@Builder
export function AuthPageBuilder() {
  AuthPage();
}

@Component
struct AuthPage {
  @Consume('NavPathStack') pageStack: NavPathStack;
  @State mode: 'create' | 'login' = 'login';
  @State errorMsg: string = '';
  @State inputPassword: string = '';
  viewModel: AuthViewModel = new AuthViewModel();

  async aboutToAppear() {
    await this.viewModel.initKeyValueRepository();
    const isThereAnyUser = await this.viewModel.isThereAnyUser();
    console.info(`is there any user: ${isThereAnyUser}`);
    this.mode = isThereAnyUser ? 'login' : 'create';
  }

  createUser = async () => {
    console.info('create user clicked');
    this.errorMsg = '';
    if (!this.inputPassword) {
      this.errorMsg = 'Required fields.';
      return;
    }
    try {
      this.viewModel.createUser(this.inputPassword);
      this.inputPassword = '';
      this.pageStack.replacePathByName('DashboardPage', null, true);
    } catch {
      this.errorMsg = 'Save failed.';
    }
  };
  loginUser = async () => {
    this.errorMsg = '';
    if (!this.inputPassword) {
      this.errorMsg = 'Required fields.';
      return;
    }
    try {
      const isValidated = await this.viewModel.loginUser(this.inputPassword);
      if (isValidated) {
        this.inputPassword = '';
        this.pageStack.replacePathByName('DashboardPage', null, true);
      } else {
        this.errorMsg = 'Invalid credentials.';
      }
    } catch {
      this.errorMsg = 'Read failed.';
    }
  };

  @Builder
  buildForm(title: string, actionLabel: string, actionFn: () => void) {
    Column() {
      Text(title)
        .fontColor(Color.White)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 8 });

      Blank('10%')

      TextInput({ placeholder: 'Password', text: this.inputPassword })
        .type(InputType.NUMBER_PASSWORD)
        .width('85%')
        .height(40)
        .fontSize(14)
        .margin({ bottom: 6 })
        .onChange((v: string) => {
          this.inputPassword = v;
        });
      if (this.mode === 'login') {
        Text('Load user from backup')
          .decoration({
            type: TextDecorationType.Underline,
            color: Color.Yellow,
            style: TextDecorationStyle.SOLID
          })
          .fontColor(Color.Yellow)
          .fontSize(10)
          .margin({ top: 8 })
          .onClick(async () => {
            try {
              await this.viewModel.restoreUserFromBackup(Constants.BACKUP_NAME);

              const userExists = await this.viewModel.isThereAnyUser();
              if (userExists) {
                this.pageStack.replacePathByName('DashboardPage', null, true);
              } else {
                this.errorMsg = 'No user found in backup.';
              }
            } catch (err) {
              console.error('Failed to load user from backup:', err);
              this.errorMsg = 'Restore failed.';
            }
          });
      }

      Blank()

      if (this.errorMsg) {
        Text(this.errorMsg)
          .fontSize(12)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Red)
          .margin({ bottom: 6 })
          .width('80%')
          .textAlign(TextAlign.Center);
      }

      ArcButton({
        options: new ArcButtonOptions(
          {
            label: actionLabel,
            onClick: actionFn
          }
        )
      })

    }
    .backgroundColor(Color.Black)
    .padding({
      top: '12%'
    })
    .width('100%')
    .height('100%')
  }

  build() {
    NavDestination() {
      Column() {
        if (this.mode === 'create') {
          this.buildForm('Create Account', 'Create', this.createUser);
        } else {
          this.buildForm('Login', 'Login', this.loginUser);
        }
      }
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
    .hideBackButton(true)
    .width('100%')
    .height('100%')
  }
}
