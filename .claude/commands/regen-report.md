---
description: Regenerate the Mira Mar marketing performance report (extract Looker data → write archive entry → deploy)
argument-hint: [period — e.g. blank, "2w", "4w", "--end 2026-05-09 --weeks 2", "--start ... --end ...", optionally append "--dry-run"]
---

You are regenerating the Mira Mar Sarasota marketing performance report.

## Arguments

Raw user arguments: **$ARGUMENTS**

Parse them into a period. Accept these forms (any combination):

| Form | Meaning |
|---|---|
| (empty) | Last 30 days ending today |
| `1w` / `2w` / `4w` / `30d` | Last N weeks/days ending today |
| `--weeks N` | Same as `Nw` |
| `--end YYYY-MM-DD` | End date (defaults: today) |
| `--start YYYY-MM-DD` | Start date (overrides `--weeks` if both given) |
| `--dry-run` | Extract data + write JSON only — skip HTML build, archive nav, and commit |

After parsing, **echo back the resolved period to the user before doing anything else**: "I'll regenerate for `<start>` – `<end>` (`<N>` days). Comparing against `<prior-folder>` (`<prior-length>` days)." Wait for confirmation only if `--start`/`--end` look unusual (e.g. older than 90 days, or end date in the future). Otherwise proceed.

## File targets

For period ending date `END` (folder naming is always end-date based, matching the existing pattern):

- `/data/<END>.json` — structured metrics snapshot
- `/reports/<END>/index.html` — archived report
- `/index.html` — root mirror of the latest report

If `/reports/<END>/` already exists, **ask before overwriting**.

## Pre-flight

1. Confirm Chrome has the Looker Studio dashboard open and is signed in to a Google account with access:
   - URL: `https://lookerstudio.google.com/reporting/67eab629-df7f-46eb-bc09-caeb2c79fc19`
   - If not signed in or not loaded, ask the user to handle it before continuing.
2. Browser tools (`mcp__claude-in-chrome__*`) are deferred — load them via `ToolSearch` before calling them. Bare minimum: `tabs_context_mcp`, `navigate`, `computer`, `get_page_text`.
3. Read `generate-report.md` and follow it. **Do not paraphrase its steps — execute them.** That document is the source of truth for which pages to extract and which metrics to capture.

## Looker date-range mapping

The Looker preset matches you'll typically use:

| Period requested | Looker preset |
|---|---|
| 30 days | `Last 30 days` + Include today |
| 4 weeks / 28 days | `Last 28 days` + Include today |
| 2 weeks / 14 days | `Last 14 days` + Include today |
| 1 week / 7 days | `Last 7 days` + Include today |
| Custom (`--start`/`--end`) | Open `Fixed` panel and pick exact dates |

**Each Looker page has its own date filter.** You must apply the range on every page individually: Spark Digital Ads Leads, Google Ads Overview, Google Ads Insights, Meta Ads Overview, Meta Ads Creative, Google Analytics, Google Search Console, CallRail. Skip the cover page and Lifetime Overview. Use `mcp__claude-in-chrome__get_page_text` to dump each page in one call rather than scrolling and screenshotting.

## Extraction

Capture every metric listed in `generate-report.md` § 2. For each section, also note the section status (🟢/🟡/🔴) using the thresholds in § 4.

Save raw notes to `/tmp/mira-mar-extraction-notes.md` as you go. Then assemble the structured snapshot at `/data/<END>.json` matching the schema of the most recent prior JSON (look at `/data/2026-04-25.json` as the canonical example — same keys, same shape, same nesting).

## Comparison

Read the most recent prior JSON in `/data/`. Compute deltas for every comparable metric:

```
delta_pct = (current - previous) / previous * 100
```

**Period-length mismatch warning:** If the prior report's period length differs from this one (e.g., 2-week vs 4-week), include a banner in the report's hero noting the mismatch. Deltas across mismatched windows are misleading and the reader should be aware.

Direction classes for each delta on the report:

- `--up` (green): increased and increase is good (leads, conversions, queries, impressions, organic CTR)
- `--down` (red): decreased and decrease is bad (those same metrics moving the other way)
- `--good-down` (green): decreased and decrease is good (CPL, CPC, missed calls, search position, bounce rate)
- `--bad-up` (red): increased and increase is bad (same metrics moving the other way)
- `--flat` (muted): change less than 2%

If `--dry-run`, stop here. Show the user the JSON + comparison summary and exit. Do not touch HTML, archive nav, or git.

## Build

Use `/reports/2026-04-25/index.html` as the canonical visual template. **Do not redesign it.** Same:

- Typography: Cormorant Garamond (display serif italic for titles) + Manrope (sans body) via Google Fonts
- Palette: deep navy `#0e1320` / card `#1b2236` / gold `#c9a96e` / cream `#f4ecd9`
- Section card with status chip, gradient accent line, editorial lede paragraph (max ~64ch)
- Stat grid with delta arrows + "vs prior" inline
- Animated bar charts (CSS keyframe `fillIn`)
- Compare strip (before → after) on key metrics
- Action callout at section end where there's a clear next step
- Recommendations list with priority tags
- Floating archive nav (top-right pill) — list every report in `/reports/`, mark this one `is-current`, mark the most recent `Latest`

Voice & tone:

- Executive-level, plain English (no jargon without explanation)
- "So what?" first — lead with the insight, not the number
- One recommendation per section when there's a clear next step
- Status chip per section (Strong Period / Improving / Watch CPL / Mixed / etc.)

## Archive nav update

The new report needs to appear in the archive panel of every existing report:

- `/index.html`
- `/reports/<END>/index.html` (this one — mark `is-current`, tag `Latest`)
- All other `/reports/*/index.html` — un-tag `Latest`, keep links intact

## Verify locally

Start the preview server, open the new report, and ask the user to confirm it looks right before committing:

```bash
python3 -m http.server 8765 > /tmp/mira-mar-server.log 2>&1 &
```

Open `http://localhost:8765/` (the new latest) and `http://localhost:8765/reports/<END>/` (the archive entry).

Pause and ask: "Looks good to commit and deploy? (y/n)"

## Ship

Once confirmed:

```bash
git add data/ reports/ index.html
git commit -m "feat(report): <START> – <END> period"
git push
```

Vercel auto-deploys from `main`. Confirm the live site shows the new report at `https://mira-mar-report.vercel.app`.

Stop the local preview server.

## Final summary

Tell the user:
- Period covered, comparison period
- 3-4 headline numbers with deltas
- Status of each section
- Live URL

Keep it tight — they can read the report itself for detail.
