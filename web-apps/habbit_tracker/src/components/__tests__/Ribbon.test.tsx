import { fireEvent, render, screen } from "@testing-library/react";
import Header from "../Header";
import Ribbon from "../Ribbon";

describe("Ribbonコンポーネントテスト", () => {
  beforeEach(() => {
    render(<Ribbon caption="test caption" title="test title" />);
  });

  test("captionが正しく表示されること", () => {
    const ribbonElement = screen.getByText("test caption");
    expect(ribbonElement).toBeInTheDocument();
  });

  test("titleが正しく表示されること", () => {
    const ribbonElement = screen.getByText("test title");
    expect(ribbonElement).toBeInTheDocument();
  });
});
