rm(list=ls())

####    Load Librarys   ####
library("stringr")  #str_count()


####     Load data     ####
review <- read.csv("../data/review_demo.csv")[,-1]
bussiness <- readRDS("../data/bussiness_train.RDS")

#### Match review and bussiness    ####
# Abbrevate the list used in
index_origin_id = which( bussiness$business_id %in% review$business_id )
useful_id=bussiness$business_id[index_origin_id]
index=numeric()
for (i in 1:dim(review)[1]){
  index[i]=which( useful_id %in% review$business_id[i] )
}

# check index correct?
# useful_id[index]==review$business_id
index_bussiness_to_review=index_origin_id[index]
# check index_bussiness_to_review correct?
# bussiness$business_id[index_bussiness_to_review]==review$business_id
names(bussiness)[-1]
review$name=bussiness$name[index_bussiness_to_review]
review$city=bussiness$city[index_bussiness_to_review]
review$state=bussiness$state[index_bussiness_to_review]
review$latitude=bussiness$latitude[index_bussiness_to_review]
review$longitude=bussiness$longitude[index_bussiness_to_review]
review$attributes=bussiness$attributes[index_bussiness_to_review]

review$categories=bussiness$categories[index_bussiness_to_review]
review$hours=bussiness$hours[index_bussiness_to_review]

review$BusinessAcceptsBitcoin=bussiness$BusinessAcceptsBitcoin[index_bussiness_to_review]
review$HappyHour=bussiness$HappyHour[index_bussiness_to_review]
review$Corkage=bussiness$Corkage[index_bussiness_to_review]
review$Alcohol=bussiness$Alcohol[index_bussiness_to_review]
review$NoiseLevel=bussiness$NoiseLevel[index_bussiness_to_review]
review$RestaurantsPriceRange2=bussiness$RestaurantsPriceRange2[index_bussiness_to_review]
review$BusinessAcceptsCreditCards=bussiness$BusinessAcceptsCreditCards[index_bussiness_to_review]
review$BusinessParking=bussiness$BusinessParking[index_bussiness_to_review]
review$RestaurantsReservations=bussiness$RestaurantsReservations[index_bussiness_to_review]
review$OutdoorSeating=bussiness$OutdoorSeating[index_bussiness_to_review]
review$CoatCheck=bussiness$CoatCheck[index_bussiness_to_review]
review$Smoking=bussiness$Smoking[index_bussiness_to_review]
review$HairSpecializesIn=bussiness$HairSpecializesIn[index_bussiness_to_review]
review$RestaurantsGoodForGroups=bussiness$RestaurantsGoodForGroups[index_bussiness_to_review]
review$AgesAllowed=bussiness$AgesAllowed[index_bussiness_to_review]
review$HasTV=bussiness$HasTV[index_bussiness_to_review]
review$Music=bussiness$Music[index_bussiness_to_review]
review$DogsAllowed=bussiness$DogsAllowed[index_bussiness_to_review]
review$BYOB=bussiness$BYOB[index_bussiness_to_review]
review$DietaryRestrictions=bussiness$DietaryRestrictions[index_bussiness_to_review]
review$RestaurantsDelivery=bussiness$RestaurantsDelivery[index_bussiness_to_review]
review$Caters=bussiness$Caters[index_bussiness_to_review]
review$GoodForKids=bussiness$GoodForKids[index_bussiness_to_review]
review$GoodForMeal=bussiness$GoodForMeal[index_bussiness_to_review]
review$WheelchairAccessible=bussiness$WheelchairAccessible[index_bussiness_to_review]

review$Monday_hours=bussiness$Monday_hours[index_bussiness_to_review]
review$Tuesday_hours=bussiness$Tuesday_hours[index_bussiness_to_review]
review$Wednesday_hours=bussiness$Wednesday_hours[index_bussiness_to_review]
review$Thursday_hours=bussiness$Thursday_hours[index_bussiness_to_review]
review$Friday_hours=bussiness$Friday_hours[index_bussiness_to_review]
review$Saturday_hours=bussiness$Saturday_hours[index_bussiness_to_review]
review$Sunday_hours=bussiness$Sunday_hours[index_bussiness_to_review]


review$MainCatInYelpCounts=bussiness$MainCatInYelpCounts[index_bussiness_to_review]
review$MainCatInYelp=bussiness$MainCatInYelp[index_bussiness_to_review]
review$AllMainCatInYelp=bussiness$AllMainCatInYelp[index_bussiness_to_review]

#####     Write file   ####

write.csv(review,"../data/review_bussiness_merge_demo.csv")
