library(tidyverse)
library(rvest)
library(httr)
library(XML)
pankit_url <- "https://www.op.fi/op-ryhma/osuuspankit/osuuspankkien-omat-sivut"

yhteinen_sivu <- read_html(pankit_url)
node <- html_nodes(yhteinen_sivu,"a")
attribuutti <- html_attr(node,"href")
linkit <- attribuutti[grep("https://www.op.fi/",attribuutti)]
loppuosa <- substr(linkit,19,nchar(linkit))
i = 1
#linkit
pankki <- loppuosa[i]
pankki_url <- paste0("https://www.op.fi/web/",pankki,"/hallinto")
pankin_sivu <- read_html(pankit_url)
raakaa <- html_nodes(pankin_sivu,".opux-expander-content") 