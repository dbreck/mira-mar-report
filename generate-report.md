# Mira Mar Monthly Marketing Report — Generation Runbook

> **Usage:** Open this file's parent directory in Claude Code, then say:
> "Generate this month's Mira Mar report" (or run the prompt below).

---

## Quick-Start Prompt

```
Read generate-report.md and follow the instructions to produce this month's Mira Mar marketing report. Navigate the Looker Studio dashboard, extract data from each page, generate insights, and write the final report.html.
```

---

## 1. Dashboard Access

- **URL:** `https://lookerstudio.google.com/reporting/e33e788e-8223-4dac-80db-afa348e65e1c`
- **Pages:** 10 total. **Skip page 1** (landing/cover). Analyze pages 2–10.
- **Navigation:** Use the page selector tabs at the top of the dashboard. Click each tab in order.

---

## 2. Per-Page Data Extraction

For each page, capture **both** a screenshot (for visual context) and the page text/accessibility tree (for precise numbers). Record every metric listed below.

### Page 2 — Spark Digital Ads Leads
- Hot / Warm / Reservation lead counts
- Lead names, statuses, sources
- Date range of leads shown
- **Insight focus:** Lead quality, follow-up status, pipeline health

### Page 3 — KPI Page
- Total Spend (all channels)
- Total Impressions, Clicks, Leads
- CPL (Cost Per Lead), CPC (Cost Per Click)
- Channel breakdown (Google vs Meta spend/leads)
- Month-over-month trends if visible
- **Insight focus:** Budget efficiency, ROI, channel allocation

### Page 4 — Google Ads Overview
- CTR, Conversion Rate, CPC
- Campaign-level performance
- Location targeting results
- Top keywords
- **Insight focus:** Google Ads health, top performers, waste

### Page 5 — Google Ads Insights
- Demographics (age, gender breakdown)
- Form submissions count
- Phone call leads count
- Device breakdown
- **Insight focus:** Who's responding, conversion paths

### Page 6 — Meta Ads Overview
- CTR, Conversion Rate, CPL, CPC
- Campaign-level performance
- Location/audience targeting
- **Insight focus:** Meta/Instagram ad health

### Page 7 — Meta Ads Insights
- Lead details by source/campaign
- Lead quality indicators
- Ad creative performance if shown
- **Insight focus:** Meta lead quality and volume

### Page 8 — Google Analytics
- Users, New Users, Page Views
- Pages per User, Avg Session Duration
- Top channels (organic, paid, direct, referral, social)
- Top landing pages
- Bounce rate / engagement rate
- **Insight focus:** Website engagement, traffic quality

### Page 9 — Google Search Console
- Average Position
- Total Queries, Impressions, Clicks
- Top search terms (with position & CTR)
- Top landing pages
- **Insight focus:** Organic search visibility, keyword wins

### Page 10 — CallRail
- Total Calls, First-Time Callers, Answered Calls
- Missed call count / rate
- Source breakdown (which campaigns drive calls)
- Call duration averages
- **Insight focus:** Phone engagement, responsiveness, missed opportunities

---

## 3. Analysis Framework

After extracting all data, analyze and assign a status to each section:

### Status Thresholds

| Status | Meaning | When to Use |
|--------|---------|-------------|
| 🟢 Green | Strong / On Track | Metrics trending up or meeting benchmarks |
| 🟡 Yellow | Watch / Mixed | Flat trends, some metrics underperforming |
| 🔴 Red | Action Needed | Declining metrics, wasted spend, missed leads |

### Section-Specific Guidance

**Budget & ROI (KPI Page)**
- 🟢 CPL under $250 and improving; spend balanced across channels
- 🟡 CPL $250–$400 or one channel underperforming
- 🔴 CPL above $400 or significant spend with few leads

**Google Ads Performance**
- 🟢 CTR > 3%, Conv Rate > 5%, strong keyword performance
- 🟡 CTR 2–3%, Conv Rate 3–5%, some wasted keywords
- 🔴 CTR < 2%, Conv Rate < 3%, high CPC with low conversions

**Meta Ads Performance**
- 🟢 Strong lead volume, CPL competitive with Google, good engagement
- 🟡 Decent volume but CPL rising or engagement flat
- 🔴 Low leads, high CPL, poor engagement

**Website & Organic**
- 🟢 User growth > 10% MoM, strong organic channel, good engagement
- 🟡 Flat traffic, organic stable but not growing
- 🔴 Traffic declining, high bounce rate, poor engagement

**Lead Pipeline**
- 🟢 Strong lead flow, high answer rate (>80%), good follow-up
- 🟡 Moderate leads, some missed calls, follow-up gaps
- 🔴 Low leads, high missed call rate, poor follow-up

---

## 4. Report Writing Guidelines

### Voice & Tone
- **Executive-level:** Assume the reader is a busy decision-maker, not a marketer
- **Plain English:** No jargon. Say "cost per lead" not "CPL" (or define it on first use)
- **"So what?" first:** Lead every card with the insight, not the number
- **Actionable:** Include one recommended action per card when warranted

### Insight Card Structure
Each card should contain:
1. **Status chip** (🟢/🟡/🔴) + **Headline** (e.g., "Paid Ads: Money Well Spent")
2. **2-3 narrative sentences** explaining what happened and why it matters
3. **2-4 highlighted metrics** (the numbers that back up the narrative)
4. **Recommended action** (optional, when there's a clear next step)

### Executive Summary
- Overall health verdict (one sentence)
- 3-4 key takeaways as bullet points
- One thing to watch
- Bottom-line stat (e.g., "$X spent → Y leads at $Z/lead")

---

## 5. Output

Write the completed report to `report.html` in this directory. The HTML file is self-contained with inline CSS. Update:
- The report month/year in the header
- The generation date in the footer
- All insight card content
- All metric values
- All status indicators

After writing, open the file in Chrome to verify it renders correctly.

---

## 6. Checklist

- [ ] Navigated all 9 data pages (skipped page 1)
- [ ] Extracted metrics from each page
- [ ] Assigned status to each section
- [ ] Wrote executive summary
- [ ] Wrote all 5 insight cards
- [ ] Updated report.html with current data
- [ ] Verified report renders in browser
