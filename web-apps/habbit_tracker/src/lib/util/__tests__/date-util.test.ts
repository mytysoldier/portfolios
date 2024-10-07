import { format } from "date-fns";
import { getWeekDates } from "../date-util";

describe("getWeekDates", () => {
  it("今週日曜日から土曜日までの日付が返されること", () => {
    const weekDates = getWeekDates();

    expect(weekDates.length).toBe(7);

    const firstDateStr = format(weekDates[0], "EEEE");
    const lastDateStr = format(weekDates[6], "EEEE");

    expect(firstDateStr).toBe("Sunday");
    expect(lastDateStr).toBe("Saturday");
  });
});
