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

#set environment
# Clear all working environemnt
rm(list=ls()) 

# Clear console
cat("\014")

# Suppress warnings  
#options(warn=-1) 

# Set seed for reproducibility
set.seed(2410)


#=================================Directories===================================
setwd("C:/Users/sasaber/ownCloud - sasaber@gwdg.de@owncloud.gwdg.de/PostDoc/Papers_To_Be_completed_from_PhD/") #office

setwd("E:/ownFolder/PostDoc/Papers_To_Be_completed_from_PhD/")

##================================Load Packages=================================

#Function to load packages
source("C:/Users/sasaber/ownCloud - sasaber@gwdg.de@owncloud.gwdg.de/CODING/R/R_functions/to_intall_load_packages.R")
source("E:/ownFolder/CODING/R/R_functions/to_intall_load_packages.R")

#Function for descriptive statistics
source("C:/Users/sasaber/ownCloud - sasaber@gwdg.de@owncloud.gwdg.de/CODING/R/R_functions/general_functions.R")


pks <- c ("ggplot2", "reshape2", "cowplot", "scales","dplyr","tidyr","lavaan", 
          "semPlot","huge", "OpenMx", "ggcorrplot","lmerTest","RColorBrewer", "ggpmisc", 
          "viridis","ggExtra", "doBy", "usdm", "stringr", "emmeans",  "multcomp"
            )

load_pkg(pks)
#=================================Save analytical state ========================    
# Load Dataset and prepare them
#save.image("./Paper 4_Pfractions/R_analysis_2026on/P_workData.RData")
load("./Paper 4_Pfractions/R_analysis_2026on/P_workData.RData") #for continuation...

##================================Load $ Prepare datasets ======================
#base data for correcting and transforming element contents
ksi_basedata <- read.csv("C:/Users/sasaber/ownCloud - sasaber@gwdg.de@owncloud.gwdg.de/PostDoc/WP1 C dynamics Kumasi/Working folder/Analyses/Database_urbSOC/0_base_soil_variables_all.csv")
ksi_basedata <- read.csv("E:/ownFolder/PostDoc/WP1 C dynamics Kumasi/Working folder/Analyses/Database_urbSOC/0_base_soil_variables_all.csv")

colnames(ksi_basedata)[1] <- "sample_id"

#Base data for all the classes 
ksi_baseclasses <- read.csv("C:/Users/sasaber/ownCloud - sasaber@gwdg.de@owncloud.gwdg.de/PostDoc/WP1 C dynamics Kumasi/Working folder/Analyses/Database_urbSOC/8_base_classes.csv")
ksi_baseclasses <- read.csv("E:/ownFolder/PostDoc/WP1 C dynamics Kumasi/Working folder/Analyses/Database_urbSOC/8_base_classes.csv")

#Join the two base datasets 
ksi_basedata <- plyr::join(ksi_basedata, ksi_baseclasses, "sample_id")

#Base data for total elements - Extraction by HNO3 assessment
ksitotal_elements <- read.csv("C:/Users/sasaber/ownCloud - sasaber@gwdg.de@owncloud.gwdg.de/PostDoc/WP1 C dynamics Kumasi/Working folder/Analyses/Database_urbSOC/9_totalElements_HNO3_jago.csv", na.strings = "NA")
ksitotal_elements <- read.csv("E:/ownFolder/PostDoc/WP1 C dynamics Kumasi/Working folder/Analyses/Database_urbSOC/9_totalElements_HNO3_jago.csv", na.strings = "NA")

#To check duplicates, use this wrapper 
source("C:/Users/sasaber/ownCloud - sasaber@gwdg.de@owncloud.gwdg.de/CODING/R/R_functions/to_check_duplicates.R")
source("E:/ownFolder/CODING/R/R_functions/to_check_duplicates.R")

#dups_by(ksitotal_elements, "sample_id")

#Total p and computing stocks
  ksitotal_P <- ksitotal_elements %>% dplyr::select(sample_id,P_40_gkg,P_105_gkg)
  ksitotal_P <- ksitotal_P %>% dplyr::filter(!is.na(sample_id))
  colnames(ksitotal_P)[2:3] <- c("P_HNO3total_40_gkg", "P_HNO3total_105_gkg")

  #Averaging the duplicates
  ksitotal_P <- ksitotal_P %>%
      group_by(sample_id) %>%
      mutate(n_id = n()) %>%
      ungroup() %>%
      group_by(sample_id) %>%
      summarise(
        across(where(is.numeric), ~ mean(.x, na.rm = TRUE)),
        n_id = first(n_id),              # keep the count for reference
        .groups = "drop"
      ) %>%
        # If you want to keep the original singletons instead of their "mean",
        # you can join them back. Otherwise, this returns one row per id.
  arrange(desc(n_id), sample_id)

#Remove the count column
ksitotal_P[4] <- NULL

#join to the base data 
ksitotal_P <- plyr::join(ksi_basedata, ksitotal_P, "sample_id")

#calculate stocks
ksitotal_P <- ksitotal_P %>% 
  mutate(P_total_HNO3_gm2 = P_HNO3total_105_gkg * fine_earth_kgdm3 * 10 *10,
         P_HNO3total_105_mgkg = P_HNO3total_105_gkg * 1000) 

glimpse (ksitotal_P) #Complete data with total P 

#Base data for total elements - Extraction by aqua-ragia assessment
ksitotal_elements_benedikt <- read.csv("C:/Users/sasaber/ownCloud - sasaber@gwdg.de@owncloud.gwdg.de/PostDoc/WP1 C dynamics Kumasi/Working folder/Analyses/Database_urbSOC/3_SA_TotalElement_subsample_R_benedikt.csv", na.strings = "NA")
ksitotal_elements_benedikt <- read.csv("E:/ownFolder/PostDoc/WP1 C dynamics Kumasi/Working folder/Analyses/Database_urbSOC/3_SA_TotalElement_subsample_R_benedikt.csv", na.strings = "NA")

colnames (ksitotal_elements_benedikt)[1] <- "sample_id"
glimpse(ksitotal_elements_benedikt)

ksitotal_elements_benedikt <- ksitotal_elements_benedikt %>% 
  dplyr::mutate(p_total_multiacid_40_mgkg = P_mgkg) %>% 
  dplyr::select(sample_id, p_total_multiacid_40_mgkg)


#join to the base data 
ksitotal_P <- plyr::join(ksitotal_P, ksitotal_elements_benedikt, "sample_id")

#calculate stocks
ksitotal_P <- ksitotal_P %>% 
  mutate(p_total_multiacid_105_mgkg = p_total_multiacid_40_mgkg * water_factor,
         p_total_multiacid_105_gkg = p_total_multiacid_105_mgkg/1000,
         p_total_multiacid_gm2 = p_total_multiacid_105_gkg * fine_earth_kgdm3 * 10 *10
         ) 

glimpse (ksitotal_P) 

#USING REGRESSION TO INPUT THE MISSING THE DATA IN THE P_HNO3 FROM THE AQUARAGIA

#select the samples with the aquaregia measured (n=56) 

P_totals_comparison <- ksitotal_P %>% 
  dplyr::filter(!is.na(p_total_multiacid_40_mgkg)) %>% 
  dplyr::select(sample_id, P_total_HNO3_gm2, p_total_multiacid_gm2)

#
#I can see from the subset that there were a couple of outliers, but I attribute
#this due to possible missup in the sample_IDs of the analysis done by Benedikt,
#so these ones were removed from further analysis (95, 137, 288)
P_totals_comparison [10,3] <- ""
P_totals_comparison [16,3] <- ""
P_totals_comparison [28,3] <- ""
P_totals_comparison$p_total_multiacid_gm2 <- as.numeric(P_totals_comparison$p_total_multiacid_gm2)

glimpse(P_totals_comparison)

lm_ptotal  <- lm( P_total_HNO3_gm2 ~ p_total_multiacid_gm2 + 0 , 
                  data = P_totals_comparison)

summary(lm_ptotal)
#R2 = 0.99 # Beta = 0.95 when intercept is set to 0 suggesting that HNO3 is on 
#average 95% of the multi-acid extraction measured with ICP-MS


#Taming the data 

#Using the derived equation between the multi-acid digestion and HNO3 digestion 
#fill the gaps in the HNO3 data --> this gap fillng was not used anyway
#just to show that it was possble 
ksitotal_P <- ksitotal_P %>%
  mutate(
    P_total_HNO3_gm2_pred = predict(lm_ptotal, newdata = ksitotal_P),
    P_total_HNO3_gm2_filled = if_else(is.na(P_total_HNO3_gm2), 
                                      P_total_HNO3_gm2_pred, P_total_HNO3_gm2)
  )

glimpse(ksitotal_P)

#
#load_pkg("ggpubr")
load_pkg("ggpmisc")

formula = y~x + 0

p_HNO3_MultiAcid <- ggplot (P_totals_comparison) + 
  aes (x=(p_total_multiacid_gm2), y = (P_total_HNO3_gm2)) + 
  geom_point(aes(alpha=0.5, size=5), fill = "grey", shape=21, col="black", 
             show.legend = F, position = position_jitterdodge(dodge.width = 0.6)) + 
  geom_smooth(method = "lm",se = T, linetype=1, col="black",
              formula = formula)+ xlim(0,73) + ylim(0,73)+ 
  geom_abline(slope = 1, linetype=5, linewidth = 0.6) +
  labs(y=bquote("HNO"[3]~~"P ["~~g*~'P'~~m^-2~']'),
       #title = "Comparing total P extractions",
       x=bquote("Multi-Acid P ["~~g*~'P'~~m^-2~']'), tag="a")+
  theme(legend.position = "top")+
  theme_light(base_size=15)+
  theme(axis.text.x = element_text(size=15),
        axis.text.y = element_text(size = 15),
        legend.position="top",
        strip.background = element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        #panel.grid=element_blank() ,
        panel.spacing.x = unit(1.5, "lines"))+
  # stat_regline_equation(aes(label =  paste(..eq.label.., ..rr.label..,
  #                                          sep = "~~~~")),
  #                       size=5, formula = y~x+0,
  #                       na.rm = TRUE)
  stat_poly_eq(use_label("eq", "R2","P"), formula = y~x+0, 
  size=5)

p_HNO3_MultiAcid
p_HNO3_MultiAcid <- ggMarginal(p_HNO3_MultiAcid, type = "densigram", fill="grey")

p_HNO3_MultiAcid


#Exchangeable cations 

