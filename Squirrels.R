library(tidyverse)
library(ggmap)

nyc_squirrels <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-10-29/nyc_squirrels.csv")

reaction<-nyc_squirrels %>%filter(!is.na(primary_fur_color)) %>% 
  gather(reaction_to_human, value, approaches, indifferent, runs_from ) %>%
  filter(value==T) 


nyc_map <- get_map(location = c( -73.968285, 40.783), maptype = "roadmap", zoom=14)
squirrel_map<-ggmap(nyc_map)

facetlabs<- c("Squirrel approaches", "Squirrel is indifferent", "Squirrel runs away")
names(facetlabs) <- c( "approaches", "indifferent", "runs_from")

squirrel_map +
  geom_point(aes(x = long, y = lat, colour=primary_fur_color), data = reaction, size = 1.2)+
  scale_color_manual(values=c('black','darkorange3', 'gray48'),
                     name = "Primary Fur Color:")+
  ggtitle(label = "NYC Squirrel Census",
          subtitle = "Map of Squirrels by Behavior towards Human")+
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.title.y=element_blank(),
        axis.text.y =element_blank(),
        axis.ticks.y=element_blank(),
        legend.position="bottom", legend.box = "horizontal",
        plot.title = element_text(size=20, hjust=0.5, vjust=0),
        plot.subtitle = element_text(size = 14, hjust = 0.5, vjust = 0))+
  facet_grid(. ~reaction_to_human, labeller = labeller(reaction_to_human= facetlabs))
