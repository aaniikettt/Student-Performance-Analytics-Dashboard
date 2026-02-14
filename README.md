# 🎓 Student Performance Analytics Dashboard

An interactive Machine Learning dashboard built with **R Shiny** to analyze and predict student exam performance using socio-economic and behavioral factors.

🔗 **Live App:** https://aaniikett.shinyapps.io/exam_study

📁 **Tech Stack:** R | Shiny | Random Forest | Plotly | shinydashboard | shinyapps.io  

---

## 📌 Project Overview

This project explores how socio-economic and lifestyle factors influence student academic performance.

The application provides:

- 📊 Interactive exploratory data analysis
- 📈 Correlation analysis between subjects
- 🌳 Random Forest regression model
- ⭐ Feature importance visualization
- 🔮 Real-time score prediction engine

The dataset contains **30,000+ student records** with demographic, educational, and behavioral features.

---

## 🧠 Problem Statement

Can we predict a student's academic performance using socio-economic background and study behavior?

Understanding these drivers can help:
- Identify at-risk students
- Guide targeted interventions
- Inform policy-level decisions
- Improve educational planning

---

## 📂 Dataset Features

Key predictors include:

- ParentEduc (Parental Education Level)
- WklyStudyHours
- TestPrep
- LunchType
- PracticeSport
- EthnicGroup
- NrSiblings

Target variable:

- Average Score (mean of Math, Reading, Writing)

---

## 🔬 Machine Learning Approach

### Model Used:
**Random Forest Regression**

Why Random Forest?

- Handles categorical variables well
- Captures nonlinear relationships
- Robust to outliers
- Provides feature importance

### Training Strategy:
- Preprocessing: Factor conversion for categorical features
- Feature engineering: Created AvgScore
- Model trained offline
- Saved as `.rds` for production efficiency

---

## 📊 Key Insights

- Parental education has strong predictive power
- Weekly study hours significantly influence performance
- Reading and Writing scores are highly correlated (0.95+)
- Test preparation shows measurable performance uplift

---

## 🖥 Application Features

### 1️⃣ Overview Dashboard
- Total students
- Subject averages
- Score variability

### 2️⃣ Exploratory Analysis
- Interactive boxplots
- Dynamic feature comparison
- Plotly-based visualization

### 3️⃣ Correlation Matrix
- Visual subject relationships

### 4️⃣ Feature Importance
- Random Forest importance ranking

### 5️⃣ Prediction Engine
- User inputs demographic & study factors
- Real-time predicted average score

---

## ⚙️ Tech Stack

- **R**
- **Shiny**
- **shinydashboard**
- **randomForest**
- **plotly**
- **corrplot**
- **DT**
- **shinyapps.io (Deployment)**

---

## 🚀 Deployment Architecture

The model is trained locally and saved as:

```r
saveRDS(rf_model, "rf_model.rds")
```
In Producion:

```r
rf_model <- readRDS("rf_model.rds")
```
This prevents memory spikes and improves startup performance.

# Install required packages
```r
install.packages(c(
  "shiny",
  "shinydashboard",
  "randomForest",
  "plotly",
  "corrplot",
  "DT",
  "dplyr"
))
```

# Run app
```r
shiny::runApp()
```
📈 Future Improvements

1. Add SHAP-style explanation for predictions
2. Add partial dependence plots
3. Compare with Linear Regression model
4. Add user authentication
5. Dockerize deployment
6. Add automated model retraining

👤 Author
Aniket
MS in Data Analytics


