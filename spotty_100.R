library(httr)
library(jsonlite)
library(RCurl)
#Get tracks from tripleJ
r = GET("http://d1uryd9vkyzcf3.cloudfront.net/jjj2015/tracks.json?v=2")
#convert content to data frame
items = fromJSON(content(r, as = "text"))


#Add a column called 'popularity'
items['popularity'] <- NA
items['albumpopularity'] <- NA
items['ageweeks'] <- NA
#Search through all tracks to find Spotify album and track popularity
#https://developer.spotify.com/web-api/search-item/
base_url = "https://api.spotify.com/v1/search/"
for (i in 1:nrow(items))
{
  track = GET(base_url, query = list(
              q = paste('track:',strsplit(items$name[i], " \\{")[[1]][1]," ",
                  'artist:',items$artist[i],sep = ""),
                    type = "track"))
  if (track$status_code == 429)
  {
    print(track$status_code)
    print(paste("Sleeping for", track$headers$`retry-after`, "seconds"))
    Sys.sleep(track$headers$`retry-after`)
    i = i-1
  }
  tracks = fromJSON(content(track, as = "text"))
  if (length(tracks$tracks$items$popularity) > 0)
  {
    alb = GET(tracks$tracks$items$album$href[1])
    avals = fromJSON(content(alb, as = "text"))
    items$albumpopularity[i] = avals$popularity
    items$popularity[i] = max(tracks$tracks$items$popularity)
    if (avals$release_date_precision == "year")
    {
      items$ageweeks[i] = 52
    }
    else {
      items$ageweeks[i] = round(as.numeric(
        difftime(Sys.Date(), as.Date(avals$release_date),
                 units = "weeks")))
    }
  }
  if (i %% 100 == 0)
    print(paste("Song number:", i))
}

testItems <- items[order(-items$popularity),]
testItems['ranking']<- NA

testItems$ranking <- ((testItems$popularity + 
                      ((testItems$popularity-testItems$albumpopularity)/10))/52)*
                      pmin(testItems$ageweeks,52)
testItems <- testItems[order(-testItems$ranking),]
