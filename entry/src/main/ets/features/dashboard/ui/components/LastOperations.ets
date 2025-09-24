import { Constants } from '../../../../core/constants/Constants';
import { Operation } from '../../../../domain/model/Operation';
import { OperationType } from '../../../add/models/OperationType';
import { ArcList, ArcListItem, ArcListAttribute, LengthMetrics } from '@kit.ArkUI';

@Component
export struct LastOperations {
    @Link operations: Operation[];
    @State showAll: boolean = false;

    isLoadMoreVisible(): boolean {
        return this.operations.length > 5;
    }

    getDisplayedOperations(): Operation[] {
        if (this.showAll) {
            return this.operations;
        }
        return this.operations.slice(0, 5);
    }

    getColorCode(code: number): string {
        const type: OperationType | undefined =
            Constants.OPERATION_TYPES.find((t: OperationType) => t.code === code);
        return type?.colorCode ?? '#ffffff';
    }

    @Builder
    buildList() {
        Stack() {
            Column() {
            }
            .width('466px')
            .height('466px')
            .clipShape(new Circle({
                width: '100%',
                height: '100%'
            }))

            ArcList({
                initialIndex: 1
            }) {
                ArcListItem() {
                    Text(this.showAll ? 'All Operations' : 'Last 5 Operations')
                        .fontSize(20)
                        .fontWeight(FontWeight.Bold)
                        .fontColor(Color.White)
                        .textAlign(TextAlign.Center)
                        .padding({ bottom: 10 })
                }

                ForEach(this.getDisplayedOperations(), (op: Operation, index: number) => {
                    ArcListItem() {
                        Text(`${op.name} ${op.amount.toString()}`)
                            .fontSize(15)
                            .fontWeight(FontWeight.Bold)
                            .fontColor(Color.White)
                            .textAlign(TextAlign.Center)
                            .height('20%')
                            .backgroundColor(this.getColorCode(op.code))
                            .borderRadius(15)
                            .width('90%')
                    }
                }, (op: Operation, index: number) => `${op.id}-${index}`)

                if (this.isLoadMoreVisible()) {
                    ArcListItem() {
                        Button() {
                            Text(this.showAll ? 'Show Last 5' : 'Show All')
                                .fontSize(16)
                                .fontWeight(FontWeight.Bold)
                                .fontColor(Color.White)
                                .textAlign(TextAlign.Center)
                        }
                        .width('90%')
                        .padding(10)
                        .borderRadius(15)
                        .onClick((): void => {
                            this.showAll = !this.showAll;
                        })
                    }
                }
            }
            .space(LengthMetrics.px(20))
            .borderRadius('466px')
            .focusable(true)
            .focusOnTouch(true)
            .defaultFocus(true)
            .width('466px')
            .height('466px')
        }
        .width('100%')
        .height('100%')
        .borderRadius('466px')
    }

    build() {
        Column() {
            this.buildList()
        }
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .width('100%')
    }
}
