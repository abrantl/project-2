#Import Libraries===============================================================
library(tidyverse)
library(keras)
library(tensorflow)
library(reticulate)
library(imager)
library(magick)


#Set the working directory
setwd("C:/Users/annab/OneDrive/Documents/project-2")

 
# Load a pre-trained neural network
model<-load_model_tf("./dandelion_model")

#Algorithm======================================================================
#Need to alter images.
                               
#Test===========================================================================

res=c("","")
f=list.files("./original")
for (i in f){
  test_image <- image_load(paste("./original/",i,sep=""), #Need to create folder named dandelions and add images of dandelions to it. 
                           target_size = c(224,224))
  x <- image_to_array(test_image) #turn to array
  x <- array_reshape(x, c(1, dim(x))) #reshape to 1 line
  x <- x/255 # resize
  
  
  pred <- model %>% predict(x)
  #if(pred[1,2]<0.50){
   print(i)
  #}
  print(pred)
}


res=c("","")
f=list.files("./grass")
for (i in f){
  test_image <- image_load(paste("./grass/",i,sep=""), #Need to create folder named dandelions and add images of dandelions to it. 
                           target_size = c(224,224))
  x <- image_to_array(test_image) #turn to array
  x <- array_reshape(x, c(1, dim(x))) #reshape to 1 line
  x <- x/255 # resize
  
  
  pred <- model %>% predict(x)
  #if(pred[1,2]<0.5){
    print(i)
  #}
  print(pred)
}




