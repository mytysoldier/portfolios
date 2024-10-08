import { HabbitActivity } from "./habbit_activity";

export type Habbit = {
  id?: number;
  userId?: number;
  title: string;
  createdAt?: Date;
  updatedAt?: Date;
  deletedAt?: Date;
  habbitActivities?: HabbitActivity[];
};
