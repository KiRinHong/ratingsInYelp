install.packages('randomForest')
brunch = readRDS('../data/628_brunch_lv.RDS', refhook = NULL)
head(lv_brunch[,c(1,40)])
colnames(brunch)
lv_brunch = brunch[which(brunch$city=='Las Vegas'),c(1,2,12:60)]
dim(lv_brunch)
colnames(lv_brunch)
length(lv_brunch$business_id)
length(unique(lv_brunch$business_id))
business_id = unique(lv_brunch$business_id)
lv_br_business = data.frame(business_id)
n = length(business_id)
l = NULL
for (i in 1:n){
  l=c(l,which(lv_brunch$business_id == business_id[i])[1])
}
lv_br_business=lv_brunch[l,1:41]
dim(lv_br_business)
lv_br_business$ave_star = "NA"
for (i in 1:n){
  lv_br_business[i,42]=mean(lv_brunch[which(lv_brunch$business_id == business_id[i]),'stars'])
}
lv_br_business
colnames(lv_br_business)

#1. BusinessAcceptBitcoin
which(lv_br_business$BusinessAcceptsBitcoin == TRUE)
#No restaurant accepts Bitcoin
# 3 no 

#2. HappyHour
table(lv_br_business$HappyHour)
which(lv_br_business$HappyHour == "True")
# Only "True" and ""
# 4 yes 2

#3. Corkage
lv_br_business$Corkage
table(lv_br_business$Corkage)
which(lv_br_business$Corkage == TRUE)
#only FALSE and TRUE
# 5 yes 2

#4. Alcohol
lv_br_business[,6]
lv_br_business[which(lv_br_business[,6]=="u'full_bar'"),6]="'full_bar'"
lv_br_business[which(lv_br_business[,6]=="u'beer_and_wine'"),6]="'beer_and_wine'"
lv_br_business[which(lv_br_business[,6]=="u'none'"),6]="'none'"
table(lv_br_business[,6])

#5. NoiseLevel
lv_br_business[,7]
lv_br_business[which(lv_br_business[,7]=="u'average'"),7]="'average'"
lv_br_business[which(lv_br_business[,7]=="u'loud'"),7]="'loud'"
lv_br_business[which(lv_br_business[,7]=="u'quiet'"),7]="'quiet'"
table(lv_br_business[,7])
# average,loud,quiet

#6. RestaurantsPriceRange2
lv_br_business[,8]
table(lv_br_business[,8])
# 1,2,3,4

#7. BusinessAcceptsCreditCards
lv_br_business[,9]
table(lv_br_business[,9])
# true,false

#8. BusinessParking
head(lv_br_business[,10])
table(lv_br_business[,10])
# no too complicated 

#9. RestaurantsReservations
head(lv_br_business[,11])
table(lv_br_business[,11])
# true,flase

#10. ByAppointmentOnly
head(lv_br_business[,12])
table(lv_br_business[,12])
# no cannot analyze

#11. GoodForDancing
head(lv_br_business[,13])
table(lv_br_business[,13])
# true, false
#no

#12. RestaurantsCouterService
head(lv_br_business[,14])
table(lv_br_business[,14])
# no

#13. BikeParking
head(lv_br_business[,15])
table(lv_br_business[,15])
# true,false
# yes

#14. RestaurantsAttire
head(lv_br_business[,16])
table(lv_br_business[,16])
# no so imbalanced

#15. RestaurantsTableService
head(lv_br_business[,17])
table(lv_br_business[,17])
# true, false

#16. BestNights
head(lv_br_business[,18])
table(lv_br_business[,18])
#no too complicated

#17. "DriveThru"                  
head(lv_br_business[,19])
table(lv_br_business[,19])
#no so imbalanced & many ommited

#18. "Ambience"  
head(lv_br_business[,20])
table(lv_br_business[,20])
# no too complicated

#19. "BYOBCorkage"
head(lv_br_business[,21])
table(lv_br_business[,21])
# no so many ommited

#20. "Open24Hours"
head(lv_br_business[,22])
table(lv_br_business[,22])
# no