cations_ksi <- read.csv("C:/Users/sasaber/ownCloud - sasaber@gwdg.de@owncloud.gwdg.de/PostDoc/Papers_To_Be_completed_from_PhD/Paper 3_ECEC_BS_N//R_dataAnalysis/2020Analyses/N_CEC_paper2023/CEC_RAW_calculations.csv")
cations_ksi <- read.csv("E:/ownFolder/PostDoc/Papers_To_Be_completed_from_PhD/Paper 3_ECEC_BS_N//R_dataAnalysis/2020Analyses/N_CEC_paper2023/CEC_RAW_calculations.csv")

cations_ksi <- cations_ksi %>% mutate(exch_Ca_stocks_gm2 = Ca_gm2, 
                                      exch_ca_105_cmolkg = Ca_105_cmol_kg, 
                                      exch_Al_stocks_gm2 = Al_gm2, 
                                      exch_Al_105_cmolkg = Al_105_cmol_kg, 
                                      exch_Fe_stocks_gm2 = Fe_gm2, 
                                      exch_Fe_105_cmolkg = Fe_105_cmol_kg) %>% 
                  dplyr::select(sample_id, exch_Ca_stocks_gm2, exch_ca_105_cmolkg, ECEC_105,
                                #exch_Al_stocks_gm2, exch_Al_105_cmolkg, exch_Fe_stocks_gm2, 
                              #exch_Fe_105_cmolkg,  bs
                              )

glimpse(cations_ksi)

#join to the base data 
ksitotal_P <- plyr::join(ksitotal_P, cations_ksi, "sample_id")

#SOC, soil pH, SIC, 
som_ksi <- read.csv2("./Paper 4_Pfractions/Data/GH_SA soil_carbon_2.csv", na.strings = "NA")
colnames(som_ksi)[1] <- "sample_id"
glimpse(som_ksi)

som_ksi <- som_ksi %>% dplyr::select(sample_id, pH, SOCf_gkg, SOC_kgm2,C_N,
                                     farms )

#join to the base data 
ksitotal_P <- plyr::join(ksitotal_P, som_ksi, "sample_id")



#=============== MAIN: P fractions # Data wrangling =============================

# Use the blanks to compute the LOD and LOQ for all the fractions 
pfractions_blanks <- read.csv("./Paper 4_Pfractions/R_analysis_2026on/Raw_data_reassessed/blanks_LOD_LOQ_2026.csv")

# Assumptions:
# - ppm here = mg/L in the extract
# - soil mass used for conversion = 1 g = 0.001 kg
# - extract volumes: 50 mL for pavail/psom/pca; 45 mL for pocc

m_soil_kg <- 0.001
vol_L <- tibble::tribble(
  ~fraction,    ~V_L,
  "pavail_ppm",  0.050,
  "psom_ppm",    0.050,
  "pca_ppm",     0.050,
  "pocc_ppm",    0.045
)

lod_loq_pooled <- pfractions_blanks %>%
  pivot_longer(cols = c(pavail_ppm, psom_ppm, pca_ppm, pocc_ppm),
               names_to = "fraction",
               values_to = "ppm") %>%
  filter(!is.na(ppm)) %>%
  group_by(fraction) %>%
  summarise(
    n = n(),
    blank_sd_mgL = sd(ppm),          # pooled SD across batches
    LOD_mgL = 3 * blank_sd_mgL,
    LOQ_mgL = 10 * blank_sd_mgL,
    .groups = "drop"
  ) %>%
  left_join(vol_L, by = "fraction") %>%
  mutate(
    LOD_mgkg = LOD_mgL * V_L / m_soil_kg,
    LOQ_mgkg = LOQ_mgL * V_L / m_soil_kg,
    LOD_gkg  = LOD_mgkg / 1000,
    LOQ_gkg  = LOQ_mgkg / 1000
  )

lod_loq_pooled

#rename the fractions to be similar to the reference table 

lod_loq_pooled[1] <- c("p_available_40_gkg","p_Ca_40_gkg",
                       "p_OCC_40_gkg","p_SOM_40_gkg")

#Load the P fractions data 
pFractions_ksi <- read.csv("./Paper 4_Pfractions/R_analysis_2026on/Raw_data_reassessed/conentrations_40_Pfractions_2026.csv")
glimpse(pFractions_ksi)
colnames(pFractions_ksi)[1] <- "sample_id"

#Exctract the repeated samples and blanks 

pFractions_references <- pFractions_ksi %>%
  dplyr::filter(str_detect(sample_id, "[A-Za-z]"))

#Extract the house (HS) and own (SA) repeated reference samples
Pcheck_cv_tbl <-  pFractions_references %>%
  filter(str_detect(sample_id, "^(HS|SA)")) %>%
  mutate(ref = str_extract(sample_id, "^(HS|SA)")) %>%
  pivot_longer(
    cols = starts_with("p_"),
    names_to = "fraction",
    values_to = "value"
  ) %>%
  filter(!is.na(value))

Pcheck_cv_tbl

# 2) LOD/LOQ table must have: fraction, LOD_gkg, LOQ_gkg
# If your LOD/LOQ are in mg/kg, convert: LOD_gkg = LOD_mgkg/1000
lod_loq_plot <- lod_loq_pooled %>%
  transmute(
    fraction = fraction,          # should match ref_long$fraction names
    LOD = LOD_gkg,
    LOQ = LOQ_gkg
  )


# 3) box + jitter + LOD/LOQ lines (facet-specific)
Pcheck_cv_tbl$ref <- factor (Pcheck_cv_tbl$ref, 
                             levels = c("HS", "SA"), 
                             labels = c("Temperate", "Tropical"))

Pcheck_cv_tbl$fraction <- factor (Pcheck_cv_tbl$fraction, 
                  levels = c("p_available_40_gkg", "p_SOM_40_gkg","p_Ca_40_gkg",
                             "p_OCC_40_gkg") 
                  #labels = c("P[Pa]", "P[SOM]", "P[Ca]", "P[OCC]")
                  )

lod_loq_plot$fraction <- factor (lod_loq_plot$fraction, 
                  levels = c("p_available_40_gkg", "p_SOM_40_gkg","p_Ca_40_gkg",
                                            "p_OCC_40_gkg")#, 
                  #labels = c("P[Pa]", "P[SOM]", "P[Ca]", "P[OCC]")
                  )

labels_Pfractions <- c(
  "p_available_40_gkg" = "P[Pa]",
  "p_SOM_40_gkg"   = "P[SOM]",
  "p_Ca_40_gkg"    = "P[Ca]",
  "p_OCC_40_gkg"   = "P[OCC]"
)


#dentify the first facet level
first_fraction <- levels(Pcheck_cv_tbl$fraction)[1]

# Create annotation data tied to the first facet
annot_df <- lod_loq_plot |>
  dplyr::filter(fraction == first_fraction) |>
  dplyr::mutate(
    x = 1.05,        # horizontal position (adjust as needed)
    LOD_label = "Limit-Of-Detection",
    LOQ_label = "Limit-Of-Quantification"
  )

plot_references_quality <-ggplot(Pcheck_cv_tbl, aes(x = ref, y = value)) +
  geom_boxplot(outlier.shape = NA, width = 0.4) +
  geom_point(aes (alpha = 0.7, size=5), show.legend = FALSE,
             position = position_jitterdodge(dodge.width = 0.6)) +
  labs(
    y = bquote(" ["~~g*~'P'~~kg^-1~']'),
    x = ""
  ) +
    # LOD/LOQ lines
  geom_hline(data = lod_loq_plot, aes(yintercept = LOD),
             linetype = 1, color = "red") +
  geom_hline(data = lod_loq_plot, aes(yintercept = LOQ),
             linetype = 1, color = "blue") +
  
  # ---- TEXT ON TOP OF THE LINES (first facet only) ----
geom_text(data = annot_df,
          aes(x = x, y = LOD, label = LOD_label),
          color = "red", fontface = "italic", size = 5,
          vjust = -0.5) +
  geom_text(data = annot_df,
            aes(x = x, y = LOQ, label = LOQ_label),
            color = "blue", fontface = "italic", size = 5,
            vjust = -0.5) +
  # -----------------------------------------------------

facet_wrap(~ fraction, scales = "free_y") +
  facet_wrap(
    ~ fraction,
    scales = "free_y",
    labeller = labeller(fraction = as_labeller(labels_Pfractions, label_parsed))
  ) +
  theme_light(base_size = 15) +
  theme(
    axis.text.x = element_text(size = 15),
    axis.text.y = element_text(size = 15),
    legend.position = "top",
    #strip.background = element_blank(),
    strip.text.x = element_text(colour = "grey30", face = "bold"),
    strip.text.y = element_text(colour = "grey30", face = "bold", angle = 360),
    panel.spacing.x = unit(1.5, "lines")
  )


plot_references_quality

#All plots together
#png
png ("./Paper 4_Pfractions/Drafts/Figures/2026_Figures/figs1_LOD_LOQ_referenceSamples.png",
     height =20, width =25, units = 'cm',  res = 300) #, compression = "lzw")
  plot_references_quality

dev.off()

#pdf
pdf ("./Paper 4_Pfractions/Drafts/Figures/2026_Figures/figs1_LOD_LOQ_referenceSamples.pn.pdf",
     height =10, width =15, ) #,units = 'cm'res = 300 compression = "lzw")

plot_references_quality

dev.off()

#======== Samples ============================================================== 
pFractions_samples<- pFractions_ksi %>%
  filter(!str_detect(sample_id, "[A-Za-z]"))

pFractions_check <- dups_by(pFractions_ksi, "sample_id")
fractions <- c("p_available_40_gkg","p_SOM_40_gkg","p_Ca_40_gkg","p_OCC_40_gkg")

# LOQ table in g/kg with matching fraction names
# (adjust object/column names to yours)
loq_gkg <- lod_loq_pooled %>%  
  dplyr:: select(fraction, LOQ = LOQ_gkg)

# --- combine replicates: prefer >=LOQ values; otherwise median of all values ---
# helper: collapse a vector using LOQ rule
collapse_loq <- function(x, loq) {
  x <- x[!is.na(x)]
  if (length(x) == 0) return(NA_real_)
  x_hi <- x[x >= loq]
  if (length(x_hi) > 0) median(x_hi) else median(x)
}

# make named vector
loq_vec <- setNames(loq_gkg$LOQ, loq_gkg$fraction)


