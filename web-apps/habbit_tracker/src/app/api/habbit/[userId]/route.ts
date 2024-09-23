import { createHabbit, getAllHabbitByUserId } from "@/lib/prisma/habbit";
import { HabbitDto } from "@/models/db/habbitDto";
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

export async function POST(request: NextRequest) {
  try {
    const jsonBody = await request.json();
    // parse request body
    const habbitDto = new HabbitDto(jsonBody.user_id, jsonBody.title, 0);
    // add habbit
    const responseData = await createHabbit(habbitDto);
    return NextResponse.json(
      { message: "Success", data: responseData },
      { status: 200 }
    );
  } catch (error) {
    console.error(`[Add Habbit]unexpected error: ${error}`);
    return NextResponse.json({ message: "Error" }, { status: 500 });
  }
}
