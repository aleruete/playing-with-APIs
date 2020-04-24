# https://atlasoflivingaustralia.github.io/ALA4R/articles/ALA4R.html
install.packages("ALA4R")
library(ALA4R)
# Caching
# ALA4R can cache most results to local files. This means that if the same code 
# is run multiple times, the second and subsequent iterations will be faster. 
# This will also reduce load on the ALA servers.
ala_config(cache_directory="C:/Users/Alejandro/Documents/GitHub/playing-with-APIs/ala_cache") ## use forward slashes, not \
ala_config(warn_on_empty=TRUE)
to_install <- c("ape", "dplyr", "ggplot2", "jpeg", "maps", "mapdata",
                "maptools", "phytools", "tidyr", "vegan")
to_install <- to_install[!sapply(to_install, requireNamespace, quietly=TRUE)]
if(length(to_install)>0)
  install.packages(to_install, repos="http://cran.us.r-project.org")

## In these examples we use the `dplyr` package to help with data manipulation.
library(dplyr)

library(ape)
library(phytools)
# Let’s say that we want to look at the taxonomic tree of penguins but we don’t know what the correct scientific name is. Start by searching for it:
  
sx <- search_fulltext("penguins")
sx$data
# download.file("https://images.ala.org.au/image/proxyImage?imageId=d5b2e315-f9f6-4f3a-b86c-886cc62cf1b4", destfile = "pinguin.jpg")
sx$data %>% dplyr::select(name, rank, family, commonName)
# We can see that penguins correspond to the family “SPHENISCIDAE”. 
# Now we can download the taxonomic data (note that the search is case-sensitive):
  
tx <- taxinfo_download("rk_family:SPHENISCIDAE", fields=c("guid", "rk_genus", "scientificName", "rank"))

## keep only species and subspecies records
tx <- tx %>% dplyr::filter(rank %in% c("species","subspecies"))

# We can make a taxonomic tree plot using the phytools package:
  
## as.phylo requires the taxonomic columns to be factors
tx <- tx %>% mutate_all(as.factor)

## create phylo object of Scientific.Name nested within Genus
ax <- as.phylo(~genus/scientificName, data=tx)
plotTree(ax, type="fan", fsize=0.7) ## plot it

# We can also plot the tree with images of the different penguin species. 
# We can first extract a species profile for each species identifier (guid) in our results:
  
s <- search_guids(tx$guid)

# For each of those species profiles, download the thumbnail image and store it in our data cache:
imfiles <- sapply(s$thumbnailUrl, function(z) {
    ifelse(!is.na(z), ALA4R:::cached_get(z, type="binary_filename"), "")
  })

# And finally, plot the tree:
## plot tree without labels
plotTree(ax, type="fan", ftype="off")

## get the tree plot object
tr <- get("last_plot.phylo", envir = .PlotPhyloEnv)

## add each image
library(jpeg)
for (k in which(nchar(imfiles)>0))
  rasterImage(readJPEG(imfiles[k]), tr$xx[k]-1/10, tr$yy[k]-1/10, tr$xx[k]+1/10, tr$yy[k]+1/10)
# A number of species may have no image (mostly, these are extinct species) and others are images of eggs rather than animals, but 

