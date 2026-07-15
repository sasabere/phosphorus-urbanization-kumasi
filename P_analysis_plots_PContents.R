###########################################################################
#After realizing all papers report their findings in mgKg I decided to recreacte all analysis in the comparable unit
#Project: UrbanRESS, part: PHOSPHORUS, Date: 28/03/2019v --> Update in 14 Jan 2026
# Analysing the data for the P fractionation 
# First parts will contain data preparations
# Then general comparisons between long- and short- term soils 
# Then barcharts for the composition of the different fractions 
# The last part will be the Structural equation modelling,

# CONTACT - stephen.asabere@icloud.com
par(mfrow=c(1,2))

###########################################################################
# Set working directory
#rm(list=ls()) # Clear Environment
#cat("\014") # clear console
#options(warn=-1) # Suppress warnings 
setwd("C:/Users/sasaber/ownCloud - sasaber@gwdg.de@owncloud.gwdg.de/PostDoc/Papers_To_Be_completed_from_PhD/") #office

###########################################################################

#Function to load packages
source("C:/Users/sasaber/ownCloud - sasaber@gwdg.de@owncloud.gwdg.de/CODING/R/R_functions/to_intall_load_packages.R")

pks <- c ("ggplot2", "reshape2", "cowplot", "scales","dplyr","tidyr","lavaan", 
           "semPlot","huge", "OpenMx", "ggcorrplot","lmerTest","RColorBrewer", 
          "viridis","ggExtra", "doBy", "usdm"
          )
load_pkg(pks)

###########################################################################    
# Load Dataset and prepare them
#save.image("Paper 4_Pfractions/Drafts/R/P_workData.RData")
load("./Paper 4_Pfractions/Drafts/R/P_workData.RData") #for continuation...

#To remove specific objects 
rm(list=ls()[! ls() %in% c("name_1"," name_2"," name_3", " name_4"," name_5")])
############################################################################
#Preparing parent data df1 from a combination of other datasets 

df_P <- read.csv("./Paper 4_Pfractions/Data/P_data_new.csv",na.strings = "NA")
df_P$Classification<- factor(df_P$Classification, levels=c('forest','Long_term','rural','Short_term'), 
                             labels=c('Forest','Long-term','Rural','Short-term')) 

df_P$Classification <- factor(df_P$Classification, levels=c("Long-term", "Short-term","Rural", "Forest")) 

df_P$Classification<- factor(df_P$Classification, levels=c("Long-term", "Short-term","Rural", "Forest"),
                             labels=c("Long-term", "Short-term", "RURAL", "FOREST"))

#SOM data 
SOMdat<- read.csv2("./Paper 4_Pfractions/Data/GH_SA soil_carbon_2.csv", na.strings = "NA")
SOMdat<- data.frame(Lab_No=SOMdat$Lab_No, farms=SOMdat$farms,sicB=SOMdat$SICw_gkg,
                    sicS=SOMdat$SIC_kgm2, socB=SOMdat$SOCw_gkg, socS= SOMdat$SOC_kgm2, 
                    skeleton=SOMdat$Skeleton_., tcB=SOMdat$TCw_gkg, tcS=SOMdat$TC_kgm2,
                    CN=SOMdat$C_N,bulk=SOMdat$Bulkdensity_gcm3)



SOMdat$sicB<-as.numeric.factor(SOMdat$sicB)#
SOMdat$sicS<-as.numeric.factor(SOMdat$sicS)#
SOMdat$socB <- as.numeric.factor(SOMdat$socB)#
SOMdat$socS <- as.numeric.factor(SOMdat$socS)#
SOMdat$skeleton  <-as.numeric.factor(SOMdat$skeleton)#
SOMdat$tcB<-as.numeric.factor(SOMdat$tcB)#
SOMdat$tcS<-as.numeric.factor(SOMdat$tcS)#
SOMdat$CN<- as.numeric.factor(SOMdat$CN)
SOMdat$bulk<- as.numeric.factor(SOMdat$bulk)

# #exchangeable cations 
# SFdat<- read.csv("./Paper2_IR/paper2_soilFert/Soil_fertility_param.csv", na.strings = "NA")
# SFdat<- data.frame(Lab_No=SFdat$Lab_No, ca=SFdat$Caw_gkg, mg=SFdat$Mgw_gkg,
#                    al=SFdat$Alw_gkg, fe=SFdat$Few_gkg, tn=SFdat$Nw_gkg)
# # SFdat$ca_stock<-as.numeric.factor(SFdat$ca_stock)#convert the factors to numbers!
# # SFdat$mg_stock<-as.numeric.factor(SFdat$mg_stock)#
# # SFdat$tn<-as.numeric.factor(SFdat$tn)#
# #SFdat$al_stock<- as.numeric.factor(SFdat$al_stock)
# #SFdat$fe_stock<- as.numeric.factor(SFdat$fe_stock)

#dat_multi<- read.csv("./Paper5_heavymetals/Data/R_stuff/SA_HeavyMetals_R.csv", na.strings = "< LOD")
#dat_multi<- data.frame(Lab_No=dat_multi$Sample_id, tFe=dat_multi$Fe, tMn=dat_multi$Mn)

catdat <- read.csv("./Paper2_IR/paper2_soilFert/cations_saturation.csv", na.strings = "NA")
catdat<- data.frame(Lab_No=catdat$Lab_No, ecec=catdat$ECEC_cmolkg, 
                    base_sat=catdat$BS, #acid_sat=catdat$AS, 
                    exbase=catdat$exbase)

#combine the three dfs
#exdat<- merge(x=SOMdat, y=SFdat)
exdat<- merge(x=SOMdat, y=catdat)

#build a new dataframe with only the stocks from the older version. l
sub_dfp<- data.frame(class = df_P$Classification, Lab_No = df_P$Lab_No, #farms=df_P$farms,
                     pH = df_P$pH, 
                     Ppa = df_P$PaB_mgkg,
                     Psom = df_P$PsB_mgkg,
                     Pca = df_P$PcB_mgkg,
                     Pocc = df_P$PoB_mgkg,
                     sumToTAL = df_P$PtB,
                     ptot = df_P$tp_bulk,
                     som = df_P$LOI_SOMw_gkg,
                     x = df_P$Location_x, 
                     y = df_P$Location_y)

df1<- merge(x=df_P, y=exdat)#adding other data by merging
#df1$sic[df1$sic<=0.00]<- NA #for converting all zeros to NA
#df1<-df1[,-1]

#Log version of df1 dataset 

df_P<- data.frame(class=df1$class, farms= df1$farms, pH=df1$pH,SOM=df1$som,
                  bulkD=df1$bulk,logxSkeleton=log(df1$skeleton+1),
                  ECEC= df1$ecec,SOC= df1$soc, CN=df1$CN, SIC=df1$sic,
                  TN=df1$tn, TC=df1$tc, 
                  ExMg= df1$mg,ExCa=df1$ca, #tMn= df1$tMn,
                  ExBases=df1$exbase, #ExAcid=df1$exacid,
                  exFe=df1$fe, exAl=df1$al,#exacid=df1$exacid,
                  logPpa= log(df1$Ppa),
                  logPsom= log (df1$Psom),
                  logPca= log (df1$Pca),
                  logxPocc= log(df1$Pocc+1),
                  logsumPtotal= log (df1$sumToTAL)) # define the data to be used

#######
#write.csv(df1, "./Paper 4_Pfractions/Data/P_data_new_2_02122019.csv")

df1<- read.csv("./Paper 4_Pfractions/Data/P_data_new_2_02122019.csv", na.strings = "NA")
  df1$class<- factor (df1$class, levels = c("Long-term", "Short-term", "FOREST", "RURAL"))

  df1$class <- factor(df1$class, levels=c("Long-term", "Short-term", "FOREST", "RURAL"), 
                      labels=c("Long-term", "Short-term", "Forest", "Rural"))   
  
#Selecting only urban soils 
dfPm <- df1[df1$class %in% c("Long-term","Short-term"),] %>%
  mutate(class = factor(class)) 

  dfPm$class<- relevel(dfPm$class, ref="Short-term") # switching the order of the classes

dfL<- df1[df1$class %in% "Long-term",] %>%
  mutate(class = factor(class)) 

dfS<- df1[df1$class %in% "Short-term",] %>%
  mutate(class = factor(class))

dfR<- df1[df1$class %in% "Rural",] %>%
  mutate(class = factor(class))

dfF<- df1[df1$class %in% "Forest",] %>%
  mutate(class = factor(class))


# rm(catdat);rm(SFdat);rm(SOMdat);rm(sub_dfp);rm(exdat); 
# 
# Df_pca<- df1 %>% filter(!is.na(Pca_ppm)) 
#########################

##############using dplr to calculate based on another colum
#load data with only the 
dfP_deleted<- read.csv("./Paper 4_Pfractions/Data/P_data_new_afterdeleting.csv",dec=".", na.strings = "NA")

df1 %>% filter(!is.na(Pca)) %>% 
  summarise(.,mean(tn))

#####################################################
#Descriptive statistics 
fun <- function (x) {c(mean= mean (x,na.rm=T), max=max (x,na.rm = T), 
                      min=min (x,na.rm = T), median= median (x,na.rm = T), 
                      se= se (x,na.rm = T))#,per=per (x, na.rm = T))
                    }
summaryBy(PtB ~ class, data=df1,
          FUN = fun)#list (mean (x,na.rm=T), max (x,na.rm = T), 
#     min (x,na.rm = T), median (x,na.rm = T), se (x,na.rm = T))) 





################################################### 
#General code for scatterplots 
sg <- ggplot(df1, aes(y=log(sumToTAL), x=log(CN))) + geom_count() +
  geom_smooth(method="lm", se=T, color="red", linetype=2)

ggMarginal(sg, type = "histogram", fill="transparent")
ggMarginal(sg, type = "boxplot", fill="transparent")
ggMarginal(sg, type = "density", fill="transparent")


