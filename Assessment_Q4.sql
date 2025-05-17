-- Assessment_Q4.sql
/*
Customer Lifetime Value (CLV) Estimation
- 4-digit customer IDs (0001, 0002...)
- Clean numeric formatting
- Accurate CLV calculation
*/

SELECT 
    -- 4-digit customer ID
    LPAD(DENSE_RANK() OVER(ORDER BY u.id), 4, '0') AS customer_id,
    
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    
    -- Account tenure in months (minimum 1 month)
    GREATEST(1, TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE())) AS tenure_months,
    
    -- Total transactions
    COUNT(s.id) AS total_transactions,
    
    -- Estimated CLV (formatted to 2 decimal places)
    FORMAT(
        /* Calculation: (transactions/tenure) * 12 * (0.1% of avg transaction value) */
        (COUNT(s.id) / GREATEST(1, TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE()))) * 
        12 * 
        (0.001 * AVG(s.confirmed_amount/100)),  -- 0.1% profit, kobo to naira
        2
    ) AS estimated_clv
FROM 
    users_customuser u
JOIN 
    savings_savingsaccount s ON u.id = s.owner_id
WHERE 
    s.confirmed_amount > 0
    AND s.transaction_status = 'success'
GROUP BY 
    u.id, u.first_name, u.last_name, u.date_joined
ORDER BY 
    CAST(estimated_clv AS DECIMAL(10,2)) DESC;  -- Proper numeric sort