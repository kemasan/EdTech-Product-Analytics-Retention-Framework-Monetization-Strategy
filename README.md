#  📊 Retention Growth & LTV Strategy

## 🎯 Executive Summary (TL;DR)
This analysis identifies growth levers for Retention, the key metric in a subscription-based EdTech business model. While the average retention rate in EdTech is around 27%, platform data shows that:
* The main retention battle happens within the first 72 hours
* A cognitive break-point occurs during difficult task resolution
* Habit formation and stored value significantly influence long-term engagement

The study focuses on behavioral drivers of retention and proposes product-level interventions to increase LTV.

---

## 🔬 The Analytical Framework & Alignment
Following a structured approach of multi-dimensional matrix analysis (similar to an ABC/XYZ alignment in commercial setups), this study evaluates user engagement across two core vectors: Friction (Cognitive Load) and Value Accumulation (Stored Capital).

                  USER SEGMENTATION MATRIX
          
          High  |  [High Friction / High Capital]  |  [Low Friction / High Capital]
                |  *At-Risk Loyalists* |  *Power Users (Investors)*
                |                                  |
🔥 Friction     |----------------------------------|----------------------------------
 (Frustration)  |                                  |
                |  [High Friction / Low Capital]   |  [Low Friction / Low Capital]
          Low   |  *Immediate Churn Risk* |  *Casual Learners*
                +---------------------------------------------------------------------
                               Low                              High
                                     🪙 Stored Value (CodeCoins Balance)

---

## 📌 Core Metrics
1️⃣ Rolling Retention (Day N+) Accounts for irregular learning patterns. A user is considered retained on day N if they return on day N or later.
Formula: Rolling Retention = (Users active on day N or LATER / Users in cohort start) * 100%

2️⃣ Stickiness (DAU / MAU) Measures daily habit formation. Observed range: 6–13%, below sustainable benchmark for subscription EdTech.
Formula: Stickiness = (DAU / MAU) * 100%

3️⃣ Activation KPI Target: 4 active days in Week 1. Users reaching this threshold show 3+ times higher long-term retention compared to baseline.

4️⃣ Frustration Index (FI) Measures cognitive load during learning. If FI > 5–8, churn probability increases sharply.
Formula: FI = Total CodeRuns / Successful CodeSubmits

---

## 🧠 Tested Hypotheses
🔹 1. “Aha-Moment” (First 72 Hours) Users solving 3+ tasks within 72 hours demonstrate:
* 45–55% higher D30 retention
* 5.3x retention gap (33.5% vs 6.3%)

🔹 2. Habit Formation 4 active days in Week 1 represent a retention inflection point. Crossing this threshold moves the platform toward the industry benchmark (27%).

🔹 3. Cognitive Break-Point When frustration exceeds sustainable levels: at the 7th attempt, abandonment probability begins to exceed success probability. FI > 6–8 significantly increases churn risk. This is the “point of no return.”

🔹 4. Loss Aversion (Stored Value Effect) Users segmented by CodeCoins balance (0, 1–10, 11–50, 51–100, 101–150, 151+). Resulting Stickiness gap: 18.65% (High-balance users) vs 12.91% (Low-balance users). Stored value creates a psychological barrier to churn. Small balances alone do not meaningfully improve retention.

---

## 🔎 Analytical Sections & Visualizations

### 1️⃣ Rolling Retention
* Question: What percentage of users remain active on D1 / D3 / D7 / D30 / D90?
* Method: Monthly cohort grouping. User counted retained if active on day N or later.
* Finding: Massive drop between Day 0 and Day 1 = FTUE wall (First-Time User Experience). Users crossing the 3-day barrier are 2.4x more likely to retain long-term.