#################################################################################
#Comparisons between sum Pfractions and total P 
#Confirm that sum of P fractions = Ptotal from acid digestion
save(P_totalchecks,m1,pTotals, file = "Paper 4_Pfractions/Data/P_totalchecks.RData")
load ("Paper 4_Pfractions/Data/P_totalchecks.RData")

data_summary <- function(x) {
  m <- mean(x)
  ymin <- m-sd(x)
  ymax <- m+sd(x)
  return(c(y=m,ymin=ymin,ymax=ymax))
}
# loadandinstall("yarrr")
# ptotals<- pirateplot ( formula = log(value)~ variable, 
#                        data=P_totalchecks, theme=4,
#                         pal="southpark")

P_totalchecks$y_pos <- aggregate(log10(value) ~ variable,P_totalchecks,
                                 function(x) max(density(x)$y))[,2]

#Tryx<- ggplot(ksoil_paramn_new, aes(x=ph, fill = loc)) + geom_density(col=NA, alpha = 0.455) just an example
P_totalchecks<- P_totalchecks %>%  group_by(variable) %>% 
  mutate(n=n()/nrow(P_totalchecks)) #calculating weights and adding it to the table aes(weight=n),

pt_density<- ggplot(P_totalchecks) + aes(x=log10(value), fill = variable, color=variable) + 
  geom_density(aes(weight=n), col=NA, alpha = 0.455) +
  labs(y="Density (normalised)", x=expression(paste(P,' ['~~g*~~m^-2*~']'))) +
  
  #stat_summary(color="black")
  geom_vline(data=P_totalchecks, aes(xintercept=32.49701, colour="#CD5C5C"),
             linetype="dashed", size=0.5)+
  geom_vline(data=P_totalchecks, aes(xintercept=26.89519, colour="#008B8B"),
             linetype="dashed", size=0.5)+
  # geom_text(data = P_totalchecks, aes(label = value, y=y_pos, x=variable)) +
  scale_x_log10()+
  theme_light(base_size=15)+
  theme(axis.text.x = element_text(size=12),
        axis.text.y = element_text(size = 12), #text(face="bold"),
        legend.position="none",
        axis.ticks.x = element_blank(),
        strip.background = element_blank(),
        #strip.text.y=element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,#panel.grid.major.y = element_blank(),
        panel.spacing.x = unit(1.5, "lines"))+
  #theme(axis.text.x = element_text(colour = c("black", "black","black", "black")))+
  #theme(axis.text.x = label_parsed)+
  #scale_x_discrete(labels=c(expression(TP[fractions]), expression(TP)))+
  # stat_summary(color="red", size = 0.5) +
  scale_fill_manual(values= c ("#CD5C5C","#008B8B"))
pt_density 
#geom_vline(data = P_totalchecks, aes(xintercept = mean(value), color = variable),
# linetype = "dashed", size = 1)



pTotals<- ggplot(P_totalchecks)+ aes(x=variable, y=log10(value), fill=variable) + 
  geom_jitter(aes(alpha=0.5))+
  #geom_violin(trim = TRUE, aes(alpha=0.5, weight=n))+ 
  geom_boxplot(width=0.7, outlier.shape=8, aes(alpha=0.5))+ 
  # geom_bar(aes(y=))+
  #scale_x_log10()+
  labs(x="", y=expression(paste(P,' ['~~g*~~m^-2*~']'))) + 
  #facet_grid(districts~., scale = "free")+
  #scale_x_discrete(limits=c("1985", "2003", "2017"))+                            (paste('Stocks of  ', 
  # sum(P[fractions], fractions=1, n)
  #coord_flip()+
  theme_light(base_size=15)+
  theme(axis.text.x = element_text(size=12),
        axis.text.y = element_text(size = 12), #text(face="bold"),
        legend.position="none",
        axis.ticks.x = element_blank(),
        strip.background = element_blank(),
        #strip.text.y=element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,#panel.grid.major.y = element_blank(),
        panel.spacing.x = unit(1.5, "lines"))+
  theme(axis.text.x = element_text(colour = c("black", "black","black", "black")))+
  #theme(axis.text.x = label_parsed)+
  scale_x_discrete(labels=c(expression(sum(TP[fractions], fractions=1,n), P[T])))+
  stat_summary(color="red", size = 0.5) +
  scale_fill_manual(values= c ("#CD5C5C","#008B8B")) 
pTotals
#

FigAppendix <- plot_grid( pTotals,pt_density,  labels=c("A","B"),
                          nrow=1,ncol=2, rel_heights = c(1),rel_widths=c(1,1))
FigAppendix
#
tiff("./Paper 4_Pfractions/Drafts/Figures/Appendix1.tif  ", 
     height =10, width =20, units = 'cm', compression = "lzw", res = 600)
plot(FigAppendix)
dev.off()

#CHAPTER 2: GENERAL BOXPLOTS 
#Figure 4: All boxplots of P
# use data from the prepared data = df1 and df2

#Ppa fine
ppa.f <- ggplot(df1) + aes(x=class, y=log10(PaF_mgkg), fill=class) + #geom_jitter(aes(alpha=0.8))+
  geom_violin(trim = F,width= 1) + 
  geom_boxplot(width=0.4, outlier.shape=8, fill="white", aes(alpha=0.4))+
  labs(x="", y=expression(paste(P[Pa],' ['~~mg*~~kg^-1*~']'))) + 
  theme_light(base_size=15)+
  theme(axis.text.x = element_text(size=12),
        axis.text.y = element_text(size = 12), #text(face="bold"),
        legend.position="none",
        axis.ticks.x = element_blank(),
        strip.background = element_blank(),
        #strip.text.y=element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,#panel.grid.major.y = element_blank(),
        panel.spacing.x = unit(1.5, "lines"))+
  theme (axis.text.x = element_text(colour = c("grey", "grey", "black", "black")))+
  scale_x_discrete(limits=c("Rural","Forest","Short-term", "Long-term"))+
  stat_summary(color="red", size = 0.5) + #scale_y_log10()+
  scale_fill_manual(values= c("palevioletred2","slateblue1","grey","grey"))

ppa.f

#Ppa bulk 
ppa.b <- ggplot(df1) + aes(x=class, y=log10(PaB_mgkg), fill=class) + #geom_jitter(aes(alpha=0.8))+
  geom_violin(trim = F,width= 1) + 
  geom_boxplot(width=0.4, outlier.shape=8, fill="white", aes(alpha=0.4))+
  labs(x="", y=expression(paste(P[Pa],' ['~~mg*~~kg^-1*~']'))) + 
  theme_light(base_size=15)+
  theme(axis.text.x = element_text(size=12),
        axis.text.y = element_text(size = 12), #text(face="bold"),
        legend.position="none",
        axis.ticks.x = element_blank(),
        strip.background = element_blank(),
        #strip.text.y=element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,#panel.grid.major.y = element_blank(),
        panel.spacing.x = unit(1.5, "lines"))+
  scale_x_discrete(limits=c("Rural","Forest","Short-term", "Long-term"))+
  theme (axis.text.x = element_text(colour = c("grey", "grey", "black", "black")))+
  stat_summary(color="red", size = 0.5) + #scale_y_log10()+
  scale_fill_manual(values= c("palevioletred2","slateblue1","grey","grey"))
ppa.b


#Ppa stocks 
ppa.s <- ggplot(df1) + aes(x=class, y=log10(PaS_mgkg), fill=class) + #geom_jitter(aes(alpha=0.8))+
  geom_violin(trim = F, width=1) + 
  geom_boxplot(width=0.4, outlier.shape=8,fill="white", aes(alpha=0.4))+
  labs(x="", y=expression(paste(P[Pa],'( ['~~g*~~m^-2*~']'))) + 
  theme_light(base_size=15)+
  theme(axis.text.x = element_text(size=12),
        axis.text.y = element_text(size = 12), #text(face="bold"),
        legend.position="none",
        axis.ticks.x = element_blank(),
        strip.background = element_blank(),
        #strip.text.y=element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,#panel.grid.major.y = element_blank(),
        panel.spacing.x = unit(1.5, "lines"))+
  scale_x_discrete(limits=c("Rural","Forest","Short-term", "Long-term"))+
  theme (axis.text.x = element_text(colour = c("grey", "grey", "black", "black")))+
  stat_summary(color="red", size = 0.5) + #scale_y_log10()+
  scale_fill_manual(values= c("palevioletred2","slateblue1","grey","grey"))
ppa.s

#PSOM fine 
psom.f <- ggplot(df1) + aes(x=class, y=PsF_mgkg, fill=class) +  #geom_jitter(aes(alpha=0.8))+
  geom_violin(trim = F, width=1) + 
  geom_boxplot(width=0.4, outlier.shape=8,fill="white", aes(alpha=0.4))+
  labs(x="", y=expression(paste(P[SOM],'['~~mg*~~kg^-1*~']'))) + 
  theme_light(base_size=15)+
  theme(axis.text.x = element_text(size=12),
        axis.text.y = element_text(size = 12), #text(face="bold"),
        legend.position="none",
        axis.ticks.x = element_blank(),
        strip.background = element_blank(),
        #strip.text.y=element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,#panel.grid.major.y = element_blank(),
        panel.spacing.x = unit(1.5, "lines"))+
  scale_x_discrete(limits=c("Rural","Forest","Short-term", "Long-term"))+
  theme (axis.text.x = element_text(colour = c("grey", "grey", "black", "black")))+
  stat_summary(color="red", size = 0.5) + scale_y_log10()+
  scale_fill_manual(values= c("palevioletred2","slateblue1","grey","grey"))
psom.f

#PSOM bulk
psom.b <- ggplot(df1) + aes(x=class, y=PsB_mgkg, fill=class) +  #geom_jitter(aes(alpha=0.8))+
  geom_violin(trim = F, width=1) + 
  geom_boxplot(width=0.4, outlier.shape=8,fill="white", aes(alpha=0.4))+
  labs(x="", y=expression(paste(P[SOM],'['~~mg*~~kg^-1*~']'))) + 
  theme_light(base_size=15)+
  theme(axis.text.x = element_text(size=12),
        axis.text.y = element_text(size = 12), #text(face="bold"),
        legend.position="none",
        axis.ticks.x = element_blank(),
        strip.background = element_blank(),
        #strip.text.y=element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,#panel.grid.major.y = element_blank(),
        panel.spacing.x = unit(1.5, "lines"))+
  scale_x_discrete(limits=c("Rural","Forest","Short-term", "Long-term"))+
  theme (axis.text.x = element_text(colour = c("grey", "grey", "black", "black")))+
  stat_summary(color="red", size = 0.5) + scale_y_log10()+
  scale_fill_manual(values= c("palevioletred2","slateblue1","grey","grey"))
