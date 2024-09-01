// export type HabbitDto = {
//   id?: number;
//   user_id: number;
//   title: string;
//   created_at: Date;
//   updated_at?: Date;
//   deleted_at?: Date;
// };

export class HabbitDto {
  id?: number;
  user_id: number;
  title: string;
  updated_at?: Date;

  constructor(
    user_id: number,
    title: string,
    id?: number,
    updated_at?: Date,
    deleted_at?: Date
  ) {
    this.id = id;
    this.user_id = user_id;
    this.title = title;
    this.updated_at = updated_at;
  }
}