#21. "AcceptsInsurance"
head(lv_br_business[,23])
table(lv_br_business[,23])
# no

#22. "WiFi"      
head(lv_br_business[,24])
lv_br_business[which(lv_br_business[,24]=="u'free'"),24]="'free'"
lv_br_business[which(lv_br_business[,24]=="u'paid'"),24]="'paid'"
lv_br_business[which(lv_br_business[,24]=="'paid'"),24]="'no'"
lv_br_business[which(lv_br_business[,24]=="u'no'"),24]="'no'"
table(lv_br_business[,24])
# free,no,paid

#23. "RestaurantsTakeOut"
head(lv_br_business[,25])
table(lv_br_business[,25])
# true,false

#24. "OutdoorSeating"  
head(lv_br_business[,26])
table(lv_br_business[,26])
# true, false

#25. "CoatCheck"  
head(lv_br_business[,27])
table(lv_br_business[,27])
# true, false 
# no only one True

#26. "Smoking" 
head(lv_br_business[,28])
table(lv_br_business[,28])
# no many ommited

#27. "HairSpecializesIn"  
head(lv_br_business[,29])
table(lv_br_business[,29])
# no

#28. "RestaurantsGoodForGroups"  
head(lv_br_business[,30])
table(lv_br_business[,30])
# true, false

#29. "AgesAllowed"  
head(lv_br_business[,31])
table(lv_br_business[,31])
# no

#30. "HasTV"      
head(lv_br_business[,32])
table(lv_br_business[,32])
# true, false

#31. "Music"    
head(lv_br_business[,33])
table(lv_br_business[,33])
#no too complicated

#32. "DogsAllowed" 
head(lv_br_business[,34])
table(lv_br_business[,34])
#true,false

#33. "BYOB"   
head(lv_br_business[,35])
table(lv_br_business[,35])
# no Nothing

#34. "DietaryRestrictions"  
head(lv_br_business[,36])
table(lv_br_business[,36])
# no Nothing

#35. "RestaurantsDelivery"  
head(lv_br_business[,37])
table(lv_br_business[,37])
# true,false

#36. "Caters"   
head(lv_br_business[,38])
table(lv_br_business[,38])
# true,false

#37. "GoodForKids"  
head(lv_br_business[,39])
table(lv_br_business[,39])
# true,false

#38. "GoodForMeal"   
head(lv_br_business[,40])
table(lv_br_business[,40])
# no Too complicated

#39. "WheelchairAccessible"   
head(lv_br_business[,41])
table(lv_br_business[,41])
# no too imbalanced

colnames(lv_br_business)
lvbr = lv_br_business[,-c(1,2,3,4,5,9,10,12,13,14,16,18:23,27,28,29,31,33:36,40,41)]
head(lvbr)
dim(lvbr)
colnames(lvbr)


for (i in 1:14) {
  lvbr[which(lvbr[, i]==''),i]='NA'
  lvbr[, i] <- factor(lvbr[, i])
}


attach(lvbr)
ave_star_int = numeric(length(ave_star))
for (i in 1:length(ave_star)){
  if (ave_star[i]<=3) ave_star_int[i] = 'Bad'
  if (3<ave_star[i] & ave_star[i]<=4) ave_star_int[i]='Intermediate'
  if (ave_star[i]>4) ave_star_int[i]='Wonderful'}
table(ave_star_int)



summary(aov(ave_star ~ Alcohol))
#NoiseLevel
summary(aov(ave_star ~ NoiseLevel))
counts = table(ave_star_int,NoiseLevel)
mosaicplot(counts, sort = 2:1, dir="h" , col = c("#857FCD","white"), 
           cex=1.2, xlab = '', ylab = '', main = 'NoiseLevel', las=1)
summary(aov(ave_star ~ RestaurantsPriceRange2))
#RestaurantsReservations
summary(aov(ave_star ~ RestaurantsReservations))
counts = table(ave_star_int,RestaurantsReservations)
mosaicplot(counts, sort = 2:1, dir="h" , col = c("#857FCD","white"), 
           cex=1.2, xlab = '', ylab = '', main = 'RestaurantsReservations', las=1)