psom.b


#PSOM stock
psom.s <- ggplot(df1) + aes(x=class, y=PsS_mgkg, fill=class) +  #geom_jitter(aes(alpha=0.8))+
  geom_violin(trim = F, width=1) + 
  geom_boxplot(width=0.4, outlier.shape=8,fill="white", aes(alpha=0.4))+
  labs(x="", y=expression(paste(P[SOM],'['~~g*~~m^-2*~']'))) + 
  theme_light(base_size=15)+
  theme(axis.text.x = element_text(size=12),
        axis.text.y = element_text(size = 12), #text(face="bold"),
        legend.position="none",
        axis.ticks.x = element_blank(),
        strip.background = element_blank(),
        #strip.text.y=element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,#panel.grid.major.y = element_blank(),
        panel.spacing.x = unit(1.5, "lines"))+
  scale_x_discrete(limits=c("Rural","Forest","Short-term", "Long-term"))+
  theme (axis.text.x = element_text(colour = c("grey", "grey", "black", "black")))+
  stat_summary(color="red", size = 0.5) + scale_y_log10()+
  scale_fill_manual(values= c("palevioletred2","slateblue1","grey","grey"))
psom.s

#
#PCa fine 

pca.f <- ggplot(df1) + aes(x=class, y=PcF_mgkg, fill=class) +  #geom_jitter(aes(alpha=0.8))+
  geom_violin(trim = F, width=1) + 
  geom_boxplot(width=0.4, outlier.shape=8,fill="white", aes(alpha=0.4))+
  labs(x="", y=expression(paste(P[Ca],'['~~mg*~~kg^-1*~']'))) + 
  theme_light(base_size=15)+
  theme(axis.text.x = element_text(size=12),
        axis.text.y = element_text(size = 12), #text(face="bold"),
        legend.position="none",
        axis.ticks.x = element_blank(),
        strip.background = element_blank(),
        #strip.text.y=element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,#panel.grid.major.y = element_blank(),
        panel.spacing.x = unit(1.5, "lines"))+
  scale_x_discrete(limits=c("Rural","Forest","Short-term", "Long-term"))+
  theme (axis.text.x = element_text(colour = c("grey", "grey", "black", "black")))+
  stat_summary(color="red", size = 0.5) + scale_y_log10()+
  scale_fill_manual(values= c("palevioletred2","slateblue1","grey","grey"))

pca.f

#Pca bulk 
pca.b <- ggplot(df1) + aes(x=class, y=PcB_mgkg, fill=class) +  #geom_jitter(aes(alpha=0.8))+
  geom_violin(trim = F, width=1) + 
  geom_boxplot(width=0.4, outlier.shape=8,fill="white", aes(alpha=0.4))+
  labs(x="", y=expression(paste(P[Ca],'['~~mg*~~kg^-1*~']'))) + 
  theme_light(base_size=15)+
  theme(axis.text.x = element_text(size=12),
        axis.text.y = element_text(size = 12), #text(face="bold"),
        legend.position="none",
        axis.ticks.x = element_blank(),
        strip.background = element_blank(),
        #strip.text.y=element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,#panel.grid.major.y = element_blank(),
        panel.spacing.x = unit(1.5, "lines"))+
  scale_x_discrete(limits=c("Rural","Forest","Short-term", "Long-term"))+
  theme (axis.text.x = element_text(colour = c("grey", "grey", "black", "black")))+
  stat_summary(color="red", size = 0.5) + scale_y_log10()+
  scale_fill_manual(values= c("palevioletred2","slateblue1","grey","grey"))

pca.b

#Pca stock
#Samples that had more than 500 g m-2:
#Maxima5-2-8, Kenyasi2, sepe1, gyinyase9
pca.s <- ggplot(df1) + aes(x=class, y=PcS_mgkg, fill=class) +  #geom_jitter(aes(alpha=0.8))+
  geom_violin(trim = F, width=1) + 
  geom_boxplot(width=0.4, outlier.shape=8,fill="white", aes(alpha=0.4))+
  labs(x="", y=expression(paste(P[Ca],'['~~g*~~m^-2*~']'))) + 
  theme_light(base_size=15)+
  theme(axis.text.x = element_text(size=12),
        axis.text.y = element_text(size = 12), #text(face="bold"),
        legend.position="none",
        axis.ticks.x = element_blank(),
        strip.background = element_blank(),
        #strip.text.y=element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,#panel.grid.major.y = element_blank(),
        panel.spacing.x = unit(1.5, "lines"))+
  scale_x_discrete(limits=c("Rural","Forest","Short-term", "Long-term"))+
  theme (axis.text.x = element_text(colour = c("grey", "grey", "black", "black")))+
  stat_summary(color="red", size = 0.5) + scale_y_log10()+
  scale_fill_manual(values= c("palevioletred2","slateblue1","grey","grey"))

pca.s

#Pocc fine 
pocc.f <- ggplot(df1) + aes(x=class, y=PoF_mgkg, fill=class) +  #geom_jitter(aes(alpha=0.8))+
  geom_violin(trim = F, width=1) + 
  geom_boxplot(width=0.4, outlier.shape=8,fill="white", aes(alpha=0.4))+
  labs(x="", y=expression(paste(P[OCC],'['~~mg*~~kg^-1*~']'))) + 
  theme_light(base_size=15)+
  theme(axis.text.x = element_text(size=12),
        axis.text.y = element_text(size = 12), #text(face="bold"),
        legend.position="none",
        axis.ticks.x = element_blank(),
        strip.background = element_blank(),
        #strip.text.y=element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,#panel.grid.major.y = element_blank(),
        panel.spacing.x = unit(1.5, "lines"))+
  scale_x_discrete(limits=c("Rural","Forest","Short-term", "Long-term"))+
  theme (axis.text.x = element_text(colour = c("grey", "grey", "black", "black")))+
  stat_summary(color="red", size = 0.5) + scale_y_log10()+
  scale_fill_manual(values= c("palevioletred2","slateblue1","grey","grey"))

pocc.f

#Pocc bulk
pocc.b <- ggplot(df1) + aes(x=class, y=PoB_mgkg, fill=class) +  #geom_jitter(aes(alpha=0.8))+
  geom_violin(trim = F, width=1) + 
  geom_boxplot(width=0.4, outlier.shape=8,fill="white", aes(alpha=0.4))+
  labs(x="", y=expression(paste(P[OCC],'['~~mg*~~kg^-1*~']'))) + 
  theme_light(base_size=15)+
  theme(axis.text.x = element_text(size=12),
        axis.text.y = element_text(size = 12), #text(face="bold"),
        legend.position="none",
        axis.ticks.x = element_blank(),
        strip.background = element_blank(),
        #strip.text.y=element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,#panel.grid.major.y = element_blank(),
        panel.spacing.x = unit(1.5, "lines"))+
  scale_x_discrete(limits=c("Rural","Forest","Short-term", "Long-term"))+
  theme (axis.text.x = element_text(colour = c("grey", "grey", "black", "black")))+
  stat_summary(color="red", size = 0.5) + scale_y_log10()+
  scale_fill_manual(values= c("palevioletred2","slateblue1","grey","grey"))

pocc.b

#Pocc stock
pocc.s <- ggplot(df1) + aes(x=class, y=PoS_mgkg, fill=class) +  #geom_jitter(aes(alpha=0.8))+
  geom_violin(trim = F, width=1) + 
  geom_boxplot(width=0.4, outlier.shape=8,fill="white", aes(alpha=0.4))+
  labs(x="", y=expression(paste(P[OCC],'['~~g*~~m^-2*~']'))) + 
  theme_light(base_size=15)+
  theme(axis.text.x = element_text(size=12),
        axis.text.y = element_text(size = 12), #text(face="bold"),
        legend.position="none",
        axis.ticks.x = element_blank(),
        strip.background = element_blank(),
        #strip.text.y=element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,#panel.grid.major.y = element_blank(),
        panel.spacing.x = unit(1.5, "lines"))+
  scale_x_discrete(limits=c("Rural","Forest","Short-term", "Long-term"))+
  theme (axis.text.x = element_text(colour = c("grey", "grey", "black", "black")))+
  stat_summary(color="red", size = 0.5) + scale_y_log10()+
  scale_fill_manual(values= c("palevioletred2","slateblue1","grey","grey"))

pocc.s

#sum of total P fine 
pt.f <- ggplot(df1) + aes(x=class, y=log10(PtF), fill=class) + #geom_jitter(aes(alpha=0.8))+
  geom_violin(trim = F, width=1) + 
  geom_boxplot(width=0.4, outlier.shape=8,fill="white", aes(alpha=0.4))+
  labs(x="", y=expression(paste(sum(TP[fractions],fractions=1, 4),'['~~mg*~~kg^-1*~']'))) + 
  theme_light(base_size=15)+
  theme(axis.text.x = element_text(size=12),
        axis.text.y = element_text(size = 12), #text(face="bold"),
        legend.position="none",
        axis.ticks.x = element_blank(),
        strip.background = element_blank(),
        #strip.text.y=element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,#panel.grid.major.y = element_blank(),
        panel.spacing.x = unit(1.5, "lines"))+
  scale_x_discrete(limits=c("Rural","Forest","Short-term", "Long-term"))+
  theme (axis.text.x = element_text(colour = c("grey", "grey", "black", "black")))+
  stat_summary(color="red", size = 0.5) + scale_y_log10()+
  scale_fill_manual(values= c("palevioletred2","slateblue1","grey","grey"))

pt.f

