-- ============================================================
-- B2B Sales Pipeline & Partnership Simulation
-- SQL Schema + Funnel / Conversion Analysis Queries
-- Import data/pipeline_leads.csv into this table before running.
-- ============================================================

CREATE TABLE IF NOT EXISTS pipeline (
    lead_id           VARCHAR(20) PRIMARY KEY,
    company_name      VARCHAR(150),
    industry          VARCHAR(50),
    company_size      VARCHAR(30),
    contact_name      VARCHAR(100),
    contact_title     VARCHAR(50),
    email             VARCHAR(150),
    lead_source       VARCHAR(50),
    date_created      DATE,
    sales_rep         VARCHAR(100),
    budget_score      INT,
    authority_score   INT,
    need_score        INT,
    timeline_score    INT,
    stage             VARCHAR(30),
    deal_value        DECIMAL(14, 2),
    win_probability   DECIMAL(4, 2),
    expected_close    DATE,
    actual_close      DATE,
    days_in_pipeline  INT,
    lost_reason       VARCHAR(100)
);

-- ------------------------------------------------------------
-- 1. Pipeline funnel — leads currently sitting in each stage
-- ------------------------------------------------------------

SELECT
    stage,
    COUNT(*)                          AS leads,
    SUM(deal_value)                   AS stage_value,
    ROUND(SUM(deal_value * win_probability), 0) AS weighted_value
FROM pipeline
GROUP BY stage
ORDER BY
    CASE stage
        WHEN 'New Lead' THEN 1
        WHEN 'Contacted' THEN 2
        WHEN 'Qualified' THEN 3
        WHEN 'Proposal Sent' THEN 4
        WHEN 'Negotiation' THEN 5
        WHEN 'Closed Won' THEN 6
        WHEN 'Closed Lost' THEN 7
    END;


-- ------------------------------------------------------------
-- 2. Overall win rate and pipeline totals
-- ------------------------------------------------------------

SELECT
    COUNT(*) FILTER (WHERE stage = 'Closed Won')  AS deals_won,
    COUNT(*) FILTER (WHERE stage = 'Closed Lost') AS deals_lost,
    ROUND(
        COUNT(*) FILTER (WHERE stage = 'Closed Won')::DECIMAL
        / NULLIF(COUNT(*) FILTER (WHERE stage IN ('Closed Won','Closed Lost')), 0) * 100, 1
    ) AS win_rate_pct,
    SUM(deal_value) FILTER (WHERE stage = 'Closed Won') AS closed_won_revenue,
    SUM(deal_value) FILTER (WHERE stage NOT IN ('Closed Won','Closed Lost')) AS open_pipeline_value
FROM pipeline;
-- MySQL alternative: replace FILTER (WHERE ...) with SUM(CASE WHEN ... THEN 1 ELSE 0 END)


-- ------------------------------------------------------------
-- 3. Lead source performance — which channels actually convert
-- ------------------------------------------------------------

SELECT
    lead_source,
    COUNT(*)                                                    AS total_leads,
    COUNT(*) FILTER (WHERE stage = 'Closed Won')                AS won,
    ROUND(
        COUNT(*) FILTER (WHERE stage = 'Closed Won')::DECIMAL
        / COUNT(*) * 100, 1
    )                                                            AS win_rate_pct,
    SUM(deal_value) FILTER (WHERE stage = 'Closed Won')          AS revenue_won
FROM pipeline
GROUP BY lead_source
ORDER BY win_rate_pct DESC;


-- ------------------------------------------------------------
-- 4. Sales rep leaderboard
-- ------------------------------------------------------------

SELECT
    sales_rep,
    COUNT(*)                                              AS leads_owned,
    COUNT(*) FILTER (WHERE stage = 'Closed Won')          AS deals_won,
    ROUND(
        COUNT(*) FILTER (WHERE stage = 'Closed Won')::DECIMAL
        / COUNT(*) * 100, 1
    )                                                      AS win_rate_pct,
    SUM(deal_value) FILTER (WHERE stage = 'Closed Won')   AS revenue_closed
FROM pipeline
GROUP BY sales_rep
ORDER BY revenue_closed DESC;


-- ------------------------------------------------------------
-- 5. BANT score vs. win rate (does qualification actually predict wins?)
-- ------------------------------------------------------------

SELECT
    CASE
        WHEN (budget_score + authority_score + need_score + timeline_score) <= 10 THEN '0-10 (Poor fit)'
        WHEN (budget_score + authority_score + need_score + timeline_score) <= 14 THEN '11-14 (Weak fit)'
        WHEN (budget_score + authority_score + need_score + timeline_score) <= 17 THEN '15-17 (Good fit)'
        ELSE '18-20 (Strong fit)'
    END AS bant_band,
    COUNT(*)                                              AS leads,
    ROUND(
        COUNT(*) FILTER (WHERE stage = 'Closed Won')::DECIMAL
        / COUNT(*) * 100, 1
    )                                                      AS win_rate_pct
FROM pipeline
GROUP BY bant_band
ORDER BY bant_band;


-- ------------------------------------------------------------
-- 6. Average sales cycle length (days) for won vs. lost deals
-- ------------------------------------------------------------

SELECT
    stage,
    ROUND(AVG(days_in_pipeline), 1) AS avg_days_in_pipeline,
    COUNT(*)                        AS deal_count
FROM pipeline
WHERE stage IN ('Closed Won', 'Closed Lost')
GROUP BY stage;


-- ------------------------------------------------------------
-- 7. Why deals are lost
-- ------------------------------------------------------------

SELECT
    lost_reason,
    COUNT(*)                          AS deals_lost,
    SUM(deal_value)                   AS lost_revenue
FROM pipeline
WHERE stage = 'Closed Lost'
GROUP BY lost_reason
ORDER BY deals_lost DESC;


-- ------------------------------------------------------------
-- 8. Deal size by company segment (which segment to prioritize)
-- ------------------------------------------------------------

SELECT
    company_size,
    COUNT(*) FILTER (WHERE stage = 'Closed Won')         AS deals_won,
    ROUND(AVG(deal_value) FILTER (WHERE stage = 'Closed Won'), 0) AS avg_deal_size,
    SUM(deal_value) FILTER (WHERE stage = 'Closed Won')  AS total_revenue
FROM pipeline
GROUP BY company_size
ORDER BY total_revenue DESC;


-- ------------------------------------------------------------
-- 9. Industry win rate (where to focus outbound targeting)
-- ------------------------------------------------------------

SELECT
    industry,
    COUNT(*)                                              AS leads,
    ROUND(
        COUNT(*) FILTER (WHERE stage = 'Closed Won')::DECIMAL
        / COUNT(*) * 100, 1
    )                                                      AS win_rate_pct
FROM pipeline
GROUP BY industry
ORDER BY win_rate_pct DESC;