pFractions_ksi <- pFractions_samples %>%
  group_by(sample_id) %>%
  summarise(
    p_available_40_gkg = collapse_loq(p_available_40_gkg, loq_vec[["p_available_40_gkg"]]),
    p_SOM_40_gkg       = collapse_loq(p_SOM_40_gkg,       loq_vec[["p_SOM_40_gkg"]]),
    p_Ca_40_gkg        = collapse_loq(p_Ca_40_gkg,        loq_vec[["p_Ca_40_gkg"]]),
    p_OCC_40_gkg       = collapse_loq(p_OCC_40_gkg,       loq_vec[["p_OCC_40_gkg"]]),
    .groups = "drop"
  )


pFractions_ksi

#Now I flag the samples below or around the LOQ

# Need BOTH LOD and LOQ in g/kg with fraction names matching your columns
lod_loq_gkg <- lod_loq_pooled %>%
dplyr:: select(fraction, LOD = LOD_gkg, LOQ = LOQ_gkg)

# make named vectors
lod_vec <- setNames(lod_loq_gkg$LOD, lod_loq_gkg$fraction)
loq_vec <- setNames(lod_loq_gkg$LOQ, lod_loq_gkg$fraction)

# helper: classify one value
classify <- function(x, lod, loq) {
  case_when(
    is.na(x)        ~ NA_character_,
    x < lod         ~ "<LOD",
    x < loq         ~ "LOD–LOQ",
    TRUE            ~ ">=LOQ"
  )
}

pFractions_ksi2 <- pFractions_ksi %>%
  mutate(
    # ---- status flags (3 levels) ----
    pavail_status = classify(p_available_40_gkg, lod_vec[["p_available_40_gkg"]], loq_vec[["p_available_40_gkg"]]),
    psom_status   = classify(p_SOM_40_gkg,       lod_vec[["p_SOM_40_gkg"]],       loq_vec[["p_SOM_40_gkg"]]),
    pca_status    = classify(p_Ca_40_gkg,        lod_vec[["p_Ca_40_gkg"]],        loq_vec[["p_Ca_40_gkg"]]),
    pocc_status   = classify(p_OCC_40_gkg,       lod_vec[["p_OCC_40_gkg"]],       loq_vec[["p_OCC_40_gkg"]]),
    
    # ---- simple boolean flags ----
    pavail_ge_loq = pavail_status == ">=LOQ",
    psom_ge_loq   = psom_status   == ">=LOQ",
    pca_ge_loq    = pca_status    == ">=LOQ",
    pocc_ge_loq   = pocc_status   == ">=LOQ",
    
    # ---- quantifiable-only columns (set <LOQ to NA, keeps originals untouched) ----
    p_available_40_gkg_q = if_else(pavail_ge_loq, p_available_40_gkg, NA_real_),
    p_SOM_40_gkg_q       = if_else(psom_ge_loq,   p_SOM_40_gkg,       NA_real_),
    p_Ca_40_gkg_q        = if_else(pca_ge_loq,    p_Ca_40_gkg,        NA_real_),
    p_OCC_40_gkg_q       = if_else(pocc_ge_loq,   p_OCC_40_gkg,       NA_real_)
  )

glimpse(pFractions_ksi2)

#flagging the number of quantifiable fractions
pFractions_ksi2 <- pFractions_ksi2 %>%
  mutate(
    n_fractions_ge_loq = rowSums(
      cbind(pavail_ge_loq, psom_ge_loq, pca_ge_loq, pocc_ge_loq),
      na.rm = TRUE
    ),
    all4_ge_loq = n_fractions_ge_loq == 4
  )

pFractions_ksi2 <- pFractions_ksi2 %>%
  mutate(
    pavail_ge_loq = coalesce(pavail_ge_loq, FALSE),
    psom_ge_loq   = coalesce(psom_ge_loq,   FALSE),
    pca_ge_loq    = coalesce(pca_ge_loq,    FALSE),
    pocc_ge_loq   = coalesce(pocc_ge_loq,   FALSE)
  ) %>%
  rowwise() %>%
  mutate(
    frac_ge_loq_list = paste(
      na.omit(c(
        if (pavail_ge_loq) "PPa"  else NA_character_,
        if (psom_ge_loq)   "PSOM" else NA_character_,
        if (pca_ge_loq)    "PCa"  else NA_character_,
        if (pocc_ge_loq)   "POCC" else NA_character_
      )),
      collapse = "+"
    ),
    frac_ge_loq_list = if_else(frac_ge_loq_list == "", NA_character_, frac_ge_loq_list)
  ) %>%
  ungroup()
glimpse(pFractions_ksi2)

table(pFractions_ksi2$n_fractions_ge_loq, pFractions_ksi2$frac_ge_loq_list)

# check combos for n=2 or 3
pFractions_ksi2 %>% group_by() %>% 
  filter(n_fractions_ge_loq %in% c(1,2,3, 4)) %>%
  count(frac_ge_loq_list)

#some plots to check 
ggplot(pFractions_ksi2, aes(x = pavail_status, y = p_available_40_gkg)) +
  geom_boxplot(outlier.shape = NA, width = 0.4) +
  geom_point(aes (alpha = 0.7, size=5), show.legend = FALSE,
             position = position_jitterdodge(dodge.width = 0.6)) +
  labs(y = bquote(" ["~~g*~'P'~~kg^-1~']'),  x = "") +
  # LOD/LOQ lines
  geom_hline(data = lod_loq_plot %>% filter(fraction=="p_available_40_gkg"), aes(yintercept = LOD),
             linetype = 1, color = "red") +
  geom_hline(data = lod_loq_plot %>% filter(fraction=="p_available_40_gkg"), aes(yintercept = LOQ),
             linetype = 1, color = "blue") 
  

#join to the base data 
ksitotal_P <- plyr::join(ksitotal_P, pFractions_ksi2, "sample_id")

ksitotal_P$pH <- as.numeric(ksitotal_P$pH)

glimpse(ksitotal_P)

#just to check if the total is much higher 
boxplot(ksitotal_P$P_HNO3total_40_gkg, ksitotal_P$p_available_40_gkg_q,
        ksitotal_P$p_SOM_40_gkg_q,ksitotal_P$p_Ca_40_gkg_q, ksitotal_P$p_OCC_40_gkg_q)

#calculate fine concentrations and stocks
ksitotal_P <- ksitotal_P %>% 
  mutate(
         p_available_105_gkg = p_available_40_gkg * water_factor,
         p_available_105_mgkg = p_available_105_gkg*1000,
         p_available_gm2 = p_available_105_gkg * fine_earth_kgdm3 * 10 *10,
         p_available_gm2_lod0 = if_else(pavail_status == "<LOD", 0, p_available_gm2), #<-- set the ones below detection as zero
         
         
         p_SOM_105_gkg = p_SOM_40_gkg * water_factor,
         p_SOM_105_mgkg = p_SOM_105_gkg*1000,
         p_SOM_gm2 = p_SOM_105_gkg * fine_earth_kgdm3 * 10 *10,
         p_SOM_gm2_lod0 = if_else(psom_status   == "<LOD", 0, p_SOM_gm2),
         
         p_Ca_105_gkg = p_Ca_40_gkg * water_factor,
         p_Ca_105_mgkg = p_Ca_105_gkg*1000,
         p_Ca_gm2 = p_Ca_105_gkg * fine_earth_kgdm3 * 10 *10,
         p_Ca_gm2_lod0 = if_else(pca_status    == "<LOD", 0, p_Ca_gm2),
         
         p_OCC_105_gkg = p_OCC_40_gkg * water_factor,
         p_OCC105_mgkg = p_OCC_105_gkg*1000,
         p_OCC_gm2 = p_OCC_105_gkg * fine_earth_kgdm3 * 10 *10,
         p_OCC_gm2_lod0 = if_else(pocc_status   == "<LOD", 0, p_OCC_gm2),
         
         p_avail_pct_HNO3 = 100 * (p_available_gm2 / P_total_HNO3_gm2_filled),
         p_SOM_pct_HNO3   = 100 * (p_SOM_gm2      / P_total_HNO3_gm2_filled),
         p_Ca_pct_HNO3    = 100 * (p_Ca_gm2       / P_total_HNO3_gm2_filled),
         p_OCC_pct_HNO3   = 100 * (p_OCC_gm2      / P_total_HNO3_gm2_filled),
         p_sum_pct_HNO3   = rowSums (across (c(p_avail_pct_HNO3, p_SOM_pct_HNO3, p_Ca_pct_HNO3, p_OCC_pct_HNO3)),  na.rm = TRUE),  
         flag_over100     = p_sum_pct_HNO3 > 100,
         
         #p_EXT_total_40_gkg = rowSums (across(c(p_available_40_gkg_q, p_SOM_40_gkg_q, p_Ca_40_gkg_q, p_OCC_40_gkg_q)), na.rm = TRUE), 
         p_EXT_total_gkg = rowSums (across(c(p_available_105_gkg, p_SOM_105_gkg, p_Ca_105_gkg, p_OCC_105_gkg)), na.rm = TRUE), 
         p_EXT_total_gm2 = rowSums(across(c(p_available_gm2, p_SOM_gm2, p_Ca_gm2, p_OCC_gm2)), na.rm = TRUE),
         p_EXT_total_gm2_lod0 = rowSums(across(c(p_available_gm2_lod0, p_SOM_gm2_lod0, p_Ca_gm2_lod0, p_OCC_gm2_lod0)), na.rm = TRUE),
         
         
         p_avail_PERCENT_sumtotalP = 100 * (p_available_gm2/p_EXT_total_gm2),
         p_avail_PERCENT_sumtotalP_lod0 = 100 * (p_available_gm2_lod0/p_EXT_total_gm2_lod0),
         
         p_SOM_PERCENT_sumtotalP = 100 * (p_SOM_gm2/p_EXT_total_gm2), 
         p_SOM_PERCENT_sumtotalP_lod0 = 100 * (p_SOM_gm2_lod0/p_EXT_total_gm2_lod0), 
         
         p_Ca_PERCENT_sumtotalP = 100 * (p_Ca_gm2/p_EXT_total_gm2),
         p_Ca_PERCENT_sumtotalP_lod0 = 100 * (p_Ca_gm2_lod0/p_EXT_total_gm2_lod0),
         
         p_OCC_PERCENT_sumtotalP = 100 * (p_OCC_gm2/p_EXT_total_gm2),
         p_OCC_PERCENT_sumtotalP_lod0 = 100 * (p_OCC_gm2_lod0/p_EXT_total_gm2_lod0),
         
         ) 

glimpse(ksitotal_P)

#Ploting the total extractable P against the HNO3 total P

#
lm_ptotal_test  <- lm (log1p(p_EXT_total_gm2) ~ log1p(P_total_HNO3_gm2) + 0 , 
                  data = (ksitotal_P |> filter(p_EXT_total_gm2 > 0)))

