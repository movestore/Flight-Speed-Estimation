library('move')
library('foreach')
library('multimode')

rFunction <- function(data,retdata="all")
{
  Sys.setenv(tz="UTC")
  
  # select ground speed
  names(data) <- make.names(names(data),allow_=FALSE)
  
  data.split <- move::split(data)
  
  #exclude upper outliers 0.999 quantile (maybe adapt)
  pdf(paste0(Sys.getenv(x = "APP_ARTIFACTS_DIR", "/tmp/"), "Modes_Histogrammes.pdf"),width=12,height=8)
  
  flight <- foreach(datai = data.split) %do% {
    logger.info(namesIndiv(datai))
    
    #exclude upper outliers 0.999 quantile (maybe adapt)
    gspeed <- datai@data$ground.speed[datai@data$ground.speed<quantile(datai@data$ground.speed,na.rm=TRUE,probs=0.999)]
    
    #modetest(datai@data$ground.speed) # this takes very long, but can give an indication in case that there are not enough flight data in the input
    modes <- locmodes(gspeed,mod0=2)
    
    plot(modes)
    hist(gspeed,na.rm=TRUE,breaks=length(gspeed)/100,freq=FALSE,col=rgb(0,0,1,0.1),add=TRUE)
    
    return(modes)
  }
  dev.off()

  modes_table <- as.data.frame(matrix(unlist(lapply(flight,function(x) x$locations)),byrow=TRUE,nc=3))
  names(modes_table) <- c("mode1","antimode","mode2")
  
  modes_table <- data.frame("trackID"=namesIndiv(data),modes_table)
  
  mode1_avg <- c(mean(modes_table$mode1),sd(modes_table$mode1))
  antimode_avg <- c(mean(modes_table$antimode),sd(modes_table$antimode))
  mode2_avg <- c(mean(modes_table$mode2),sd(modes_table$mode2))
  
  modes_table <- rbind(modes_table,data.frame("trackID"=c("mean","sd"),"mode1"=mode1_avg,"antimode"=antimode_avg,"mode2"=mode2_avg))
  
  write.csv(modes_table,file= paste0(Sys.getenv(x = "APP_ARTIFACTS_DIR", "/tmp/"),"groudspeed_modes.csv"),row.names=FALSE)
  
  # return all data or only flight locations?
  if (retdata=="flight")
  {
    flight_data <- foreach(datai = data.split) %do% {
      antimode <- modes_table$antimode[modes_table$trackID==namesIndiv(datai)]
      datai[datai@data$ground.speed>antimode & !is.na(datai@data$ground.speed)] #NA is not allowed
    }
    
    flight_data.nozero <- flight_data[unlist(lapply(flight_data, length) > 0)] #is not possible to be empty
    
    result <- moveStack(flight_data.nozero,forceTz="UTC")
    logger.info(paste("You have selected to output/pass on only the flight locations (ground speed above antimode) of this data set. Your new data set contains",length(result),"flight locationas out of in total",length(data),"locations."))
    
  } else result <- data

  return(result)
}

  
  
  
  
  
  
  
  
  
  
