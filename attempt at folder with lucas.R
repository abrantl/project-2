library(imager)
library(jpeg)


# Load the image
f = list.files("./adversarial_examples/")
target_size = c(224, 224)


for (i in f){

# Load an example image
  img <- readJPEG(i)
  
  # Define the probability of changing a pixel, meaning that we expect to change x% of the pixels of the image
  prob <- 0.1
  
  # Calculate the number of pixels to change
  num_pixels <- round(prob * length(img))

  # Generate a vector of random pixel indices
  pixels_to_change <- sample.int(length(img), num_pixels)

    # Generate a vector of random values to replace the pixels
    new_values <- runif(num_pixels)
  
      # Replace the pixels in the image with the new values
  
  img[pixels_to_change] <- new_values
  
  # Save the modified image
  
  name_file <- strsplit(i, ".")[[1]][1] # this need to be fixed to get the name of the file before the ".jpeg"
  
  print(name_file)
  
  writeJPEG(img, paste(name_file, "modified",".jpg"))
  
}