lm_ptotal_test  <- lm ((p_EXT_total_gm2) ~ (P_total_HNO3_gm2) + 0 , 
                       data = (ksitotal_P |> filter(p_EXT_total_gm2 > 0)))

summary(lm_ptotal_test)

hist(resid(lm_ptotal_test))
car::qqPlot(resid(lm_ptotal_test))
shapiro.test(resid(lm_ptotal_test))
simulationOutput <-DHARMa::simulateResiduals(fittedModel = lm_ptotal_test, n = 500)
plot(simulationOutput)  
DHARMa::testDispersion (lm_ptotal_test)
#car::leveneTest(resid(msocf)) #for testing homoscadicity
summary(lm_ptotal_test)
anova (lm_ptotal_test)
jtools::plot_summs(lm_ptotal_test,inner_ci_level = 0.9)
jtools::summ(lm_ptotal_test)
  



p_HNO3_ExtP <- ggplot (ksitotal_P%>% filter(p_EXT_total_gm2 > 0)) + #%>% filter(p_EXT_total_gm2 > 0)
  aes (y=  (p_EXT_total_gm2), x=  (P_total_HNO3_gm2))+ 
  geom_point(aes(alpha=0.5, size=5,  fill=frac_ge_loq_list), shape = 21, col="black",
             show.legend = T, position = position_jitterdodge(dodge.width = 0.6)) + 
  geom_smooth(method = "lm",se = T, linetype=1, col= "black",
              formula = formula)+ xlim(0,250) + ylim(0, 250)+ 
  geom_abline(slope = 1, linetype=5, linewidth = 0.6) +
  labs(x=bquote("HNO"[3]~~"P ["~~g*~'P'~~m^-2~']'),
    #title = "Comparing total P extractions",
    y=bquote(" Extractable P ["~~g*~'P'~~m^-2~']'), tag="b")+
  theme(legend.position = "top")+
  theme_light(base_size=15)+
  theme(axis.text.x = element_text(size=15),
        axis.text.y = element_text(size = 15),
        legend.position="right",
        strip.background = element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        #panel.grid=element_blank() ,
        panel.spacing.x = unit(1.5, "lines"))+
  stat_poly_eq(use_label("eq", "R2","P"), formula = y~x+0, 
               size=5)

p_HNO3_ExtP
p_HNO3_ExtP <- ggMarginal(p_HNO3_ExtP, type = "densigram", fill="grey")

p_HNO3_ExtP

#All plots together
#png
png ("./Paper 4_Pfractions/Drafts/Figures/2026_Figures/figs2_relationships_extr_totalP.png",
     height =20, width =25, units = 'cm',  res = 300) #, compression = "lzw")

gridExtra::grid.arrange(p_HNO3_MultiAcid, p_HNO3_ExtP, ncol = 2)

dev.off()

#pdf
pdf ("./Paper 4_Pfractions/Drafts/Figures/2026_Figures/figs2_relationships_extr_totalP2.pdf",
     height =10, width =15, ) #,units = 'cm'res = 300 compression = "lzw")

gridExtra::grid.arrange(p_HNO3_MultiAcid, p_HNO3_ExtP, ncol = 2)

dev.off()


#This is to write out all the prepared data for the analysiss of the paper 

#write.csv(ksitotal_P, "./Paper 4_Pfractions/R_analysis_2026on/Raw_data_reassessed/MAIN_DATA_P_fractions_2026.csv")

#ksitotal_P <- read.csv("./Paper 4_Pfractions/R_analysis_2026on/Raw_data_reassessed/MAIN_DATA_P_fractions_2026.csv")

#organise the main classes

levels (as.factor(ksitotal_P$class))

ksitotal_P$class <- factor(ksitotal_P$class,
            levels = c("Profile", "RURAL", "FOREST","Short-term","Long-term"),
            labels = c("Profile", "RURAL", "FOREST","Short-duration","Long-duration")
            )

ksitotal_P$road_class <- factor(ksitotal_P$road_class,
            levels = c(  "Reference", "Profile",  "Low-activity", "High-activity"),
            labels = c( "Reference", "Profile", "Low-intensity", "High-intensity")
            )
#
ksitotal_P$urbimpact <- factor(ksitotal_P$urbimpact,
            levels = c("Profile", "RURAL","FOREST", "Weak","Mild", "Moderate", "Strong"),
            )




#Urban soils with the refernce fractions
ksitotal_P_filtered_urbanREF_data <- droplevels(subset(ksitotal_P, 
                                !(class %in% "Profile")))

#Only the urban samples 
ksitotal_P_filtered_urban_data <- droplevels(subset(ksitotal_P, 
                                !(class %in% c("Profile", "FOREST", "RURAL"))))

ksitotal_P_filtered_urban_data$urbimpact <- factor(ksitotal_P_filtered_urban_data$urbimpact,
          levels = c( "Weak","Mild", "Moderate", "Strong" )
                    )


# organise the urban levels from low to high 
ksitotal_P_filtered_urban_data$urbimpact <- factor(ksitotal_P_filtered_urban_data$urbimpact, ordered = T)
ksitotal_P_filtered_urbanREF_data$urbimpact <- factor(ksitotal_P_filtered_urbanREF_data$urbimpact, ordered = T)

ksitotal_P_filtered_urban_data$urbnumber <- as.numeric(ksitotal_P_filtered_urban_data$urbimpact)
ksitotal_P_filtered_urbanREF_data$urbnumber <- as.numeric(ksitotal_P_filtered_urbanREF_data$urbimpact)

#======================= 01 Data analyses ======================================

#Total P========================================================================
#A general function to make boxplots
source("C:/Users/sasaber/ownCloud - sasaber@gwdg.de@owncloud.gwdg.de/PostDoc/Papers_To_Be_completed_from_PhD/Paper 4_Pfractions/R_analysis_2026on/function_twoway_boxplot.R")
source("E:/ownFolder/PostDoc/Papers_To_Be_completed_from_PhD/Paper 4_Pfractions/R_analysis_2026on/function_twoway_boxplot.R")
source("E:/ownFolder/PostDoc/Papers_To_Be_completed_from_PhD/Paper 4_Pfractions/R_analysis_2026on/function_twoway_boxplot_points_Shape.R")
source("C:/Users/sasaber/ownCloud - sasaber@gwdg.de@owncloud.gwdg.de/PostDoc/Papers_To_Be_completed_from_PhD/Paper 4_Pfractions/R_analysis_2026on/function_twoway_boxplot_points_Shape.R")

##checked, and there is no interraction effect ===============================

set.seed(123456)
#note that the Hn03 used are the ones that were gapfilled
#log_transform data 
ksitotal_P_filtered_urbanREF_data$log_P_total_HNO3_gm2 <- log1p (ksitotal_P_filtered_urbanREF_data$P_total_HNO3_gm2)


#checked, and there is no interraction effect before proceeding
                                     
mtotalP <- lm (log_P_total_HNO3_gm2 ~  class + road_class, 
                         data =  droplevels(subset(ksitotal_P_filtered_urbanREF_data, 
                                !(class %in% c("FOREST", "RURAL"))))
                    )

#This is for extracting the coefficients fo the linear regression
mtotalP <-  lm ( log_P_total_HNO3_gm2 ~ urbnumber, 
              data =  droplevels(subset(ksitotal_P_filtered_urbanREF_data, 
                                        !(class %in% c("FOREST", "RURAL"))))
                  )


####From the model examinations, there is no interractive effect  Skeleton

hist(resid(mtotalP))
car::qqPlot(resid(mtotalP))
shapiro.test(resid(mtotalP))
simulationOutput <-DHARMa::simulateResiduals(fittedModel = mtotalP, n = 500)
plot(simulationOutput)  
DHARMa::testDispersion (simulationOutput)
#car::leveneTest(resid(msocf)) #for testing homoscadicity
summary(mtotalP)
anova (mtotalP)
jtools::plot_summs(mtotalP,inner_ci_level = 0.9)
jtools::summ(mtotalP)

#
emm_totalP <- emmeans(mtotalP, ~ class + road_class , df = Inf,)

# Compute CLD letters (Tukey-adjusted)
emm_totalP <- as.data.frame(cld(emm_totalP, adjust = "tukey", Letters = letters, 
                alpha = 0.05,   # 95% family-wise
                sort = T))  # preserve order


plot(emm_totalP)


#the plots 

p_total <- baseboxplot_rdinfluence(ksitotal_P_filtered_urbanREF_data, x_col = "class", 
                        y_col = "P_total_HNO3_gm2", z_class_col = "road_class") +

 geom_text(data = emm_totalP, aes(x= class, y= emmean, color= road_class,
                    label = .group, group = road_class),show.legend = F, 
                    position = position_dodge2(width = 0.9, preserve = "single"),
                    vjust= -15, hjust=2, size = 7) +
  scale_y_continuous(breaks = pretty(ksitotal_P_filtered_urbanREF_data$P_total_HNO3_gm2_filled, n = 5))+
  labs(x="", y=bquote('HNO'[3]~ '['~g*~~P~~m^-2~']'), 
       size=15, tag = "a", title =expression("HNO"[3]~~ "P  [duration=***, intensity=***]"), 
       subtitle= "log1p(y) = 0.25 x + 2.5, *p* < 0.001, R² = 0.24") #+
  #theme (plot.margin=unit(c(0,1,-0.5,0), "cm"))

plot (p_total)

#pdf

#Descriptives
ksitotal_P_filtered_urbanREF_data %>%
  group_by(class, road_class) %>%
  summarise(
    median = median(P_total_HNO3_gm2, na.rm = TRUE),
    mean   = mean(P_total_HNO3_gm2, na.rm = TRUE),
    se     = standard_error(P_total_HNO3_gm2, na.rm = TRUE),
    sd     = sd(P_total_HNO3_gm2, na.rm = TRUE),
    .groups = "drop"
  )


#Avialable P===================================================================

set.seed(123456)

ksitotal_P_filtered_urbanREF_data$log_p_available_gm2_lod <- log1p(ksitotal_P_filtered_urbanREF_data$p_available_gm2_lod0)


#checked, and there is no interraction effect

mPpa <- lm ( log_p_available_gm2_lod ~  class + road_class, 
                data =  droplevels(subset(ksitotal_P_filtered_urbanREF_data, 
                                          !(class %in% c("FOREST", "RURAL"))))
                      )

#
mPpa <-  lm ( log_p_available_gm2_lod ~ urbnumber, 
                 data =  droplevels(subset(ksitotal_P_filtered_urbanREF_data, 
                                           !(class %in% c("FOREST", "RURAL"))))
                )


