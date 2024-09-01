export class HabbitActivityDto {
  habbit_id: number;
  checked: boolean;

  constructor(habbit_id: number, checked: boolean) {
    this.habbit_id = habbit_id;
    this.checked = checked;
  }
}
