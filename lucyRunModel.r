#Import Libraries===============================================================
library(tidyverse)
library(keras)
library(tensorflow)
library(reticulate)


setwd("C:/Users/oopsw/Desktop/project2/project-2")
model<-load_model_tf("./dandelion_model")

#Algorithm======================================================================
# python part
tf <- import("tensorflow")
Sys.setenv(TF_CPP_MIN_LOG_LEVEL = "2")
# img <- load.image("data-for-332/grass/5.jpg")
img_raw <- tf$io$read_file("data-for-332/grass/5.jpg")
img <- tf$image$decode_image(img_raw)


loss_object <- tf$keras$losses$CategoricalCrossentropy()




# library(imager)
# library(GenSA)
# img <- load.image("data-for-332/grass/5.jpg")
# cost_function <- function(x, img) {
#   modified_img <- apply_filters(img, x[1], x[2], x[3])
#   mse <- sum((modified_img - img)^2) / length(img)
#   return(mse)
# }
# up <- c(50,50,50)
# low <- c(-50,-50,-50)
# initial_solution <- c(0, 0, 0)
# result <- GenSA(fn = cost_function, lower = low, upper = up, initial_solution, img)
# modified_img <- apply_filters(img, result$xbest[1], result$xbest[2], result$xbest[3])
# writeJPEG(modified_img, "C:/Users/oopsw/Desktop/project2/project-2")
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
  print(pred)
}

