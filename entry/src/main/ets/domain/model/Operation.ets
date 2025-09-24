import { OperationType } from '@kit.ArkUI'

export interface Operation{
    id: number,
    code: OperationType,
    name: string,
    amount: number
}