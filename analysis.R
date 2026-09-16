#Load required libraries  
library("rmcorr") 
library("ggplot2") 
library("cowplot") 
library("pals") 

#Load the data 
inputData <- read.delim2("hrv_mwl.csv",
                          header = TRUE,
                          sep = ';',
                          quote = '',
                          check.names = TRUE,
                          dec = '.')

#Get sample size
n <- length(unique(inputData$participant))

#Calculate rmcorr using selected columns 
my.rmc <- rmcorr(participant = participant,
                 measure1 = hr,
                 measure2 = nasa,
                 dataset = inputData,
                 CI.level = 0.95,
                 CIs = "analytic",
                 nreps = 100,
                 bstrap.out = FALSE) 

#Plot the data  
plotData <- inputData
ggplot(plotData, aes(x = hr, y = nasa,   group = factor(participant), color = factor(participant))) +
  geom_point(aes(colour = factor(participant))) +
  geom_line(aes(y = my.rmc$model$fitted.values), linetype = 2) +
  ylab("NASA-TLX") +
  xlab("Heart Rate (in beats per minute)") +
  theme_cowplot() +
  scale_shape_identity() +
  theme(legend.position = "none",
             plot.title = element_text(size = 20, hjust = 0.5),
             axis.title = element_text(size = 15),
             axis.text = element_text(size = 15),
             axis.text.x = element_text(angle = 0, hjust = 0, vjust = 0)) +
  scale_colour_manual(values = cols25(n)) +
  annotate("text",
          x = -Inf,
          y = -Inf,
          size = 5,
          label = deparse(bquote(atop(~~italic(r[rm])~"="~ .(sprintf("%.2f", round(my.rmc$r, 2))),
            ~italic(p)~.(ifelse(my.rmc$p < 0.001, "< 0.001",
                          ifelse(my.rmc$p < 0.01, "< 0.01",
                            ifelse(my.rmc$p < 0.05 & my.rmc$p > 0.045, "< 0.05",
                              paste0("= ",round(my.rmc$p, digits = 2))))))))),
          hjust = -0.5,
          vjust = -0.5,
          parse = TRUE) 

#Calculate rmcorr for LFHF Ratio 
my.rmc_lfhf <- rmcorr(participant = participant,
                 measure1 = lfhf,
                 measure2 = nasa,
                 dataset = inputData,
                 CI.level = 0.95,
                 CIs = "analytic",
                 nreps = 100,
                 bstrap.out = FALSE) 

#Plot data
plotData <- inputData 
ggplot(plotData, aes(x = lfhf, y = nasa,   group = factor(participant), color = factor(participant))) +
  geom_point(aes(colour = factor(participant))) +
  geom_line(aes(y = my.rmc_lfhf$model$fitted.values), linetype = 2) +
  ylab("NASA-TLX") +
  xlab("Ratio LF to HF (%)") +
  theme_cowplot() +
  scale_shape_identity() +
  theme(legend.position = "none",
             plot.title = element_text(size = 20, hjust = 0.5),
             axis.title = element_text(size = 15),
             axis.text = element_text(size = 15),
             axis.text.x = element_text(angle = 0, hjust = 0, vjust = 0)) +
  scale_colour_manual(values = cols25(n)) +
  annotate("text",
          x = Inf,
          y = -Inf,
          size = 5,
          label = deparse(bquote(atop(~~italic(r[rm])~"="~ .(sprintf("%.2f", round(my.rmc_lfhf$r, 2))),
            ~italic(p)~.(ifelse(my.rmc_lfhf$p < 0.001, "< 0.001",
                          ifelse(my.rmc_lfhf$p < 0.01, "< 0.01",
                            ifelse(my.rmc_lfhf$p < 0.05 & my.rmc$p > 0.045, "< 0.05",
                              paste0("= ",round(my.rmc_lfhf$p, digits = 2))))))))),
          hjust = 1.5,
          vjust = -0.5,
          parse = TRUE)