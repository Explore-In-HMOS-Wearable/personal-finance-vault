@Component
export struct Settings {
    @Require onResetPassword: (newPassword: string) => Promise<void>;
    @Require onBackupUser: () => Promise<void>;
    @Require onRemoveBackup: () => Promise<void>;
    @State inputPassword: string = '';
    @State message: string = '';

    build() {
        Row() {
            Column({ space: 10 }) {
                Text('Settings')
                    .fontSize(20)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(Color.White)
                    .textAlign(TextAlign.Center)
                if (this.message) {
                    Text(this.message)
                        .fontSize(12)
                        .fontColor(Color.Yellow)
                }
                TextInput({ placeholder: 'New Password', text: this.inputPassword })
                    .type(InputType.NUMBER_PASSWORD)
                    .width('75%')
                    .height(40)
                    .fontSize(12)
                    .onChange((v: string) => {
                        this.inputPassword = v;
                    });

                Button() {
                    Text('Reset Password')
                        .fontSize(12)
                        .fontColor(Color.White)
                        .fontWeight(FontWeight.Bold);
                }
                .padding({
                    left: 15,
                    right: 15,
                    top: 3,
                    bottom: 3
                }).onClick(async () => {
                    if (!this.inputPassword) {
                        this.message = 'Password cannot be empty';
                        return;
                    }
                    try {
                        await this.onResetPassword(this.inputPassword);
                        this.message = 'Password updated successfully';
                        this.inputPassword = '';
                    } catch (err) {
                        console.error(err);
                        this.message = 'Failed to reset password';
                    }
                })

                Button() {
                    Text('Backup User')
                        .fontColor(Color.White)
                        .fontSize(12)
                        .fontWeight(FontWeight.Bold);
                }
                .padding({
                    left: 15,
                    right: 15,
                    top: 3,
                    bottom: 3
                }).onClick(async () => {
                    try {
                        await this.onBackupUser();
                        this.message = 'User back upped successfully';
                    } catch (err) {
                        console.error(err);
                        this.message = 'Backup failed';
                    }
                })

                Button() {
                    Text('Remove Backup')
                        .fontColor(Color.White)
                        .fontSize(12)
                        .fontWeight(FontWeight.Bold);
                }
                .padding({
                    left: 15,
                    right: 15,
                    top: 3,
                    bottom: 3
                }).onClick(async () => {
                    try {
                        await this.onRemoveBackup();
                        this.message = 'Removed backup.';
                    } catch (err) {
                        console.error(err);
                        this.message = 'Remove failed';
                    }
                })
            }
            .padding({ top: '5%' })
            .backgroundColor(Color.Black)
            .width('100%')
        }
        .height('100%')
        .alignItems(VerticalAlign.Center)
    }
}
