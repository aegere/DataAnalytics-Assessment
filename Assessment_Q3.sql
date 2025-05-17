-- Find inactive accounts (no deposits in 365+ days)
WITH inactive_accounts AS (
    SELECT 
        p.id,
        p.owner_id,
        IF(p.is_a_fund = 1, 'Investment', 'Savings') AS type,
        COALESCE(
            (SELECT MAX(transaction_date) 
             FROM savings_savingsaccount 
             WHERE plan_id = p.id AND confirmed_amount > 0),
            p.start_date
        ) AS last_date
    FROM 
        plans_plan p
    WHERE 
        DATEDIFF(CURRENT_DATE, COALESCE(
            (SELECT MAX(transaction_date) 
             FROM savings_savingsaccount 
             WHERE plan_id = p.id AND confirmed_amount > 0),
            p.start_date
        )) > 365
)

SELECT 
    LPAD(ROW_NUMBER() OVER(), 4, '0') AS plan_id,
    LPAD(DENSE_RANK() OVER(ORDER BY owner_id), 3, '0') AS owner_id,
    type,
    DATE(last_date) AS last_transaction_date,
    DATEDIFF(CURRENT_DATE, last_date) AS inactivity_days
FROM 
    inactive_accounts
ORDER BY 
    inactivity_days DESC;