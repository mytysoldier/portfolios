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
