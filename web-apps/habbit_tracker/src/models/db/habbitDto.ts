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
  created_at?: Date;
  updated_at?: Date;
  deleted_at?: Date;

  constructor(
    user_id: number,
    title: string,
    id?: number,
    created_at?: Date,
    updated_at?: Date,
    deleted_at?: Date
  ) {
    this.id = id;
    this.user_id = user_id;
    this.title = title;
    this.created_at = created_at;
    this.updated_at = updated_at;
    this.deleted_at = deleted_at;
  }
}
