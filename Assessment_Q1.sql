-- Assessment_Q1.sql
/*
High-Value Customers Analysis
- 4-digit owner IDs (0001, 0002...)
- 6-digit deposit format (000,000)
- Processed in safe batches
*/

-- Step 1: Clean up any existing temp tables
DROP TEMPORARY TABLE IF EXISTS temp_savings;
DROP TEMPORARY TABLE IF EXISTS temp_investments;

-- Step 2: Create savings summary (execute this first)
CREATE TEMPORARY TABLE temp_savings AS
SELECT 
    owner_id,
    COUNT(DISTINCT id) AS savings_count,
    SUM(confirmed_amount) AS total_deposits_kobo
FROM savings_savingsaccount
WHERE confirmed_amount > 0
GROUP BY owner_id;

-- Step 3: Create investments summary (execute this second)
CREATE TEMPORARY TABLE temp_investments AS
SELECT 
    owner_id,
    COUNT(DISTINCT id) AS investment_count
FROM plans_plan
WHERE is_a_fund = 1
GROUP BY owner_id;

-- Step 4: Final formatted output (execute this last)
SELECT 
    LPAD(DENSE_RANK() OVER(ORDER BY u.id), 4, '0') AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    IFNULL(s.savings_count, 0) AS savings_count,
    IFNULL(i.investment_count, 0) AS investment_count,
    FORMAT(FLOOR(IFNULL(s.total_deposits_kobo, 0)/100), 0) AS total_deposits
FROM users_customuser u
LEFT JOIN temp_savings s ON u.id = s.owner_id
LEFT JOIN temp_investments i ON u.id = i.owner_id
WHERE IFNULL(s.savings_count, 0) > 0
AND IFNULL(i.investment_count, 0) > 0
ORDER BY IFNULL(s.total_deposits_kobo, 0) DESC;

-- Clean up (execute after getting results)
DROP TEMPORARY TABLE IF EXISTS temp_savings;
DROP TEMPORARY TABLE IF EXISTS temp_investments;