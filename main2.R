library(jpeg)
main_func <- function(name) {
  img <- readJPEG(name)
  
  new_name <- gsub("\\.jpg$", "_modified.jpg", name)
  writeJPEG(img, new_name)
}

setwd("C:/Users/oopsw/Desktop/project2/project-2")
main_func("origin.jpg")