#sum total P bulk
pt.b <- ggplot(df1) + aes(x=class, y=log10(PtB), fill=class) + #geom_jitter(aes(alpha=0.8))+
  geom_violin(trim = F, width=1) + 
  geom_boxplot(width=0.4, outlier.shape=8,fill="white", aes(alpha=0.4))+
  labs(x="", y=expression(paste(sum(TP[fractions],fractions=1, 4),'['~~mg*~~kg^-1*~']'))) + 
  theme_light(base_size=15)+
  theme(axis.text.x = element_text(size=12),
        axis.text.y = element_text(size = 12), #text(face="bold"),
        legend.position="none",
        axis.ticks.x = element_blank(),
        strip.background = element_blank(),
        #strip.text.y=element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,#panel.grid.major.y = element_blank(),
        panel.spacing.x = unit(1.5, "lines"))+
  scale_x_discrete(limits=c("Rural","Forest","Short-term", "Long-term"))+
  theme (axis.text.x = element_text(colour = c("grey", "grey", "black", "black")))+
  stat_summary(color="red", size = 0.5) + scale_y_log10()+
  scale_fill_manual(values= c("palevioletred2","slateblue1","grey","grey"))

pt.b
#sum of total P
pt.s <- ggplot(df1) + aes(x=class, y=log10(PtS_mgkg), fill=class) + #geom_jitter(aes(alpha=0.8))+
  geom_violin(trim = F, width=1) + 
  geom_boxplot(width=0.4, outlier.shape=8,fill="white", aes(alpha=0.4))+
  labs(x="", y=expression(paste(sum(TP[fractions],fractions=1, 4),'['~~g*~~m^-2*~']'))) + 
  theme_light(base_size=15)+
  theme(axis.text.x = element_text(size=12),
        axis.text.y = element_text(size = 12), #text(face="bold"),
        legend.position="none",
        axis.ticks.x = element_blank(),
        strip.background = element_blank(),
        #strip.text.y=element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,#panel.grid.major.y = element_blank(),
        panel.spacing.x = unit(1.5, "lines"))+
  scale_x_discrete(limits=c("Rural","Forest","Short-term", "Long-term"))+
  theme (axis.text.x = element_text(colour = c("grey", "grey", "black", "black")))+
  stat_summary(color="red", size = 0.5) + scale_y_log10()+
  scale_fill_manual(values= c("palevioletred2","slateblue1","grey","grey"))

pt.s

fig4<- plot_grid(ppa.f,ppa.b,ppa.s, psom.f, psom.b, psom.s, pca.f, pca.b,pca.s, pocc.f,pocc.b,pocc.s, pt.f,pt.b,pt.s,
                 labels=c("A","B","C", "D", "E", "F", "G", "H", "I","J", "K", "L", "M", "N", "O"),    #this plots the box plots
                 nrow=5,ncol=3, rel_heights = c(1),rel_widths=c(1,1))
fig4

#print as .tif
tiff("./Paper 4_Pfractions/Drafts/Figures/Fig_BoxplotsAll_ContStock.tif",
     height =38, width =33, units = 'cm',
     compression = "lzw", res = 600)
plot(fig4)
dev.off()

###################################################
#CHAPTER 1: USING LINEAR MODELS TO COMPARE URBAN SOILS 
set.seed(123321)
#plant available P- fine contents 
mfcontentsPpa<- lm(log10(PaF_mgkg)~class, data=dfPm)
hist(resid(mfcontentsPpa))
summary(mfcontentsPpa)
CImfcontentsPpa<- confint(mfcontentsPpa, method="boot")

#Plant available P - bulk contents 
mcontentsPpa<- lm(log10(PaB_mgkg)~class, data=dfPm)
hist(resid(mcontentsPpa))
summary(mcontentsPpa)
CImcontentsPpa<- confint(mcontentsPpa, method="boot")

#Stocks 
mstocksPpa<- lm(log10(PaS_mgkg)~class, data=dfPm)
hist(resid(mstocksPpa))
summary(mstocksPpa)
CImstocksPpa<- confint(mstocksPpa, method="boot")

#SOM bound P - fine Contents 
mfcontentsPsom<- lm(log10(PsF_mgkg)~class, data=dfPm)
hist(resid(mfcontentsPsom))
summary(mfcontentsPsom)
CImfcontentsPsom<- confint(mfcontentsPsom, method="boot")

#SOM bound P - bulk Contents 
mcontentsPsom<- lm(log10(PsB_mgkg)~class, data=dfPm)
hist(resid(mcontentsPsom))
summary(mcontentsPsom)
CImcontentsPsom<- confint(mcontentsPsom, method="boot")

#stocks
mstocksPsom<- lm(log10(PsS_mgkg)~class, data=dfPm)
hist(resid(mstocksPsom))
summary(mstocksPsom)
CImstockssPsom<- confint(mstocksPsom, method="boot")

#Ca bound P - fine contents
mfcontentsPca<- lm(log10(PcF_mgkg)~class, data=dfPm)
hist(resid(mfcontentsPca))
summary(mfcontentsPca)
CImfcontentsPca<- confint(mfcontentsPca, method="boot")

#Ca bound P - bulk contents
mcontentsPca<- lm(log10(PcB_mgkg)~class, data=dfPm)
hist(resid(mcontentsPca))
summary(mcontentsPca)
CImcontentsPca<- confint(mcontentsPca, method="boot")

#Stocks
mstocksPca<- lm(log10(PcS_mgkg)~class, data=dfPm)
hist(resid(mstocksPca))
summary(mstocksPca)
CImstocksPca<- confint(mstocksPca, method="boot")

#Occluded P - fine Contents
mfcontentsPocc<- lm(log10(PoF_mgkg)~class, data=dfPm)
hist(resid(mfcontentsPocc))
summary(mfcontentsPocc)
CImfcontentsPocc<- confint(mfcontentsPocc, method="boot")

#Occluded P - fine Contents
mcontentsPocc<- lm(log10(PoB_mgkg)~class, data=dfPm)
hist(resid(mcontentsPocc))
summary(mcontentsPocc)
CImcontentsPocc<- confint(mcontentsPocc, method="boot")

#Stocks
mstocksPocc<- lm(log10(PoS_mgkg)~class, data=dfPm)
hist(resid(mstocksPocc))
summary(mstocksPocc)
CImstocksPocc<- confint(mstocksPocc, method="boot")

#Total P - finecontents
mfcontentsPsumtotal<- lm(log10(PtF)~class, data=dfPm)
hist(resid(mfcontentsPsumtotal))
summary(mfcontentsPsumtotal)
CImfcontentsPsumtotal<- confint(mfcontentsPsumtotal, method="boot")

#Total P - bulk contents
mcontentsPsumtotal<- lm(log10(PtB)~class, data=dfPm)
hist(resid(mcontentsPsumtotal))
summary(mcontentsPsumtotal)
CImcontentsPsumtotal<- confint(mcontentsPsumtotal, method="boot")

#Stocks
mPstockssumtotal<- lm(log10(PtS_mgkg)~class, data=dfPm)
hist(resid(mPstockssumtotal))
summary(mPstockssumtotal)
CImstocksPsumtotal<- confint(mPstockssumtotal, method="boot")


#saving all models as an object 
save (mcontentsPpa,mstocksPpa, mcontentsPsom, mstocksPsom, mcontentsPca,mstocksPca,
      mcontentsPocc, mstocksPocc, mcontentsPsumtotal,mPstockssumtotal,
      file = "Paper 4_Pfractions/Data/P_comparisons_modelTable.RData")
load ("Paper 4_Pfractions/Data/P_comparisons_modelTable.RData")

dat <- data.frame(par=NA,est=NA)
indx <- ls()[grep("m",ls())]
for ( i in indx){
  dat <- rbind(dat,data.frame(par=substring(i,2,nchar(i)),
                              est=coefficients(get(i))[2]))  
}
dat <- dat[-1,]
rownames(dat) <- 1:nrow(dat)
dat

rm(list=ls()[-grep("dat",ls())]) #clear objects except "dat"

#Creating a table from the confindence estimates 
# CI_table <- data.frame(CImPpa, CImPsom, CImPca, CImPocc)
# colnames(CI_table)<- c("Ppa_H", "Ppa_L", "Psom_H", "Psom_L", 
#                        "Pca_H", "Pca_L", "Pocc_H", "Pocc_L")
save(CImcontentsPpa,CImstocksPpa, CImcontentsPsom, CImstockssPsom, 
     CImcontentsPca,CImstocksPca, CImcontentsPocc, CImstocksPocc,
     CImcontentsPsumtotal, CImstocksPsumtotal,
     file="Paper 4_Pfractions/Data/P_CImodels.RData")
load("Paper 4_Pfractions/Data/P_CImodels.RData")

dat2 <- data.frame(par=NA, lwr=NA, upr=NA)
indx <- ls()[grep("CI",ls())]

for ( i in indx){
  dat2 <- rbind(dat2,data.frame(par=substring(i,5,nchar(i)),
                                lwr=get(i)[2,1],upr=get(i)[2,2]))  
}
dat2 <- dat2[-1,]
rownames(dat2) <- 1:nrow(dat2)
dat2

dat2$par<- factor(dat2$par, levels=c("ontentsPca", "ontentsPocc","ontentsPpa", "ontentsPsom", "ontentsPsumtotal",
                                     "tocksPca", "tocksPocc","tocksPpa", "tocksPsumtotal", "tockssPsom"),
                  labels=c("contentsPca", "contentsPocc", "contentsPpa", "contentsPsom", "contentsPsumtotal",
                           "stocksPca", "stocksPocc", "stocksPpa", "Pstockssumtotal", "stocksPsom"))

rm(list=ls()[-grep("dat",ls())]) #clear objects except "dat

dat <- inner_join(dat,dat2) #joining the two tables
rm(dat2)

dat$type <- c("Contents", "Contents","Contents","Contents","Contents",
              "Stocks","Stocks","Stocks","Stocks","Stocks") 
#dat[(dat$lwr < 0 & dat$upr < 0) | (dat$lwr > 0 & dat$upr > 0),"sig"] <- 1