![Rolling Retention Cohort]([images/retention_heatmap.png](https://github.com/kemasan/EdTech-Product-Analytics-Retention-Framework-Monetization-Strategy/blob/main/images/RR%20.png))

> 📂 Production SQL Query: [👉 sql/01_rolling_retention_matrix.sql]([sql/01_rolling_retention_matrix.sql](https://github.com/kemasan/EdTech-Product-Analytics-Retention-Framework-Monetization-Strategy/blob/main/sql/01_rolling_retention_matrix.sql))

---

### 2️⃣ Stickiness (DAU / MAU)
* Question: Has the platform become part of daily routine?
* Finding: Stickiness remains in the 6–13% range, indicating that habit formation is weak. The platform is not yet embedded in daily behavior for most users.

![Stickiness Distribution Chart]([images/stickiness_distribution.png](https://github.com/kemasan/EdTech-Product-Analytics-Retention-Framework-Monetization-Strategy/blob/main/images/Stickiness.png))

> 📂 Production SQL Query: [👉 sql/02_stickiness_analysis.sql]([sql/02_stickiness_analysis.sql](https://github.com/kemasan/EdTech-Product-Analytics-Retention-Framework-Monetization-Strategy/blob/main/sql/02_stickiness_analysis.sql))

---

### 3️⃣ Aha-Moment (First 72h Activity)
* Question: Does early success predict retention?
* Finding: Users with >=3 solved tasks in first 72 hours show D30 retention = 33.5%, while users without show D30 retention = 6.3%. Activation is not engagement — it is economic survival inside the product.

![Aha-Moment Retention Comparison](https://github.com/kemasan/EdTech-Product-Analytics-Retention-Framework-Monetization-Strategy/blob/main/images/Aha-moment.png)

> 📂 Production SQL Query: [👉 sql/03_aha_moment_segmentation.sql]([sql/03_aha_moment_segmentation.sql](https://github.com/kemasan/EdTech-Product-Analytics-Retention-Framework-Monetization-Strategy/blob/main/sql/03_aha_moment_segmentation.sql)

---

### 4️⃣ Habit Hypothesis (Week 1 Frequency)
* Question: Is there a behavioral threshold in early usage?
* Finding: 4 active days in Week 1 pushes retention to industry benchmark levels. Habit formation drives monetization potential.
![Behavioral cohort](https://github.com/kemasan/EdTech-Product-Analytics-Retention-Framework-Monetization-Strategy/blob/main/images/habit%20hypothesis.png)

> 📂 Production SQL Query: [👉 sql/04_habit_frequency_split.sql]([sql/04_habit_frequency_split.sql](https://github.com/kemasan/EdTech-Product-Analytics-Retention-Framework-Monetization-Strategy/blob/main/sql/04_habit_frequency_split.sql)

---

### 5️⃣ Cognitive Break-Point
* Question: At which attempt does abandonment overtake success probability?
* Finding: At the 7th attempt, Abandon Rate = Success Rate (1.05%). This marks a psychological break-point where product challenge transforms into toxic frustration.

![Friction Index and Abandon Rate Intersection](https://github.com/kemasan/EdTech-Product-Analytics-Retention-Framework-Monetization-Strategy/blob/main/images/break-point.png)

> 📂 Production SQL Query: [👉 sql/05_frustration_index_modeling.sql]([sql/05_frustration_index_modeling.sql](https://github.com/kemasan/EdTech-Product-Analytics-Retention-Framework-Monetization-Strategy/blob/main/sql/05_frustration_index_modeling.sql)

---

### 6️⃣ Loss Aversion (Stored Value)
* Question: Does accumulated virtual capital affect retention behavior?
* Finding: High-balance users show significantly higher stickiness. Virtual currency creates real behavioral inertia and attachment.

![Stored Value and Stickiness Analysis](images/stored_value_stickiness.png)

> 📂 Production SQL Query: [👉 sql/06_stored_value_analysis.sql]([sql/06_stored_value_analysis.sql](https://github.com/kemasan/EdTech-Product-Analytics-Retention-Framework-Monetization-Strategy/blob/main/sql/06_stored_value_analysis.sql)

---

## 🛠 SQL & Implementation
All SQL queries were built in PostgreSQL and executed via Metabase. The full query set is organized inside a dedicated analytical dashboard: Retention Growth Analysis (Metabase).

**Key components implemented in separate scripts:**
* Cohort retention matrix
* DAU/MAU segmentation
* Frustration modeling
* Activity-based retention splits
* Behavioral segmentation by stored value

---

## 📈 Confirmed Hypotheses
* ✔ Early success (>=3 tasks in 72h) increases D30 retention
* ✔ High cognitive load (FI > 6–8) increases churn risk
* ✔ Higher CodeCoins balance correlates with higher stickiness

❌ Not Confirmed: Small coin balances alone do not significantly improve retention.

---

## 💡 Product Recommendations
1️⃣ Strengthen Aha-Moment
* Guarantee early wins & reduce Day 0–1 cognitive friction
* Visually reinforce progress and simplify onboarding flows

2️⃣ Control Frustration
* Trigger hints after 4 failed attempts & offer alternative solutions
* Detect toxic frustration early before the 7th attempt threshold

3️⃣ Expand Stored Value Mechanics
* Balance interest rewards, status tiers, and streak freeze mechanics
* Deploy soft-loss notifications using behavioral loss aversion frameworks

---

## 🔄 Next Steps
* Focus product optimization on the first 3 days of usage
* Track Time-on-Task and explicitly log soft-fails and hint interactions
* Implement segmentation-based retention interventions
* Run controlled A/B tests for streak and stored-value mechanics

---

## 🧰 Tools & Methods
* Languages & DB: PostgreSQL (Window Functions, Conditional Aggregations)
* Methods: Cohort Analysis, Behavioral Segmentation, Retention Modeling
* BI Architecture: Metabase Dashboard Engineering

---

## 📚 References
* Webengage – EdTech Engagement Strategies
* Moengage – Industry Retention Benchmarks
* Wudpecker – B2B SaaS Retention
* Userpilot – Product-Led Engagement
* iMotions – Behavioral Gamification
* Stripe – Retention vs Churn
* PMC – Programming Education Research
* Market.us – EdTech Statistics (2025)
* Medium – Psychology of Streak Design

---

## 🏁 Portfolio Positioning
This project demonstrates:
* Metric design for subscription models
* Behavioral retention modeling
* Cognitive load impact analysis
* Product analytics thinking
* Business-driven data recommendations
* Strategic LTV optimization
