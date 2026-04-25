# Mira Mar Marketing Report — Generation Runbook

> **Usage:** Open this file's parent directory in Claude Code, then say:
> "Generate this period's Mira Mar report" (or run the prompt below).

This is a multi-report archive site:
- **Latest report** is mirrored at the root (`/index.html`).
- **All reports** are archived under `/reports/YYYY-MM-DD/index.html`.
- Each period's metrics are also stored as JSON at `/data/YYYY-MM-DD.json` so future reports can compute deltas.
- An archive nav (top-right pill) appears on every report and links between them.
- The intended cadence is **biweekly** (every 2 weeks).

---

## Quick-Start

In Claude Code, in this directory:

```
/regen-report             # last 30 days ending today
/regen-report 2w          # last 2 weeks ending today
/regen-report 4w          # last 4 weeks ending today
/regen-report --end 2026-05-09 --weeks 2     # backfill 2 weeks ending May 9
/regen-report --start 2026-04-26 --end 2026-05-09     # explicit range
/regen-report 2w --dry-run                   # extract + JSON only, skip HTML/commit
```

The slash command is defined in `.claude/commands/regen-report.md` and orchestrates everything below — it follows this runbook and pauses for your approval before committing.

If you want to run the steps manually without the slash command, the long-form prompt is:

```
Read generate-report.md and follow it to produce this period's Mira Mar marketing report. Navigate the Looker Studio dashboard, set every page's date filter to the appropriate Last N days preset with Include today checked, extract data from each page, write a /data/YYYY-MM-DD.json snapshot, then build /reports/YYYY-MM-DD/index.html with comparisons against the most recent prior report. Finally copy the new report file to /index.html and update the archive nav on all reports.
```

---

## 1. Dashboard Access

