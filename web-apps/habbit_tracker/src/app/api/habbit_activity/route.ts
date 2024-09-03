import {
  createHabbitActivity,
  deleteHabbitActivity,
} from "@/lib/prisma/habbit_activity";
import { HabbitActivityDto } from "@/models/db/habbitActivityDto";
import { NextRequest, NextResponse } from "next/server";

export async function GET() {
  return NextResponse.json({ id: 1 });
}

export async function POST(request: NextRequest) {
  try {
    const jsonBody = await request.json();
    // parse request body
    const habbitActivityDto = new HabbitActivityDto(
      jsonBody.habbit_id,
      jsonBody.checked
    );
    // add habbit activity
    createHabbitActivity(habbitActivityDto);
    return NextResponse.json(
      { message: "Success", data: habbitActivityDto },
      { status: 200 }
    );
  } catch (error) {
    console.error(`[Add HabbitActivity]unexpected error: ${error}`);
    return NextResponse.json({ message: "Error" }, { status: 500 });
  }
}

export async function DELETE(request: NextRequest) {
  try {
    const jsonBody = await request.json();
    const habbit_activity_ids = jsonBody.ids;
    console.log(`habbit_activity_ids: ${habbit_activity_ids}`);
    return NextResponse.json({ message: "Success", data: "" }, { status: 200 });
    // delete habbit activity
    // const deletedHabbitActivity = await deleteHabbitActivity(
    //   jsonBody.habbit_id
    // );
    // return NextResponse.json(
    //   { message: "Success", data: deletedHabbitActivity },
    //   { status: 200 }
    // );
  } catch (error) {
    console.error(`[Delete HabbitActivity]unexpected error: ${error}`);
    return NextResponse.json({ message: "Error" }, { status: 500 });
  }
}
