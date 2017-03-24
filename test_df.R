## Main File
source('topic_model.R')
source('counting.R')
require(stats)
require(dplyr)
require(syuzhet)

## Cleaning of News DataSet
news = read.csv("F:/Analytics/Kaggle/Inter-IIT Tech meet/test.csv",header = T)
news = unique(news)
news = subset(news,!duplicated(news$Title))
news = news[complete.cases(news),]
news = news[order(news$Stock.Name),]

## Topic Modelling
#p = by(news$Title,news$Stock.Name, FUN = function(x) topic_modelling(x)$topics)
#news$title_topic = unname(unlist(p,recursive = FALSE),force = FALSE)

#q = by(news$Text,news$Stock.Name, FUN = function(x) topic_modelling(x)$topics)
#news$text_topic = unname(unlist(q,recursive = FALSE),force = FALSE)

## Sentiment Analysis of Text and Body using three algorithms
news$sent_title_syuzhet = sapply(news$Title, FUN = function(x) get_sentiment(as.character(x), method = "syuzhet", path_to_tagger = NULL))
news$sent_text_syuzhet = sapply(news$Text, FUN = function(x) get_sentiment(as.character(x), method = "syuzhet", path_to_tagger = NULL))

news$sent_title_afinn = sapply(news$Title, FUN = function(x) get_sentiment(as.character(x), method = "afinn", path_to_tagger = NULL))
news$sent_text_afinn = sapply(news$Text, FUN = function(x) get_sentiment(as.character(x), method = "afinn", path_to_tagger = NULL))

news$sent_title_nrc = sapply(news$Title, FUN = function(x) get_sentiment(as.character(x), method = "nrc", path_to_tagger = NULL))
news$sent_text_nrc = sapply(news$Text, FUN = function(x) get_sentiment(as.character(x), method = "nrc", path_to_tagger = NULL))

news$sent_title_bing = sapply(news$Title, FUN = function(x) get_sentiment(as.character(x), method = "bing", path_to_tagger = NULL))
news$sent_text_bing = sapply(news$Text, FUN = function(x) get_sentiment(as.character(x), method = "bing", path_to_tagger = NULL))

## Frequency of occurrence of Company name in Title and Body
news$freq_title = apply(news[,c("Stock.Name","Title")],1, FUN = function(x) as.integer(frequency(x[1],x[2])))
news$freq_text = apply(news[,c("Stock.Name","Text")],1, FUN = function(x) as.integer(frequency(x[1],x[2])))

Test = news[,c(1,2,4,7:16)]