- **URL:** `https://lookerstudio.google.com/reporting/67eab629-df7f-46eb-bc09-caeb2c79fc19`
- **Account:** Sign in to the Google account that has access (currently signed in via the user's Chrome browser when needed).
- **Pages (10 total, skip page 1 cover):** Spark Leads (cover) → Spark Digital Ads Leads → Lifetime Overview (skip — new, lifetime data) → Google Ads Overview → Google Ads Insights → Meta Ads Overview → Meta Ads Creative → Google Analytics → Google Search Console → CallRail.
- **Each page has its own date filter.** You must set the date range on every analysis page individually. Use the page-level date picker → "Fixed" dropdown → hover "Last 7 days" → click "Last 30 days" → check "Include today" → Apply.

---

## 2. Per-Page Data Extraction

For each page, capture both a screenshot (for visual context) and the page text/accessibility tree (for precise numbers). Use `mcp__claude-in-chrome__get_page_text` to dump the full page text in one call — much faster than scrolling and screenshotting.

### Spark Digital Ads Leads
- KPI card counts: Warm, Sales Visit/Meeting, Hot, Reservation
- Hot Leads & Reservations table (date, name, ad source, status)
- Lead source mix from the table

### Google Ads Overview
- Total: Clicks, CTR, Impressions
- Conversions, Conv Rate, CPL, CPC, Cost
- Campaign-Level Breakdown (Search_Branded, Search_Non-Branded_Sarasota, Search_Competitors, Search_Non-Branded_Key Feeder Markets) — capture impressions/clicks/conversions/cost per campaign
- Top search keywords (top 10)
- Conversions by device (mobile/computer/tablet %)
- Agents vs Non-Agents (% split)
- Top performing ad copy

### Google Ads Insights
- Clicks by age bracket
- Clicks by gender
- Website Form Submissions (count + table)
- Phone Call Leads (count + table)

### Meta Ads Overview
- Total: Link clicks, CTR, Impressions, Leads, Conv Rate, CPL, Cost, CPC
- Campaign-Level Breakdown (Prospecting Sarasota, Prospecting Feeder, Remarketing) — impressions/clicks/leads/CPL/cost per campaign
- Lead Insights table (recent leads + sources)

### Meta Ads Creative
- Top creatives by leads (campaign × ad × leads × CPL × video views × engagements)

### Google Analytics
- Active Users (with delta % from prior)
- New Users (with delta %)
- Views (with delta %)
- Avg Pages per User (with delta %)
- Sessions by Source/Campaign (google, meta, direct, yourobserver)
- Top Pages with bounce rate + avg time
- Channel Mix (organic vs paid breakdown)

### Google Search Console
- Average Position (with delta %)
- Query count (with delta %)
- Impressions (with delta %)
- Top search terms (top 10) with impressions/clicks/CTR
- Top landing pages

### CallRail
- Total Calls, First Time Callers, Answered Calls, Missed Calls (with deltas)
- Answer Rate, Avg Duration
- Calls by Source (table: total/first time/leads per source)

---

## 3. Compute Comparisons

Read the most recent prior report's JSON from `/data/`. For each metric, compute:

```
delta_pct = (current - previous) / previous * 100
```

Mark each metric with the appropriate direction class:
- `--up` (green): increased and increase is good (leads, conversions, queries, impressions, etc.)
- `--down` (red): decreased and decrease is bad
- `--good-down` (green): decreased and decrease is good (CPL, CPC, missed calls, search position, bounce rate)
- `--bad-up` (red): increased and increase is bad (CPL, missed calls, search position)
- `--flat` (muted): change less than 2%

---

## 4. Status Framework

Assign a section status (`green` / `yellow` / `red`) to:
- Executive Summary
- Budget & ROI
- Google Ads
- Meta Ads
- Website & Organic
- Lead Pipeline & Phone

### Section thresholds

**Budget & ROI**
- 🟢 CPL trending down or flat under $250
- 🟡 CPL flat $250-$400 or one channel underperforming
- 🔴 CPL rising above $400 or significant spend with few leads

**Google Ads**
- 🟢 Conv Rate above 1.2% with conversions trending up
- 🟡 Conv Rate 0.8-1.2% or CTR declining
- 🔴 Conv Rate under 0.8% with high CPC

**Meta Ads**
- 🟢 CPL under $150 with strong volume
- 🟡 CPL $150-$220 or volume flat with cost rising
- 🔴 CPL over $220 with declining lead quality

**Website & Organic**
- 🟢 Organic queries/impressions growing 20%+
- 🟡 Mostly flat
- 🔴 Traffic declining with no organic offset

**Lead Pipeline**
- 🟢 Hot/warm count growing, answer rate >85%
- 🟡 Pipeline flat, answer rate 70-85%
- 🔴 Pipeline shrinking, answer rate <70%

---

## 5. Output Files

For a report covering period ending `YYYY-MM-DD`:

1. **`/data/YYYY-MM-DD.json`** — structured metrics snapshot. Match the schema of the most recent prior report's JSON (see `/data/2026-04-25.json` for reference).
2. **`/reports/YYYY-MM-DD/index.html`** — full report with comparison deltas vs prior period.
3. **`/index.html`** — root copy of the latest report for the bare URL. Just `cp` the new report file here.
4. **Update archive nav** — add the new report to the dropdown list in:
   - `/index.html`
   - `/reports/YYYY-MM-DD/index.html` (this period — mark `is-current`)
   - All previously archived reports (`/reports/*/index.html`) — un-mark "Latest" tag from previous report

The report HTML uses Cormorant Garamond (display serif) + Manrope (sans body) via Google Fonts, deep navy + gold + cream palette, animated bar charts, scroll-triggered reveals, and a floating archive nav. See `/reports/2026-04-25/index.html` for the canonical template.

---

## 6. Re-Running on Demand

From this directory:

```bash
# 1. Open Looker dashboard in Chrome (auth required)
# 2. Run Claude Code with the prompt at the top of this file
# 3. Locally preview before committing:
python3 -m http.server 8765
# Open http://localhost:8765
```

When happy, commit and push:

```bash
git add data/ reports/ index.html
git commit -m "feat(report): YYYY-MM-DD period"
git push
```

Vercel auto-deploys from `main`.

---

## 7. Biweekly Schedule

The cadence is every 2 weeks. Set a reminder via the Claude Code `/schedule` skill to fire a generation request automatically. The schedule prompt should include:

> "Generate the next Mira Mar marketing report. Read /Users/dannybreckenridge/Documents/Clear ph/Clients/Mira Mar/Looker Analysis/generate-report.md, follow it to extract Looker data for the last 30 days, build the new archived report, and commit + push."

---

## 8. Voice & Tone

- **Executive-level:** assume a busy decision-maker, not a marketer
- **Plain English:** define jargon on first use ("cost per lead", not "CPL")
- **"So what?" first:** lead each card with the insight, not the number
- **One recommendation per section** when there's a clear next step
- **Comparison built-in:** every metric should show the delta vs prior period

### Section card structure
1. Status chip (🟢/🟡/🔴) + headline
2. Editorial 2-3 sentence narrative (in serif, max ~64 chars wide)
3. 3-4 stat cards with values + delta arrows
4. 1-2 charts (animated bar fills)
5. Optional `Recommendation` callout

### Executive Summary
- Overall verdict (one sentence)
- 3-4 key takeaways embedded in the narrative
- Headline stat grid (4 KPIs with deltas)
- Spend-by-channel mini chart

---

## 9. Checklist

- [ ] Set Last 30 days + Include today on every analysis page
- [ ] Captured metrics from all 9 data pages
- [ ] Computed comparisons against most recent prior report
- [ ] Assigned status to each section
- [ ] Wrote `/data/YYYY-MM-DD.json`
- [ ] Wrote `/reports/YYYY-MM-DD/index.html`
- [ ] Copied to `/index.html`
- [ ] Updated archive nav links in all reports (mark new as Latest, un-mark old)
- [ ] Previewed locally with `python3 -m http.server 8765`
- [ ] Committed + pushed to `main`
