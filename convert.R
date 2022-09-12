library(readr)
library(tidyverse)
library(sf)
CA <- read_delim("CA/CA.txt", delim = "\t",
                 escape_double = FALSE, col_names = FALSE,
                 trim_ws = TRUE)
colnames(CA) <- c("country code",
                  "postal code",
                  "place name ",
                  "admin name1",
                  "admin code1",
                  "admin name2",
                  "admin code2",
                  "admin name3",
                  "admin code3",
                  "latitude",
                  "longitude",
                  "accuracy" )

CA <- CA %>% filter(`admin code1` == "BC") #WGS84

ha <- read_sf('./ha_2018/HA_2018.shp') #NAD83 / BC Albers

st_crs(ha)

pnts_sf <- sf::st_as_sf(CA, coords = c("latitude", "longitude"), crs = 4326)

pnts_trans <- st_transform(pnts_sf, 3005)
st_crs(pnts_trans)

library(ggplot2)
ggplot() + geom_sf(data = ha)


res <- sf::st_join(pnts_trans, ha)

print(res)
