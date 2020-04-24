library(httr)
library(keyring)
library(jsonlite)
# https://api.ala.org.au/apps

url_ala<-"https://biocache-ws.ala.org.au/ws"
url_nbn<-"https://records-ws.nbnatlas.org"
###### GET artfakta
GETala<-function(url, 
                 resource, 
                 query){
  get<-GET(url = paste(url, resource, query, sep = "/"))
  # get$status_code
  message(paste("satus code:", get$status_code, "\ndate:", get$date))
  rfc <- content(get, as = "text")
  # rfl <- content(get, as = "parsed")
  rff <- fromJSON(rfc, simplifyDataFrame = TRUE)
  # json_file <- sapply(rfl$occurrences, function(x) {
  #   x[sapply(x, is.null)] <- NA
  #   unlist(x)
  # })
  # json_file$id <- rownames(json_file)
  
  return(rff)
}

occ<-GETala(url=url_nbn, #url=url_ala,
            resource = "occurrences",
            query = "search?q=genus:Macropus" )
occ
occ$totalRecords
occ$occurrences

occ$pageSize
length(occ$occurrences)
lengths(occ$occurrences)

occ$occurrences
# remove classification level
library(purrr)
get<-GET(url=paste(url_nbn, "occurrences", "search?q=genus:Macropus", sep="/" ))
rfl <- content(get, as = "parsed")
rfl %>%
  flatten() %>%
  
  # turn nested lists into dataframes
  map_if(is_list, as_tibble) %>%
  
  # bind_cols needs tibbles to be in lists
  map_if(is_tibble, list) %>%
  
  # creates nested dataframe
  bind_cols()
