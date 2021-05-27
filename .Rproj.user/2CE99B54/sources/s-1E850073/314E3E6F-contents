shinyUI(fluidPage(
  
  title = "K-Nearest Neighbour",
  titlePanel(title=div(img(src="logo.png",align='right'),"K-Nearest Neighbour")),
  sidebarPanel(
    source("scripts//uiInput.R",local = TRUE)[[1]], 
    conditionalPanel(condition = "input.tabselected==2",
                     
    ),
    conditionalPanel(condition="input.tabselected==3",
                     uiOutput("y_ui"),
                     uiOutput("x_ui"),
                     radioButtons("task","Select task",
                                  choices = c("Classification" = 'clf',
                                              "Regression" = "reg")),
                     sliderInput("tr_per",
                                 label = "Select training data proportion",
                                 min = 0,
                                 max = 1,
                                 value = 0.7,
                                 step = 0.05),
                     sliderInput("sel_k",
                                 label = "Select K-Nearest Neighbours", # Tune grid
                                 min = 1,
                                 max = 50,
                                 value = 5,
                                 step = 1),
                     sliderInput("sel_k_fold",
                                 label = "Select Number of CV folds",
                                 min =1 ,
                                 max = 10,
                                 value = 3,
                                 step = 2),
                     actionButton("apply","Train model")
    )
    
  ),
  mainPanel(
    # recommend review the syntax for tabsetPanel() & tabPanel() for better understanding
    # id argument is important in the tabsetPanel()
    # value argument is important in the tabPanle()
    tabsetPanel(
      tabPanel("Overview & Example Dataset", value=1, 
               includeMarkdown("overview.md")
      ),
      tabPanel("Data Summary", value=3,
               DT::dataTableOutput("samp"),
               hr(),
               h4("Data Structure"),
               verbatimTextOutput("data_str"),
               h4("PCA Plot"),
               plotOutput("pca_plot")
      ),
      tabPanel("kNN Results", value=3,
               h4("Training Summary"),
               verbatimTextOutput("mod_sum"),
               hr(),
               dataTableOutput('tr_res'),
               hr(),
              # h4("Confusion Matrix (Train Set)"),
               #plotOutput('conf_train_plot'),
               #HTML('<button data-toggle="collapse" data-target="#demo">Detailed Result</button>'),
               # tags$div(id="demo",class="collapse",),
               #verbatimTextOutput("conf_train"),
               hr(),
               h4("Model performance on validation set"),
               # HTML('<button data-toggle="collapse" data-target="#demo1">Detailed Result</button>'),
               verbatimTextOutput("conf_test")
               #tags$div(id="demo1",class="collapse",)
               
      ),
      tabPanel("kNN Plots",value=3,
               h4("Model accuracy vs Different K-Values"),
               plotOutput("knn_plot"),
               h4("Performance on validation set"),
               plotOutput('conf_test_plot')
               
      ),
      # tabPanel("Variable Importance",value=3,
      #          h4("No of nodes in trees"),
      #          plotOutput("n_tree"),
      #          h4("Variable Importance"),
      #          plotOutput("var_imp"),
      #          dataTableOutput("var_imp_tb")
      # ),
      tabPanel("Prediction Output",value=3,
               helpText("Note: Please upload test data with same features in train dataset"),
               dataTableOutput("test_op"),
               downloadButton("download_pred")
               
      ),
      id = "tabselected"
    )
  )
))