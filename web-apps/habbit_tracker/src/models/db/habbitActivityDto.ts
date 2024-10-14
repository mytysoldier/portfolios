export class HabbitActivityDto {
  id?: number;
  habbit_id: number;
  checked: boolean;
  createdAt?: Date;

  constructor(
    habbit_id: number,
    checked: boolean,
    id?: number,
    createdAt?: Date
  ) {
    this.habbit_id = habbit_id;
    this.checked = checked;
    this.id = id;
    this.createdAt = createdAt;
  }
}
