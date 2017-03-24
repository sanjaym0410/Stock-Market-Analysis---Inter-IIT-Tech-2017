## Function for topic modelling
topic_modelling<- function(sdk){
    ## Packages used are mentioned below
    require("topicmodels")
    require("grid")
    require("plyr")
    require("lda")
    require("tm")
    print(length(sdk))
    CorpusObj<- VectorSource(sdk);
    txt<-Corpus(CorpusObj);
    myCorpus <- tm_map(txt, tolower)
    myCorpus <- tm_map(myCorpus, removePunctuation)
    myCorpus <- tm_map(myCorpus, removeNumbers)
    myCorpus <- tm_map(myCorpus, removeWords, stopwords('en'))
    myCorpus <- tm_map(myCorpus, stemDocument)
    myCorpus <- tm_map(myCorpus, stripWhitespace)
    myCorpus <- tm_map(myCorpus, PlainTextDocument)
    myTdm <- TermDocumentMatrix(myCorpus, control = list(wordLengths=c(1,Inf)))
    rowTotals <- apply(myTdm , 1, sum)
    #print(rowTotals)
    CorpusObj.tdm = myTdm[rowTotals> 0, ]
    #Set parameters for Gibbs sampling
    burnin <- 4000
    iter <- 2000
    thin <- 500
    seed <-list(2,100,6,100,76)
    nstart <- 5
    best <- TRUE
    
    #Number of topics
    k <- 5    
    CorpusObj.tdm = t(CorpusObj.tdm)
    
    #Run LDA using Gibbs sampling
    ldaOut <-LDA(CorpusObj.tdm,k, method='Gibbs', control=list(nstart=nstart, seed = seed, best=best, burnin = burnin, iter = iter, thin=thin))

    #write out results i.e. docs to topics 
    ldaOut.topics <- as.matrix(topics(ldaOut))
    
    #top 20 most frequent terms in each topic
    ldaOut.terms <- as.matrix(terms(ldaOut,20))
    
    #probabilities associated with each topic assignment
    topicProbabilities <- as.data.frame(ldaOut@gamma)
    print('dispatching')
    list(topics = ldaOut.topics, terms = ldaOut.terms, prob = topicProbabilities)
}