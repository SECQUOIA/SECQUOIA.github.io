#!/usr/bin/env python3
"""Render the paper's CSTR30 panel with localized, readable labels.

Requires Matplotlib, NumPy, and Pillow. No optimizer or simulation is run.
The retained CSV and source JSON identify the original figure and data.
"""
import argparse
import csv
from pathlib import Path

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib import font_manager
from matplotlib.lines import Line2D
from matplotlib.ticker import FixedLocator, ScalarFormatter
import numpy as np
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "assets/images/gdp-configuration-search"
METHODS = [
    "dsda", "nomad", "rbfopt_msrsm_genetic", "miso", "bam", "fmqa_sa",
    "uniform_without_replacement", "gloa", "loa", "ric",
]
NAMES = ["D-SDA", "NOMAD", "RBFOpt", "MISO", "BAM", "FMQA-SA", "Uniform",
         "GLOA", "LOA", "RIC"]
TEXT = {
    "en": {
        "title": "Largest reactor network (CSTR30)",
        "axis": "NLP subproblems solved per completed run (log scale)",
        "outcomes": "Reference\nreached",
        "hit": "Reference reached", "miss": "Reference not reached",
        "spread": "Median and middle 50%", "all": "All configurations: 465",
        "budget": "Candidate budget: 43", "no": "No", "uniform": "Uniform",
    },
    "es": {
        "title": "Red de reactores más grande (CSTR30)",
        "axis": "Subproblemas NLP resueltos por ejecución completa (escala logarítmica)",
        "outcomes": "Referencia\nalcanzada",
        "hit": "Referencia alcanzada", "miss": "Referencia no alcanzada",
        "spread": "Mediana y 50 % central", "all": "Todas las configuraciones: 465",
        "budget": "Límite de evaluaciones: 43", "no": "No", "uniform": "Uniforme",
    },
    "ko": {
        "title": "가장 큰 반응기 네트워크 (CSTR30)",
        "axis": "완료된 실행별 NLP 하위 문제 풀이 횟수 (로그 척도)",
        "outcomes": "기준값\n도달",
        "hit": "기준값 도달", "miss": "기준값 미도달",
        "spread": "중앙값과 가운데 50%", "all": "전체 구성 평가: 465",
        "budget": "구성 평가 예산: 43", "no": "미도달", "uniform": "균등 추출",
    },
}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--korean-font", type=Path, required=True)
    args = parser.parse_args()
    font_manager.fontManager.addfont(str(args.korean_font))
    korean_family = font_manager.FontProperties(fname=args.korean_font).get_name()
    with (ROOT / "assets/data/gdp-configuration-search/cstr30-nlp-solves.csv").open() as f:
        rows = list(csv.DictReader(f))
    assert len(rows) == 73
    for language, text in TEXT.items():
        family = korean_family if language == "ko" else "DejaVu Sans"
        with plt.rc_context({
            "font.family": family, "font.size": 13, "axes.titlesize": 18,
            "axes.spines.top": False, "axes.spines.right": False,
            "svg.fonttype": "none", "svg.hashsalt": "gdp-cstr30",
        }):
            fig, ax = plt.subplots(figsize=(10, 7.6), dpi=160)
            fig.patch.set_facecolor("white")
            ax.set_facecolor("white")
            ax.axvline(465, color="#555555", ls="--", lw=1.5, zorder=0)
            ax.axvline(43, color="#999999", ls=":", lw=1.5, zorder=0)
            labels = NAMES.copy()
            labels[6] = text["uniform"]
            for index, method in enumerate(METHODS):
                group = [r for r in rows if r["method"] == method]
                dfo = index < 7
                assert len(group) == (10 if dfo else 1)
                values = [int(r["nlp_calls"]) for r in group]
                if dfo:
                    q25, median, q75 = np.quantile(values, [0.25, 0.5, 0.75])
                    ax.plot([q25, q75], [index, index], color="#b0b0b0", lw=7, zorder=1)
                    ax.plot(median, index, marker="|", color="#222222", ms=18, mew=2, zorder=4)
                for row, value in zip(group, values):
                    hit = row["target_reached"] == "True"
                    y = index + (int(row["seed"]) - 4.5) * 0.055 if dfo else index
                    ax.scatter(value, y, marker="o" if hit else "x",
                               c="#0072B2" if hit else "#D55E00",
                               s=46, linewidths=1.5, zorder=3)
                hits = sum(r["target_reached"] == "True" for r in group)
                ax.text(1.03, index, f"{hits}/10" if dfo else text["no"],
                        transform=ax.get_yaxis_transform(), va="center", fontsize=13)
            ax.axhline(6.5, color="#999999", lw=1)
            ax.set(xscale="log", xlim=(0.8, 1000), ylim=(9.7, -0.7),
                   yticks=range(10), yticklabels=labels, xlabel=text["axis"])
            ax.xaxis.set_major_locator(FixedLocator([1, 10, 100, 1000]))
            ax.xaxis.set_major_formatter(ScalarFormatter())
            ax.tick_params(axis="y", length=0, pad=10)
            ax.grid(axis="x", which="major", alpha=0.18)
            ax.set_title(text["title"], pad=34)
            ax.text(1.03, 1.01, text["outcomes"], transform=ax.transAxes,
                    ha="left", va="bottom", fontsize=11)
            legend = [
                Line2D([], [], marker="o", color="#0072B2", ls="", label=text["hit"]),
                Line2D([], [], marker="x", color="#D55E00", ls="", label=text["miss"]),
                Line2D([], [], marker="|", color="#b0b0b0", markeredgecolor="#222222",
                       ms=12, lw=5, label=text["spread"]),
                Line2D([], [], color="#555555", ls="--", label=text["all"]),
                Line2D([], [], color="#999999", ls=":", label=text["budget"]),
            ]
            fig.legend(handles=legend, loc="lower center", ncol=2,
                       frameon=False, fontsize=11, bbox_to_anchor=(0.51, 0.015))
            fig.subplots_adjust(left=0.18, right=0.80, top=0.85, bottom=0.24)
            stem = OUT / f"cstr30-results-{language}"
            fig.savefig(stem.with_suffix(".png"), dpi=160, facecolor="white")
            fig.savefig(stem.with_suffix(".svg"), metadata={"Date": None})
            svg = stem.with_suffix(".svg")
            svg.write_text("\n".join(line.rstrip() for line in svg.read_text().splitlines()) + "\n")
            with Image.open(stem.with_suffix(".png")) as im:
                im.save(stem.with_suffix(".webp"), quality=95)
            plt.close(fig)


if __name__ == "__main__":
    main()
