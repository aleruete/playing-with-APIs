library(httr)
library(keyring)
# https://api.ala.org.au/apps

url<-"https://biocache-ws.ala.org.au/ws"

###### GET artfakta
GETala<-function(url="https://biocache-ws.ala.org.au/ws", 
                 resource = "occurrences", 
                 query=""){
  get<-GET(url = paste(url, resource, query, sep = "/"))
  # get$status_code
  message(paste("satus code:", get$status_code, "\ndate:", get$date))
  return(content(get, as = "parsed"))
}

occ<-GETala(query = "search?q=genus:Macropus" )
occ$totalRecords
occ$occurrences

occ$pageSize
length(occ$occurrences)
lengths(occ$occurrences)

occ$occurrences