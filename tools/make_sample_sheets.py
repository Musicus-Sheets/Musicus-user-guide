# /// script
# requires-python = ">=3.10"
# dependencies = ["reportlab>=4"]
# ///
"""Generates synthetic sample parts (PDF) for the screenshots of the user guide.

    uv run tools/make_sample_sheets.py <output-dir>

The notes are random; titles and composers only make the library look real.
"""

import json
import random
import unicodedata
import sys
from pathlib import Path

from reportlab.lib.pagesizes import A4
from reportlab.pdfgen import canvas

SCORES = [
    {"title": "Florentiner Marsch", "composer": "Julius Fučík", "genre": "March", "tags": ["Encore"], "pages": 2},
    {"title": "Radetzky-Marsch", "composer": "Johann Strauss (father)", "genre": "March", "tags": ["New Year", "Encore"], "pages": 2},
    {"title": "Wiener Blut", "composer": "Johann Strauss (son)", "genre": "Waltz", "tags": ["New Year"], "pages": 3},
    {"title": "Amazing Grace", "composer": "Traditional", "arranger": "M. Example", "genre": "Sacred", "tags": ["Christmas"], "pages": 1},
]
PARTS = [
    {"label": "1st Trumpet in Bb", "instrument": "Trumpet", "voice": 1, "transposition": "Bb"},
    {"label": "2nd Trumpet in Bb", "instrument": "Trumpet", "voice": 2, "transposition": "Bb"},
    {"label": "Flute", "instrument": "Flute", "voice": None, "transposition": None},
    {"label": "Clarinet in Bb", "instrument": "Clarinet", "voice": None, "transposition": "Bb"},
    {"label": "Trombone", "instrument": "Trombone", "voice": None, "transposition": None},
]
DYNAMICS = ["p", "mp", "mf", "f", "ff", "cresc.", "dim."]


def draw_part(path: Path, score: dict, part: dict, seed: int, version: int = 1) -> None:
    rng = random.Random(seed)
    c = canvas.Canvas(str(path), pagesize=A4)
    w, h = A4
    for page in range(score["pages"]):
        if page == 0:
            c.setFont("Times-Bold", 20)
            c.drawCentredString(w / 2, h - 50, score["title"])
            c.setFont("Times-Italic", 11)
            c.drawString(40, h - 72, part["label"])
            # The PDF base fonts have no glyphs for e.g. "č"; strip accents on the sheet only.
            byline = unicodedata.normalize("NFKD", score["composer"]).encode("ascii", "ignore").decode()
            byline = byline + (f" / arr. {score['arranger']}" if score.get("arranger") else "")
            c.drawRightString(w - 40, h - 72, byline)
            y = h - 120
        else:
            y = h - 70
        c.setFont("Times-Roman", 8)
        c.drawCentredString(w / 2, 24, f"- {page + 1} -   Sample sheet for the Musicus user guide" + (f" (corrected v{version})" if version > 1 else ""))
        while y > 80:
            c.setLineWidth(0.5)
            for l in range(5):
                c.line(40, y - l * 5, w - 40, y - l * 5)
            x = 62
            while x < w - 55:
                for _ in range(4):
                    ny = y - rng.randint(-2, 10) * 2.5
                    c.saveState()
                    c.translate(x, ny)
                    c.rotate(20)
                    c.ellipse(-3.2, -2.2, 3.2, 2.2, fill=1)
                    c.restoreState()
                    up = ny < y - 10
                    c.setLineWidth(0.8)
                    if up:
                        c.line(x + 3, ny, x + 3, ny + 17)
                    else:
                        c.line(x - 3, ny, x - 3, ny - 17)
                    if rng.random() < 0.12:
                        c.setFont("Times-BoldItalic", 9)
                        c.drawString(x - 4, y - 33, rng.choice(DYNAMICS))
                    x += 14
                c.setLineWidth(0.6)
                c.line(x - 4, y, x - 4, y - 20)
                x += 8
            y -= 68
        c.showPage()
    c.save()


def main() -> None:
    out = Path(sys.argv[1])
    out.mkdir(parents=True, exist_ok=True)
    manifest = []
    for si, score in enumerate(SCORES):
        for pi, part in enumerate(PARTS):
            name = f"score{si}-part{pi}.pdf"
            draw_part(out / name, score, part, seed=si * 100 + pi)
            manifest.append({"score": si, "part": pi, "file": name})
    # A corrected version of the 2nd trumpet part of the first score.
    draw_part(out / "score0-part1-v2.pdf", SCORES[0], PARTS[1], seed=1, version=2)
    (out / "manifest.json").write_text(json.dumps({"scores": SCORES, "parts": PARTS, "files": manifest}, indent=2, ensure_ascii=False))
    print(f"{len(manifest) + 1} PDFs written to {out}")


if __name__ == "__main__":
    main()
