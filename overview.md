#### Overview & Example Datasets

In [statistics](https://en.wikipedia.org/wiki/Statistics), the ***k\*-nearest neighbors algorithm** (***k\*-NN**) is a [non-parametric](https://en.wikipedia.org/wiki/Non-parametric_statistics) [classification](https://en.wikipedia.org/wiki/Classification) method. It is used for [classification](https://en.wikipedia.org/wiki/Statistical_classification) and [regression](https://en.wikipedia.org/wiki/Regression_analysis). In both cases, the input consists of the *k* closest training examples in [data set](https://en.wikipedia.org/wiki/Data_set). The output depends on whether *k*-NN is used for classification or regression:

- In k-NN classification, the output is a class membership. An object is classified by a plurality vote of its neighbors, with the object being assigned to the class most common among its k nearest neighbors (k is a positive integer, typically small). If k = 1, then the object is simply assigned to the class of that single nearest neighbor.

- In k-NN regression, the output is the property value for the object. This value is the average of the values of k nearest neighbors. 

*Source:*  [Wikipedia](https://en.wikipedia.org/wiki/K-nearest_neighbors_algorithm)





------

#### How to use this App

1. Upload training data from sidebar panel
2. Go to kNN Results tab and select Y and X variables from sidebar panel and then select task at hand i.e. classification or regression
3. Select percentage of data required for training model
4. Tune kNN parameter
5. Click on Train model 



Once your model is trained, You may find training results & corresponding plots in RF Results, RF Plots and Variable Importance Tabs.

------

#### Predict new dataset

After training the model you can predict new dataset by uploading it from sidebar panel.

Once your data is uploaded, you can download predicted data from Prediction Output tab.

***Note: Prediction data should contains all the features used while training the model.***