dat$par <- factor(dat$par, levels = c("contentsPca", "contentsPocc", "contentsPpa", "contentsPsom", 
                                      "contentsPsumtotal","Pstockssumtotal","stocksPca", "stocksPocc",
                                      "stocksPpa", "stocksPsom"),
                  labels =  c("P[Ca]", "P[OCC]", "P[Pa]", "P[SOM]", "TP[fractions]", "TP[fractions]",
                              "P[Ca]", "P[OCC]", "P[Pa]", "P[SOM]"))
##write to csv and order accordingly 
write.csv(dat, "./Paper 4_Pfractions/Drafts/R/P_CI_comparativeModels.csv")
dat<- read.csv("./Paper 4_Pfractions/Drafts/R/P_CI_comparativeModels.csv")
#dat$par<- factor(dat$par, levels = c( "TP[fractions]","P[Pa]", "P[SOM]","P[Ca]", "P[OCC]")
dat$par <- factor(dat$par, levels = dat$par[order(dat$ord)])


#All the models show that long-term soils were significantly greater in P compared to short-term soils 
##Plotting the the comparative differences
save(dat, file="./Paper 4_Pfractions/Data/ModelEstimates_CIs.RData") #data from the processing of models and CIs
load("./Paper 4_Pfractions/Data/ModelEstimates_CIs.RData")

dat$par<- factor (dat$par, levels = c("P[Pa]", "P[SOM]","P[Ca]", "P[OCC]", "TP[fractions]"))

dat$type<- factor (dat$type, levels = c("Fine", "Bulk","Stocks" ))

pmc.s <- ggplot(dat) + aes(x=par,y=est,ymin=lwr,ymax=upr)+
  geom_hline(yintercept=0,colour="grey")+
  geom_pointrange(size=1.5,fatten=3, colour="palevioletred2") +
  facet_grid(par~type,scale="free", labeller = label_parsed, switch = "y") +
  coord_flip()+
  labs(y="Estimates & confidence intervals",x="")+
  theme_light(base_size=15)+
  theme(axis.text.y = element_blank(),#text(face="bold"),
        legend.position="none",
        strip.background= element_blank(),
        #strip.text.y=element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold", size = 15,angle = 180),
        panel.grid=element_blank())+
 # scale_x_discrete(limits=c("Fine","Bulk","Stock"))+
  ylim(-1, 1)
#
pmc.s

#exporting the tifs
tiff("./Paper 4_Pfractions/Drafts/Figures/Fig_comporativelmodels.tif", 
     height =15, width =20, units = 'cm', compression = "lzw", res = 600)
plot(pmc.s)
dev.off()
###############################

############ CHAPTER 3: THE c:P RATIOS 

#C:P ratios 

df1$PtB.gkg<-df1$PtB/1000 #convert the P in the same unit as the soc--> g kg
#df1$PPa.gkg<-df1$Ppa/1000
#df1$Psom.gkg<-df1$Psom/1000


#Calculate the CP ratio for the total, PPa and the PSOM
df1$OC.TP<- df1$socB/df1$PtB.gkg
df1$OC.PPA<- df1$socB/df1$Pavail_bulk
df1$OC.PSOM<- df1$socB/df1$Psom_bulk


boxplot(df1$OC.PPA~df1$class)
boxplot(df1$OC.TP~df1$class)
boxplot(df1$OC.PSOM~df1$class)

summaryBy(OC.TP ~ class, data=df1,
          FUN = fun)

#Boxplots for the CP ratios 
#soc/ppa
mPPratio<- lm(OC.PPA~class, data= dfPm)
hist(resid(mPPratio))
summary(mPPratio)
CImPPratio<- confint(mPPratio, method= "boot_")

soc.ppa <- ggplot(df1[df1$OC.PPA<2000,]) + aes(x=class, y=OC.PPA, fill=class) +  #geom_jitter(aes(alpha=0.8))+
  geom_violin(trim=F, width=1)+
  geom_boxplot(width=0.4, outlier.shape=8, fill="white", aes(alpha=0.4))+
  labs(x="", y= expression(paste('SOC /',P[Pa]))) + 
  theme_light(base_size=15)+
  theme(axis.text.x = element_text(size=12),
        axis.text.y = element_text(size = 12), #text(face="bold"),
        legend.position="none",
        axis.ticks.x = element_blank(),
        strip.background = element_blank(),
        #strip.text.y=element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,#panel.grid.major.y = element_blank(),
        panel.spacing.x = unit(1.5, "lines"))+
    scale_x_discrete(limits=c("Rural","Forest","Short-term", "Long-term"))+
    theme (axis.text.x = element_text(colour = c("grey", "grey", "black", "black")))+
    stat_summary(color="red", size = 0.5) + #scale_y_log10()+
    scale_fill_manual(values= c("palevioletred2","slateblue1","grey","grey"))
soc.ppa

#SOC/TP

mPTratio<- lm(OC.TP~class, data=dfPm)
hist(resid(mPTratio))
summary(mPTratio)
CImPTratio<- confint(mPTratio, method="boot_")

soc.tp <- ggplot(df1) + aes(x=class, y=OC.TP, fill=class) +  #geom_jitter(aes(alpha=0.8))+
  geom_violin(trim=F, width=1)+ 
  geom_boxplot(width=0.5, outlier.shape=8, fill="white", aes(alpha=0.4))+
  labs(x="", y= expression(paste('SOC /',TP[fractions]))) + 
  theme_light(base_size=15)+
  theme(axis.text.x = element_text(size=12),
        axis.text.y = element_text(size = 12), #text(face="bold"),
        legend.position="none",
        axis.ticks.x = element_blank(),
        strip.background = element_blank(),
        #strip.text.y=element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,#panel.grid.major.y = element_blank(),
        panel.spacing.x = unit(1.5, "lines"))+
  scale_x_discrete(limits=c("Rural","Forest","Short-term", "Long-term"))+
  theme (axis.text.x = element_text(colour = c("grey", "grey", "black", "black")))+
  stat_summary(color="red", size = 0.5) + #scale_y_log10()+
  scale_fill_manual(values= c("palevioletred2","slateblue1","grey","grey"))
soc.tp


FigOCratio <- plot_grid( soc.ppa,soc.tp,  labels=c("A","B"),
                         nrow=1,ncol=2, rel_heights = c(1),rel_widths=c(1,1))
FigOCratio
#
tiff("./Paper 4_Pfractions/Drafts/Figures/CPratios.tif  ", 
     height =10, width =25, units = 'cm', compression = "lzw", res = 600)
plot(FigOCratio)
dev.off()
###############################################
#CHAPTER 3: General information on the P fractions. Box and Barchart to show fractions per strata
#This plot will combine a box plot on the fractions and the percentages per field 
bar.dat2 %>% group_by(variable) %>% summarise(., mean=mean(value[!is.na(value)]))

barchart<- df1[, c(4,11,18,25,32)]
barchart.2<- df1 [, c(4, 13, 20, 27, 34)]

bar.dat<- melt(barchart[,1:5], id.vars = "class"  )
bar.dat2<- melt(barchart.2[,1:5], id.vars = "class" )

######################################################
#calculating percentages

test <- bar.dat %>% dplyr::filter(., class=="Rural") #subsetting particular datasets before using 

sum(test$value[which(test$variable=="PoB_mgkg")], 
    na.rm = TRUE)/ sum(test$value, na.rm = TRUE)
###########################################################

save (bar.dat, file = "./Paper 4_Pfractions/Data/barchartData.RData")
load( "./Paper 4_Pfractions/Data/barchartData.RData")


#box plot of all fractions - Contents
a1 <- ggplot(bar.dat) + aes(x=variable, y=value, fill=variable) + geom_jitter()+
  geom_violin(trim = T, width = 1)+ 
  geom_boxplot(width=0.4, outlier.shape=8, fill="white", aes(alpha=0.4))+ 
  labs(x="", y=expression(paste(P,' ['~~mg*~~kg^-1*~']'))) + 
  theme_light(base_size=15)+
  theme(axis.text.x = element_text(size=12),
        axis.text.y = element_text(size = 12), #text(face="bold"),
        legend.position="none",
        #axis.ticks.x = element_blank(),
        strip.background = element_blank(),
        #strip.text.y=element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,#panel.grid.major.y = element_blank(),
        panel.spacing.x = unit(1.5, "lines"))+
   theme(axis.text.x = element_text(colour = c("black", "black","black", "black")))+
   scale_x_discrete(labels=c(expression(P[Pa]), expression(P[SOM]), 
   expression(P[Ca]), expression(P[OCC]), expression(TP[fraction])))+
  stat_summary(color="red", size = 0.5) + scale_y_log10()+
  scale_fill_manual(values= c ("#018571","#80CDC1","#DFC27D","#A6611A", "grey50")) 
a1


###contents
a2<- ggplot(bar.dat) + aes(x = class, y =value, fill = variable) + 
  geom_bar(stat="identity",  position="fill", width = 0.9)+ #color="white"The position will scale the values, also geom_col can be used instead of geom_bar
  labs(x="", y= expression(paste( 'Contribution',' to TP'[fractions], '  [ % ]'))) + 
  scale_y_continuous(labels = percent_format())+
  theme_light(base_size=15)+
  theme(axis.text.x = element_text(size=16), 
        axis.text.y = element_text(size = 15), #text(face="bold"),
        legend.position="none",
       # axis.ticks.x = element_blank(),
        strip.background = element_blank(),
        #strip.text.y=element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,#panel.grid.major.y = element_blank(),
        panel.spacing.x = unit(1.5, "lines"))+
  theme(axis.text.x = element_text(colour = c("grey", "grey","black", "black")))+
  scale_x_discrete(limits=c("Rural","Forest","Short-term", "Long-term"))+
  scale_fill_manual(values= c ("#018571","#80CDC1","#DFC27D","#A6611A")) 

a2


FigA<- plot_grid(a1,a2,  labels=c("A","B"),
                 nrow=1,ncol=2, rel_heights = c(1),rel_widths=c(1,1))
FigA

