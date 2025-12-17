# Restaurant Operations Analysis

<img width="1536" height="1024" alt="Copilot_20251216_204710" src="https://github.com/user-attachments/assets/2bfabb13-6ec8-429d-9659-3331c060e731" />


## About This Project

This project is part of the [Maven Analytics Guided Projects](https://www.mavenanalytics.io/). The scenario: I've just been hired as a Data Analyst for Taste of the World Café, a restaurant featuring dishes from around the globe — Italian Shrimp Scampi, Korean Beef Bowl, Mexican Steak Torta, and classic American Hamburgers.

The café launched a new menu at the start of 2023, and I was tasked with analyzing customer data to see how it's performing. Which dishes are customers loving? Which ones need attention? What do the big spenders order?

## Dataset

| Table | Records | Description |
|-------|---------|-------------|
| `menu_items` | 32 | Menu item details (name, category, price) |
| `order_details` | 12,234 | Individual order transactions |

**Date Range:** January – March 2023 (Q1)

## Key Findings

### Popular Doesn't Mean Profitable

American items dominate the bestseller list:
- #1 Hamburger (622 orders)
- #4 Cheeseburger (583 orders)
- #5 French Fries (571 orders)

Yet American ranks **last** in revenue at just 18%.

Italian has no items in the top 5 bestsellers, but leads revenue at **31%**. The difference? Price point — American averages $10.33 per item while Italian averages $16.78.

### Category Performance

| Category | Items Sold | Revenue | Avg Price | Share |
|----------|------------|---------|-----------|-------|
| Italian | 2,948 | $49,463 | $16.78 | 31% |
| Asian | 3,470 | $46,721 | $13.46 | 29% |
| Mexican | 2,945 | $34,797 | $11.82 | 22% |
| American | 2,734 | $28,238 | $10.33 | 18% |

### When Customers Order

**Busiest Day:** Monday (885 orders)  
**Slowest Day:** Wednesday (682 orders)  
**Peak Period:** Lunch — 36% of all orders

The weekday lunch rush suggests a strong office crowd.

### What Big Spenders Order

4 out of 5 top-spending orders had Italian as their highest category. Big spenders buy Italian.

### Q1 Performance

| Metric | Value |
|--------|-------|
| Total Revenue | $159,218 |
| Total Orders | 5,370 |
| Avg Order Value | $29.78 |
| Avg Daily Revenue | $1,769 |

## Recommendations

- **Upsell Italian** — Popular American items bring traffic; Italian brings profit. Bundle them.
- **Boost weekends** — Saturday is slowest. Promotions could help.
- **Review Chicken Tacos** — Only 123 orders. Lowest on the menu.
- **Staff for lunch** — 36% of business happens between 10 AM – 2 PM.

## Tools

- MySQL
- MySQL Workbench

## Files

| File | Description |
|------|-------------|
| `restaurant_operations_analysis.sql` | Full analysis with queries and insights |
|`create_restaurant_db.sql` | Database setup script with table creation and data |
|`restaurant_db_data_dictionary.csv` | Data dictionary explaining all fields |
| `README.md` | Project overview |


---

*Data sourced from Maven Analytics.*
