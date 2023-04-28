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
# Define the FGSM attack function
fgsm_attack <- function(x, y_target, eps) {
  # Calculate the gradient of the loss function with respect to the input image
  grad <- keras::k_gradient(model$output, model$input)
  # Calculate the sign of the gradient
  sign_grad <- tensorflow::sign(grad)
  # Add a small perturbation in the direction of the sign of the gradient that maximizes the loss
  x_perturbed <- x + eps * sign_grad
  # Clip the pixel values of the perturbed image to the range [0, 1]
  x_perturbed <- tensorflow::clip_by_value(x_perturbed, 0, 1)
  # Set the target label to the true label to generate an untargeted attack
  y_target <- array(0, dim = dim(x)[1:2])
  y_target[y_true + 1] <- 1
  # Add the target label to the input tensor to generate a targeted attack
  # y_target_tensor <- array(y_target, dim = c(1, length(y_target)))
  # x_perturbed <- tensorflow::concatenate(list(x, y_target_tensor), axis = 1)
  return(x_perturbed)
}


# Define the directory to save the adversarial examples
dir.create("./adversarial_examples", showWarnings = FALSE)

# Generate adversarial examples for the grass images
f_grass <- list.files("./grass")
for (i in f_grass){
  test_image <- image_load(paste("./grass/",i,sep=""), #Need to create folder named grass and add images of grass to it
                           target_size = c(224,224))
  x <- image_to_array(test_image)
  x <- array_reshape(x, c(1, dim(x)))
  x <- x/255
  y_true <- 1 # Set the true label of the image
  eps <- 0.01 # Set the perturbation magnitude
  x_perturbed <- fgsm_attack(x, y_true, eps)
  x_perturbed <- array_reshape(x_perturbed, dim = c(224, 224, 3))
  image_write(x_perturbed, path = paste("./adversarial_examples/grass/", i, sep = ""))
}

# Generate adversarial examples for the dandelion images
f_dandelions <- list.files("./dandelions")
for (i in f_dandelions){
  test_image <- image_load(paste("./dandelions/",i,sep=""), #Need to create folder named dandelions and add images of dandelions to it. 
                           target_size = c(224,224))
  x <- image_to_array(test_image)
  x <- array_reshape(x, c(1, dim(x)))
  x <- x/255
  y_true <- 0 # Set the true label of the image
  eps <- 0.01 # Set the perturbation magnitude
  x_perturbed <- fgsm_attack(x, y_true, eps)
  x_perturbed <- array_reshape(x_perturbed, dim = c(224, 224, 3))
  image_write(x_perturbed, path = paste("./adversarial_examples/dandelion/", i, sep = ""))
}

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