summary(aov(ave_star ~ BikeParking))
counts = table(ave_star_int,BikeParking)
mosaicplot(counts, sort = 2:1, dir="h" , col = c("#857FCD","white"), 
           cex=1.2, xlab = '', ylab = '', main = 'BikeParking', las=1)
summary(aov(ave_star ~ RestaurantsTableService))
counts = table(ave_star_int,RestaurantsTableService)
mosaicplot(counts, sort = 2:1, dir="h" , col = c("#857FCD","white"), 
           cex=1.2, xlab = '', ylab = '', main = 'RestaurantsTableService', las=1)
summary(aov(ave_star ~ WiFi))
counts = table(ave_star_int,WiFi)
mosaicplot(counts, sort = 2:1, dir="h" , col = c("#857FCD","white"), 
           cex=1.2, xlab = '', ylab = '', main = 'WiFi', las=1)
summary(aov(ave_star ~ RestaurantsTakeOut))
summary(aov(ave_star ~ OutdoorSeating))
counts = table(ave_star_int,OutdoorSeating)
mosaicplot(counts, sort = 2:1, dir="h" , col = c("#857FCD","white"), 
           cex=1.2, xlab = '', ylab = '', main = 'OutdoorSeating', las=1)
summary(aov(ave_star ~ RestaurantsGoodForGroups))
summary(aov(ave_star ~ HasTV))
counts = table(ave_star_int,HasTV)
mosaicplot(counts, sort = 2:1, dir="h" , col = c("#857FCD","white"), 
           cex=1.2, xlab = '', ylab = '', main = 'HasTV', las=1)
summary(aov(ave_star ~ RestaurantsDelivery))
counts = table(ave_star_int,RestaurantsDelivery)
mosaicplot(counts, sort = 2:1, dir="h" , col = c("#857FCD","white"), 
           cex=1.2, xlab = '', ylab = '', main = 'RestaurantsDelivery', las=1)
summary(aov(ave_star ~ Caters))
counts = table(ave_star_int,Caters)
mosaicplot(counts, sort = 2:1, dir="h" , col = c("#857FCD","white"), 
           cex=1.2, xlab = '', ylab = '', main = 'Caters', las=1)
summary(aov(ave_star ~ GoodForKids))
p = NULL
p = c(p, summary(aov(ave_star ~ Alcohol))[[1]][1,5])
p = c(p, summary(aov(ave_star ~ NoiseLevel))[[1]][1,5])
p = c(p, summary(aov(ave_star ~ RestaurantsPriceRange2))[[1]][1,5])
p = c(p, summary(aov(ave_star ~ RestaurantsReservations))[[1]][1,5])
p = c(p, summary(aov(ave_star ~ BikeParking))[[1]][1,5])
p = c(p, summary(aov(ave_star ~ RestaurantsTableService))[[1]][1,5])
p = c(p, summary(aov(ave_star ~ WiFi))[[1]][1,5])
p = c(p, summary(aov(ave_star ~ RestaurantsTakeOut))[[1]][1,5])
p = c(p, summary(aov(ave_star ~ OutdoorSeating))[[1]][1,5])
p = c(p, summary(aov(ave_star ~ RestaurantsGoodForGroups))[[1]][1,5])
p = c(p, summary(aov(ave_star ~ HasTV))[[1]][1,5])
p = c(p, summary(aov(ave_star ~ RestaurantsDelivery))[[1]][1,5])
p = c(p, summary(aov(ave_star ~ Caters))[[1]][1,5])
p = c(p, summary(aov(ave_star ~ GoodForKids))[[1]][1,5])
p
detach(lvbr)
for (i in 1:14) {
  lvbr[which(lvbr[, i]==''),i]='NA'
  lvbr[, i] <- factor(lvbr[, i])
}
write.csv(lvbr, file = 'lvbr.csv', quote = F, row.names = F)
lvbr_cat <- read.csv('lvbr.csv', header = T, na.strings = c())
colnames(lvbr_cat)
lvbr_final = lvbr_cat[,c(2,4,5,6,9,11:13,15)]
rf <- randomForest(ave_star~., data = lvbr_final)
importance(rf)
