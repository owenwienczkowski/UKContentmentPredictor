# UK Resident Contentment Predictor

This project aims to identify which community factors have the greatest impact on overall satisfaction among local areas in England, focusing on actionable insights for County Durham. By combining descriptive statistics and a multivariate linear regression model, we uncover how different variables—like a sense of belonging, community cohesion, influence on decisions, and perceptions of drug-related issues—affect residents’ satisfaction levels.

---

## 1. Background & Objectives

Data comes from the UK governmental website ([data.gov.uk](https://data.gov.uk/)), covering 353 local areas in England. Respondents in each area answered five yes/no questions:

1. **Influence Decisions:** “Do you feel able to influence decisions made in your local area?”  
2. **Get On Well:** “Do you believe people from different backgrounds get on well together in your local area?”  
3. **Belong:** “Do you feel you belong to your neighbourhood?”  
4. **Drug Use and Selling:** “Do you consider drug use and/or drug selling to be a problem in the local area?”  
5. **Overall Satisfaction:** “Overall, are you satisfied living in your local area?”

Local officials in County Durham aim to improve their Overall Satisfaction score (#5). Our goal is to determine which factors (questions 1–4) have the strongest impact on question #5, providing priority areas for policy interventions.

---

## 2. Data Description

- **File:** `UKContentment.csv`  
- **Scope:** 353 local areas in England  
- **Columns:**  
  - **Authority** (character) – Unique identifier for each local area  
  - **Influence_Decisions** (numeric) – % answering “yes”  
  - **Get_On_Well** (numeric) – % answering “yes”  
  - **Belong** (numeric) – % answering “yes”  
  - **Drug_Use_And_Selling** (numeric) – % answering “yes”  
  - **Area** (character) – Broader region within England  
  - **Overall** (numeric) – % satisfied with living in the local area

We excluded **Authority** and **Area** from the regression model because they are non-numerical and do not directly influence Overall satisfaction. Exploratory Data Analysis (EDA) showed no null values. Some outliers appeared in each numeric column, but all seemed plausible for real-world data, so none were removed. The dataset was also **randomized** to reduce the risk of autocorrelation based on alphabetical or regional ordering.

---

## 3. Statistical Methodology

### 3.1 Data Processing
1. **Import & EDA:** The data was imported into RStudio. Basic statistics and boxplots identified the distribution of values and potential outliers.  
2. **Outlier Decision:** While outliers existed for variables like *Influence_Decisions* and *Get_On_Well*, no extreme anomalies or erroneous data were found, so no removal was done.  
3. **Randomization:** We randomized row order using a random seed to prevent any sequential bias by **Authority** or **Area**.

### 3.2 Model Selection
- We used the **“leaps”** package in R for an exhaustive search of predictors.  
- The best-performing model (highest adjusted R², valid regression assumptions) included the following predictors for **Overall**:  
  - **Influence_Decisions**  
  - **Get_On_Well**  
  - **Belong**  
  - **Drug_Use_And_Selling**

This combination yielded an **adjusted R² of 0.8475**, indicating that **84.75%** of the variance in Overall satisfaction is explained by these four variables.

### 3.3 Model Equation

Overall = 42.34256 + (0.07945 * Influence_Decisions) + (0.37324 * Get_On_Well) + (0.30559 * Belong) - (0.36784 * Drug_Use_And_Selling)

The model’s p-value is less than 2.2e-16, signifying strong statistical significance.

### 3.4 Residual Diagnostics
To validate the **five assumptions** of multiple linear regression:

1. **Linearity & Homoscedasticity**  
   - Residuals vs. fitted plots show a random scatter, suggesting a linear relationship and constant variance.  
2. **Independence of Observations**  
   - A Durbin-Watson test returned p-values around 0.044–0.15 (depending on the random seed), indicating no significant autocorrelation.  
3. **Normality of Residuals**  
   - Q-Q plots show the residuals closely follow a normal distribution.  
4. **No Multicollinearity**  
   - Variance Inflation Factor (VIF) values for all predictors were below 5 (max ~2.156892).  

Since all assumptions appear to hold, the model’s predictions are reliable for inference and policy decisions.

---

## 4. Key Findings

- **Strong Model Fit:** The final model explains **84.75%** of Overall satisfaction.  
- **Most Influential Factors:**  
  - **Get_On_Well** shows the largest positive coefficient (+0.37324).  
  - **Drug_Use_And_Selling** is the second-largest factor but negatively impacts satisfaction (-0.36784).  
  - **Belong** also has a substantial positive influence (+0.30559).  
  - **Influence_Decisions** has a smaller positive impact (+0.07945).  
- **Baseline Satisfaction:** The intercept of ~42.34% suggests a starting point before adding each factor’s effect.

### County Durham Focus
A secondary model used only North East region data (eight entries). That model explained **51.23%** of the variance in Overall, with **Influence_Decisions** emerging as the most significant predictor in the subset. However, the small sample size means we recommend collecting more granular data for a robust region-specific analysis.

---

## 5. Recommendations

To improve local satisfaction—particularly in County Durham—prioritize the following:

1. **Enhance Community Cohesion (Get_On_Well)**  
   - Organize events for community interaction and understanding.  
   - Support anti-discrimination workshops and social programs promoting inclusivity.  
2. **Address Drug-Related Issues (Drug_Use_And_Selling)**  
   - Provide community-wide drug education and prevention initiatives.  
   - Enable safe, anonymous reporting channels.  
   - Expand addiction recovery services.  
3. **Encourage Resident Involvement (Influence_Decisions)**  
   - Host regular town halls or online surveys to gather feedback.  
   - Develop digital platforms (e.g., apps, portals) for local decision-making input.  

While **Influence_Decisions** shows the smallest effect across England as a whole, the North East subset indicates it may be more critical for County Durham. Hence, this factor shouldn’t be overlooked.

---

## 6. Limitations

1. **Time Dimension**  
   The dataset covers only a single time period. Longitudinal data (e.g., 5–10 years) could reveal trends and changes in satisfaction factors over time.  

2. **Demographic Gaps**  
   No age, gender, ethnicity, or income data is available. These insights could refine the model for targeted interventions.  

3. **Limited Regional Sample**  
   Only eight data points from the North East. A more detailed, granular dataset could yield stronger region-specific models and recommendations.

---

## 7. Future Work

- **Longitudinal Analysis:** Gather multi-year data to observe trends in satisfaction drivers.  
- **Demographic Enhancements:** Collect additional demographic features for more nuanced policy targeting.  
- **Deeper Regional Studies:** Expand data in County Durham (and the North East) to build robust, localized models.

---

**Final Note**  
This project confirms that fostering social cohesion, reducing drug-related issues, and improving residents’ influence in local decision-making can substantially boost community satisfaction in England. With more extensive datasets—both temporally and demographically—further refinement of these models could lead to even more impactful, data-driven recommendations for local governance.
