library(shiny)
library(shinydashboard)
library(randomForest)
library(plotly)
library(ggplot2)
library(dplyr)
library(rsconnect)
library(corrplot)
library(shinyWidgets)
library(DT)


data <- read.csv("new_dataset_student_exam.csv")

data$AvgScore <- rowMeans(data[, c("MathScore",
                                   "ReadingScore",
                                   "WritingScore")])

# Convert character to factor
data <- data %>% mutate(across(where(is.character), as.factor))

# loading the pre-trained model here
rf_model <- readRDS("rf_model.rds")

# ---------------- UI ----------------

ui <- dashboardPage(
  
  dashboardHeader(title = "🎓 Student Performance Dashboard"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Overview", tabName = "overview", icon = icon("dashboard")),
      menuItem("Exploratory Analysis", tabName = "eda", icon = icon("chart-bar")),
      menuItem("Correlation", tabName = "correlation", icon = icon("project-diagram")),
      menuItem("Feature Importance", tabName = "importance", icon = icon("star")),
      menuItem("Prediction", tabName = "prediction", icon = icon("brain"))
    )
  ),
  
  dashboardBody(
    
    tabItems(
      
      # ---------------- OVERVIEW ----------------
      tabItem(tabName = "overview",
              
              fluidRow(
                valueBox(nrow(data), "Total Students", icon = icon("users"), color = "blue"),
                valueBox(round(mean(data$AvgScore), 2), "Average Score", icon = icon("chart-line"), color = "green"),
                valueBox(round(mean(data$MathScore), 2), "Average Math Score", icon = icon("chart-line"), color = "orange"),
                valueBox(round(mean(data$ReadingScore), 2), "Average Reading Score", icon = icon("chart-line"), color = "orange"),
                valueBox(round(mean(data$WritingScore), 2), "Average Writing Score", icon = icon("chart-line"), color = "orange"),
                valueBox(round(sd(data$AvgScore), 2), "Score Std Dev", icon = icon("calculator"), color = "yellow")
              )
      ),
      
      # ---------------- EDA ----------------
      tabItem(tabName = "eda",
              
              fluidRow(
                box(width = 4,
                    selectInput("subject", "Select Score:",
                                choices = c("MathScore",
                                            "ReadingScore",
                                            "WritingScore",
                                            "AvgScore")),
                    
                    selectInput("factor", "Compare By:",
                                choices = c("ParentEduc",
                                            "WklyStudyHours",
                                            "TestPrep",
                                            "LunchType",
                                            "EthnicGroup",
                                            "NrSiblings"))
                ),
                
                box(width = 8,
                    plotlyOutput("boxPlot"))
              )
      ),
      
      # ---------------- CORRELATION ----------------
      tabItem(tabName = "correlation",
              box(width = 12,
                  plotOutput("corPlot"))
      ),
      
      # ---------------- FEATURE IMPORTANCE ----------------
      tabItem(tabName = "importance",
              box(width = 12,
                  plotOutput("importancePlot"))
      ),
      
      # ---------------- PREDICTION ----------------
      tabItem(tabName = "prediction",
              
              fluidRow(
                box(width = 4,
                    
                    selectInput("parent", "Parental Education",
                                choices = unique(data$ParentEduc)),
                    
                    selectInput("hours", "Weekly Study Hours",
                                choices = unique(data$WklyStudyHours)),
                    
                    selectInput("prep", "Test Preparation",
                                choices = unique(data$TestPrep)),
                    
                    selectInput("lunch", "Lunch Type",
                                choices = unique(data$LunchType)),
                    
                    selectInput("sport", "Practice Sport",
                                choices = unique(data$PracticeSport)),
                    
                    selectInput("ethnic", "Ethnic Group",
                                choices = unique(data$EthnicGroup)),
                    
                    numericInput("siblings", "Number of Siblings",
                                 value = 1, min = 0, max = 7),
                    
                    actionButton("predictBtn", "Predict Score",
                                 class = "btn-success")
                ),
                
                box(width = 8,
                    h3("Predicted Average Score"),
                    h1(textOutput("prediction")))
              )
      )
    )
  )
)

# ---------------- SERVER ----------------

server <- function(input, output) {
  
  # Interactive Boxplot
  output$boxPlot <- renderPlotly({
    
    p <- ggplot(data,
                aes_string(x = input$factor,
                           y = input$subject)) +
      geom_boxplot(fill = "#2C3E50") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
    
    ggplotly(p)
  })
  
  # Correlation Plot
  output$corPlot <- renderPlot({
    
    cor_data <- cor(data[, c("MathScore",
                             "ReadingScore",
                             "WritingScore")])
    
    corrplot(cor_data,
             method = "color",
             addCoef.col = "black",
             tl.col = "black")
  })
  
  # Feature Importance
  output$importancePlot <- renderPlot({
    
    importance_df <- as.data.frame(importance(rf_model))
    importance_df$Feature <- rownames(importance_df)
    
    ggplot(importance_df,
           aes(x = reorder(Feature, IncNodePurity),
               y = IncNodePurity)) +
      geom_col(fill = "#1ABC9C") +
      coord_flip() +
      theme_minimal() +
      labs(title = "Feature Importance (Random Forest)",
           x = "",
           y = "Importance")
  })
  
  # Prediction
  observeEvent(input$predictBtn, {
    
    req(input$parent,
        input$hours,
        input$prep,
        input$lunch,
        input$sport,
        input$ethnic,
        input$siblings)
    
    new_student <- data.frame(
      ParentEduc = factor(input$parent, levels = levels(data$ParentEduc)),
      WklyStudyHours = factor(input$hours, levels = levels(data$WklyStudyHours)),
      TestPrep = factor(input$prep, levels = levels(data$TestPrep)),
      LunchType = factor(input$lunch, levels = levels(data$LunchType)),
      PracticeSport = factor(input$sport, levels = levels(data$PracticeSport)),
      EthnicGroup = factor(input$ethnic, levels = levels(data$EthnicGroup)),
      NrSiblings = as.numeric(input$siblings)
    )
    
    pred <- predict(rf_model, new_student)
    
    output$prediction <- renderText({
      paste("Predicted Score:", round(pred, 2))
    })
  })
}

shinyApp(ui, server)