####From the model examinations, there is no interractive effect  Skeleton

hist(resid(mPpa))
car::qqPlot(resid(mPpa))
shapiro.test(resid(mPpa))
simulationOutput <-DHARMa::simulateResiduals(fittedModel = mPpa, n = 500)
plot(simulationOutput)  
DHARMa::testDispersion (simulationOutput)
#car::leveneTest(resid(msocf)) #for testing homoscadicity
summary(mPpa)
anova (mPpa)
jtools::plot_summs(mPpa,inner_ci_level = 0.9)
jtools::summ(mPpa)

#
emm_Ppa <- emmeans(mPpa, ~ class + road_class , df = Inf,)

# Compute CLD letters (Tukey-adjusted)
emm_Ppa <- as.data.frame(cld(emm_Ppa, adjust = "tukey", Letters = letters, 
                                alpha = 0.05,   # 95% family-wise
                                sort = T))  # preserve order


plot(emm_Ppa)


#the plots 

p_Ppa <- baseboxplot_rdinfluence_points_Shape(ksitotal_P_filtered_urbanREF_data |> filter(p_available_gm2_lod0 < 40) , 
                  x_col = "class", y_col = "p_available_gm2_lod0", 
                  z_class_col = "road_class", status_col = "pavail_status") +
  
  geom_text(data = emm_Ppa, aes(x= class, y= emmean, color= road_class,
                                   label = .group, group = road_class),show.legend = F, 
            position = position_dodge2(width = 0.9, preserve = "single"),
            vjust= -9, hjust=1.5, size = 7) +
  #scale_y_continuous(breaks = pretty(ksitotal_P_filtered_urbanREF_data$p_available_gm2_lod0, n = 5))+
  labs(x="", y=bquote('P'[Pa]~  '['~g*~~P~~m^-2~']'), 
       size=15, tag = "b", title =expression("Plant-available P [duration=***, intensity=***]"), 
       subtitle= "log1p(y) = 0.34 x -0.39, *p* < 0.001, R² = 0.26") #+
#theme (plot.margin=unit(c(0,1,-0.5,0), "cm"))

p_Ppa


#pdf
pdf ("./Paper 4_Pfractions/Drafts/Figures/2026_Figures/f4b_ppa.pdf",
     height =5, width =7, ) #,units = 'cm'res = 300 compression = "lzw")

p_Ppa

dev.off()

#computing descriptive stats 


ksitotal_P_filtered_urbanREF_data %>%
  group_by(class, road_class) %>%   # or just road_class
  summarise(
    n = sum(!is.na(pavail_status)),
    n_ge_loq = sum(pavail_status == ">=LOQ", na.rm = TRUE),
    pct_ge_loq = if_else(n > 0, 100 * n_ge_loq / n, NA_real_),
    median = median(p_available_gm2_lod0, na.rm = TRUE),
    mean   = mean(p_available_gm2_lod0, na.rm = TRUE),
     se     = if_else(sum(!is.na(p_available_gm2_lod0)) > 1,
                     sd(p_available_gm2_lod0, na.rm=TRUE) / sqrt(sum(!is.na(p_available_gm2_lod0))),
                     NA_real_),
    sd     = sd(p_available_gm2_lod0, na.rm = TRUE),
    .groups = "drop"
  )



#SOM P===================================================================

set.seed(123456)

#Best transformed is sqrt transformation 
ksitotal_P_filtered_urbanREF_data$log_p_SOM_gm2 <- log1p(ksitotal_P_filtered_urbanREF_data$p_SOM_gm2_lod0)


#checked, and there is no interraction effect

mPsom <- lm ( log_p_SOM_gm2 ~  class + road_class, 
             data =  droplevels(subset(ksitotal_P_filtered_urbanREF_data, 
                                       !(class %in% c("FOREST", "RURAL"))))
            )


mPsom <-  lm ( log_p_SOM_gm2 ~ urbnumber, 
              data =  droplevels(subset(ksitotal_P_filtered_urbanREF_data, 
                                        !(class %in% c("FOREST", "RURAL"))))
            )


####From the model examinations, there is no interractive effect  Skeleton

hist(resid(mPsom))
car::qqPlot(resid(mPsom))
shapiro.test(resid(mPsom))
simulationOutput <-DHARMa::simulateResiduals(fittedModel = mPsom, n = 500)
plot(simulationOutput)  
DHARMa::testDispersion (simulationOutput)
#car::leveneTest(resid(msocf)) #for testing homoscadicity
summary(mPsom)
anova (mPsom)
jtools::plot_summs(mPsom,inner_ci_level = 0.9)
jtools::summ(mPsom)

#
emm_Psom <- emmeans(mPsom, ~ class + road_class , df = Inf,)

# Compute CLD letters (Tukey-adjusted)
emm_Psom <- as.data.frame(cld(emm_Psom, adjust = "tukey", Letters = letters, 
                             alpha = 0.05,   # 95% family-wise
                             sort = T))  # preserve order


plot(emm_Psom)


#the plots 

p_Psom <- baseboxplot_rdinfluence_points_Shape(ksitotal_P_filtered_urbanREF_data, x_col = "class", 
                 y_col = "p_SOM_gm2_lod0", z_class_col = "road_class", status_col = "psom_status" ) +
  
  geom_text(data = emm_Psom, aes(x= class, y= emmean, color= road_class,
                                label = .group, group = road_class),show.legend = F,
            position = position_dodge2(width = 0.9, preserve = "single"),
            vjust= -15, hjust=2, size = 7) +
  scale_y_continuous(breaks = pretty(ksitotal_P_filtered_urbanREF_data$p_SOM_gm2_lod0, n = 5))+
  labs(x="", y=bquote('P'[SOM]~ '['~g*~~P~~m^-2~']'), 
       size=15, tag = "c", title =expression("SOM-bound P [ duration = **, intensity= ** ]"),
       subtitle= "log1p(y) = 0.17 x - 0.033, *p* < 0.001, R² = 0.11"
       ) #+
#theme (plot.margin=unit(c(0,1,-0.5,0), "cm"))

p_Psom

#pdf
pdf ("./Paper 4_Pfractions/Drafts/Figures/2026_Figures/f4c_psom.pdf",
     height =5, width =7, ) #,units = 'cm'res = 300 compression = "lzw")

p_Psom

dev.off()

#computing descriptive stats 


ksitotal_P_filtered_urbanREF_data %>%
  group_by(class, road_class) %>%   # or just road_class
  summarise(
    n = sum(!is.na(psom_status)),
    n_ge_loq = sum(psom_status == ">=LOQ", na.rm = TRUE),
    pct_ge_loq = if_else(n > 0, 100 * n_ge_loq / n, NA_real_),
    median = median(p_SOM_gm2_lod0, na.rm = TRUE),
    mean   = mean(p_SOM_gm2_lod0, na.rm = TRUE),
    se     = if_else(sum(!is.na(p_SOM_gm2_lod0)) > 1,
                     sd(p_SOM_gm2_lod0, na.rm=TRUE) / sqrt(sum(!is.na(p_SOM_gm2_lod0))),
                     NA_real_),
    sd     = sd(p_SOM_gm2_lod0, na.rm = TRUE),
    .groups = "drop"
  )



#Ca-boound P===================================================================

set.seed(123456)

ksitotal_P_filtered_urbanREF_data$log_p_Ca_gm2 <- log1p (ksitotal_P_filtered_urbanREF_data$p_Ca_gm2_lod0)


#checked, and there is no interraction effect

mPca <- lm ( log_p_Ca_gm2 ~  class + road_class, 
              data =  droplevels(subset(ksitotal_P_filtered_urbanREF_data, 
                                        !(class %in% c("FOREST", "RURAL"))))
                )


mPca <-  lm ( log_p_Ca_gm2 ~ urbnumber, 
               data =  droplevels(subset(ksitotal_P_filtered_urbanREF_data, 
                                         !(class %in% c("FOREST", "RURAL"))))
                )


####From the model examinations, there is no interractive effect  Skeleton

hist(resid(mPca))
car::qqPlot(resid(mPca))
shapiro.test(resid(mPca))
simulationOutput <-DHARMa::simulateResiduals(fittedModel = mPca, n = 500)
plot(simulationOutput)  
DHARMa::testDispersion (simulationOutput)
#car::leveneTest(resid(msocf)) #for testing homoscadicity
summary(mPca)
anova (mPca)
jtools::plot_summs(mPca,inner_ci_level = 0.9)
jtools::summ(mPca)

#
emm_Pca <- emmeans(mPca, ~ class + road_class , df = Inf,)

# Compute CLD letters (Tukey-adjusted)
emm_Pca <- as.data.frame(cld(emm_Pca, adjust = "tukey", Letters = letters, 
                              alpha = 0.05,   # 95% family-wise
                              sort = T))  # preserve order


plot(emm_Pca)


#the plots 

p_Pca <- baseboxplot_rdinfluence_points_Shape(ksitotal_P_filtered_urbanREF_data |> filter(p_Ca_gm2_lod0 <100), 
            x_col = "class", y_col = "p_Ca_gm2_lod0", z_class_col = "road_class", 
            status_col = "pca_status") +
  
  geom_text(data = emm_Pca, aes(x= class, y= emmean, color= road_class,
                                 label = .group, group = road_class),show.legend = F, 
            position = position_dodge2(width = 0.9, preserve = "single"),
            vjust= -11, hjust=2, size = 7) +
  scale_y_continuous(breaks = pretty(ksitotal_P_filtered_urbanREF_data$p_Ca_gm2_lod0, n = 5))+
  labs(x="", y=bquote('P'[Ca]~ '['~g*~~P~~m^-2~']'), 
       size=15, tag = "d", title =expression("Ca-bound P [ duration = ***, intensity= * ]"), 
       subtitle= "log1p(y) = 0.44 x - 0.60, *p* < 0.001, R² = 0.13") #+
#theme (plot.margin=unit(c(0,1,-0.5,0), "cm"))

p_Pca

#pdf
pdf ("./Paper 4_Pfractions/Drafts/Figures/2026_Figures/f4d_pca.pdf",
     height =5, width =7, ) #,units = 'cm'res = 300 compression = "lzw")

p_Pca

dev.off()

#computing descriptive stats 


