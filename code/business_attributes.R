brunch = readRDS('628data_brunch_merge.RDS', refhook = NULL)
head(lv_brunch[,c(1,40)])
colnames(brunch)
lv_brunch = brunch[which(brunch$city=='Las Vegas'),c(1,2,12:60)]
dim(lv_brunch)
colnames(lv_brunch)

#1. BusinessAcceptBitcoin
which(lv_brunch$BusinessAcceptsBitcoin == TRUE)
#No restaurant accepts Bitcoin
# 3 no 

#2. HappyHour
lv_brunch$HappyHour
table(lv_brunch$HappyHour)
which(lv_brunch$HappyHour == "True")
# Only "True" and ""
# 4 yes 2

#3. Corkage
lv_brunch$Corkage
table(lv_brunch$Corkage)
which(lv_brunch$Corkage == TRUE)
#only FALSE and TRUE
# 5 yes 2

#4. Alcohol
lv_brunch[,6]
lv_brunch[which(lv_brunch[,6]=="u'full_bar'"),6]="'full_bar'"
lv_brunch[which(lv_brunch[,6]=="u'beer_and_wine'"),6]="'beer_and_wine'"
lv_brunch[which(lv_brunch[,6]=="u'none'"),6]="'none'"
table(lv_brunch[,6])

#5. NoiseLevel
lv_brunch[,7]
lv_brunch[which(lv_brunch[,7]=="u'average'"),7]="'average'"
lv_brunch[which(lv_brunch[,7]=="u'loud'"),7]="'loud'"
lv_brunch[which(lv_brunch[,7]=="u'quiet'"),7]="'quiet'"
table(lv_brunch[,7])
# average,loud,quiet

#6. RestaurantsPriceRange2
lv_brunch[,8]
table(lv_brunch[,8])
# 1,2,3,4

#7. BusinessAcceptsCreditCards
lv_brunch[,9]
table(lv_brunch[,9])
# true,false

#8. BusinessParking
head(lv_brunch[,10])
table(lv_brunch[,10])
# no too complicated 

#9. RestaurantsReservations
head(lv_brunch[,11])
table(lv_brunch[,11])
# true,flase

#10. ByAppointmentOnly
head(lv_brunch[,12])
table(lv_brunch[,12])
# no cannot analyze

#11. GoodForDancing
head(lv_brunch[,13])
table(lv_brunch[,13])
# true, false

#12. RestaurantsCouterService
head(lv_brunch[,14])
table(lv_brunch[,14])
# no

#13. BikeParking
head(lv_brunch[,15])
table(lv_brunch[,15])
# true,false
# yes

#14. RestaurantsAttire
head(lv_brunch[,16])
table(lv_brunch[,16])
# no so imbalanced

#15. RestaurantsTableService
head(lv_brunch[,17])
table(lv_brunch[,17])
# true, false

#16. BestNights
head(lv_brunch[,18])
table(lv_brunch[,18])
#no too complicated

#17. "DriveThru"                  
head(lv_brunch[,19])
table(lv_brunch[,19])
#no so imbalanced

#18. "Ambience"  
head(lv_brunch[,20])
table(lv_brunch[,20])
# no too complicated

#19. "BYOBCorkage"
head(lv_brunch[,21])
table(lv_brunch[,21])
# three levels

#20. "Open24Hours"
head(lv_brunch[,22])
table(lv_brunch[,22])
# no

#21. "AcceptsInsurance"
head(lv_brunch[,23])
table(lv_brunch[,23])
# no

#22. "WiFi"      
head(lv_brunch[,24])
lv_brunch[which(lv_brunch[,24]=="u'free'"),24]="'free'"
lv_brunch[which(lv_brunch[,24]=="u'paid'"),24]="'paid'"
lv_brunch[which(lv_brunch[,24]=="u'no'"),24]="'no'"
table(lv_brunch[,24])
# free,no,paid

#23. "RestaurantsTakeOut"
head(lv_brunch[,25])
table(lv_brunch[,25])
# true,false

