library(tidyverse)
library(rvest)

pankit <- read_html("https://www.op.fi/op-ryhma/osuuspankit/osuuspankkien-omat-sivut")

pankit <- pankit %>% html_nodes("a") %>%  html_attr("href")
pankit <- pankit[grepl("www.op.fi",pankit)]
hn<-list()
#Tehdään aluksi yhdellä ja tutkitaan hallintoa
for(i in 1:length(pankit)){
  pankki <- pankit[i]
  pankki_nimi<-unlist(str_split(pankki,"/"))[4]
  
  if(pankki_nimi=="kuortaneen-osuuspankki"){
    pankki_nimi<-"op-kuortane"
  }
  
  #Tehdään helsigin kohdalla poikkeus, koska ei ole samaa muotoa
   if(pankki_nimi %in% c("op-helsinki","op-korsnas","op-suomenselka")){
    next
   }
  
  pankki <- read_html(paste0("https://www.op.fi/web/",pankki_nimi,"/hallinto"))
  print(c(pankki_nimi,i))
  
  hallintoneuvosto <- pankki %>% 
    html_table(fill = T)
  hallintoneuvosto <- hallintoneuvosto[[1]]
  hallintoneuvosto$Pankki <- pankki_nimi
  
  print(paste("Pankki",pankki_nimi,"luku onnistui."))
  hn[[i]]<-hallintoneuvosto
  # if(i == 1){
  #   hn <- hallintoneuvosto
  # }else{
  #   print(paste("Pankki",pankki_nimi,"liitos yritys."))
  #   hn <- hn %>% bind_rows(hallintoneuvosto)
  #   print(paste("Pankki",pankki_nimi,"liitos onnistui"))
  #   
  #   }
}

#Editoidaan aineistoa
hallintoneuvosto <- hn

#Kirjoitettava uudelleen, koska lista.
# hallintoneuvosto <- hallintoneuvosto %>% 
#   mutate(Nimi = coalesce(Nimi,Namn,X1), Ammatti = coalesce(Ammatti, Yrke,X2),
#          Kotipaikka = coalesce(Kotipaikka,Hemort,X3),
#          Toimikausi = coalesce(Toimikausi,Mandatperiod, X4))
# #Poistetaan ylimääräiset
# hallintoneuvosto <- hallintoneuvosto %>% select(Nimi,Ammatti,Kotipaikka,Toimikausi,Pankki)
# #Poista ne, joissa rivillä mainitaan sana nimi nimi-sarakkeessa. Niitä on tullut.
# #Aluksi voitaisiin laskea eri kuntien ja ammattien määrät
# 




