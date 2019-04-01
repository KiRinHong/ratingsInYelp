#########################  ANOVA analysis of words    ########################
rm(list=ls())

# load package and data
library(MASS) #stepAIC

data=readRDS("../data/628_brunch_lv.RDS")
names(data)[5] <- c("text")
data=data[(!(data$text=="") ),]
word_list <- read.table("../data/select_words.txt")
posiwords <- unlist( strsplit(as.character(word_list[1,]), split=",") )
negawords <- unlist( strsplit(as.character(word_list[2,]), split=",") )


# p-value calculator based on One-way ANOVA
calcWordP <- function(words){
  p_value <- numeric()
  for (i in 1:length(words)){
    var <- rep(0,dim(data)[1])
    var[grep(words[i], data$text)]=1
    res.aov <- aov(data$stars ~ var)
    print(words[i])
    print( summary(res.aov) )
    p_value[i] <- unlist( summary(res.aov)[[1]][5] )[1]
  }
  names(p_value) <- words
  # fdr p-value in case
  p_adj   <- sapply("fdr", function(meth) p.adjust(p_value, meth))
  p_value <- sort(p_value)
  return(p_value)
}


# select significant words based on fdr
p_posi <- calcWordP(posiwords)
p_nega <- calcWordP(negawords)
p_words <- c(p_posi, p_nega)
influence <- c(rep("p",length(p_posi)), rep( "n", length(p_nega) ))
p.adj    <- sapply("fdr", function(meth) p.adjust(p_words, meth))
p_words_adj <- data.frame(p.fdr=as.numeric(p.adj), word=names(p_words))#, influence=influence)
dim(p_words_adj)[1] #33
p_words_adj <- p_words_adj[order(p_words_adj[,"p.fdr"]), ]
p_words_adj <- subset (p_words_adj, p.fdr < 0.005)
dim(p_words_adj)[1] #30

# Merge 30 selected words

words_merge <- c("smile", "rachel|ashley|jovany|jenifer|mike", 
           "dirt|hair|cigarette",
           "minute|hour|takeout",  "refund|credit|policy", 
           "vegan", "hazelnut|chipotle|broth",
           "dry|overcook", "bland|flavorless|tasteless", "burnt",
           "overprice|cost","voucher|advertising")
p_merge <- calcWordP(words_merge)
names_merge <- c(rep("service", 5), rep("food", 5), rep("price",2) )
detail <- c("smile", "name", "hygiene", "wait_time", "payment",
            "vegan","ingredient","cook","taste","burnt","price","promotion")

df_merge <- data.frame(p=as.numeric(p_merge), word=words_merge, types = names_merge, detail=detail )
df_merge <- df_merge[order(df_merge[,"p"]), ]
df_merge