tiff("./Paper 4_Pfractions/Drafts/Figures/ALLPs_barchart.tif", 
     height =10, width =24, units = 'cm', compression = "lzw", res = 600)
plot(FigA)
dev.off()

#####################################################
#CHAPTER 4: Correlations and regressions 
#Correlations
cordat<- tibble (class=df_P$class, Ppa= df_P$logPpa, PSOM= df_P$logPsom,     #logged inputs = all P fractions, sum of P, CoarseFraction,
                 PCa=df_P$logPca, POCC=df_P$logxPocc, TPfractions=df_P$logsumPtotal,
                 SOM=df_P$SOM, TC=df_P$TC, TN=df_P$TN, BD=df_P$bulkD, CF=df_P$logxSkeleton,
                 ECEC=df_P$ECEC, ExBases=df_P$ExBases, pH= df_P$pH)

save(corr, p.mat,pcor,df_P, file = "Paper 4_Pfractions/Data/correlationsData.RData")
load("Paper 4_Pfractions/Data/correlationsData.RData")

#correlate all variables including p fractions (log), som, sic, tc, tn, cec, exca, exmg, exfe
corr<- round (cor(cordat[,2:14],use = "pairwise.complete.obs"), 2) # correlation with 2 decimal places 
head(corr[, 1:6])# show the first six rows 
p.mat <- cor_pmat(corr)  # compute a matrix of correlation p-values 
head(p.mat[, 1:4])

#plots
ggcorrplot(corr, method = "circle")
ggcorrplot(corr, hc.order = TRUE, outline.col = "white") #hierarchical clustering 
ggcorrplot(corr, hc.order = TRUE, type = "upper", lab=T, p.mat = p.mat,
           outline.col = "white")
# Leave blank on no significant coefficient
ggcorrplot(corr, p.mat = p.mat, hc.order = TRUE,
           type = "lower", insig = "blank")

# Change colors and theme
pcor<- ggcorrplot(corr, hc.order = FALSE, type = "lower", legend.title = '',
                  outline.col = "grey", insig = "pch", p.mat = p.mat,#pch = 4,
                  ggtheme = ggplot2::theme_classic(base_size=15),lab=T, 
                  colors = c( "#8DD3C7", "#FFFFB3", "#BEBADA"))  #fee0d2 #fc9272 #de2d26

pcor

tiff("./Paper 4_Pfractions/Drafts/Figures/Fig_Contents_corelations.tiff", 
     height =17, width =20, units = 'cm', compression = "lzw", res = 600)
plot(pcor)
dev.off()

setEPS()
postscript("./Paper 4_Pfractions/Drafts/Figures/coreditPlots.eps")
plot(pcor)
###########################################################################################
#Regressions 
#Bivariate linear regressions were used to explore the relationship between 
#the sum of the P fractions (sumPtotal) ~ SOM stocks and soil pH(water)

set.seed(1000)

#### Linear relationships between PPA and the other 3 P fractions
#PPA~PSOM contents
m <- lm (log10(df1$PaB_mgkg)~ log10 (df1$PsB_mgkg))
hist(resid(m))
summary(m)
confint(m, method="boot_")
#
pf.psom<- ggplot(df1) + aes(y=log10(PaB_mgkg), x=log10(PsB_mgkg), color=class) + 
  geom_jitter (size = 2, aes (alpha=0.05))+
  geom_smooth(method = "lm",se=F, linetype=1, aes(color=class))+
  #geom_abline(slope =  0.24371 , intercept =  2.41314, size=1, linetype=2, color="red")+ "italic(R) ^ 2 == 0.1"), 
  labs(y= expression(paste(P[Pa],' ['~~mg*~~kg^-1*~']')), 
    x=expression(paste(P[SOM],'  ['~~mg*~~kg^-1*~']')))+
  theme_light(base_size=10)+
  theme(axis.text.x = element_text(size=12),
        axis.text.y = element_text(size =12), #text(face="bold"),
        legend.position="none",
        #axis.ticks.x = element_blank(),
        strip.background = element_blank(),
        #strip.text.y=element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,#panel.grid.major.y = element_blank(),
        panel.spacing.x = unit(1.5, "lines"))+
    scale_color_manual(values= c("palevioletred2","slateblue1","grey","black"))
#scale_color_manual(values = c("#686868", "#E2E2E2","grey100","grey100"))+theme(legend.position = "none")
pf.psom

#PPA ~ PCA contents 
m <- lm (log10(df1$PaB_mgkg)~ log10 (df1$PcB_mgkg))
hist(resid(m))
summary(m)
confint(m, method="boot_")
#
pf.pca<- ggplot(df1) + aes(y=log10(PaB_mgkg), x=log10(PcB_mgkg), color=class) + 
  geom_jitter (size = 2, aes(alpha=0.05))+
  geom_smooth(method = "lm",se=F, linetype=1, aes(color=class))+
  #geom_abline(slope =  0.24371 , intercept =  2.41314, size=1, linetype=2, color="red")+ "italic(R) ^ 2 == 0.1"), 
  labs(y= "", #expression(paste(P[Pa],'Contents','  (log10) ['~~mg*~~kg^-1*~']')), 
       x=expression(paste(P[Ca],' ['~~mg*~~kg^-1*~']')))+
  theme_light(base_size=10)+
  theme(axis.text.x = element_text(size=12),
        axis.text.y = element_text(size =12), #text(face="bold"),
        legend.position="none",
        #axis.ticks.x = element_blank(),
        strip.background = element_blank(),
        #strip.text.y=element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,#panel.grid.major.y = element_blank(),
        panel.spacing.x = unit(1.5, "lines"))+
  scale_color_manual(values= c("palevioletred2","slateblue1","grey","black"))
#scale_color_manual(values = c("#686868", "#E2E2E2","grey100","grey100"))+theme(legend.position = "none")
pf.pca

#PPA ~ POCC contents 
m <- lm (log10(df1$PaB_mgkg)~ log10 (df1$PoB_mgkg))
hist(resid(m))
summary(m)
confint(m, method="boot_")
#
pf.pocc<- ggplot(df1) + aes(y=log10(PaB_mgkg), x=log10(PoB_mgkg), color=class) + 
  geom_jitter (size = 2, aes(alpha=0.05))+
  geom_smooth(method = "lm",se=F, linetype=1, aes(color=class))+
  #geom_abline(slope =  0.24371 , intercept =  2.41314, size=1, linetype=2, color="red")+ "italic(R) ^ 2 == 0.1"), 
  labs(y= "", # expression(paste(P[Pa],'Contents','  (log10) ['~~mg*~~kg^-1*~']')), 
       x=expression(paste(P[OCC],' ['~~mg*~~kg^-1*~']')))+
  theme_light(base_size=10)+
  theme(axis.text.x = element_text(size=12),
        axis.text.y = element_text(size =12), #text(face="bold"),
        legend.position="none",
        #axis.ticks.x = element_blank(),
        strip.background = element_blank(),
        #strip.text.y=element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,#panel.grid.major.y = element_blank(),
        panel.spacing.x = unit(1.5, "lines"))+
  scale_color_manual(values= c("palevioletred2","slateblue1","grey","black"))
#scale_color_manual(values = c("#686868", "#E2E2E2","grey100","grey100"))+theme(legend.position = "none")
pf.pocc


Figrelations <- plot_grid(pf.psom,pf.pca,pf.pocc,  labels=c("A","B", "C"),
                          nrow=1,ncol=3, rel_heights = c(1),rel_widths=c(1,1))
Figrelations

tiff("./Paper 4_Pfractions/Drafts/Figures/FigX_P_regressions.tif", 
     height =10, width =23, units = 'cm', compression = "lzw", res = 600)
plot(Figrelations)
dev.off()

##########################################
#### P fractions in relation with soil properties 
#PPA~ SOC contents
m <- lm (log10(df1$PaB_mgkg)~ log10 (df1$socB))
hist(resid(m))
summary(m)
confint(m, method="boot_")
#
pa.som<- ggplot(df1) + aes(y=log10(PaB_mgkg), x=log10(socB), color=class) + 
  geom_jitter (size = 2, aes(alpha=0.05))+
  geom_smooth(method = "lm",se=F, linetype=1, aes(color=class))+
  #geom_abline(slope =  0.24371 , intercept =  2.41314, size=1, linetype=2, color="red")+ "italic(R) ^ 2 == 0.1"), 
  labs(y= expression(paste(P[Pa],'  ['~~mg*~~kg^-1*~']')), 
       x=expression(paste(SOC,'  ['~~g*~~kg^-1*~']')))+
  theme_light(base_size=10)+
  theme(axis.text.x = element_text(size=12),
        axis.text.y = element_text(size =12), #text(face="bold"),
        legend.position="none",
        #axis.ticks.x = element_blank(),
        strip.background = element_blank(),
        #strip.text.y=element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,#panel.grid.major.y = element_blank(),
        panel.spacing.x = unit(1.5, "lines"))+
  scale_color_manual(values= c("palevioletred2","slateblue1","grey","black"))

pa.som

## Pa - pH 
m <- lm (log10(df1$PaB_mgkg)~ df1$pH)
hist(resid(m))
summary(m)
confint(m, method="boot_")

pa.ph<- ggplot(df1) + aes(y=log10(PaB_mgkg), x=pH, color=class) + 
  geom_jitter (size = 2, aes(alpha=0.05))+
  geom_smooth(method = "lm",se=F, linetype=1, aes(color=class))+
  #geom_abline(slope =  0.24371 , intercept =  2.41314, size=1, linetype=2, color="red")+ "italic(R) ^ 2 == 0.1"), 
  labs(y= "", # expression(paste(P[Pa],'Contents','  (log10) ['~~mg*~~kg^-1*~']')), 
       x=expression(paste(soil , pH[water])))+
  theme_light(base_size=10)+
  theme(axis.text.x = element_text(size=12),
        axis.text.y = element_text(size =12), 
        legend.position="none",
        strip.background = element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,#panel.grid.major.y = element_blank(),
        panel.spacing.x = unit(1.5, "lines"))+
  scale_color_manual(values= c("palevioletred2","slateblue1","grey","black"))

pa.ph

