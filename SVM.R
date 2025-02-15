# Support Vector Machine (SVC)
#D:\Data Set\Social_Network_Ads.cvs



dataset1 = read.csv("D:\\Data Set\\Social_Network_Ads.csv")
dataset = dataset1[3:5]



# Encoding the target feature as factor
dataset$Purchased = factor(dataset$Purchased, levels = c(0, 1))



# Splitting the dataset into the Training set and Test set
library(caTools)
set.seed(123)
split = sample.split(dataset$Purchased, SplitRatio = 0.75)
training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)


# Feature Scaling
training_set[-3] = scale(training_set[-3])
test_set[-3] = scale(test_set[-3])

#e1071-->>offers additional functions and options for fine-tuning 
# Fitting SVM to the Training set
library(e1071)

classifier = svm(formula = Purchased ~ .,
                 data = training_set,
                 type = 'C-classification',
                 gamma= 0.5,#border 
                 kernel = 'radial')


#radial basis function -> gamma
#poly -> degree

#type -> for binary classification
#kernel is RBF

?svm
summary(classifier)
# Predicting the Test set results

y_pred = predict(classifier, newdata = test_set[-3])
y_pred
# Making the Confusion Matrix
cm = table(test_set[, 3], y_pred)
cm
Accuracy=sum(diag(cm)/sum(cm))
Accuracy


# Visualising the Training set results
library('Rfast')
set = training_set
X1 = seq(min(set[, 1]) - 1, max(set[, 1]) + 1, by = 0.01)
X2 = seq(min(set[, 2]) - 1, max(set[, 2]) + 1, by = 0.01)
grid_set = expand.grid(X1, X2)#meshgrid
colnames(grid_set) = c('Age', 'EstimatedSalary')
y_grid = predict(classifier, newdata = grid_set)
plot(set[, -3],
     main = 'SVM (Training set)',
     xlab = 'Age', ylab = 'Estimated Salary',
     xlim = range(X1), ylim = range(X2))
contour(X1, X2, matrix(as.numeric(y_grid), length(X1), length(X2)), add = TRUE)
points(grid_set, pch = '+', col = ifelse(y_grid == 1, 'springgreen3', 'tomato'))
points(set, pch = 21, bg = ifelse(set[, 3] == 1, 'green4', 'red3'))

#as -> converting
#is -> checking
# Visualising the Test set results
library('Rfast')
set = test_set
X1 = seq(min(set[, 1]) - 1, max(set[, 1]) + 1, by = 0.01)
X2 = seq(min(set[, 2]) - 1, max(set[, 2]) + 1, by = 0.01)
grid_set = expand.grid(X1, X2)
colnames(grid_set) = c('Age', 'EstimatedSalary')
y_grid = predict(classifier, newdata = grid_set)
plot(set[, -3], main = 'SVM (Test set)',
     xlab = 'Age', ylab = 'Estimated Salary',
     xlim = range(X1), ylim = range(X2))
contour(X1, X2, matrix(as.numeric(y_grid), length(X1), length(X2)), add = FALSE)
points(grid_set, pch = '_', col = ifelse(y_grid == 1, 'springgreen3', 'tomato'))
points(set, pch = 21, bg = ifelse(set[, 3] == 1, 'green4', 'red3'))











