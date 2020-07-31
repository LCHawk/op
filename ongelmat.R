#tbodyä käyttää Halsua-ylipää


library(tidyverse)
library(rvest)

pankit <- read_html("https://www.op.fi/op-ryhma/osuuspankit/osuuspankkien-omat-sivut")

pankit <- pankit %>% html_nodes("a") %>%  html_attr("href")
pankit <- pankit[grepl("www.op.fi",pankit)]
i = 115
#Tehdään aluksi yhdellä ja tutkitaan hallintoa
#for(i in 1:length(pankit)){
  pankki <- pankit[i]
  pankki_nimi<-unlist(str_split(pankki,"/"))[4]
  
  if(pankki_nimi=="kuortaneen-osuuspankki"){
    pankki_nimi<-"op-kuortane"
  }
  
  #Tehdään helsigin kohdalla poikkeus, koska ei ole samaa muotoa
  # if(pankki_nimi %in% c("op-helsinki","op-korsnas","andelsbanken-for-aland",
  #                       "op-kuortane","op-simpele","vaasan-osuuspankki","op-ypaja","yla-savon-osuuspankki")
  #    |(i>109&i<120)){
  #   next
  # }
  
  pankki <- read_html(paste0("https://www.op.fi/web/",pankki_nimi,"/hallinto"))
  
  hallintoneuvosto <- pankki %>% 
    html_table(fill = T)
  hallintoneuvosto <- hallintoneuvosto[[1]]
  hallintoneuvosto$Pankki <- pankki_nimi
  print(c(pankki_nimi,i))
  
  if(i == 1){
    hn <- hallintoneuvosto
  }else
    hn <- hn %>% bind_rows(hallintoneuvosto)
#}