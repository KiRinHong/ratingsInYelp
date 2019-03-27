########
rm(list=ls())

library(ggplot2)
library(grid)
library(stringr)  #str_count()

# data <- read.csv("628_brunch_lv.csv")
data=readRDS("../data/628_brunch_lv.RDS")
names(data)[5] <- c("text")
data=data[(!(data$text=="") ),]

#####   LV contain many data  ######
LVProportionPlot <- function(textcex=1){
  counts <- table(data$city)
  city_index=order(counts, decreasing = T)
  counts=counts[city_index]
  c <- data.frame(city=names(counts), count=as.numeric(counts))
  
  city_names <- c("Las Vegas", "Other 332 Cities")
  review_counts <- c(169529, 521672-169529)
  bussness_counts <- c(448, 4322-448)
  par(mfrow=c(1,2))
  
  par(mgp = c(0, 0.5, 0), mar=c(1,2,1,2), mfrow=c(1,2))
  pie(review_counts, labels = c("",""), 
      xlab = '', ylab = '', main = '',  col = c("#C7C3F2","white"))
  text(0.3,0.35, paste(sep="\n","Las Vegas","32.5%"), col="dark blue", cex=textcex)
  text(-0.1,-0.35,paste(sep="\n","Other 332 Cities","67.5%"), col="dark blue", cex=textcex) 
  
  pie(bussness_counts, labels = c("",""), 
      xlab = '', ylab = '', main = '',  col = c("#C7C3F2","white"))
  text(0.52,0.12, paste(sep="\n","Las Vegas","10.4%"), col="dark blue", cex=textcex)
  text(-0.1,-0.35,paste(sep="\n","Other 332 Cities","90.6%"), col="dark blue", cex=textcex)  
}

####   Averge StarPlot dist ####
starsPlot <- function(){
  counts <- table(data$stars)
  cp <- ggplot(data = data, aes(x = stars)) + 
    geom_bar(width=.7, 
             fill="blue4", 
             aes(y = (..count..)/dim(data)[1]*100), 
             alpha=.5) + 
    labs(title="Original Star Dist.", 
      subtitle="For All Brunch & Breakfast Restaurants in Las Vegas.", #subtitle/caption
      x = "Star",
      y = "Star %") + 
    theme(axis.text.x = element_text(size=13, angle=0, vjust=0.6, face="bold"), 
          axis.text.y = element_text(size=12, face="bold"),
          title = element_text(size=14),
          panel.background = element_rect(fill = "white", colour = "grey50"),
          panel.grid = element_blank())
  
  return(cp)
}
#####     plotWordStar    ####
wordStarPlot <- function(ninewords=c("coffee", "alcohol",   "water", "benedict|burrito","bell pepper|onion", "fries|chips"), ylimit=0.5){
  plotSingleWordStar <-  function(word, ylimit=0.6){
    data_subset=data[grep(word, data$text),]
    star_mean=signif( mean(data_subset$stars), 3)
    starcounts <- table(data_subset$stars)
    pi <- ggplot(data = data_subset, aes(x = stars)) + 
      geom_bar(width=.7, 
               fill="blue4", 
               aes(y = (..count..)/dim(data_subset)[1]), 
               alpha=.5) + 
      ylim(0,ylimit) +
      geom_text(stat="count", aes(label=..count..), vjust=0)+
      labs(title= paste(sep="","\"", word, "\": ",star_mean), 
           x = "Stars", 
           y = "Star Ratio") + 
      theme(title = element_text(size=12),
            panel.background = element_rect(fill = "white", colour = "grey50"),
            panel.grid = element_blank())
    return(pi)
  }
  p1 <- plotSingleWordStar(ninewords[1], ylimit)
  p2 <- plotSingleWordStar(ninewords[2], ylimit)
  p3 <- plotSingleWordStar(ninewords[3], ylimit)
  
  p4 <- plotSingleWordStar(ninewords[4], ylimit)
  p5 <- plotSingleWordStar(ninewords[5], ylimit)
  p6 <- plotSingleWordStar(ninewords[6], ylimit)
  grid.newpage()
  pushViewport(viewport(layout = grid.layout(2,3)))
  print(p1, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))
  print(p2, vp = viewport(layout.pos.row = 1, layout.pos.col = 2))
  print(p3, vp = viewport(layout.pos.row = 1, layout.pos.col = 3))
  print(p4, vp = viewport(layout.pos.row = 2, layout.pos.col = 1))
  print(p5, vp = viewport(layout.pos.row = 2, layout.pos.col = 2))
  print(p6, vp = viewport(layout.pos.row = 2, layout.pos.col = 3))
}
####  plotAdjectiveDist   ####
adjPlot <- function(data=data, word){
  singlePlot <- function(data, word = word, title) {
    p<-ggplot(data = data, aes(x = stars)) + 
      geom_bar(width=.7, 
               fill="blue4", 
               aes(y = (..count..)/dim(data)[1]), 
               alpha=.5) + 
      ylim(0,0.5) +
      labs(x = paste(sep="","",  title, ""),
           y="Star Ratio") + 
      theme(text = element_text(size=18),
            title = element_text(size=17),
            panel.background = element_rect(fill = "white", colour = "grey50"),
            panel.grid = element_blank())
    return(p)
  }
  bus_yes <- unique( data$business_id[grep(word, data$text)] )
  index <- which( data$business_id %in% bus_yes )
  data_yes <- data[index,]
  data_no <- data[-index,]
  p1 <- singlePlot(data_yes, word, title=paste(sep="", "a). Have \"", word, "\" Item"))
  p2 <- singlePlot(data_no, word, title=paste(sep="","b). No \"", word, "\" Item"))
  grid.newpage()
  pushViewport(viewport(layout = grid.layout(1,2)))
  print(p1, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))
  print(p2, vp = viewport(layout.pos.row = 1, layout.pos.col = 2))
}
#### Mosaicplots for Attributes ####
plotAttrMosaic <- function(variable=data$BikeParking){
  index=which(variable=="")
  if (length(index > 0)){
    data_subset=data[-index,]
    variable=variable[-index]
  } else {
    data_subset=data
  }
  counts <- table(data_subset$stars, variable)
  mosaicplot(counts, sort = 2:1, dir="h" , col = c("#857FCD","white"), 
             cex=1.2, xlab = '', ylab = '', main = '', las=1)
}

####    Call Plot Functions   ####
LVProportionPlot()
starsPlot()
wordStarPlot()
adjPlot(data, "homemade")  # "special" adjPlot(data, "house-made")  adjPlot(data, "feature")  adjPlot(data, "buffet")
plotAttrMosaic(variable=data$HappyHour)
plotAttrMosaic(variable=data$HasTV)
plotAttrMosaic(variable=data$BikeParking)
plotAttrMosaic(variable=data$OutdoorSeating)


