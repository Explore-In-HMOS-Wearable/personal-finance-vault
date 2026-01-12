import { ArcButton, ArcButtonOptions, curves } from '@kit.ArkUI';
import { OperationType } from '../models/OperationType';
import { InsertViewModel } from '../viewmodel/InsertViewModel';

@Builder
export function InsertOperationBuilder() {
  InsertOperation();
}

@Component
struct InsertOperation {
  @Consume('NavPathStack') pageStack: NavPathStack;
  @State name: string = ''
  @State value: string = ''
  private operationTypeCode: number = 0;
  @State isModalOpen: boolean = false
  @State selectedType: number = 0;
  viewModel: InsertViewModel = new InsertViewModel();

  aboutToAppear() {
    this.operationTypeCode = this.pageStack.getParamByName('InsertOperation')[0] as number;
  }

  @Builder
  TypePickerModal(operationTypes: OperationType[]) {
    Column({ space: 10 }) {
      Text('Select Operation')
        .fontSize(15)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .textAlign(TextAlign.Center)

      ForEach(operationTypes, (item: OperationType) => {
        Text(item.name)
          .width('65%')
          .height('20%')
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .backgroundColor(item.colorCode)
          .borderRadius(8)
          .fontSize(18)
          .onClick(() => {
            this.selectedType = item.code
            this.isModalOpen = false
          })
      }, (item: OperationType) => item.code.toString())
    }
    .padding(20)
    .size({ width: '100%', height: '100%' })
    .backgroundColor(Color.Black)
  }

  build() {
    NavDestination() {
      Column({ space: 10 }) {
        Text(this.viewModel.getTypeNameByCode(this.selectedType))
          .width('50%')
          .height('20%')
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Bold)
          .borderRadius(8)
          .backgroundColor(this.viewModel.getTypeColorByCode(this.selectedType))
          .onClick(() => this.isModalOpen = true)
          .bindContentCover($$this.isModalOpen, this.TypePickerModal(this.viewModel.getOperationTypes()), {
            transition: TransitionEffect.translate({ y: 500 })
              .animation({ curve: curves.springMotion(0.6, 0.8) })
          })

        // Normal text inputs
        TextInput({ placeholder: 'Name', text: this.name })
          .onChange(val => this.name = val)

        TextInput({ placeholder: 'Amount', text: this.value })
          .type(InputType.Number)
          .onChange(val => this.value = val)
        Blank()
        ArcButton({
          options: new ArcButtonOptions({
            label: 'Save',
            onClick: async () => {
              await this.viewModel.insertOperation(
                this.selectedType,
                this.name,
                Number(this.value)
              );
              console.info('Saving:', this.name, this.value, this.selectedType);

              this.pageStack.pop(this.name);
            }
          })
        })
      }
      .padding(20)
    }
    .backgroundColor(Color.Black)
    .hideTitleBar(true)
    .hideBackButton(true)
    .width('100%')
    .height('100%')
  }
}
