import { getAllHabbitByUserId } from "@/lib/prisma/habbit";
import { error } from "console";
import { NextRequest, NextResponse } from "next/server";

export async function GET(
  req: NextRequest,
  { params }: { params: { userId: string } }
) {
  const { userId } = params;

  if (!userId) {
    return NextResponse.json({ error: "userId is required" }, { status: 400 });
  }

  try {
    const habbits = await getAllHabbitByUserId(Number(userId));
    return NextResponse.json(
      { message: "Success", data: habbits },
      { status: 200 }
    );
  } catch (error) {
    return NextResponse.json(
      { error: "Failed to fetch habbits" },
      { status: 500 }
    );
  }
}
