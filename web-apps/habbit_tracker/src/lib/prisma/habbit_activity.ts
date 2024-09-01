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
