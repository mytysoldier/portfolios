import { fireEvent, render, screen } from "@testing-library/react";
import Header from "../Header";
import Ribbon from "../Ribbon";
import WeekCalendar from "../WeekCalendar";

describe("WeekCalendarコンポーネントテスト", () => {
  beforeEach(() => {
    render(<WeekCalendar />);
  });

  test("WeekCalendarコンポーネントが描画されること", () => {
    const weekCalendarElement = screen.getByRole("grid");
    expect(weekCalendarElement).toBeInTheDocument();
  });
});
