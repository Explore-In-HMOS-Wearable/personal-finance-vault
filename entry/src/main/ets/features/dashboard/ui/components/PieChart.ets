import { Operation } from '../../../../domain/model/Operation';
import { Constants } from '../../../../core/constants/Constants';

interface GroupedOperation {
    code: number;
    total: number;
}

@Component
export struct PieChart {
    @Require onAddButtonClick: () => void;
    @Link operations: Operation[];

    groupedOperations(): GroupedOperation[] {
        const map = new Map<number, number>();
        for (let i = 0; i < this.operations.length; i++) {
            const op = this.operations[i];
            map.set(op.code, (map.get(op.code) ?? 0) + op.amount);
        }
        const result: GroupedOperation[] = [];
        const entries = Array.from(map.entries());
        for (let j = 0; j < entries.length; j++) {
            const entry = entries[j];
            result.push({ code: entry[0], total: entry[1] });
        }
        return result;
    }

    total(): number {
        const grouped = this.groupedOperations();
        let sum = 0;
        for (let i = 0; i < grouped.length; i++) {
            sum += grouped[i].total;
        }
        return sum;
    }

    chartValues(): number[] {
        const grouped = this.groupedOperations();
        const totalValue = this.total();
        const values: number[] = [];
        for (let i = 0; i < grouped.length; i++) {
            values.push(totalValue > 0 ? (grouped[i].total / totalValue) * 100 : 0);
        }
        return values;
    }

    chartColors(): string[] {
        const grouped = this.groupedOperations();
        const colors: string[] = [];
        for (let i = 0; i < grouped.length; i++) {
            const type = Constants.OPERATION_TYPES.find(t => t.code === grouped[i].code);
            colors.push(type ? type.colorCode : '#ffffff');
        }
        return colors;
    }

    getExpensesPercentageText(): string {
        const grouped = this.groupedOperations();
        let expensesTotal = 0;
        for (let i = 0; i < grouped.length; i++) {
            if (grouped[i].code === -1) {
                expensesTotal = grouped[i].total;
                break;
            }
        }
        const totalValue = this.total();
        return totalValue > 0 ? `${Math.round((expensesTotal / totalValue) * 100)}%` : '0%';
    }

    build() {
        Column() {
            Row() {
                Stack() {
                    DataPanel({
                        values: this.chartValues(),
                        max: 100,
                        type: DataPanelType.Circle
                    })
                        .valueColors(this.chartColors())
                        .width(233)
                        .height(233)
                        .strokeWidth(20);

                    Column() {
                        Text('Expense Rate')
                            .fontSize(15)
                            .fontWeight(FontWeight.Bold)
                            .fontColor(Color.White);
                        Text(this.getExpensesPercentageText())
                            .fontSize(35)
                            .fontColor(Color.Red);

                        Button() {
                            Text('Add New')
                                .fontColor(Color.White)
                                .fontWeight(FontWeight.Bold);
                        }
                        .onClick(() => this.onAddButtonClick())
                        .padding({
                            left: 15,
                            right: 15,
                            top: 5,
                            bottom: 5
                        });
                    }
                }
            }
            .height('100%')
            .alignItems(VerticalAlign.Center)
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
    }
}
