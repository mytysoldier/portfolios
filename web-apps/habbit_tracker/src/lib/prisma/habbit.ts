import { HabbitDto } from "@/models/db/habbitDto";
import prisma from "./prisma";
import { HabbitActivityDto } from "@/models/db/habbitActivityDto";

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
  return await prisma.habbit.create({
    data: {
      user_id: data.user_id,
      title: data.title,
    },
  });
}

export async function updateHabbit(id: number, title: string) {
  return await prisma.habbit.update({
    where: {
      id,
    },
    data: {
      title,
      updated_at: new Date(),
    },
  });
}

export async function upsertHabbit(data: HabbitDto) {
  return prisma.habbit.upsert({
    create: data,
    update: data,
    where: {
      id: data?.id,
    },
  });
}

export async function deleteHabbit(id: number) {
  return await prisma.habbit.delete({
    where: {
      id,
    },
  });
}
