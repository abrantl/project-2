#Import Libraries===============================================================
library(tidyverse)
library(keras)
library(tensorflow)
library(reticulate)

#Need to change this line for your wd
setwd("C:/Users/annab/OneDrive/Documents/project-2")

 

model<-load_model_tf("./dandelion_model")

#Algorithm======================================================================
#Need to alter images.


#Test===========================================================================

res=c("","")
f=list.files("./grass")
for (i in f){
  test_image <- image_load(paste("./grass/",i,sep=""), #Need to create folder named grass and add images of grass to it
                           target_size = c(224,224))
  x <- image_to_array(test_image)
  x <- array_reshape(x, c(1, dim(x)))
  x <- x/255
  pred <- model %>% predict(x)
#  if(pred[1,2]<0.50){
    #print(i)
  #}
  print(pred)
}

res=c("","")
f=list.files("./dandelions")
for (i in f){
  test_image <- image_load(paste("./dandelions/",i,sep=""), #Need to create folder named dandelions and add images of dandelions to it. 
                           target_size = c(224,224))
  x <- image_to_array(test_image)
  x <- array_reshape(x, c(1, dim(x)))
  x <- x/255
  pred <- model %>% predict(x)
#  if(pred[1,1]<0.50){
  #   print(i)
  #}
  print(pred)
}

