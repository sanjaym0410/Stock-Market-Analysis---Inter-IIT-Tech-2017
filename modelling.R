## Models constructed and validated on the dataset : 
## Logistic Regression
## Random Forest
## CART Trees
## Neural Network
## Packages used are mentioned below
require(randomForest) 
require(ROCR)
require(nnet) 
require(rpart) 
require(foreach)
require(caret)
require(caTools)

## Load cleaned training Dataset from train_data.RData
load("~/train_data.RData/")

train_new = train_set[,c(4:14)]
train_new$Relevance = as.factor(train_new$Relevance)

set.seed(89)
split = sample.split(final_new$Relevance, SplitRatio = 0.70)

# Create training and validation data sets by splitting the dataset in 1:4 ratio
Train = subset(final_new, split == TRUE)
Test = subset(final_new, split == FALSE)

# Cleaned test and validation dataset loaded
data <- list(train = Train,val = Test)

# Logistic Regression 
logit.fit = glm(Relevance ~., family = binomial(logit),data = data$train) 
logit.preds = predict(logit.fit,newdata=data$val,type="response") 
logit.pred = prediction(logit.preds,data$val$Relevance) 
logit.perf = performance(logit.pred,"rec","spec") 

# Random Forest 
bestmtry <- tuneRF(data$train[-1],data$train$Relevance, ntreeTry=1000, stepFactor=1.5,improve=0.01, trace=TRUE, plot=TRUE, dobest=FALSE)
rf.fit <-randomForest(Relevance~.,data=data$train, mtry=4, ntree=1000, keep.forest=TRUE, importance=TRUE,test=data$val) 
rf.preds = predict(rf.fit,type="prob",newdata=data$val)[,2] 
rf.pred = prediction(rf.preds, data$val$Relevance) 
rf.perf = performance(rf.pred,"rec","spec") 

# CART Trees
mycontrol = rpart.control(cp = 0, xval = 10) 
tree.fit = rpart(Relevance~., method = "class",data = data$train, control = mycontrol) 
tree.fit$cptable
tree.cptarg = sqrt(tree.fit$cptable[6,1]*tree.fit$cptable[5,1]) 
tree.prune = prune(tree.fit,cp=tree.cptarg) 
tree.preds = predict(tree.prune,newdata=data$val,type="prob")[,2] 
tree.pred = prediction(tree.preds,data$val$Relevance) 
tree.perf = performance(tree.pred,"rec","spec") 

# Neural Network 
nnet.fit = nnet(Relevance~., data=data$train,size=30,maxit=10000,decay=.001,MaxNWts = 2000) 
nnet.preds = predict(nnet.fit,newdata=data$val,type="raw") 
nnet.pred = prediction(nnet.preds,data$val$Relevance) 
nnet.perf = performance(nnet.pred,"rec","spec") 

# Plotting Specificity versus Recall curves for all models 
plot(logit.perf,col=2,lwd=2,main="Recall vs Specificty Curve") 
plot(rf.perf,col=3,lwd=2,add=T)
plot(tree.perf,lwd=2,col=4,add=T)
plot(nnet.perf,lwd=2,col=5,add=T)
abline(a=0,b=1,lwd=2,lty=2,col="gray") 
legend("bottomleft",col=c(2:6),lwd=2,legend=c("logit","RF","CART","Neural Net"),bty='n')

# Test Result Prediction
testing = Test[,c(4:13)]
preds.test = predict(rf.fit,newdata=testing,type="response")
Test$Relevance = preds.test
final_test = subset(Test, Test$Relevance == 1)
final_test$Date = format(final_test$Date, format="%d-%m-%Y")
sub_test = subset(final_test,final_test$Date == "23-03-2017" || final_test$Date == "24-03-2017")
sub_test = [,c('url','Title')]
if(dim(sub_test)[1]>10){sub_test = sub_test[c(1:10),]}

write.csv(sub_test,'stock_name.csv',row.names = F)

#confusionMatrix(preds.test,Test$Relevance)
