## --- code knn func
knn_func <- function(df0, pred_data = NULL, classifn, 
                     train_popn_ui=tr_pop, # from UI, slider from 0.1 to 0.9
                     tuneGrid_max= tune_grid,  # from UI, slider from 1 to 50
                     kfoldcv = k_fold)  # from UI, dropdown integers 3 to 10
{
 
  if (classifn == "clf") { 
    if(is.numeric(df0$y)){
      a00 = as.character(paste0('y_', df0$y)) %>% unique(); a00
      a01 = df0$y %>% unique(); a01
      for (i0 in 1:length(a01)){ df0$y[df0$y == a01[i0]] <- a00[i0] }
      df0$y %>% head()
    }
    
    
    metric0 = "ROC"
    
    # trainControl in caret for cross-validn in classifn
    trControl <- trainControl(method = "repeatedcv",
                              number = kfoldcv,
                              repeats = 3,
                              classProbs = TRUE,
                              summaryFunction = twoClassSummary) 
    
  } else { # for regn, below
    
    metric0 = 'Rsquared'
    trControl <- trainControl(method = 'repeatedcv', 
                              number = kfoldcv,   
                              repeats = 3) 
    
    
  }
  
  # Partition Data
  set.seed(222)
  ind <- sample(2, nrow(df0), replace = TRUE, 
                prob = c(train_popn_ui, (1-train_popn_ui)))
  train <- df0[ind==1,]
  test <- df0[ind==2,]
  
  
  # run knn in caret now
  set.seed(222)
  fit <- train(y ~ .,
               data = train,
               method = 'knn',
               trControl = trControl,
               preProc = c("center", "scale"),
               metric = metric0,
               tuneGrid = expand.grid(k = 1:tuneGrid_max))  
  
  
  return(list(fit,test))
  
}
  

