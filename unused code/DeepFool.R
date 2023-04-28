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

# Set up Python environment
use_python("/usr/bin/python3")
py <- import("numpy")z

# Define DeepFool function
deepfool <- function(image, classifier, pixel_budget=100, overshoot=0.02, max_iter=50) {
  # Convert image to numpy array
  img_array <- py$asarray(as.array(image))
  img_array <- py$expand_dims(img_array, 0)
  
  # Get image shape
  img_shape <- img_array$shape[-1]
  
  # Convert classifier to a function that takes in a numpy array and returns a prediction
  classify <- function(x) {
    y <- classifier(py$expand_dims(x, 0))
    as.integer(py$argmax(py$sum(y, 0))[1])
  }
  
  # Compute initial prediction
  f_init <- classify(img_array)
  
  # Initialize variables
  I <- py$identity(img_shape)
  pert_image <- img_array
  w <- py$zeros(img_shape)
  r_tot <- py$zeros(img_shape)
  k <- 0
  
  while (classify(pert_image) == f_init && k < max_iter) {
    # Compute gradient of current prediction
    gradients <- py$asarray(classifier(pert_image), dtype="float64")
    gradients[1, f_init] <- -py$inf
    
    # Compute minimum adversarial perturbation
    for (i in seq_len(img_shape)) {
      w[i] <- gradients[1, i]
      for (j in seq_len(i-1)) {
        w[i] <- w[i] - (w[j] * gradients[1, i, j]) / py$linalg$norm(py$asarray(I[i, ] - I[j, ], dtype="float64"))
      }
      w[i] <- w[i] / py$linalg$norm(py$asarray(w[i], dtype="float64"))
      
      # Compute adversarial perturbation for current pixel
      r_i <- (overshoot * py$asarray(w[i], dtype="float64")) / py$linalg$norm(py$asarray(w[i], dtype="float64"))
      r_tot <- py$asarray(py$asarray(r_tot, dtype="float64") + r_i, dtype="float64")
      pert_image <- img_array + r_tot
      pert_image <- py$clip(pert_image, 0, 255)
      pert_image <- py$asarray(pert_image, dtype="float64")
      
      # Check if pixel budget has been exceeded
      if (k == 0 && i == 1) {
        pixel_budget <- min(pixel_budget, py$sum(py$abs(r_i)))
      }
      if (py$sum(py$abs(r_tot)) > pixel_budget) {
        break
      }
    }
    k <- k + 1
  }
  
  # Compute set of pixels to be changed
  pixel_changes <- py$argwhere(py$not_equal(py$asarray(img_array), py$asarray(pert_image)))
  pixel_changes <- pixel_changes + 1
  pixel_changes <- as.data.frame(py$transpose(pixel_changes))
  names(pixel_changes) <- c("x", "y", "z")
  pixel_changes
}

# Example usage
img <- image_read("example.jpg")
classifier <- function(x) {
  model1 <- keras::load_model_hdf5("model1.h5")
  
  
                               
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
  if(pred[1,2]<0.50){
    print(i)
  }
  #print(pred)
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
 if(pred[1,1]<0.50){
    print(i)
  }
  #print(pred)
}


