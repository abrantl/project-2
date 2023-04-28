#code flips image horizontally


library(magick)

main_func <- function(name) {
  img_path <- name
  
  new_name <- gsub("\\.jpg$", "_flip.jpg", name)
  
  img_path <- "Dandelion_field-3713827972.jpg"
  
  img <- image_read(img_path, density = NULL, depth = NULL, strip = FALSE)
  
  flip_img <- image_flip(img)
  #print(flip_img)
  
  image_write(flip_img, new_name)
  
}

#set a working directory. Make sure the directory goes where the images you want to alter
setwd("C:/Users/annab/OneDrive/Documents/project-2/dandelions") 

main_func("636597665741397587-dandelion-1097518082.jpg") #Change the file of the picture you want altered

#used for duplicity
set.seed(123)

