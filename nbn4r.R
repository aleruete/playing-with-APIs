# https://github.com/BiologicalRecordsCentre/NBN4R
# NBM4R
remotes::install_github("fozy81/NBN4R")
library(NBN4R)
nbn_config(cache_directory="C:/Users/Alejandro/Documents/GitHub/playing-with-APIs/nbn_cache") ## Windows
x <- occurrences(taxon="taxon_name:\"Accipiter gentilis\"", download_reason_id="testing", email="test@test.org")
summary(x)
