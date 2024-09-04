import { createHabbit, deleteHabbit, updateHabbit } from "@/lib/prisma/habbit";
import { HabbitDto } from "@/models/db/habbitDto";
import { NextRequest, NextResponse } from "next/server";

export async function GET() {
  return NextResponse.json({ id: 1 });
}

export async function POST(request: NextRequest) {
  try {
    const jsonBody = await request.json();
    // parse request body
    const habbitDto = new HabbitDto(jsonBody.user_id, jsonBody.title, 0);
    // add habbit
    createHabbit(habbitDto);
    return NextResponse.json(
      { message: "Success", data: habbitDto },
      { status: 200 }
    );
  } catch (error) {
    console.error(`[Add Habbit]unexpected error: ${error}`);
    return NextResponse.json({ message: "Error" }, { status: 500 });
  }
}

export async function PUT(request: NextRequest) {
  try {
    const jsonBody = await request.json();
    // update habbit
    const data = await updateHabbit(jsonBody.id, jsonBody.title);
    return NextResponse.json({ message: "Success", data }, { status: 200 });
  } catch (error) {
    console.error(`[Update Habbit]unexpected error: ${error}`);
    return NextResponse.json({ message: "Error" }, { status: 500 });
  }
}

export async function DELETE(request: NextRequest) {
  try {
    const jsonBody = await request.json();
    // delete habbit
    const data = await deleteHabbit(jsonBody.id);
    return NextResponse.json({ message: "Success", data }, { status: 200 });
  } catch (error) {
    console.error(`[Delete Habbit]unexpected error: ${error}`);
    return NextResponse.json({ message: "Error" }, { status: 500 });
  }
}
