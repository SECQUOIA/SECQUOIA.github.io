#!/usr/bin/env python3
"""Render the GDP article's localized SVG/PNG/WebP assets.

Requires Pillow, PyYAML, ImageMagick, DejaVu Sans Condensed, and Noto Sans CJK KR.
Pass --korean-font with the Noto OTF. A temporary fontconfig file makes exports
use the same Korean font as text measurement; a substitution fails explicitly.
No font files are distributed with the website.
"""
import argparse
import html
import os
import re
import subprocess
import tempfile
from pathlib import Path

import yaml
from PIL import ImageFont

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "assets/images/gdp-configuration-search"
GOLD, IVORY, BG = "#ceb888", "#f4f0e8", "#202122"


def wrap(text, font, width):
    # Wrap at spaces in every language so SVG extraction preserves complete words.
    words = text.split()
    lines, line = [], ""
    for word in words:
        candidate = line + (" " if line else "") + word
        if font.getlength(candidate) > width and line:
            lines.append(line.rstrip())
            line = word.lstrip()
        else:
            line = candidate
    if line:
        lines.append(line.rstrip())
    return lines


def text_lines(lines, x, y, size, family, color=IVORY, leading=None):
    leading = leading or size * 1.3
    return "".join(
        f'<text x="{x}" y="{y + i * leading:g}" font-family="{family}" '
        f'font-size="{size}" fill="{color}">{html.escape(line)}</text>'
        for i, line in enumerate(lines)
    )


def export(name, content, environment):
    svg = OUT / f"{name}.svg"
    svg.write_text(
        '<svg xmlns="http://www.w3.org/2000/svg" width="1200" height="630" '
        'viewBox="0 0 1200 630">'
        f'<rect width="1200" height="630" fill="{BG}"/>{content}</svg>\n'
    )
    subprocess.run(["convert", "-background", BG, str(svg), "-strip", str(svg.with_suffix(".png"))],
                   check=True, env=environment)
    subprocess.run(["convert", str(svg.with_suffix(".png")), "-quality", "92", str(svg.with_suffix(".webp"))], check=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--korean-font", type=Path, required=True)
    args = parser.parse_args()
    font_config = tempfile.TemporaryDirectory(prefix="gdp-fontconfig-")
    config_path = Path(font_config.name) / "fonts.conf"
    config_path.write_text(
        '<?xml version="1.0"?><fontconfig><include>/etc/fonts/fonts.conf</include>'
        f'<dir>{html.escape(str(args.korean_font.resolve().parent))}</dir>'
        f'<cachedir>{font_config.name}/cache</cachedir></fontconfig>'
    )
    environment = dict(os.environ, FONTCONFIG_FILE=str(config_path))
    resolved_font = subprocess.check_output(
        ["fc-match", "-f", "%{file}", "Noto Sans CJK KR"], env=environment, text=True
    )
    if Path(resolved_font).resolve() != args.korean_font.resolve():
        raise ValueError(f"Korean export font differs from measurement font: {resolved_font}")
    OUT.mkdir(parents=True, exist_ok=True)
    for language in ("en", "ko", "es"):
        page = ROOT / ("_posts/2026-11-07-gdp-configuration-search.md" if language == "en"
                       else f"articles/gdp-configuration-search/{language}.md")
        _, front, body = page.read_text().split("---", 2)
        meta = yaml.safe_load(front)
        family = "Noto Sans CJK KR" if language == "ko" else "DejaVu Sans Condensed"
        font_file = args.korean_font if language == "ko" else Path("/usr/share/fonts/truetype/dejavu/DejaVuSansCondensed.ttf")
        font = lambda size: ImageFont.truetype(str(font_file), size)
        title = wrap(meta["title"], font(52), 550 if language == "ko" else 670)
        if len(title) > 5:
            raise ValueError(f"{language}: cover title needs more than five lines")
        content = text_lines(["SECQUOIA  /  PURDUE"], 55, 70, 23, family, GOLD)
        content += text_lines(title, 55, 170, 52, family, leading=66)
        content += text_lines(["GDP + DFO"], 55, 565, 26, family, GOLD)
        # Three alternative flowsheets; the selected middle path is gold.
        for row, color in ((0, "#77766f"), (1, GOLD), (2, "#77766f")):
            y = 175 + row * 135
            content += f'<g fill="none" stroke="{color}" stroke-width="3">'
            content += f'<path d="M805 {y + 30} H838 M892 {y + 30} H965 M1017 {y + 30} H1100"/>'
            content += f'<rect x="838" y="{y}" width="54" height="60" rx="14"/>'
            content += f'<rect x="965" y="{y - 12}" width="52" height="85" rx="12"/>'
            content += f'<path d="M973 {y + 10} H1009 M973 {y + 28} H1009 M973 {y + 46} H1009"/>'
            content += "</g>"
        content += f'<rect x="780" y="280" width="360" height="125" rx="22" fill="none" stroke="{GOLD}" stroke-width="2"/>'
        export(f"cover-{language}", content, environment)

        steps = re.findall(r'<li>\s*<span class="step-number"[^>]*>(.*?)</span>\s*<h3>(.*?)</h3>\s*<p>(.*?)</p>\s*</li>', body, re.S)
        if len(steps) != 3:
            raise ValueError(f"{language}: expected three complete steps")
        label = {"en": "The configuration-search loop", "es": "El ciclo de búsqueda de configuraciones",
                 "ko": "구성 탐색의 반복 과정"}[language]
        content = text_lines([label], 50, 70, 34, family)
        content += text_lines(["GDP + DFO"], 50, 112, 20, family, GOLD)
        for index, (number, heading, paragraph) in enumerate(steps):
            x = 45 + 380 * index
            heading = html.unescape(heading)
            paragraph = html.unescape(" ".join(paragraph.split()))
            heads = wrap(heading, font(27), 295)
            lines = wrap(paragraph, font(24), 295)
            if len(heads) > 3 or len(lines) > 6:
                raise ValueError(f"{language}: step {index + 1} would overflow")
            content += f'<g class="step"><rect x="{x}" y="150" width="350" height="430" rx="14" fill="#292a2b" stroke="{GOLD}"/>'
            content += text_lines([number], x + 25, 215, 39, family, GOLD)
            content += text_lines(heads, x + 25, 285, 27, family, leading=35)
            content += text_lines(lines, x + 25, 405, 24, family, leading=29)
            content += "</g>"
            if index < 2:
                content += f'<path d="M{x + 357} 365 h15 m-6 -6 6 6 -6 6" fill="none" stroke="{GOLD}" stroke-width="2"/>'
        export(f"methodology-{language}", content, environment)


if __name__ == "__main__":
    main()
