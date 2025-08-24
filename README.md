# 📊 SQL Server EDA & Data Cleaning Project

## 📌 Overview
This project demonstrates **Exploratory Data Analysis (EDA)** and **Data Cleaning** on a laptop dataset stored in **SQL Server**.  
The goal is to analyze raw data, generate insights, and prepare it for further **analytics / machine learning**.

---

## 🛠️ Tools & Technologies
- Microsoft SQL Server  
- SQL Server Management Studio (SSMS)  
- T-SQL (Transact-SQL)

---

## ⚙️ Steps Performed

### 🔍 Exploratory Data Analysis (EDA)

#### 1. Data Preview  
- Show first 10 rows (**Head**)  
- Show last 10 rows (**Tail**)  
- Fetch random 10 rows (**Sample**)  
- Count total rows & columns (Dataset Shape)  

#### 2. Numerical Columns Analysis  
- Compute **8-number summary**:  
  - Count, Min, Max, Mean, Std, Q1, Median, Q3  
- Detect outliers using **IQR method**  
- Bucketize `Price` into ranges (Low, Medium, High, Premium)  

#### 3. Categorical Columns Analysis  
- Count unique values per column  
- Frequency distribution of categories (**value counts**)  
- Handle missing values in categorical fields  
- (Optional) Visualize as pie chart outside SQL  

#### 4. Numerical vs Numerical  
- Side-by-side descriptive statistics  
- Scatterplots (visualized outside SQL)  
- Correlation analysis of numerical fields  

#### 5. Categorical vs Categorical  
- Cross-tabulations (e.g., Company vs OpSys)  
- Distribution comparison  

#### 6. Numerical vs Categorical  
- Compare distributions of numerical features across categories  
  - Example: Average Price per Company  
  - Example: Average Price by Screen Size  

#### 7. Missing Value Treatment  
- Identify NULLs across all columns  
- Impute or drop missing values  
  - Replace missing `Price` with mean / company-wise mean  
  - Standardize Operating Systems  

#### 8. Feature Engineering  
- **PPI (Pixels Per Inch)** from Resolution & Inches  
- **Price Bracket** categories (Low, Medium, High, Premium)  
- Extract **CPU Brand & Model**  
- Extract **GPU Brand & Model**  
- Clean `Memory` column → GB values + type (SSD/HDD/Hybrid)  

#### 9. One-Hot Encoding  
- Generate dummy variables for categorical columns  
  - Example: `is_Dell`, `is_HP`, `is_Lenovo` for Company  

---

## 📂 Project Structure
- `eda_cleaning.sql` → Contains all SQL queries step by step  
- `README.md` → Documentation of the process  

---

## 🚀 How to Run
1. Clone this repository  
2. Open `eda_cleaning.sql` in **SQL Server Management Studio (SSMS)**  
3. Run the queries step by step on your dataset `[dbo].[sql_cx_live_laptops]`  

---

## 📊 Output
- Dataset preview (head, tail, sample)  
- Descriptive statistics of numerical & categorical columns  
- Outlier detection and missing value handling  
- Feature engineered dataset with `ppi`, `price_bracket`, `cpu_brand`, `gpu_brand` etc.  
- One-hot encoded categorical features  
- Final **cleaned & analysis-ready dataset**  

---

✍️ Author: **Vikas Rana**  
📅 Year: 2025