#24. "OutdoorSeating"  
head(lv_brunch[,26])
table(lv_brunch[,26])
# true, false

#25. "CoatCheck"  
head(lv_brunch[,27])
table(lv_brunch[,27])
# true, false

#26. "Smoking" 
head(lv_brunch[,28])
table(lv_brunch[,28])
# no

#27. "HairSpecializesIn"  
head(lv_brunch[,29])
table(lv_brunch[,29])
# no

#28. "RestaurantsGoodForGroups"  
head(lv_brunch[,30])
table(lv_brunch[,30])
# true, false

#29. "AgesAllowed"  
head(lv_brunch[,31])
table(lv_brunch[,31])
# no

#30. "HasTV"      
head(lv_brunch[,32])
table(lv_brunch[,32])
# true, false

#31. "Music"    
head(lv_brunch[,33])
table(lv_brunch[,33])
#no too complicated

#32. "DogsAllowed" 
head(lv_brunch[,34])
table(lv_brunch[,34])
#true,false

#33. "BYOB"   
head(lv_brunch[,35])
table(lv_brunch[,35])
# no Nothing

#34. "DietaryRestrictions"  
head(lv_brunch[,36])
table(lv_brunch[,36])
# no Nothing

#35. "RestaurantsDelivery"  
head(lv_brunch[,37])
table(lv_brunch[,37])
# true,false

#36. "Caters"   
head(lv_brunch[,38])
table(lv_brunch[,38])
# true,false

#37. "GoodForKids"  
head(lv_brunch[,39])
table(lv_brunch[,39])
# true,false

#38. "GoodForMeal"   
head(lv_brunch[,40])
table(lv_brunch[,40])
# no Too complicated

#39. "WheelchairAccessible"   
head(lv_brunch[,41])
table(lv_brunch[,41])
# no too imbalanced


lv_brunch_1 = lv_brunch[,-c(1,2,3,8,10,12,14,16,18,19,20,22,23,28,29,31,33,35,36,40,41,42:49,51)]
head(lv_brunch_1)
dim(lv_brunch_1)
colnames(lv_brunch_1)
lv_brunch_1

attach(lv_brunch_1)
p = NULL
p = c(p, summary(aov(stars ~ HappyHour))[[1]][1,5])
p = c(p, summary(aov(stars ~ Corkage))[[1]][1,5])
p = c(p, summary(aov(stars ~ Alcohol))[[1]][1,5])
p = c(p, summary(aov(stars ~ NoiseLevel))[[1]][1,5])
p = c(p, summary(aov(stars ~ BusinessAcceptsCreditCards))[[1]][1,5])
p = c(p, summary(aov(stars ~ RestaurantsReservations))[[1]][1,5])
p = c(p, summary(aov(stars ~ GoodForDancing))[[1]][1,5])
p = c(p, summary(aov(stars ~ BikeParking))[[1]][1,5])
p = c(p, summary(aov(stars ~ RestaurantsTableService))[[1]][1,5])
p = c(p, summary(aov(stars ~ BYOBCorkage))[[1]][1,5])
p = c(p, summary(aov(stars ~ WiFi))[[1]][1,5])
p = c(p, summary(aov(stars ~ RestaurantsTakeOut))[[1]][1,5])
p = c(p, summary(aov(stars ~ OutdoorSeating))[[1]][1,5])
p = c(p, summary(aov(stars ~ CoatCheck))[[1]][1,5])
p = c(p, summary(aov(stars ~ RestaurantsGoodForGroups))[[1]][1,5])
p = c(p, summary(aov(stars ~ HasTV))[[1]][1,5])
p = c(p, summary(aov(stars ~ DogsAllowed))[[1]][1,5])
p = c(p, summary(aov(stars ~ RestaurantsDelivery))[[1]][1,5])
p = c(p, summary(aov(stars ~ Caters))[[1]][1,5])
p = c(p, summary(aov(stars ~ GoodForKids))[[1]][1,5])

p
p.adjust(p, method = 'fdr')
detach(lv_brunch_1)