ksitotal_P_filtered_urbanREF_data %>%
  group_by(class, road_class) %>%   # or just road_class or class
  summarise(
    n = sum(!is.na(pca_status)),
    n_ge_loq = sum(pca_status == ">=LOQ", na.rm = TRUE),
    pct_ge_loq = if_else(n > 0, 100 * n_ge_loq / n, NA_real_),
    median = median(p_Ca_gm2_lod0, na.rm = TRUE),
    mean   = mean(p_Ca_gm2_lod0, na.rm = TRUE),
    se     = if_else(sum(!is.na(p_Ca_gm2_lod0)) > 1,
                     sd(p_Ca_gm2_lod0, na.rm=TRUE) / sqrt(sum(!is.na(p_Ca_gm2_lod0))),
                     NA_real_),
    sd     = sd(p_Ca_gm2_lod0, na.rm = TRUE),
    .groups = "drop"
  )



#Occlude P===================================================================

set.seed(123456)

#Best transformed is sqrt transformation 
ksitotal_P_filtered_urbanREF_data$log_p_OCC_gm2 <-  log1p(ksitotal_P_filtered_urbanREF_data$p_OCC_gm2_lod0)


#checked, and there is no interraction effect

mPocc <- lm ( log_p_OCC_gm2 ~  class + road_class, 
             data =  droplevels(subset(ksitotal_P_filtered_urbanREF_data, 
                                       !(class %in% c("FOREST", "RURAL"))))
      )


mPocc <-  lm ( log_p_OCC_gm2 ~ urbnumber, 
              data =  droplevels(subset(ksitotal_P_filtered_urbanREF_data, 
                                        !(class %in% c("FOREST", "RURAL"))))
      )


####From the model examinations, there is no interractive effect  Skeleton

hist(resid(mPocc))
car::qqPlot(resid(mPocc))
shapiro.test(resid(mPocc))
simulationOutput <-DHARMa::simulateResiduals(fittedModel = mPocc, n = 500)
plot(simulationOutput)  
DHARMa::testDispersion (simulationOutput)
#car::leveneTest(resid(msocf)) #for testing homoscadicity
summary(mPocc)
anova (mPocc)
jtools::plot_summs(mPocc,inner_ci_level = 0.9)
jtools::summ(mPocc)

#
emm_Pocc <- emmeans(mPocc, ~ class + road_class , df = Inf,)

# Compute CLD letters (Tukey-adjusted)
emm_Pocc <- as.data.frame(cld(emm_Pocc, adjust = "tukey", Letters = letters, 
                             alpha = 0.05,   # 95% family-wise
                             sort = T))  # preserve order


plot(emm_Pocc)


#the plots 

p_Pocc <- baseboxplot_rdinfluence_points_Shape(ksitotal_P_filtered_urbanREF_data, x_col = "class", 
                                 y_col = "p_OCC_gm2_lod0", z_class_col = "road_class",  status_col = "pocc_status") +
  
  geom_text(data = emm_Pocc, aes(x= class, y= emmean, color= road_class,
                                label = .group, group = road_class),show.legend = F, 
            position = position_dodge2(width = 0.9, preserve = "single"),
            vjust= -18, hjust=2, size = 7) +
  scale_y_continuous(breaks = pretty(ksitotal_P_filtered_urbanREF_data$p_OCC_gm2_lod0, n = 5))+
  labs(x="", y=bquote('P'[OCC]~ '['~g*~~P~~m^-2~']'), 
       size=15, tag = "e", title =expression("Occluded P [ duration = ***, intensity= ns ]"), 
       subtitle= "log1p(y) = 0.11 x + 2.14, *p* < 0.0001 R² = 0.07") #+
#theme (plot.margin=unit(c(0,1,-0.5,0), "cm"))

p_Pocc

#pdf
pdf ("./Paper 4_Pfractions/Drafts/Figures/2026_Figures/f4e_pocc.pdf",
     height =5, width =7, ) #,units = 'cm'res = 300 compression = "lzw")

p_Pocc

dev.off()




#computing descriptive stats 


ksitotal_P_filtered_urbanREF_data %>%
  group_by(class, road_class) %>%   # or just road_class or class
  summarise(
    n = sum(!is.na(pocc_status)),
    n_ge_loq = sum(pocc_status == ">=LOQ", na.rm = TRUE),
    pct_ge_loq = if_else(n > 0, 100 * n_ge_loq / n, NA_real_),
    median = median(p_OCC_gm2_lod0, na.rm = TRUE),
    mean   = mean(p_OCC_gm2_lod0, na.rm = TRUE),
    se     = if_else(sum(!is.na(p_OCC_gm2_lod0)) > 1,
                     sd(p_OCC_gm2_lod0, na.rm=TRUE) / sqrt(sum(!is.na(p_OCC_gm2_lod0))),
                     NA_real_),
    sd     = sd(p_OCC_gm2_lod0, na.rm = TRUE),
    .groups = "drop"
  )

#Sum of the P pools=============================================================
#Select those samples without zero and have all fractions measured
set.seed(123456)

#Best transformed is sqrt transformation 
ksitotal_P_filtered_urbanREF_data$log_p_sum_total_gm2_lod0 <- log1p(ksitotal_P_filtered_urbanREF_data$p_EXT_total_gm2_lod0)


#checked, and there is no interraction effect

msumPtotal <- lm ( log_p_sum_total_gm2_lod0 ~  class + road_class, 
              data =   ksitotal_P_filtered_urbanREF_data %>% 
                filter(p_EXT_total_gm2>0, !(class %in% c("FOREST", "RURAL"))))
                        


msumPtotal <-  lm ( log_p_sum_total_gm2_lod0 ~ urbnumber, 
                    data =   ksitotal_P_filtered_urbanREF_data %>% 
                      filter(p_EXT_total_gm2>0, !(class %in% c("FOREST", "RURAL"))))

####From the model examinations, there is no interractive effect  Skeleton

hist(resid(msumPtotal))
car::qqPlot(resid(msumPtotal))
shapiro.test(resid(msumPtotal))
simulationOutput <-DHARMa::simulateResiduals(fittedModel = msumPtotal, n = 500)
plot(simulationOutput)  
DHARMa::testDispersion (simulationOutput)
#car::leveneTest(resid(msocf)) #for testing homoscadicity
summary(msumPtotal)
anova (msumPtotal)
jtools::plot_summs(msumPtotal,inner_ci_level = 0.9)
jtools::summ(msumPtotal)

#
emm_sumPtotal <- emmeans(msumPtotal, ~ class + road_class , df = Inf,)

# Compute CLD letters (Tukey-adjusted)
emm_sumPtotal <- as.data.frame(cld(emm_sumPtotal, adjust = "tukey", Letters = letters, 
                              alpha = 0.05,   # 95% family-wise
                              sort = T))  # preserve order


plot(emm_sumPtotal)


#plot
ksitotal_P_filtered_urbanREF_data$n_fractions_ge_loq <- as.factor (ksitotal_P_filtered_urbanREF_data$n_fractions_ge_loq)
levels(ksitotal_P_filtered_urbanREF_data$n_fractions_ge_loq )
# make a factor for shapes
ksitotal_P_filtered_urbanREF_data$n_fractions_ge_loq_factor = factor(ksitotal_P_filtered_urbanREF_data$n_fractions_ge_loq , levels = 1:4, labels = paste0(1:4, " ≥LOQ"))
levels(ksitotal_P_filtered_urbanREF_data$n_fractions_ge_loq_factor )





source("./Paper 4_Pfractions/R_analysis_2026on/function_twoway_boxplot_points_Shape_totalPfractions.R")

p_sumPtotal<- ksitotal_P_filtered_urbanREF_data %>% 
                  filter(p_EXT_total_gm2>0, !(n_fractions_ge_loq %in% "0")) %>% 
  baseboxplot_rdinfluence_pointPfractions(x_col = "class", 
                        y_col = "p_EXT_total_gm2_lod0", z_class_col = "road_class", 
                        status_col = "n_fractions_ge_loq_factor")+ 
  geom_text(data = emm_sumPtotal, aes(x= class, y= emmean, color= road_class,
                   label = .group, group = road_class),show.legend = F, 
            position = position_dodge2(width = 0.9, preserve = "single"),
            vjust= -12, hjust=2, size = 7) +
  scale_y_continuous(breaks = pretty(ksitotal_P_filtered_urbanREF_data$p_EXT_total_gm2, n = 5))+
  labs(x="", y=expression(paste(sum(P[fractions],fractions=1, 4),'['~~g*~~m^-2*~']')), 
       size=15, tag = "f", title =expression(paste(sum(P[fractions],fractions=1, 4),
                                  " Extractable P [ duration = ***, intensity= ** ]")), 
       subtitle= "log1p(y) = 0.29 x + 1.77, *p* < 0.001, R² = 0.22")

p_sumPtotal

#pdf
pdf ("./Paper 4_Pfractions/Drafts/Figures/2026_Figures/f4f_sumP.pdf",
     height =5, width =7, ) #,units = 'cm'res = 300 compression = "lzw")

p_sumPtotal

dev.off()


#Descriptives 
#check for whic P fraction goes into the extP
ksitotal_P_filtered_urbanREF_data %>%
  filter(n_fractions_ge_loq %in% 1:4) %>%
  group_by(road_class) %>%
  count(frac_ge_loq_list, sort = TRUE)

ksitotal_P_filtered_urbanREF_data %>%
  filter(n_fractions_ge_loq %in% 1:4) %>%
  group_by(class, frac_ge_loq_list) %>%
  summarise(n = n(), .groups = "drop_last") %>%
  mutate(pct = 100 * n / sum(n)) %>%
  arrange(class, desc(n))


#computing descriptive stats 


ksitotal_P_filtered_urbanREF_data %>%
  filter(p_EXT_total_gm2>0, !(n_fractions_ge_loq %in% "0")) %>% 
  group_by(class) %>%   # or just road_class or class
  summarise(
    #n = sum(!is.na(pocc_status)),
    #n_ge_loq = sum(pocc_status == ">=LOQ", na.rm = TRUE),
    #pct_ge_loq = if_else(n > 0, 100 * n_ge_loq / n, NA_real_),
    median = median(p_EXT_total_gm2_lod0, na.rm = TRUE),
    mean   = mean(p_EXT_total_gm2_lod0, na.rm = TRUE),
    se     = if_else(sum(!is.na(p_EXT_total_gm2_lod0)) > 1,
                     sd(p_EXT_total_gm2_lod0, na.rm=TRUE) / sqrt(sum(!is.na(p_EXT_total_gm2_lod0))),
                     NA_real_),
    sd     = sd(p_EXT_total_gm2_lod0, na.rm = TRUE),
    .groups = "drop"
  )


#All plots together
#png
png ("./Paper 4_Pfractions/Drafts/Figures/2026_Figures/fig4_Pfractions_total.png",
    height =50, width = 60, units = 'cm',  res = 300) #, compression = "lzw")
  
