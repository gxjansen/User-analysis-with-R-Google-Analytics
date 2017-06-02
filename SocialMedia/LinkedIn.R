require(Rlinkedin)
in.auth <- inOAuth()

# Download my connections
my.connections <- getMyConnections(in.auth)

# Create Wordcloud
clean.text <- function(some_txt)
{
  some_txt = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", some_txt)
  some_txt = gsub("@\\w+", "", some_txt)
  some_txt = gsub("[[:punct:]]", "", some_txt)
  some_txt = gsub("[[:digit:]]", "", some_txt)
  some_txt = gsub("http\\w+", "", some_txt)
  some_txt = gsub("[ \t]{2,}", "", some_txt)
  some_txt = gsub("^\\s+|\\s+$", "", some_txt)
  some_txt = gsub("amp", "", some_txt)
  # define "tolower error handling" function
  try.tolower = function(x)
  {
    y = NA
    try_error = tryCatch(tolower(x), error=function(e) e)
    if (!inherits(try_error, "error"))
      y = tolower(x)
    return(y)
  }
  
  some_txt = sapply(some_txt, try.tolower)
  some_txt = some_txt[some_txt != ""]
  names(some_txt) = NULL
  return(some_txt)
}
clean_text = clean.text(text)
tweet_corpus = Corpus(VectorSource(clean_text))

tdm = TermDocumentMatrix(tweet_corpus, control = list(removePunctuation = TRUE,stopwords = stopwords("english"), removeNumbers = TRUE, tolower = TRUE))

#install.packages(c("wordcloud","tm"),repos="http://cran.r-project.org")

library(wordcloud)
m = as.matrix(tdm) #we define tdm as matrix
word_freqs = sort(rowSums(m), decreasing=TRUE) #now we get the word orders in decreasing order
dm = data.frame(word=names(word_freqs), freq=word_freqs) #we create our data set
wordcloud(dm$word, dm$freq, random.order=FALSE, colors=brewer.pal(8, "Dark2")) #and we visualize our data
