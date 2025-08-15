# MySQL Data Cleaning Project

This project demonstrates the step-by-step process of cleaning and standardizing a dataset using MySQL.  
The workflow includes removing duplicates, fixing inconsistent formats, handling null values, and preparing the data for analysis.

For the Dataset here is the link :https://www.kaggle.com/datasets/swaptr/layoffs-2022

---

## 📌 Dataset
The dataset used is a layoffs dataset containing company layoff records.  
Columns include:
- `company`
- `location`
- `total_laid_off`
- `date`
- `percentage_laid_off`
- `industry`
- `source`
- `stage`
- `funds_raised`
- `country`
- `date_added`

*(A sample dataset can be provided in CSV/SQL format for testing.)*

---

## 🛠 Steps Performed

### 1. **Removing Duplicates**
- Used `ROW_NUMBER()` with `PARTITION BY` to identify duplicate rows.
- Stored results in a new table to avoid modifying the original dataset.
- Deleted rows where `row_num > 1`.

### 2. **Standardizing Data**
- Removed extra spaces using `TRIM()`.
- Converted date strings to proper `DATE` format using:
  ```sql
  UPDATE table_name
  SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');
