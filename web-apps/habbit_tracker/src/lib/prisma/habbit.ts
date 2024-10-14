import { HabbitDto } from "@/models/db/habbitDto";
import prisma from "./prisma";
import { getWeekDates } from "../util/date-util";

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

export async function getAllHabbitByUserId(userId: number) {
  // const weekDates = getWeekDates();
  return await prisma?.habbit.findMany({
    orderBy: {
      created_at: "asc",
    },
    include: {
      habbit_activities: true,
    },
    where: {
      user_id: userId,
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
  const deletedHabbitActivities = prisma.habbit_activity.deleteMany({
    where: {
      habbit_id: id,
    },
  });

  const deletedHabbit = prisma.habbit.delete({
    where: {
      id,
    },
  });

  return await prisma.$transaction([deletedHabbitActivities, deletedHabbit]);
}
