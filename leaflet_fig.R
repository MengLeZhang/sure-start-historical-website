library(tidyverse)
library(leaflet)
library(sf)
library(viridis)

df <- read_sf("data/geometry/geom_data_2009_expansion.shp")
df <- st_transform(df, crs=4326)
df <- df %>% mutate(
  NAME_title = str_to_title(NAME)
)

pal <- colorFactor(
  palette = viridis(length(unique(na.omit(df$expansn))),
                    begin = 0.2, direction = -1),
  domain = df$expansn,
  na.color = "#ECECEC"
)


# Create leaflet map
leaflet_map <- leaflet(data = df) %>%
  addTiles() %>%
  setView(lng = -7, lat = 54.5, zoom = 8) %>%
  addPolygons(
    fillColor = ~pal(expansn),
    weight = 0.2,
    color = "lightgrey",
    fillOpacity = 0.6,
    smoothFactor = 0.5,
    label = ~NAME_title,
    highlightOptions = highlightOptions(color = "black", weight = 2, opacity=1, bringToFront = TRUE)
  )%>%
  addLegend(
    "bottomright",
    pal = pal,
    values = ~expansn,
    title = "Expansion",
    opacity = 1
  )

# Show the map
leaflet_map


