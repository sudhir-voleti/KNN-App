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

pca_plot <- function(y,X){
  
  y = y; X = X
  
  if (is.numeric(y)){y = as.character(paste0('y_', y))}
  X_num <- X %>% dplyr::select(where(is.numeric))
  #a0 = apply(X, 2, function(x) {is.numeric(x)}) %>% which(.) %>% as.numeric(); a0
  a1 = princomp(X_num, cor=TRUE)$scores[,1:2]
  a2 = data.frame(y=y, x1=a1[,1], x2=a1[,2])
  
  p <- ggplot(data=a2, aes(x=x1, y=x2, colour = factor(y))) + 
    geom_point(size = 4, shape = 19, alpha = 0.6) + 
    xlab("PCA compt1") + ylab("PCA compt 2")
  
  plot(p)  } # func ends