gridExtra::grid.arrange(p_total,p_Ppa,p_Psom,
                          p_Pca, p_Pocc, p_sumPtotal,  ncol = 3)
dev.off()

#pdf
pdf ("./Paper 4_Pfractions/Drafts/Figures/2026_Figures/fig4_Pfractions_total.pdf",
     height =25, width =30, ) #,units = 'cm'res = 300 compression = "lzw")

gridExtra::grid.arrange(p_total,p_Ppa,p_Psom,
                        p_Pca, p_Pocc, p_sumPtotal,  ncol = 3)
dev.off()

#Proportion of P fractions ===================================================== 

#Box plots to see the trends 

#pa
baseboxplot_rdinfluence(ksitotal_P_filtered_urbanREF_data, x_col = "class", 
                        y_col = "p_avail_PERCENT_sumtotalP_lod0", z_class_col = "road_class")

#som
baseboxplot_rdinfluence(ksitotal_P_filtered_urbanREF_data, x_col = "class", 
                        y_col = "p_SOM_PERCENT_sumtotalP_lod0", z_class_col = "road_class")

#ca
baseboxplot_rdinfluence(ksitotal_P_filtered_urbanREF_data, x_col = "class", 
                        y_col = "p_Ca_PERCENT_sumtotalP_lod0", z_class_col = "road_class")

#occ
baseboxplot_rdinfluence(ksitotal_P_filtered_urbanREF_data, x_col = "class", 
                        y_col = "p_OCC_PERCENT_sumtotalP_lod0", z_class_col = "road_class")

#


pct_long <- ksitotal_P_filtered_urbanREF_data %>% 
  dplyr::select(sample_id, class, road_class, 
        urbimpact, p_avail_PERCENT_sumtotalP_lod0, p_SOM_PERCENT_sumtotalP_lod0, 
        p_Ca_PERCENT_sumtotalP_lod0, p_OCC_PERCENT_sumtotalP_lod0) %>% 
  pivot_longer(
    cols = contains("_PERCENT_"),
    names_to  = "pfraction",
    values_to = "pct"
  ) %>%
  mutate(
    pfraction = str_remove(pfraction, "_PERCENT_.*$"),
    # optional: nicer labels + order
    pfraction = factor(pfraction, levels = c("p_avail","p_SOM","p_Ca","p_OCC"))
  )

pct_sum_cr <- pct_long %>%
  group_by(class, road_class,urbimpact, pfraction) %>%
  summarise(pct = mean(pct, na.rm = TRUE), .groups = "drop") %>% 
  filter(!is.na(pfraction))

# Option 1: facet by road_class, bars = fractions, fill = class (dodge)
ggplot(pct_sum_cr, aes(x = urbimpact, y = pct, fill = pfraction)) +
  geom_col(position = "fill", width = 0.7) +
  #facet_wrap(~ road_class) +
  labs(x = NULL, y = "Percent of HNO3 total (%)") +
  theme_light(base_size = 14)



ggplot(pct_sum_cr) + aes(x = urbimpact, y =pct, fill = pfraction) + 
  geom_bar(stat="identity",  position="fill", width = 0.7)+ #color="white"The position will scale the values, also geom_col can be used instead of geom_bar
  labs(x="", y= "P fractions [ % ]") + 
  scale_y_continuous(labels = percent_format())+ #facet_grid(road_class~.)+
  coord_flip()+
  theme(legend.position="top",
        axis.text.x = element_text(colour = c("black", "black","grey", "grey")),
        panel.grid.minor=element_blank(), panel.grid.major=element_blank()) +

scale_fill_manual(values= c ("#4597A0","#00B0F0","#405887","#B1B1D1"))





## ============ Calculating and plotting the relative amounts ==================
labels_Pfractions <- c(
  "p_avail" = expression(P[Pa]),
  "p_SOM"   = expression(P[SOM]),
  "p_Ca"    = expression(P[Ca]),
  "p_OCC"   = expression(P[OCC])
)

# 2. Build a 100%-stacked bar plot with geom_col(position="fill"), and add labels
p_relative <- ggplot(pct_sum_cr, aes(x = urbimpact, y = pct, fill = pfraction)) +
  geom_col(position = "fill") +
  # Add percentage‐labels at the center of each stacked segment:
  geom_text(
    aes(
      label = percent(pct/100, accuracy = 1),   # “12%”, “35%”, etc.
      group = pfraction
    ),
    position = position_fill(vjust = 0.5),    # center label in each stack
    size     = 6,#fontface = "italic",
    color    = "black"
  ) +
  # Vertical separators between your reference/short/long blocks:
  geom_vline(xintercept = 2.5, col = "grey70", linewidth = 0.5) +
  geom_vline(xintercept = 4.5, col = "grey70", linewidth = 0.5) +
  geom_hline(yintercept = 0, col = "grey70", linewidth = 0.5) +
  # Annotations (“REFERENCE”, “Short-duration”, “Long-duration”)
  annotate(geom = "text", y = 1, x = 1.5, label = "REFERENCE",
           size = 5, fontface = "italic", vjust = -1.03) +
  annotate(geom = "text", y = 1, x = 3.5, label = "Short-duration",
           size = 5, fontface = "italic", vjust = -1.03) +
  annotate(geom = "text", y = 1, x = 5.5, label = "Long-duration",
           size = 5, fontface = "italic", vjust = -1.03) +
  # Axis labels and theme tweaks
  # scale_y_continuous(
  #   limits = c(0, .1),
  #   breaks = c(0, .25, .50, .75, 1),
  #   labels = percent_format(accuracy = 1)
  # ) +
  labs(
    x = NULL,  size=15, tag="",
    y = expression("Mean relative P proportion [  "*"%"*" ]")
  ) +
  scale_fill_manual(values = c( "#018571","#80CDC1","#DFC27D","#A6611A"),
                    # palette = "Dark2",
                    labels = labels_Pfractions
  ) +
  theme_light(base_size = 15) +
  theme(
    axis.text.x       =  element_text(size = 15),
    axis.text.y       = element_text(size = 15),
    legend.position   = "top",
    legend.title      = element_blank(),
    strip.background  = element_blank(),
    plot.tag = element_text(size=15),
    strip.text.x      = element_text(colour = "grey30", face = "bold"),
    strip.text.y      = element_text(colour = "grey30", face = "bold"),
    panel.grid        = element_blank(),
    panel.spacing.x   = unit(1.5, "lines"), 
    plot.background = element_rect(color = "black", fill = NA, linewidth = 0.5)
  ) +
  #scale_y_continuous(breaks = pretty(pct_sum_cr$pct, n = 5))+
  
  scale_x_discrete(labels = c("RURAL","FOREST","Low-intensity","High-intensity",
                              "Low-intensity","High-intensity"))

p_relative

#All plots together
#png
png ("./Paper 4_Pfractions/Drafts/Figures/2026_Figures/fig5_relativeP.png",
     height =25, width =30, units = 'cm',  res = 300) #, compression = "lzw")

p_relative

dev.off()

#pdf
pdf ("./Paper 4_Pfractions/Drafts/Figures/2026_Figures/fig5_relativeP.pdf",
     height =10, width =15, ) #,units = 'cm'res = 300 compression = "lzw")
p_relative

dev.off()

#

##=================== Relationship ================================

model_Pavail_som <- lm ((log_p_available_gm2_lod) ~ (log_p_SOM_gm2) * class * road_class, 
                    data= ksitotal_P_filtered_urbanREF_data %>% 
                      filter(p_available_gm2<60, !(class %in% c("FOREST", "RURAL"))))
                      
                      #droplevels(subset(ksitotal_P_filtered_urbanREF_data, 
                      #             !(class %in% c("FOREST", "RURAL")))))

ggplot(ksitotal_P_filtered_urbanREF_data) 
  aes(y= p_available_gm2_lod0, x= p_SOM_gm2_lod0, colour = urbimpact) + 
  geom_point(aes(size=SOC_kgm2), show.legend = F) + geom_smooth(method = "lm")


hist(resid(model_Pavail_som))
car::qqPlot(resid(model_Pavail_som))#, group= ksitotal_P_filtered_urbanREF_data$class)
shapiro.test(resid(model_Pavail_som))
plot(DHARMa::simulateResiduals(fittedModel = model_Pavail_som, n = 500))
jtools::plot_summs(model_Pavail_som,inner_ci_level = 0.9)
jtools::summ(model_Pavail_som)
summary(model_Pavail_som)

#
#load_pkg("ggpubr")

formula = y~x

#Pavaila and PSOM seem to be highly related in long and highly intensive fields 
p_relatinship_pavail_psom <- ggplot (ksitotal_P_filtered_urbanREF_data)+ #%>% 
            #filter( !(class %in% c("FOREST", "RURAL")))) + #p_available_gm2_lod0<60,
  aes (y=(log_p_available_gm2_lod), x = (log_p_SOM_gm2), color=road_class) + 
  geom_point(aes(alpha=0.5, size = P_total_HNO3_gm2_filled, 
                 fill = road_class),show.legend = FALSE, shape=21, color="black",
             position = position_jitterdodge(dodge.width = 0.6)) + 
  geom_smooth(method = "lm", linetype=1, aes(color=road_class), se = TRUE,
              formula = formula)+ facet_grid(.~ class, scales = "free") + 
  labs(y=  bquote('Log1p (y) P'[Pa]~ '['~g*~~P~~m^-2~']'), 
       x= bquote('Log1p (x) P'[SOM]~ '['~g*~~P~~m^-2~']'))+ 
       
  theme(legend.position = "top")+
  theme_light(base_size=15)+
  theme(axis.text.x = element_text(size=15),
        axis.text.y = element_text(size = 15),
        legend.position="none",
        strip.background = element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,
        panel.spacing.x = unit(1.5, "lines"))+

  scale_fill_manual(values= c ("grey","#BFA004FF","#00B0F0"))+
  scale_color_manual(values= c ("black","#BFA004FF","#00B0F0"))+
stat_poly_eq(use_label("eq", "R2","P"), formula = y~x, 
             size=5)


p_relatinship_pavail_psom

#pdf
pdf ("./Paper 4_Pfractions/Drafts/Figures/2026_Figures/fig6_rel_PPA_PSOM.pdf",
     height =4, width =10) #,units = 'cm'res = 300 compression = "lzw")
p_relatinship_pavail_psom

dev.off()

