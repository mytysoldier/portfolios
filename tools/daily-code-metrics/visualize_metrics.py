#!/usr/bin/env python3
from __future__ import annotations

import argparse
import datetime as dt
from pathlib import Path

import matplotlib.pyplot as plt
import pandas as pd


def load_summary(output_dir: Path) -> pd.DataFrame | None:
    paths = sorted(output_dir.glob("*/daily_code_summary.csv"))
    if not paths:
        return None

    frames: list[pd.DataFrame] = []
    for path in paths:
        df = pd.read_csv(path)
        df["date"] = pd.to_datetime(df["date"])
        frames.append(df)

    summary = pd.concat(frames, ignore_index=True)
    summary = summary.sort_values("date")
    summary = summary.drop_duplicates(subset=["date"], keep="last")
    return summary


def load_detail(output_dir: Path) -> pd.DataFrame | None:
    paths = sorted(output_dir.glob("*/daily_code_detail.csv"))
    if not paths:
        return None

    frames: list[pd.DataFrame] = []
    for path in paths:
        df = pd.read_csv(path)
        df["date"] = pd.to_datetime(df["date"])
        frames.append(df)

    detail = pd.concat(frames, ignore_index=True)
    detail = detail[detail["repo"] != "TOTAL"]
    detail = detail.sort_values(["date", "repo"])
    return detail


def plot_summary(summary: pd.DataFrame, plots_dir: Path) -> Path:
    fig, ax = plt.subplots(figsize=(10, 5))
    ax.plot(summary["date"], summary["added"], label="added")
    ax.plot(summary["date"], summary["deleted"], label="deleted")
    ax.plot(summary["date"], summary["touched"], label="touched")
    ax.set_title("Daily code changes (summary)")
    ax.set_xlabel("date")
    ax.set_ylabel("lines")
    ax.grid(True, alpha=0.3)
    ax.legend()
    fig.autofmt_xdate()

    out_path = plots_dir / "summary_timeseries.png"
    fig.tight_layout()
    fig.savefig(out_path, dpi=150)
    plt.close(fig)
    return out_path


def plot_latest_repos(detail: pd.DataFrame, plots_dir: Path, top_n: int) -> Path | None:
    if detail.empty:
        return None

    latest_date = detail["date"].max()
    latest = detail[detail["date"] == latest_date]
    if latest.empty:
        return None

    latest = latest.sort_values("touched", ascending=False).head(top_n)
    fig, ax = plt.subplots(figsize=(10, 6))
    ax.barh(latest["repo"], latest["touched"], color="#2f6f8f")
    ax.invert_yaxis()
    ax.set_title(f"Touched lines by repo ({latest_date.date()})")
    ax.set_xlabel("touched lines")
    ax.grid(True, axis="x", alpha=0.3)

    out_path = plots_dir / "latest_repo_touched.png"
    fig.tight_layout()
    fig.savefig(out_path, dpi=150)
    plt.close(fig)
    return out_path


def default_plots_dir(output_dir: Path) -> Path:
    today = dt.date.today().isoformat()
    return output_dir / "report" / today


def main() -> int:
    parser = argparse.ArgumentParser(description="Visualize daily code metrics CSVs.")
    parser.add_argument(
        "--output-dir",
        default="output",
        help="Directory that contains date folders with CSVs.",
    )
    parser.add_argument(
        "--plots-dir",
        default=None,
        help="Directory to write plot images. Defaults to output/report/YYYY-MM-DD.",
    )
    parser.add_argument(
        "--repo-top",
        type=int,
        default=15,
        help="How many repos to show in the latest-date bar chart.",
    )
    parser.add_argument(
        "--show",
        action="store_true",
        help="Show plots interactively instead of only saving PNGs.",
    )
    args = parser.parse_args()

    output_dir = Path(args.output_dir)
    plots_dir = Path(args.plots_dir) if args.plots_dir else default_plots_dir(output_dir)
    plots_dir.mkdir(parents=True, exist_ok=True)

    summary = load_summary(output_dir)
    if summary is None or summary.empty:
        print(f"No summary CSVs found under: {output_dir}")
        return 1

    summary_path = plot_summary(summary, plots_dir)
    print(f"Wrote: {summary_path}")

    detail = load_detail(output_dir)
    if detail is not None and not detail.empty:
        latest_path = plot_latest_repos(detail, plots_dir, args.repo_top)
        if latest_path:
            print(f"Wrote: {latest_path}")

    if args.show:
        plt.show()

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
