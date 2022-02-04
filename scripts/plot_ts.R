#Manual data
d<-read.csv("wp.csv")
str(d)

library(dplyr)
SE<-function(x){sd(x,na.rm=T)/sqrt(length(x))}
sum_WP<-d%>%
  mutate(datetime=as.POSIXct(strptime(datetime, "%m/%d/%Y %H:%M")),
         date=as.POSIXct(paste0(date," 00:00"), format="%m/%d/%Y %H:%M"))%>%
  group_by(date)%>%
  summarize(m=mean(negWP,na.rm=T),se=SE(negWP),sd=sd(negWP))


#Automated data
load("../psychrometer_append/clean3/new_1b_3.r")
str(new_d1)

library(ggplot2)
fig1<-ggplot()+
  geom_point(data=new_d1, aes(x=datetime, y=psy))+
  geom_point(data=sum_WP, aes(x=date, y=m), stat="identity", size=3, col="red")+
  geom_errorbar(data=sum_WP, aes(x=date, ymin=m-sd, ymax=m+sd), stat="identity",width=5)
fig1

