import prisma from "./prisma";

export async function getUser(userId: number) {
  return await prisma?.user.findUnique({
    where: {
      id: userId,
    },
  });
}

export async function getAllUser() {
  return await prisma?.user.findMany({
    orderBy: {
      id: "asc",
    },
  });
}