#PPA~ ECEC
m <- lm (log10(df1$PaB_mgkg)~ log10 (df1$ecec))
hist(resid(m))
summary(m)
confint(m, method="boot_")
#
pa.ecec<- ggplot(df1) + aes(y=log10(PaB_mgkg), x=log10(ecec), color=class) + 
  geom_jitter (size = 2, aes(alpha=0.05))+
  geom_smooth(method = "lm",se=F, linetype=1, aes(color=class))+
 
  labs(y= "", #expression(paste(P[Pa],'Contents','  (log10) ['~~mg*~~kg^-1*~']')), 
       x=expression(paste(ECEC,' ['~~cmol*~~kg^-1*~']')))+
  theme_light(base_size=10)+
  theme(axis.text.x = element_text(size=12),
        axis.text.y = element_text(size =12), #text(face="bold"),
        legend.position="none",
        #axis.ticks.x = element_blank(),
        strip.background = element_blank(),
        #strip.text.y=element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,#panel.grid.major.y = element_blank(),
        panel.spacing.x = unit(1.5, "lines"))+
  scale_color_manual(values= c("palevioletred2","slateblue1","grey","black"))

pa.ecec

#PSOM~ SOM_loi contents
m <- lm (log10(df1$PsB_mgkg)~ log10 (df1$socB))
hist(resid(m))
summary(m)
confint(m, method="boot_")
#
ps.som<- ggplot(df1) + aes(y=log10(PsB_mgkg), x=log10(socB), color=class) + 
  geom_jitter (size = 2, aes(alpha=0.05))+
  geom_smooth(method = "lm",se=F, linetype=1, aes(color=class))+
  #geom_abline(slope =  0.24371 , intercept =  2.41314, size=1, linetype=2, color="red")+ "italic(R) ^ 2 == 0.1"), 
  labs(y= expression(paste(P[SOM],'  ['~~mg*~~kg^-1*~']')), 
       x=expression(paste(SOC,'  ['~~g*~~kg^-1*~']')))+
  theme_light(base_size=10)+
  theme(axis.text.x = element_text(size=12),
        axis.text.y = element_text(size =12), #text(face="bold"),
        legend.position="none",
        #axis.ticks.x = element_blank(),
        strip.background = element_blank(),
        #strip.text.y=element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,#panel.grid.major.y = element_blank(),
        panel.spacing.x = unit(1.5, "lines"))+
  scale_color_manual(values= c("palevioletred2","slateblue1","grey","black"))

ps.som

## Psom - pH 
m <- lm (log10(df1$PsB_mgkg)~ df1$pH)
hist(resid(m))
summary(m)
confint(m, method="boot_")

ps.ph<- ggplot(df1) + aes(y=log10(PsB_mgkg), x=pH, color=class) + 
  geom_jitter (size = 2, aes(alpha=0.05))+
  geom_smooth(method = "lm",se=F, linetype=1, aes(color=class))+
  #geom_abline(slope =  0.24371 , intercept =  2.41314, size=1, linetype=2, color="red")+ "italic(R) ^ 2 == 0.1"), 
  labs(y="", # expression(paste(P[SOM],'Contents','  (log10) ['~~mg*~~kg^-1*~']')), 
       x=expression(paste(soil , pH[water])))+
  theme_light(base_size=10)+
  theme(axis.text.x = element_text(size=12),
        axis.text.y = element_text(size =12), #text(face="bold"),
        legend.position="none",
        #axis.ticks.x = element_blank(),
        strip.background = element_blank(),
        #strip.text.y=element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,#panel.grid.major.y = element_blank(),
        panel.spacing.x = unit(1.5, "lines"))+
  scale_color_manual(values= c("palevioletred2","slateblue1","grey","black"))
#scale_color_manual(values = c("#686868", "#E2E2E2","grey100","grey100"))+theme(legend.position = "none")
ps.ph

#Psom~ ECEC
m <- lm (log10(df1$PsB_mgkg)~ log10 (df1$ecec))
hist(resid(m))
summary(m)
confint(m, method="boot_")
#
ps.ecec<- ggplot(df1) + aes(y=log10(PsB_mgkg), x=log10(ecec), color=class) + 
  geom_jitter (size = 2, aes(alpha=0.05))+
  geom_smooth(method = "lm",se=F, linetype=1, aes(color=class))+
  #geom_abline(slope =  0.24371 , intercept =  2.41314, size=1, linetype=2, color="red")+ "italic(R) ^ 2 == 0.1"), 
  labs(y="",# expression(paste(P[SOM],'Contents','  (log10) ['~~mg*~~kg^-1*~']')), 
       x=expression(paste(ECEC,' ['~~cmol*~~kg^-1*~']')))+
  theme_light(base_size=10)+
  theme(axis.text.x = element_text(size=12),
        axis.text.y = element_text(size =12), #text(face="bold"),
        legend.position="none",
        #axis.ticks.x = element_blank(),
        strip.background = element_blank(),
        #strip.text.y=element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,#panel.grid.major.y = element_blank(),
        panel.spacing.x = unit(1.5, "lines"))+
  scale_color_manual(values= c("palevioletred2","slateblue1","grey","black"))
#scale_color_manual(values = c("#686868", "#E2E2E2","grey100","grey100"))+theme(legend.position = "none")
ps.ecec

#PCA~ SOM_loi contents
m <- lm (log10(df1$PcB_mgkg) ~ log10(df1$socB))
hist(resid(m))
summary(m)
confint(m, method="boot_")

#
pc.som<- ggplot(df1) + aes(y=log10(PcB_mgkg), x=log10 (socB), color=class) + 
  geom_jitter (size = 2, aes(alpha=0.05))+
  geom_smooth(method = "lm",se=F, linetype=1, aes(color=class))+
  #geom_abline(slope =  0.24371 , intercept =  2.41314, size=1, linetype=2, color="red")+ "italic(R) ^ 2 == 0.1"), 
  labs(y= expression(paste(P[Ca],' ['~~g*~~kg^-1*~']')), 
       x=expression(paste(SOC,' ['~~g*~~kg^-1*~']')))+
  theme_light(base_size=10)+
  theme(axis.text.x = element_text(size=12),
        axis.text.y = element_text(size =12), #text(face="bold"),
        legend.position="none",
        #axis.ticks.x = element_blank(),
        strip.background = element_blank(),
        #strip.text.y=element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,#panel.grid.major.y = element_blank(),
        panel.spacing.x = unit(1.5, "lines"))+
  scale_color_manual(values= c("palevioletred2","slateblue1","grey","black"))
#scale_color_manual(values = c("#686868", "#E2E2E2","grey100","grey100"))+theme(legend.position = "none")
pc.som

## PCa - pH 
m <- lm (log10(df1$PaB_mgkg)~ df1$pH)
hist(resid(m))
summary(m)
confint(m, method="boot_")

pc.ph<- ggplot(df1) + aes(y=log10(PcB_mgkg), x=pH, color=class) + 
  geom_jitter (size = 2, aes(alpha=0.05))+
  geom_smooth(method = "lm",se=F, linetype=1, aes(color=class))+
  #geom_abline(slope =  0.24371 , intercept =  2.41314, size=1, linetype=2, color="red")+ "italic(R) ^ 2 == 0.1"), 
  labs(y="", #expression(paste(P[Ca],'Contents','  (log10) ['~~mg*~~kg^-1*~']')), 
       x=expression(paste(soil , pH[water])))+
  theme_light(base_size=10)+
  theme(axis.text.x = element_text(size=12),
        axis.text.y = element_text(size =12), #text(face="bold"),
        legend.position="none",
        #axis.ticks.x = element_blank(),
        strip.background = element_blank(),
        #strip.text.y=element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,#panel.grid.major.y = element_blank(),
        panel.spacing.x = unit(1.5, "lines"))+
  scale_color_manual(values= c("palevioletred2","slateblue1","grey","black"))
#scale_color_manual(values = c("#686868", "#E2E2E2","grey100","grey100"))+theme(legend.position = "none")
pc.ph

#Pca~ ECEC
m <- lm (log10(df1$PcB_mgkg)~ log10 (df1$ecec))
hist(resid(m))
summary(m)
confint(m, method="boot_")
#
pc.ecec<- ggplot(df1) + aes(y=log10(PcB_mgkg), x= log10(ecec), color=class) + 
  geom_jitter (size = 2, aes(alpha=0.05))+
  geom_smooth(method = "lm",se=F, linetype=1, aes(color=class))+
  #geom_abline(slope =  0.24371 , intercept =  2.41314, size=1, linetype=2, color="red")+ "italic(R) ^ 2 == 0.1"), 
  labs(y="", #expression(paste(P[Ca],'Contents','  (log10) ['~~mg*~~kg^-1*~']')), 
       x=expression(paste(ECEC,' (log10) ['~~cmol*~~kg^-1*~']')))+
  theme_light(base_size=10)+
  theme(axis.text.x = element_text(size=12),
        axis.text.y = element_text(size =12), #text(face="bold"),
        legend.position="none",
        #axis.ticks.x = element_blank(),
        strip.background = element_blank(),
        #strip.text.y=element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,#panel.grid.major.y = element_blank(),
        panel.spacing.x = unit(1.5, "lines"))+
  scale_color_manual(values= c("palevioletred2","slateblue1","grey","black"))
#scale_color_manual(values = c("#686868", "#E2E2E2","grey100","grey100"))+theme(legend.position = "none")
pc.ecec

#POCC~ SOM_loi contents
m <- lm (log10(df1$PoB_mgkg)~ log10 (df1$socB))
hist(resid(m))
summary(m)
confint(m, method="boot_")
#
po.som<- ggplot(df1) + aes(y=log10(PoB_mgkg), x=log10(socB), color=class) + 
  geom_jitter (size = 2, aes(alpha=0.05))+
  geom_smooth(method = "lm",se=F, linetype=1, aes(color=class))+
  #geom_abline(slope =  0.24371 , intercept =  2.41314, size=1, linetype=2, color="red")+ "italic(R) ^ 2 == 0.1"), 
  labs(y= expression(paste(P[OCC],'  ['~~mg*~~kg^-1*~']')), 
       x=expression(paste(SOC, '  ['~~g*~~kg^-1*~']')))+
  theme_light(base_size=10)+
  theme(axis.text.x = element_text(size=12),
        axis.text.y = element_text(size =12), #text(face="bold"),
        legend.position="none",
        #axis.ticks.x = element_blank(),
        strip.background = element_blank(),
        #strip.text.y=element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,#panel.grid.major.y = element_blank(),
        panel.spacing.x = unit(1.5, "lines"))+

  scale_color_manual(values= c("palevioletred2","slateblue1","grey","black"))
