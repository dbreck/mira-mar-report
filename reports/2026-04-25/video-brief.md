# Mira Mar Marketing Report — Animated Video Brief

**Source report:** `/reports/2026-04-25/index.html`
**Source data:** `/data/2026-04-25.json`
**Period:** Mar 27 – Apr 25, 2026 (vs. Feb 10 – Mar 11, 2026)
**Target length:** 60–90 seconds
**Format:** Self-contained HTML/CSS/JS artifact (Claude artifact-renderable), 16:9, 1920×1080.

---

## Brand & Style Anchors

Carry over the editorial look from `index.html`:

- **Palette:** Deep navy `#0c1a2c` background, warm gold/champagne `#c9a96e` accents, off-white `#f5f1e8` text, soft slate `#94a3b8` secondary.
- **Status colors:** green `#7fb685`, yellow `#e8b96b`, red `#d97757`.
- **Typography:** Cormorant Garamond (display, italic for emphasis), Manrope (UI/numbers, tabular).
- **Motion vocabulary:** slow easing (`cubic-bezier(0.16, 1, 0.3, 1)`), bars fill left-to-right, numbers count up, gentle parallax on text reveals. No bouncy/spring animations — this is a luxury real-estate brand.
- **Audio:** No sound. Captions/labels only. (The deliverable is a silent motion piece for client review.)

---

## Scene-by-Scene Script

### Scene 1 — Title (0:00–0:04)
- Black fade in to navy.
- Cormorant italic serif: *"Mira Mar Sarasota"* fades up.
- Subtitle Manrope all-caps tracked-out: `MARCH 27 – APRIL 25, 2026  ·  PERFORMANCE REPORT`
- Subtle gold underline draws left-to-right beneath the title.

### Scene 2 — Headline Numbers (0:04–0:14)
Four KPIs animate in sequentially, each with the prior-period delta in a small ▲/▼ chip:

| Metric | Value | Delta |
|--------|-------|-------|
| Total spend | **$16,164** | ▼ 3.1% |
| Total leads | **70** | ▲ 4.5% |
| Cost per lead | **$231** | ▼ 7.2% (good) |
| Google CTR | **8.3%** | ▼ 17% |

Numbers count up from 0; deltas snap in last. Use green for improvements, amber/red for declines, gold for the value itself.

### Scene 3 — The Story (0:14–0:22)
Single line of editorial italic text fades through, one phrase at a time:

> *"Strong period overall —"* … *"Google Ads efficiency doubled,"* … *"organic search is surging,"* … *"but Meta CPL crept up."*

### Scene 4 — Google Ads Win (0:22–0:34)
- Header: "GOOGLE ADS"
- Big stat: **Conversion rate doubled** — `0.76% → 1.66%` (+118%) — animate the comparison as two horizontal bars filling.
- Secondary: 30 conversions (▲ 43%), $5.13 CPC, 8.3% CTR.
- Small footnote line: *"Sarasota Non-Brand campaign delivered 17 of 30 conversions."*

### Scene 5 — Meta Ads Caution (0:34–0:46)
- Header: "META ADS"
- Big stat: **CPL up 45%** — `$119 → $172` — same bar treatment, amber not green.
- Three campaigns as a stacked CPL chart:
  - Remarketing: $60 (best)
  - Sarasota Prospecting: $171
  - Feeder Mkt Prospecting: $207 (worst)
- Footnote: *"Top creative: Video_Amenity — 13 leads at $132 CPL."*

### Scene 6 — Organic Momentum (0:46–0:58)
- Header: "WEBSITE & SEARCH"
- Three stats animate as ascending arrows / line charts:
  - Search impressions: 4.2K → **8.0K** (▲ 76%)
  - Queries: 91 → **147** (▲ 52%)
  - Avg position: 11.3 → **7.7** (▲ 32% — *lower is better*, label this clearly)
- Counter-note in muted text: *"Active users dipped 10% to 5,200 — watch."*

### Scene 7 — Pipeline Pulse (0:58–1:08)
- Header: "SPARK PIPELINE"
- Funnel-style horizontal bars:
  - 49 tracked leads
  - **31 warm** (▲ 35%)
  - **2 hot** (▲ 100%)
  - 1 reservation holder
- Calls strip below: 15 calls, 87% answer rate (▲ 24%), 2 missed (▼ 75%).

### Scene 8 — What's Next (1:08–1:22)
Three recommendation cards slide in, each with a priority pill:

1. 🔴 **HIGH** — Pause Google Feeder Markets *(0 conversions, $1,468 spent)*
2. 🔴 **HIGH** — Investigate Meta CPL spike *(Sarasota stable, Feeder weak)*
3. 🟡 **MEDIUM** — Double down on organic content *(impressions +76%)*

### Scene 9 — Outro (1:22–1:30)
- All elements fade.
- Centered Cormorant italic: *"Mira Mar Sarasota"*
- Below in Manrope tracked-out: `PREPARED BY CLEAR PH DESIGN  ·  APRIL 2026`
- Gold underline contracts back to a single point. Fade to navy.

---

## Technical Direction for the Artifact

- One HTML file. Inline `<style>` and `<script>`. Use Google Fonts CDN for Cormorant Garamond + Manrope.
- Use `requestAnimationFrame` for the timeline; do **not** rely on CSS `@keyframes` alone — we need a single deterministic master timeline so it can be screen-recorded cleanly.
- Auto-play on load; expose a `?seek=` query param for scrubbing while iterating.
- All text and numbers must be data-driven from a single `const REPORT = {...}` object at the top of the script — paste the JSON in as that object so the brief stays trivially editable.
- Aspect 16:9, scale to viewport with `transform: scale()` on a fixed 1920×1080 stage so screen-record at any zoom level looks identical.

---

## Data Payload

Paste the full contents of `/data/2026-04-25.json` into the artifact as `const REPORT = { ... }`. The numbers above are derived from it; if anything diverges, **trust the JSON, not this brief.**
