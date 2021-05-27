server <- function(input, output,session) {
  
  tr_data <-  reactive({
    req(input$tr_data$datapath)
    df <- read.csv(input$tr_data$datapath,stringsAsFactors = TRUE)
    return(df)
  })
  
  test_data <-  reactive({
    req(input$test_data$datapath)
    df <- read.csv(input$test_data$datapath,stringsAsFactors = TRUE)
    return(df)
  })
  
  tr_cols <- reactive({
    req(input$tr_data$datapath)
    return(colnames(tr_data()))
  })
  
  
  #----Tab-2 Data Summary----#
  
  output$samp <- DT::renderDataTable({
    req(input$tr_data$datapath)
    DT::datatable(tr_data(),
                  #filter = "top"
                  options = list(lengthMenu = list(c(10,25,50,-1),c("5","25","50","All")),
                                 autoWidth = TRUE),
                  caption = "Table 1: Sample of Data"
    )
  })
  
  output$data_str <- renderPrint({
    str(tr_data())
  })
  
  
  output$y_ui <- renderUI({
    req(input$tr_data$datapath)
    selectInput(inputId = 'sel_y',label = "Select Y (Target Variable)",choices = tr_cols(),multiple = FALSE)
  })
  
  x_col <- reactive({
    req(input$tr_data$datapath)
    x <- match(input$sel_y,tr_cols())
    y_col <- tr_cols()[-x]
    return(y_col)
  })
  
  output$x_ui <- renderUI({
    req(input$tr_data$datapath)
    selectInput(inputId = "sel_x",label="Select X (Features)",choices = x_col(),multiple = TRUE,selected = x_col())
  })
  
  output$pca_plot <- renderPlot({
    req(tr_data())
    if (input$task == "clf"){
      y <- tr_data()[,input$sel_y]
      X <- tr_data()[,input$sel_x]
      pca_plot(y,X)
    }else{
      return(NULL)
    }
   
  })
  
  
  knn_fit <- eventReactive(input$apply, {
    
    y <- tr_data()[,input$sel_y]
    X <- tr_data()[,input$sel_x]
    df0 <- data.frame(y,X)
    #df0 
   fit <- knn_func(df0,
             classifn = input$task, 
             pred_data = NULL,
             train_popn_ui = input$tr_per,
             tuneGrid_max = input$sel_k,
             kfoldcv = input$sel_k_fold
              )
   output$mod_sum <- renderPrint({
     req(fit[[1]])
     cat("\nThe best performing model yields optimal k =", 
         as.numeric(fit[[1]]$bestTune),"\n",
         print(fit[[1]]$preProcess))
   })
   
   pred <- predict(fit[[1]],fit[[2]])
   
   if(input$task=="clf"){
     cnf_mat <- confusionMatrix(as.factor(pred),as.factor(fit[[2]]$y))
     output$conf_test_plot <- renderPlot({
       fourfoldplot(cnf_mat$table,
                    color = c("#CC6666", "#99CC99"),
                    conf.level = 0,
                    main="")
     })
     
     output$conf_test <- renderPrint({
       cnf_mat
     })
     
   }else{
     output$conf_test <- renderPrint({
       cat("\nTest-set RMSE = ", RMSE(pred, fit[[2]]$y),"\n")
     })
     
     output$conf_test_plot <- renderPlot({
       plot(pred ~ fit[[2]]$y,xlab="actual")
       abline(a=0, b=1)
     })
   }
   return(fit)
   })
  
  
  
  output$tr_res <- renderDataTable({
    req(knn_fit())
    knn_fit()[[1]]$results %>% round(2)%>%head(10) # show as HTML table
  })
  # output$conf_train_plot <- renderPlot({
  #   fourfoldplot(data()[[2]]$table,
  #                color = c("#CC6666", "#99CC99"),
  #                conf.level = 0,
  #                main="")
  # })
  # 

  # 
  # output$conf_train <- renderPrint({
  #   data()[[2]]
  # })
  # 
  # output$conf_test <- renderPrint({
  #   data()[[3]]
  # })
  # 
  # #----KNN Plot output tab ------#
  output$knn_plot <- renderPlot({
    req(knn_fit())
    plot(knn_fit()[[1]])
  })
  # 
  # output$roc <- renderPlot({
  #   data()[[4]]
  # })
  # 
  # #-----Var Imp Plot ----#
  # 
  # output$n_tree <- renderPlot({
  #   hist(treesize(data()[[1]]),
  #        main = "No. of Nodes for the Trees",
  #        col = "green",xlab="Tree Size")
  # })
  # 
  # output$var_imp <- renderPlot({
  #   varImpPlot(data()[[1]],
  #              sort = T,
  #              n.var = 10,
  #              main = "Top 10 - Variable Importance")
  # })
  # 
  # output$var_imp_tb <- renderDataTable({
  #   imp_df = data.frame("Features" = rownames(importance(data()[[1]])),
  #                       "MeanDecreaseGini"=round(importance(data()[[1]]),2))
  #   a0 = sort(imp_df$MeanDecreaseGini, decreasing = TRUE, index.return=TRUE)$ix
  #   rownames(imp_df) = NULL
  #   # names(imp_df) <- c("Features","MeanDecreaseGini")
  #   imp_df[a0,]
  #   
  # })
  # 
  # # Prediction Tab----#
  out_pred_df <- reactive({
    req(test_data())
    pred_data <- test_data()[,input$sel_x]
    p3 = predict(knn_fit()[[1]], pred_data)
    out_pred_df = data.frame("prediction" = p3, pred_data)
  })# downloadable file. })

  output$test_op <- renderDataTable({
    req(out_pred_df())
    head(out_pred_df(), 10) # display 10 rows of this as HTML tbl
  })

  output$download_pred <- downloadHandler(
    
    filename = function() { "predictions.csv" },
    content = function(file) {
      write.csv(out_pred_df(), file,row.names=FALSE)
    }
  )
  
}