#Pavaila and PCa seem to be highly related in long and highly intensive fields 
p_relatinship_pavail_pca <-  ggplot (ksitotal_P_filtered_urbanREF_data)+ #%>% 
                # filter(#p_available_gm2<60, p_Ca_gm2>0,
                #        !(class %in% c("FOREST", "RURAL")))) +
  aes (y=(log_p_available_gm2_lod), x = (log_p_Ca_gm2), color=road_class) + 
  geom_point(aes(alpha=0.5, size = P_total_HNO3_gm2_filled, 
                 fill = road_class),show.legend = F, shape=21, color="black",
             position = position_jitterdodge(dodge.width = 0.6)) + 
  geom_smooth(method = "lm",se = T, linetype=1, aes(color=road_class), 
              formula = formula)+ facet_grid(.~ class, scales = "free") + 
  labs(y=  bquote('Log1p (y) P'[Pa]~ '['~g*~~P~~m^-2~']'), 
       x= bquote('Log1p (x) P'[Ca]~ '['~g*~~P~~m^-2~']'))+ 
  theme(legend.position = "top")+
  theme_light(base_size=15)+
  theme(axis.text.x = element_text(size=15),
        axis.text.y = element_text(size = 15),
        legend.position="none",
        strip.background = element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,
        panel.spacing.x = unit(1.5, "lines"))+
  expand_limits(x =0, y = 0.5) +
  scale_fill_manual(values= c ("grey","#BFA004FF","#00B0F0"))+
  scale_color_manual(values= c ("black","#BFA004FF","#00B0F0"))+
  stat_poly_eq(use_label("eq", "R2","P"), formula = y~x, 
               size=5)


p_relatinship_pavail_pca

#pdf
pdf ("./Paper 4_Pfractions/Drafts/Figures/2026_Figures/fig6_rel_PPA_PCA.pdf",
     height =4, width =10) #,units = 'cm'res = 300 compression = "lzw")

p_relatinship_pavail_pca

dev.off()

#Pavaila and Pocc seem to be highly related in long and highly intensive fields 
p_relatinship_pavail_pocc <- ggplot (ksitotal_P_filtered_urbanREF_data )+# %>% 
                  # filter(#p_available_gm2<60, p_Ca_gm2>0,
                  # !(class %in% c("FOREST", "RURAL")))) +
  aes (y=(log_p_available_gm2_lod), x = (log_p_OCC_gm2), color=road_class) + 
  geom_point(aes(alpha=0.5, size = P_total_HNO3_gm2_filled, 
                 fill = road_class),show.legend = F, shape=21, color="black",
             position = position_jitterdodge(dodge.width = 0.6)) + 
  geom_smooth(method = "lm",se = T, linetype=1, aes(color=road_class), 
              formula = formula)+ facet_grid(.~ class, scales = "free") +  
  labs(y=  bquote('Log1p (y) P'[Pa]~ '['~g*~~P~~m^-2~']'), 
       x= bquote('Log1p (x) P'[OCC]~ '['~g*~~P~~m^-2~']'))+ 
  theme_light(base_size=15)+
  theme(axis.text.x = element_text(size=15),
        axis.text.y = element_text(size = 15),
        legend.position="none",
        strip.background = element_blank(),
        strip.text.x=element_text(colour="grey30",face="bold"),
        strip.text.y=element_text(colour="grey30",face="bold",angle = 360),
        panel.grid=element_blank() ,
        panel.spacing.x = unit(1.5, "lines"))+
  scale_fill_manual(values= c ("grey","#BFA004FF","#00B0F0"))+
  scale_color_manual(values= c ("black","#BFA004FF","#00B0F0"))+
  stat_poly_eq(use_label("eq", "R2","P"), formula = y~x, 
               size=5)

p_relatinship_pavail_pocc

#pdf
pdf ("./Paper 4_Pfractions/Drafts/Figures/2026_Figures/fig6_rel_PPA_POCC.pdf",
     height =4, width =10) #,units = 'cm'res = 300 compression = "lzw")

p_relatinship_pavail_pocc

dev.off()


#1. Export the 
png("./Paper 4_Pfractions/Drafts/Figures/2026_Figures/figPavail_relationship_withOtherPs.png",  
    height =40, width =45, units = 'cm',  res = 300) #, compression = "lzw")

gridExtra::grid.arrange (p_relatinship_pavail_psom, p_relatinship_pavail_pca, 
                        p_relatinship_pavail_pocc, ncol = 1)

dev.off()

#pdf
pdf ("./Paper 4_Pfractions/Drafts/Figures/2026_Figures/fig6Pavail_relationship_withOtherPs.pdf",
     height =15, width =20, ) #,units = 'cm'res = 300 compression = "lzw")

gridExtra::grid.arrange (p_relatinship_pavail_psom, p_relatinship_pavail_pca, 
                         p_relatinship_pavail_pocc, ncol = 1)


dev.off()

#
#============================Structural Equation Modelling======================
#After here I decided to try out Lavaan for the SEM instead of building individual models to explain what I want to say 
glimpse(ksitotal_P_filtered_urbanREF_data)

ksitotal_P_filtered_urban_data <- droplevels(subset(ksitotal_P_filtered_urbanREF_data, 
                                !(class %in% c("FOREST", "RURAL"))))

#log1p transform the SOC and ExtCa

ksitotal_P_filtered_urban_data <- ksitotal_P_filtered_urban_data %>% 
  dplyr::mutate(logSOC_kgm2 = log1p (as.numeric(SOC_kgm2)), 
         logExCa_gm2 = log1p (exch_Ca_stocks_gm2)
                            )

model <- '
  # Exogenous soil properties → reserve pools
  log_p_SOM_gm2 ~ logSOC_kgm2 + pH + logExCa_gm2         
  log_p_Ca_gm2 ~ logSOC_kgm2 + pH + logExCa_gm2         
  log_p_OCC_gm2 ~ logSOC_kgm2 + pH + logExCa_gm2         

  # Reserve pools + soil properties → labile P (PPa)
  log_p_available_gm2_lod ~ logSOC_kgm2 + pH + logExCa_gm2 + log_p_SOM_gm2 + log_p_Ca_gm2 + log_p_OCC_gm2

  # Allow shared unmodelled influences among reserve pools
  log_p_SOM_gm2 ~~ log_p_Ca_gm2 + log_p_OCC_gm2
  log_p_Ca_gm2 ~~ log_p_OCC_gm2
'
vars <- c("log_p_available_gm2_lod","log_p_SOM_gm2",
          "log_p_Ca_gm2","log_p_OCC_gm2",
          "logSOC_kgm2","pH","logExCa_gm2","class", "road_class")

SEM_P_data <- na.omit(ksitotal_P_filtered_urban_data[, vars])
# fit <- lavaan::sem(model, data = dat, estimator = "MLR", missing = "fiml")

fit_class <-  lavaan::sem(model, data = SEM_P_data, 
                    group="class", estimator = "MLR", missing = "fiml")

fit_road_class <-  lavaan::sem(model, data = SEM_P_data, 
                          group="road_class", estimator = "MLR", missing = "fiml")
varTable(fit) #checking variances 
lavInspect(fit, "cov.lv")
summary(fit, fit.measures=T) #evaluate model perfomance

# Summarize the model
summary(fit_road_class, standardized = TRUE, rsq=T)
summary(fit, fit.measures = TRUE, rsq=T)
# pull specific fit measures
lavaan::fitMeasures(fit, c("chisq","df","pvalue","cfi",
                           "tli","rmsea","rmsea.ci.lower",
                           "rmsea.ci.upper","srmr"))

#plot
#export as tif
pdf("./Paper 4_Pfractions/Drafts/Figures/2026_Figures/Fig_SEMP_short_long.pdf",
     height =25, width =30) #compression = "lzw",  bg = "transparent" , res = 600)

semPaths(fit_class, edge.label.cex = 1,whatLabels = "std", what= "std",
         style = "lisrel", reorder = FALSE, intercepts = F, 
         layout = "tree",nCharNodes= 0, nCharEdges=0,
         sizeMan=6,  edge.color = "black", mar = c(10, 5, 10, 5),
         fixedStyle = 1,curvePivot = TRUE, #exoVar = FALSE,  #color = "yellow",
         color = list(lat= rgb(220,220,220,maxColorValue = 255), 
                      man = c("#80CDC1","#DFC27D","#A6611A","#018571","white", "white","white") 
                      #exoCov = FALSE, fade=FALSE
         ))  #whatLabels = "eq"

dev.off()
#

#plot
#export as tif
pdf("./Paper 4_Pfractions/Drafts/Figures/2026_Figures/Fig_SEMP_low_hi.pdf",
    height =25, width =30) #compression = "lzw",  bg = "transparent" , res = 600)

semPaths(fit_road_class, edge.label.cex = 1,whatLabels = "std", what= "std",
         style = "ram", reorder = FALSE, intercepts = F, 
         layout = "tree", nCharNodes= 0, nCharEdges=0,
         sizeMan=6,  edge.color = "black", mar = c(10, 5, 10, 5),
         fixedStyle = 1,curvePivot = TRUE, #exoVar = FALSE,  #color = "yellow",
         color = list(lat= rgb(220,220,220,maxColorValue = 255), 
                      man = c("#80CDC1","#DFC27D","#A6611A","#018571","white", "white","white") 
                      #exoCov = FALSE, fade=FALSE
         ))  #whatLabels = "eq"

dev.off()
#





#
PATH_cationsData <- "C:/Users/sasaber/ownCloud - sasaber@gwdg.de@owncloud.gwdg.de/PostDoc/Papers_To_Be_completed_from_PhD/Paper 3_ECEC_BS_N/R_dataAnalysis/2020Analyses/N_CEC_paper2023/main_data_ghana.csv"
cations_data <- read.csv(PATH_cationsData)

cations_distace <- cations_data |> dplyr::select(sample_id, NEAR_DIST_km)

ksitotal_P_filtered_urbanREF_data <- plyr::join(ksitotal_P_filtered_urbanREF_data, cations_distace, "sample_id")


#the boxplot showing the groups and distance to primary road 

ggplot(ksitotal_P_filtered_urbanREF_data |> dplyr::filter(road_class != "Reference")) + 
  aes (x = class, y = NEAR_DIST_km, fill = road_class) + 
  geom_boxplot()

plot_distances <- baseboxplot_rdinfluence(ksitotal_P_filtered_urbanREF_data, x_col = "class", 
                        y_col = "NEAR_DIST_km", z_class_col = "road_class") 


plot_distances


#pdf
pdf ("./Paper 4_Pfractions/Drafts/Figures/2026_Figures/supplementary_Fig1distance.pdf",
     height =5, width =7, ) #,units = 'cm'res = 300 compression = "lzw")

plot_distances

dev.off()





























