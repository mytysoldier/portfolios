import { HabbitDto } from "@/models/db/habbitDto";
import prisma from "./prisma";

export async function getAllHabbit() {
  return await prisma?.habbit.findMany({
    orderBy: {
      id: "asc",
    },
    include: {
      habbit_activities: true,
    },
  });
}

export async function createHabbit(data: HabbitDto) {
  return prisma.habbit.create({
    data: {
      user_id: data.user_id,
      title: data.title,
    },
  });
}

export async function upsertHabbit(data: HabbitDto) {
  console.log("start upsert");
  return prisma.habbit.upsert({
    create: data,
    update: data,
    where: {
      id: data?.id,
    },
  });
}
