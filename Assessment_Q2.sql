-- Assessment_Q2.sql
/* Transaction Frequency Analysis */

-- Step 1: Create temporary table with proper date formatting
CREATE TEMPORARY TABLE monthly_transaction_counts AS
SELECT 
    owner_id,
    DATE_FORMAT(transaction_date, '%Y-%m') AS month_year,  -- Fixed date formatting
    COUNT(*) AS transactions_count
FROM 
    savings_savingsaccount
WHERE 
    transaction_status = 'success'
    AND confirmed_amount > 0
GROUP BY 
    owner_id, 
    DATE_FORMAT(transaction_date, '%Y-%m');  -- Consistent grouping

-- Step 2: Calculate averages (unchanged)
CREATE TEMPORARY TABLE customer_avg_transactions AS
SELECT 
    owner_id,
    AVG(transactions_count) AS avg_monthly_transactions,
    COUNT(month_year) AS active_months
FROM 
    monthly_transaction_counts
GROUP BY 
    owner_id;

-- Step 3: Categorize customers (unchanged)
SELECT 
    CASE 
        WHEN avg_monthly_transactions >= 10 THEN 'High Frequency'
        WHEN avg_monthly_transactions >= 3 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_monthly_transactions), 1) AS avg_transactions_per_month
FROM 
    customer_avg_transactions
GROUP BY 
    frequency_category
ORDER BY 
    CASE frequency_category
        WHEN 'High Frequency' THEN 1
        WHEN 'Medium Frequency' THEN 2
        ELSE 3
    END;

-- Clean up
DROP TEMPORARY TABLE IF EXISTS monthly_transaction_counts;
DROP TEMPORARY TABLE IF EXISTS customer_avg_transactions;