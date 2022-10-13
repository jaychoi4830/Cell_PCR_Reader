#ArgsList-> 1. Path to file 2. FileName 3. Destination
args <- commandArgs(TRUE)
library(tidyverse)
library(readxl)
setwd(args[3])
library(gridExtra)

#function to concert SD sample to SD population. SD by default uses sample (n-1)
sd.p <- function(x){sd(x)*sqrt((length(x)-1)/length(x))}

#function to analyse PCR data; import data using readxl
#function returns: processed data, trimmed data, original data, and graphs for Ct, dCt, and mtDNA content
pcr <- function(data){
  colnames(data) <- gsub(" ", "_", colnames(data))
  colnames(data)
  
  #Convert column 'Cq' to numeric so that mutate function can calculate the 
  #delta-Ct and copy number
  data$Cq <- as.numeric(data$Cq)
  
  #data is trimmed to keep only the essential columns to proceed with analysis
  data.trimmed <- data[c("Well", "Fluor", "Content", "Sample", "Cq")]
  
  #Convert long-format data to wide so that can apply mutate functions to analyze results
  processed <- data.trimmed %>% 
    pivot_wider(names_from = 'Fluor', values_from = 'Cq') %>% 
    mutate(dCt = (HEX - FAM), mtDNA = 2^(-dCt)) %>% 
    group_by(Sample) %>% 
    mutate(avg = mean(mtDNA), stdev = sd.p(mtDNA), CV = stdev/avg*100) %>% 
    ungroup()
  
  #graphing
  mtDNA <- ggplot(processed, aes(x = Sample, y = mtDNA)) +
    geom_errorbar(aes(ymin = avg-stdev, ymax = avg+stdev), colour = "grey") +
    geom_dotplot(dotsize = .4, binaxis = "y", stackdir = "center") +
    geom_point(aes(y = avg), shape = 23, colour = "blue") +
    ggtitle("mtDNA Content") +
    theme(axis.text.x = element_text(angle = -45, hjust = 0), 
          panel.background = element_rect(fill = "white"),
          axis.line = element_line(colour = "black"),
          plot.title = element_text(hjust = 0.5))
  
  Cq.stats <- ggplot(data, aes(x = Sample, y = Cq)) +
    geom_errorbar(aes(ymin = Cq_Mean - Cq_Std._Dev, ymax = Cq_Mean + Cq_Std._Dev), colour = "grey") +
    geom_dotplot(dotsize = .4, binaxis = "y", stackdir = "center", aes(fill = Fluor)) +
    geom_point(aes(y = Cq_Mean), shape = 23, colour = "blue") +
    ggtitle("Cq values") + 
    theme(axis.text.x = element_text(angle = -45, hjust = 0), 
          panel.background = element_rect(fill = "white"),
          axis.line = element_line(colour = "black"),
          plot.title = element_text(hjust = 0.5))
  
  dCt.stats <- ggplot(processed, aes(x = Sample, y = dCt)) +
    geom_dotplot(dotsize = .4, binaxis = "y", stackdir = "center") +
    stat_summary(fun = mean, geom = "point", shape = 23, colour = "blue") +
    ggtitle("dCt") +
    theme(axis.text.x = element_text(angle = -45, hjust = 0), 
          panel.background = element_rect(fill = "white"),
          axis.line = element_line(colour = "black"),
          plot.title = element_text(hjust = 0.5))
  
  
  return(list("processed" = processed, 
              "trimmed" = data.trimmed, 
              "original" = data, 
              "Cq.graph" = Cq.stats, 
              "dCt.graph" = dCt.stats, 
              "mtDNA.graph" = mtDNA))
}

experiment <- read_excel(args[1], skip = 19)
analysis <- pcr(experiment)

plots <- list(analysis[[4]], analysis[[5]], analysis[[6]])
multiplot <- marrangeGrob(grobs = plots, nrow = 1, ncol = 1)
ggsave("multiplot.pdf", multiplot, device = "pdf", width = 8.5, height = 11, units = "in")
write.csv(analysis[[1]], file = paste(args[2],"_summary", ".csv", sep =""), row.names = FALSE)

dev.off()

#dat <- read_excel(args[1])
#dat$Cq <- as.numeric(dat$Cq)
#out <- dat %>% group_by(dat$Sample) %>% summarize(meanCq = mean(dat$Cq))

#write.csv(out, file = paste(args[2],"_summary", ".csv", sep =""), row.names = FALSE)