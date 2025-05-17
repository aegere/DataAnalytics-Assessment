
## Assessment Solutions

### Question 1: High-Value Customers
**Approach**:
1. Identified customers with both savings and investment accounts
2. Used temporary tables to optimize performance
3. Formatted output with:
   - 4-digit owner IDs (0001)
   - 6-digit deposit amounts (000,000)

**Challenge**: 
- Initial timeouts resolved by breaking into smaller queries
- Learned to use `LPAD` for ID formatting

### Question 2: Transaction Frequency
**Approach**:
1. Calculated monthly transaction averages
2. Categorized customers using `CASE WHEN`
3. Used `DATE_FORMAT` for proper monthly grouping

**Challenge**:
- Date formatting issues fixed with `%Y-%m` pattern
- Learned about MySQL's date functions

### Question 3: Account Inactivity
**Approach**:
1. Found last transaction dates
2. Calculated days since last activity
3. Used `COALESCE` to handle null values

**Challenge**:
- Missing date columns required schema investigation
- Learned to verify table structures first

### Question 4: CLV Estimation
**Approach**:
1. Calculated account tenure in months
2. Applied 0.1% profit assumption
3. Formatted output with:
   - 4-digit customer IDs
   - Proper decimal places

**Challenge**:
- Division by zero risk mitigated with `GREATEST(1, tenure)`
- Learned about numeric casting for sorting

---

