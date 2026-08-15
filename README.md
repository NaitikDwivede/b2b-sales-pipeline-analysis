# B2B Sales Pipeline & Partnership Development Simulation

**Tools used:** Excel · SQL · BANT Qualification Framework

## Business Problem

You're a Business Development / Sales rep at **PulseCRM**, a B2B SaaS analytics
platform sold to mid-market retail, e-commerce, and logistics companies in India
(the buyer persona a company running the earlier *Sales Analytics Dashboard* project
would actually use). Leadership wants to know:

> "Which lead sources and reps are actually converting, where in the funnel are we
> losing deals, and does our BANT qualification process actually predict who buys?"

This project simulates a full sales pipeline — from lead generation through
close/loss — with a CRM-style spreadsheet, SQL analysis, and outreach collateral you'd
use to actually run this process.

## Project Structure

```
bd-pipeline-project/
├── data/
│   └── pipeline_leads.csv           # 600 leads, full funnel history
├── excel/
│   └── Sales_Pipeline_CRM.xlsx      # Pipeline, Funnel Summary, Lead Source Analysis,
│                                     # Sales Rep Leaderboard, BANT Matrix, Lost Reasons
├── sql/
│   └── pipeline_analysis.sql        # schema + 9 funnel/conversion queries
├── templates/
│   └── outreach_templates.md        # BANT script, cold email, LinkedIn, follow-up,
│                                     # objection handling
└── README.md
```

## Dataset

600 leads (Jan 2025–Jul 2026) with: Lead ID, Company, Industry, Company Size, Contact,
Lead Source, Sales Rep, individual BANT scores (Budget/Authority/Need/Timeline, 1-5
each), current pipeline Stage, Deal Value, Win Probability %, Expected/Actual Close
Date, Days in Pipeline, and Lost Reason (for closed-lost deals).

## Pipeline Stages

```
New Lead → Contacted → Qualified → Proposal Sent → Negotiation → Closed Won / Closed Lost
```

A lead is only marked **Qualified** once BANT score reaches 15+ out of 20 — this
threshold isn't arbitrary, it's validated by the data (see insights below).

## 1. Excel — CRM Spreadsheet

Open `excel/Sales_Pipeline_CRM.xlsx`. Six sheets, all formula-driven (no hardcoded
totals):

- **Pipeline** — the 600-row CRM record table. `BANT Total` and `Weighted Value` are
  live formulas (`=SUM()`, `=DealValue*WinProbability`), and `Qualified?` auto-flags
  any lead scoring 15+.
- **Funnel Summary** — leads and value at each stage, conversion % from the previous
  stage, overall win rate, and weighted open pipeline value — all `COUNTIFS`/`SUMIFS`.
- **Lead Source Analysis** — win rate and revenue by channel (Referral, Cold Outbound,
  LinkedIn, etc.)
- **Sales Rep Leaderboard** — leads owned, win rate, and revenue closed per rep.
- **BANT Matrix** — the qualification scoring rubric, plus a live table proving win
  rate rises with BANT score band.
- **Lost Reason Analysis** — why deals are lost, by frequency and revenue impact.

## 2. SQL — Funnel & Conversion Analysis

`sql/pipeline_analysis.sql` covers: funnel-by-stage, overall win rate, lead source
performance, rep leaderboard, BANT-band vs. win rate, sales cycle length (won vs.
lost), lost-reason breakdown, deal size by company segment, and industry win rate.

## 3. Outreach Templates

`templates/outreach_templates.md` includes the BANT discovery-call questions, cold
email and LinkedIn scripts, follow-up sequences, a cold-call opening script, and an
objection-handling table mapped to the actual lost reasons in the dataset.

## Key Business Insights

*(Computed directly from this dataset — this is the kind of finding a BD/sales
analysis is supposed to surface.)*

**Insight 1 — Referral is the highest-converting channel; Cold Outbound is the
lowest, by a wide margin.**
Referral leads close at 14.3%, followed by Inbound-Website at 9.8%. Cold Outbound and
LinkedIn Outreach convert at just 2.3% and 1.9% respectively, despite Cold Outbound
being the single largest source of volume (173 of 600 leads).
**Recommendation:** Shift budget from cold outbound volume toward a formal referral
program and inbound content — the data suggests quality beats quantity here.

**Insight 2 — BANT score is a genuinely strong predictor of win rate.**
Win rate climbs from 2.6% (BANT 0-10) to 8.3% (11-14) to 13.2% (15-17) to 30.0%
(18-20) — a more than 10x difference between weakest and strongest fit.
**Recommendation:** Enforce the 15+ qualification gate strictly before investing rep
time in a proposal; deprioritize sub-10 leads instead of chasing every lead equally.

**Insight 3 — Rep performance varies far more than lead volume would suggest.**
All five reps were assigned a similar number of leads (114-125), but revenue closed
ranges from ₹25.6L (Rohit) to ₹91.8L (Ananya) — a 3.5x spread. Win rate tells the same
story: 1.7%–12.1%.
**Recommendation:** Have top performers (Ananya, Sneha) shadow-coach lower performers,
and audit whether it's discovery-call quality or follow-up cadence driving the gap.

**Insight 4 — Most lost deals aren't lost on price.**
"Chose competitor" (32) and "No decision / went dark" (28) together account for more
lost deals than "Budget too high" (23). Deals that go dark tend to drop off *earlier*
in the cycle, while competitor losses happen later, closer to negotiation.
**Recommendation:** Fix the mid-funnel follow-up cadence to reduce "went dark" losses,
and build a stronger late-stage competitive battlecard to win more negotiation-stage
deals.

## How to Put This on Your Resume

```
B2B Sales Pipeline Development & Funnel Analysis
Tools: Excel, SQL, BANT Qualification Framework
• Built and analyzed a 600-lead B2B sales pipeline across 6 stages (New Lead through
  Closed Won/Lost), tracking BANT qualification scores, deal value, and win
  probability for each lead.
• Applied BANT qualification to validate a 15+/20 scoring threshold, showing a 10x
  win-rate gap between weak-fit and strong-fit leads.
• Analyzed lead source and sales rep performance using SQL and Excel (COUNTIFS,
  SUMIFS, weighted pipeline value), identifying Referral as the highest-converting
  channel at 14.3% vs. 2.3% for Cold Outbound.
• Diagnosed root causes of lost deals (28% went dark mid-funnel vs. 20% lost on price)
  and proposed process changes to follow-up cadence and channel mix.
• Wrote outreach templates (cold email, LinkedIn, objection handling) aligned to
  each pipeline stage.
```
