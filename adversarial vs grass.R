#Import Libraries===============================================================
library(tidyverse)
library(keras)
library(tensorflow)
library(reticulate)
library(imager)
library(magick)


#Need to change this line for your wd
setwd("C:/Users/annab/OneDrive/Documents/project-2")

 
# Load a pre-trained neural network
model<-load_model_tf("./dandelion_model")

#Algorithm======================================================================
#Need to alter images.
                               
#Test===========================================================================

res=c("","")
f=list.files("./dandelions")
for (i in f){
  test_image <- image_load(paste("./dandelions/",i,sep=""), #Need to create folder named grass and add images of grass to it
                           target_size = c(224,224))
  x <- image_to_array(test_image)
  x <- array_reshape(x, c(1, dim(x)))
  x <- x/255
  pred <- model %>% predict(x)
  if(pred[1,2]<0.50){
    print(i)
  }
  print(pred)
}

res=c("","")
f=list.files("./changing grass folder with black then green pixels/")
for (i in f){
  test_image <- image_load(paste("./changing grass folder with black then green pixels/",i,sep=""), #Need to create folder named dandelions and add images of dandelions to it. 
                           target_size = c(224,224))
  x <- image_to_array(test_image) #turn to array
  x <- array_reshape(x, c(1, dim(x))) #reshape to 1 line
  x <- x/255 # resize
  
  
  pred <- model %>% predict(x)
 if(pred[1,1]<0.50){
    print(i)
  }
  print(pred)
}


res=c("","")
f=list.files("./original")
for (i in f){
  test_image <- image_load(paste("./original/",i,sep=""), #Need to create folder named dandelions and add images of dandelions to it. 
                           target_size = c(224,224))
  x <- image_to_array(test_image) #turn to array
  x <- array_reshape(x, c(1, dim(x))) #reshape to 1 line
  x <- x/255 # resize
  
  
  pred <- model %>% predict(x)
  if(pred[1,1]<0.50){
    print(i)
  }
  print(pred)
}

res=c("","")
f=list.files("./modify")
for (i in f){
  test_image <- image_load(paste("./modify/",i,sep=""), #Need to create folder named dandelions and add images of dandelions to it. 
                           target_size = c(224,224))
  x <- image_to_array(test_image) #turn to array
  x <- array_reshape(x, c(1, dim(x))) #reshape to 1 line
  x <- x/255 # resize
  
  
  pred <- model %>% predict(x)
  if(pred[1,1]<0.50){
    print(i)
  }
  print(pred)
}