#scale_color_manual(values = c("#686868", "#E2E2E2","grey100","grey100"))+theme(legend.position = "none")
po.som

## Pocc - pH 
m <- lm (log10(df1$PoB_mgkg)~ log10 (df1$pH))
hist(resid(m))
summary(m)
confint(m, method="boot_")

po.ph<- ggplot(df1) + aes(y=log10(PoB_mgkg), x=pH, color=class) + 
  geom_jitter (size = 2, aes(alpha=0.05))+
  geom_smooth(method = "lm",se=F, linetype=1, aes(color=class))+
  #geom_abline(slope =  0.24371 , intercept =  2.41314, size=1, linetype=2, color="red")+ "italic(R) ^ 2 == 0.1"), 
  labs(y="", # expression(paste(P[OCC],'Contents','  (log10) ['~~mg*~~kg^-1*~']')), 
       x=expression(paste(soil , pH[water])))+
  theme_light(base_size=10)+
  theme(axis.text.x = element_text(size=12),
        axis.text.y = element_text(size =12), #text(face="bold"),
        legend.position="none",
        #axis.ticks.x = element_blank(),
        strip.background = element_blank(),
        #strip.text.y=element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,#panel.grid.major.y = element_blank(),
        panel.spacing.x = unit(1.5, "lines"))+
  scale_color_manual(values= c("palevioletred2","slateblue1","grey","black"))
#scale_color_manual(values = c("#686868", "#E2E2E2","grey100","grey100"))+theme(legend.position = "none")
po.ph

#PPA~ ECEC
m <- lm (log10(df1$PoB_mgkg)~ log10 (df1$ecec))
hist(resid(m))
summary(m)
confint(m, method="boot_")
#
po.ecec<- ggplot(df1) + aes(y=log10(PoB_mgkg), x=log10(ecec), color=class) + 
  geom_jitter (size = 2, aes(alpha=0.05))+
  geom_smooth(method = "lm",se=F, linetype=1, aes(color=class))+
  #geom_abline(slope =  0.24371 , intercept =  2.41314, size=1, linetype=2, color="red")+ "italic(R) ^ 2 == 0.1"), 
  labs(y= "", # expression(paste(P[OCC],'Contents','  (log10) ['~~mg*~~kg^-1*~']')), 
       x=expression(paste(ECEC,' ['~~cmol*~~kg^-1*~']')))+
  theme_light(base_size=10)+
  theme(axis.text.x = element_text(size=12),
        axis.text.y = element_text(size =12), #text(face="bold"),
        legend.position="none",
        #axis.ticks.x = element_blank(),
        strip.background = element_blank(),
        #strip.text.y=element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,#panel.grid.major.y = element_blank(),
        panel.spacing.x = unit(1.5, "lines"))+
 
  scale_color_manual(values= c("palevioletred2","slateblue1","grey","black"))
#scale_color_manual(values = c("#686868", "#E2E2E2","grey100","grey100"))+theme(legend.position = "none")
po.ecec

Figrelations <- plot_grid(pa.som,pa.ph, pa.ecec, ps.som, ps.ph, ps.ecec, pc.som, pc.ph, pc.ecec, po.som, po.ph, po.ecec,
                          labels=c("A","B", "C", "D","E", "F", "G", "H", "I", "J", "K", "L"),
                          nrow=4,ncol=3, rel_heights = c(1),rel_widths=c(1,1))
Figrelations

tiff("./Paper 4_Pfractions/Drafts/Figures/Fig_PregressionsSOM_pH_ecec.tif", 
     height =30, width =23, units = 'cm', compression = "lzw", res = 600)
plot(Figrelations)
dev.off()


##############################################
set.seed(20000)
#CHAPTER 4: Structural equation modelling
save(semdf, fit,  file="./Paper 4_Pfractions/Data/semdata.RData")
load("./Paper 4_Pfractions/Data/semdata.RData")

semDf<- tibble(class= dfPm$class, logxPaB=log10(dfPm$PaB_mgkg), 
               logxPsB=log10(dfPm$PsB_mgkg), logxPcB=log10(dfPm$PcB_mgkg), 
               logxPoB=log10(dfPm$PoB_mgkg), logxECEC=log10(dfPm$ecec), 
               logxSOC=log10(dfPm$socB), pH=dfPm$pH)
#check collinearity
#Package = usdm
vif<-vifstep(dfCL[,c(2:8)],th=10)
vif
# Define the model syntax
model <- '
          # LATENT variables | Soil properties from other studies were used as latent variables 
             #for this work, latent variables were not used
              # SOC =~ logxSOC
              # pHw =~ pH
              # ECEC=~ logxECEC
    
              
          # REGRESSIONS | Linear regressions of all P fractions were related to the soil properties 
             
             #Regressing the individual exogenous and endogenous variables 
              
              logxPaB ~ logxSOC
              logxPaB ~ pH
              logxPaB ~ logxECEC
              
              logxPsB ~ logxSOC
              logxPsB ~ pH
              logxPsB ~ logxECEC

              logxPcB ~ logxSOC
              logxPcB ~ pH
              logxPcB ~ logxECEC

              logxPoB ~ logxSOC
              logxPoB ~ pH
              logxPoB ~ logxECEC
              
            #REGRESSING ALL THE P FRACTIONS... THIS IS IMPORTANT FOR CONVERGING 
              
               logxPaB ~ logxPsB
               logxPaB ~ logxPcB
               logxPaB ~ logxPoB
              
               # logPsom ~ logPca
               # logPsom ~ logxPocc
               # logPsom ~ logPpa
               # 
               # logPca ~ logPpa
               # logPca~ logPsom
               # logPca ~ logxPocc
               # 
               # logxPocc ~ logPpa
               # logxPocc ~ logPca 
               # logxPocc ~ logPsom

          # Residual correlation | This can also be the measurement error 
             # logExCa ~~ logEcec + logExBases
              #ecec~~exBases
              #SOM ~~  SOC + TC
              #TN ~~ TC

          # Intercept of observed variables
              # logxPaB ~ 1
              # logxPsB ~ 1
              # logxPcB ~ 1
              # logxPoB ~ 1
          '

fit<- sem(model, data = semDf, group="class")
varTable(fit) #checking variances 
lavInspect(fit, "cov.lv")
summary(fit, fit.measures=T) #evaluate model perfomance

# Summarize the model
summary(fit, standardized = TRUE, rsq=T)
summary(fit, fit.measures = TRUE, rsq=T)

#export as tif
tiff("./Paper 4_Pfractions/Drafts/Figures/Fig_SEMP.tif",
     height =25, width =30, units = 'cm', compression = "lzw",  bg = "transparent" , res = 600)

 semPaths(fit, edge.label.cex = 1,whatLabels = "std", what= "std",
         style = "lisrel", reorder = FALSE, intercepts = F, 
         layout = "tree",nCharNodes= 0, nCharEdges=0,
         sizeMan=6,  edge.color = "black", mar = c(10, 5, 10, 5),
         fixedStyle = 1,curvePivot = TRUE, #exoVar = FALSE,  #color = "yellow",
         color = list(lat= rgb(220,220,220,maxColorValue = 255), 
                      man = c("#018571","#80CDC1","#DFC27D","#A6611A","white", "white","white") 
                      #exoCov = FALSE, fade=FALSE
         ))  #whatLabels = "eq"

dev.off()

#export as tif
pdf(file="./Paper 4_Pfractions/Drafts/Figures/Fig_SEMP.pdf",
     height =25, width =30) #units = 'cm', compression = "lzw",  bg = "transparent" , res = 600)

semPaths(fit, edge.label.cex = 1,whatLabels = "std", what= "std",
         style = "lisrel", reorder = FALSE, intercepts = F, 
         layout = "tree",nCharNodes= 0, nCharEdges=0,
         sizeMan=6,  edge.color = "black", mar = c(10, 5, 10, 5),
         fixedStyle = 1,curvePivot = TRUE, #exoVar = FALSE,  #color = "yellow",
         color = list(lat= rgb(220,220,220,maxColorValue = 255), 
                      man = c("#018571","#80CDC1","#DFC27D","#A6611A","white", "white","white") 
                      #exoCov = FALSE, fade=FALSE
         ))  #whatLabels = "eq"

dev.off()

#Sending as eps for possible clarity 
setEPS()
postscript("./Paper 4_Pfractions/Drafts/Figures/Fig_SEMPfit.eps")
semPaths(fit, edge.label.cex = 0.5,whatLabels = "std", what= "std",
         style = "lisrel", reorder = FALSE, intercepts = F, 
         layout = "tree",nCharNodes= 0, nCharEdges=0,
         sizeMan=6,  edge.color = "black", mar = c(10, 5, 10, 5),
         fixedStyle = 1,curvePivot = TRUE, #exoVar = FALSE,  #color = "yellow",
         color = list(lat= rgb(220,220,220,maxColorValue = 255), 
                      man = c("white", "white","white", "white", "white", "white", "white",#"white",
                              "white","white","#018571","#80CDC1","#DFC27D","#A6611A") 
                      #exoCov = FALSE, fade=FALSE
         )) 





#C:P ratios 
#import fresh datframe 
#df.ratio<- read.csv("./Paper 4_Pfractions/Data/P_data_new.csv", na.strings = "NA")

df1$sumToTAL.gkg<-df1$sumToTAL/1000 #convert the P in the same unit as the soc--> g kg
df1$PPa.gkg<-df1$Ppa/1000
df1$Psom.gkg<-df1$Psom/1000








































