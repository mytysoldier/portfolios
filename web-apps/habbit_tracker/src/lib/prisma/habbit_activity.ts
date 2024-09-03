import { HabbitActivityDto } from "@/models/db/habbitActivityDto";
import prisma from "./prisma";

export async function createHabbitActivity(data: HabbitActivityDto) {
  return prisma.habbit_activity.create({
    data: {
      habbit_id: data.habbit_id,
      checked: data.checked,
    },
  });
}

// TODO 説明用、後で削除
export async function deleteHabbitActivity(id: number) {
  return await prisma.habbit_activity.delete({
    where: {
      id,
    },
  });
}

export async function deleteHabbitActivities(ids: number[]) {
  return await prisma.habbit_activity.deleteMany({
    where: {
      id: {
        in: ids,
      },
    },
  });
}

export async function deleteAllHabbitActivity() {
  return await prisma.habbit_activity.deleteMany({});
}
