
README.md for Dataverse Dataset
Dataset Title
Soil Phosphorus Stocks and Partitioning Along an Urbanization Gradient in Kumasi, Ghana

Citation
Asabere, S.B.(2026). Soil Phosphorus Stocks and Partitioning Along an Urbanization Gradient in Kumasi, Ghana [Dataset]. University of Göttingen. https://doi.org/10.25625/DA3TOR

Description
This dataset contains soil phosphorus (P) and physicochemical data from 225 topsoil samples (0–10 cm depth) collected from rainfed maize fields on Ferric Acrisols in Kumasi, Ghana. Samples were collected along a gradient of urbanization influence to quantify the effects of urbanization on soil P stocks and partitioning among operational P fractions.
Study Area: Kumasi Metropolitan Area, Ghana
Sampling Depth: 0–10 cm
Soil Type: Ferric Acrisols (WRB classification)
Land Use: Urban and peri-urban rainfed maize agroecosystems
Number of Samples: 650

Associated Publication
This dataset is associated with the following publication:
Asabere, S.B., Sauer, D. (2026). Oxide-occluded to calcium-bound: Urbanization increases soil phosphorus stocks and diversifies pools in tropical West African agroecosystems. Journal of Geophysical Research: Biogeosciences. [Add DOI when available]

Funding
This research was supported by the Deutsche Forschungsgemeinschaft (DFG), project number 467340364.

Data Files
MAIN_DATA_P_fractions_2026..csv
Complete dataset containing soil properties, phosphorus fractionation data, and urbanization classification for all 225 samples.
File format: CSV (comma-separated values)
Encoding: UTF-8
Missing values: Coded as NA
Number of rows: 225 (plus header)
Number of columns: 81

Variable Descriptions
Variables are organized into the following categories:
1. Sample Identifiers and Field Information
VariableDescriptionUnitssample_idUnique sample identifier-field_IDField identifier-farmsFarm classification/grouping-profile_infoSoil profile information-

2. Soil Physical Properties
VariableDescriptionUnitswater_factorWater content correction factor-skeletonCoarse fragment (>2mm) content% by weightfine_earth_kgdm3Fine earth (<2mm) bulk densitykg dm⁻³fine_earth_gFine earth massgbulkdensity_gcm3Fine earth bulk densityg cm⁻³soil_moistureGravimetric soil moisture content%

3. Urbanization Classification
VariableDescriptionValues/UnitsclassIntegrated urbanization influence classweak, mild, moderate, strongroad_classRoad proximity class-urbimpactUrbanization impact composite measure-
Note: The class variable represents the four-level urbanization gradient used in the main analysis (weak < mild < moderate < strong).

4. Total Phosphorus
4a. HNO₃ Digestion (Primary Total P Method)
VariableDescriptionUnitsP_HNO3total_40_gkgTotal P (HNO₃), dried at 40°Cg P kg⁻¹P_HNO3total_105_gkgTotal P (HNO₃), dried at 105°Cg P kg⁻¹P_HNO3total_105_mgkgTotal P (HNO₃), dried at 105°Cmg P kg⁻¹P_total_HNO3_gm2Total P stock (HNO₃)g P m⁻²P_total_HNO3_gm2_predPredicted total P stock (HNO₃)g P m⁻²P_total_HNO3_gm2_filledGap-filled total P stock (HNO₃)g P m⁻²
4b. Multi-Acid Digestion (Alternative Total P Method)
VariableDescriptionUnitsp_total_multiacid_40_mgkgTotal P (multi-acid), dried at 40°Cmg P kg⁻¹p_total_multiacid_105_mgkgTotal P (multi-acid), dried at 105°Cmg P kg⁻¹p_total_multiacid_105_gkgTotal P (multi-acid), dried at 105°Cg P kg⁻¹p_total_multiacid_gm2Total P stock (multi-acid)g P m⁻²

5. Sequential Phosphorus Fractions
5a. Concentrations (40°C dried samples)
VariableDescriptionExtraction MethodUnitsp_available_40_gkgPlant-available P (PPa)0.5 M NaHCO₃, pH 8.5g P kg⁻¹p_SOM_40_gkgSOM-bound P (PSOM)H₂O₂–acetateg P kg⁻¹p_Ca_40_gkgCa-bound P (PCa)Mild HCl–acetateg P kg⁻¹p_OCC_40_gkgOxide-occluded P (POCC)Dithionite–citrate–bicarbonateg P kg⁻¹
5b. Concentrations (105°C dried samples)
VariableDescriptionUnitsp_available_105_gkgPlant-available P (PPa)g P kg⁻¹p_available_105_mgkgPlant-available P (PPa)mg P kg⁻¹p_SOM_105_gkgSOM-bound P (PSOM)g P kg⁻¹p_SOM_105_mgkgSOM-bound P (PSOM)mg P kg⁻¹p_Ca_105_gkgCa-bound P (PCa)g P kg⁻¹p_Ca_105_mgkgCa-bound P (PCa)mg P kg⁻¹p_OCC_105_gkgOxide-occluded P (POCC)g P kg⁻¹p_OCC105_mgkgOxide-occluded P (POCC)mg P kg⁻¹
5c. Stocks (g P m⁻²)
VariableDescriptionUnitsp_available_gm2Plant-available P stock (PPa)g P m⁻²p_available_gm2_lod0PPa stock with LOD values set to 0g P m⁻²p_SOM_gm2SOM-bound P stock (PSOM)g P m⁻²p_SOM_gm2_lod0PSOM stock with LOD values set to 0g P m⁻²p_Ca_gm2Ca-bound P stock (PCa)g P m⁻²p_Ca_gm2_lod0PCa stock with LOD values set to 0g P m⁻²p_OCC_gm2Oxide-occluded P stock (POCC)g P m⁻²p_OCC_gm2_lod0POCC stock with LOD values set to 0g P m⁻²
5d. Sum of Extractable P
VariableDescriptionUnitsp_EXT_total_gkgSum of all fractions (PPa+PSOM+PCa+POCC)g P kg⁻¹p_EXT_total_gm2Sum of all fraction stocksg P m⁻²p_EXT_total_gm2_lod0Sum of all fraction stocks (LOD=0)g P m⁻²

6. Limit of Quantification (LOQ) Status Flags
VariableDescriptionValuespavail_statusPPa quantification statuscategoricalpsom_statusPSOM quantification statuscategoricalpca_statusPCa quantification statuscategoricalpocc_statusPOCC quantification statuscategoricalpavail_ge_loqPPa ≥ LOQ?TRUE/FALSEpsom_ge_loqPSOM ≥ LOQ?TRUE/FALSEpca_ge_loqPCa ≥ LOQ?TRUE/FALSEpocc_ge_loqPOCC ≥ LOQ?TRUE/FALSEn_fractions_ge_loqNumber of fractions ≥ LOQ0-4all4_ge_loqAll 4 fractions ≥ LOQ?TRUE/FALSEfrac_ge_loq_listList of fractions ≥ LOQtext
Quantified Values (for samples ≥ LOQ)
VariableDescriptionUnitsp_available_40_gkg_qPPa (only samples ≥ LOQ)g P kg⁻¹p_SOM_40_gkg_qPSOM (only samples ≥ LOQ)g P kg⁻¹p_Ca_40_gkg_qPCa (only samples ≥ LOQ)g P kg⁻¹p_OCC_40_gkg_qPOCC (only samples ≥ LOQ)g P kg⁻¹
Note: Variables ending in _q contain values only for samples where the fraction was ≥ LOQ; samples < LOQ are coded as NA.

7. Other Soil Properties
VariableDescriptionUnitspHSoil pH (1:2.5 soil:water)-SOCf_gkgSoil organic carbon concentrationg C kg⁻¹SOC_kgm2Soil organic carbon stockkg C m⁻²C_NCarbon to nitrogen ratio-exch_ca_105_cmolkgExchangeable calciumcmolc kg⁻¹exch_Ca_stocks_gm2Exchangeable calcium stockg Ca m⁻²ECEC_105Effective cation exchange capacitycmolc kg⁻¹

8. Fraction Percentages and Ratios
8a. Percentage of HNO₃ Total P
VariableDescriptionUnitsp_avail_pct_HNO3PPa as % of total P (HNO₃)%p_SOM_pct_HNO3PSOM as % of total P (HNO₃)%p_Ca_pct_HNO3PCa as % of total P (HNO₃)%p_OCC_pct_HNO3POCC as % of total P (HNO₃)%p_sum_pct_HNO3Sum of fractions as % of total P%flag_over100Flag if sum > 100%TRUE/FALSE
8b. Percentage of Extractable P Pool
VariableDescriptionUnitsp_avail_PERCENT_sumtotalPPPa as % of extractable P%p_avail_PERCENT_sumtotalP_lod0PPa as % (LOD=0)%p_SOM_PERCENT_sumtotalPPSOM as % of extractable P%p_SOM_PERCENT_sumtotalP_lod0PSOM as % (LOD=0)%p_Ca_PERCENT_sumtotalPPCa as % of extractable P%p_Ca_PERCENT_sumtotalP_lod0PCa as % (LOD=0)%p_OCC_PERCENT_sumtotalPPOCC as % of extractable P%p_OCC_PERCENT_sumtotalP_lod0POCC as % (LOD=0)%

Methods Summary
Sampling Design
Topsoil samples (0–10 cm) were collected from rainfed maize fields across Kumasi Metropolitan Area, Ghana. Sampling sites were stratified into four urbanization influence classes (weak, mild, moderate, strong) based on a composite urbanization impact measure.
Laboratory Analysis
Soil Drying:

Samples were dried at both 40°C (air-dry equivalent) and 105°C (oven-dry)
Most P fraction data are reported for 105°C-dried samples
Concentrations were corrected using the water factor

Soil Properties:

pH: 1:2.5 soil:water suspension
Soil Organic Carbon (SOC): Dry combustion (Leco)
Bulk Density: Core method, corrected for coarse fragments
Exchangeable Cations: NH4CL Extraction and ICP-OES measured

Phosphorus Fractionation:
A tailored sequential extraction was applied to separate four operational P fractions:

Plant-available P (PPa): 0.5 M NaHCO₃ (pH 8.5) extraction
SOM-bound P (PSOM): H₂O₂–acetate extraction
Ca-bound P (PCa): Mild HCl–acetate extraction
Oxide-occluded P (POCC): Dithionite–citrate–bicarbonate (DCB) extraction

Total P:

Primary method: HNO₃ digestion
Alternative method: Multi-acid digestion (for comparison)

P concentrations were determined by [ICP-OES/spectrophotometry - specify].
Stock Calculations:
P stocks (g P m⁻²) were calculated as:
Stock (g m⁻²) = Concentration (g kg⁻¹) × Bulk density (kg m⁻³) × Depth (m) × (1 - Skeleton fraction)
Where:

Depth = 0.10 m
Skeleton fraction = coarse fragment content (>2 mm)


Data Quality and Limitations
Analytical Quality

All samples were analyzed at [Institute of Geography Laboratory, Department of Physical Geography, University of Göttingen]
Duplicate and blank samples were included for quality control
Limit of quantification (LOQ) varied by fraction; see status flags

Handling of Below-LOQ Values
Two approaches are provided in the dataset:

Standard variables (e.g., p_available_gm2): Values < LOQ are coded as NA or as measured values
"lod0" variables (e.g., p_available_gm2_lod0): Values < LOQ are set to 0

Users should choose the appropriate variable based on their analytical approach.
Data Completeness

Some PSOM values were below LOQ, particularly in weakly urbanized soils
Gap-filled total P values (P_total_HNO3_gm2_filled) are provided where direct measurements were unavailable
The n_fractions_ge_loq variable indicates how many fractions were quantifiable for each sample

Known Issues

The variable flag_over100 identifies samples where the sum of fractions exceeded total P (may indicate analytical uncertainty)
Some percentage calculations may produce values >100% due to independent measurement of fractions and total P


Usage Notes
Recommended Variables for Analysis
For main analysis (as used in the publication):

Duration of urbanization: class (Short-duration, long-duration)
Intensity of urbanization: class_road (Low-intensity, High-intensity)
Urbanization class: class (weak, mild, moderate, strong)
Total P: P_total_HNO3_gm2_filled (gap-filled stock data)
P fractions (stocks): p_available_gm2, p_SOM_gm2, p_Ca_gm2, p_OCC_gm2
Soil properties: pH, SOC_kgm2, exch_Ca_stocks_gm2
LOQ status: Check *_ge_loq variables before analysis

For percent contributions:
Use *_PERCENT_sumtotalP variables (fractions as % of extractable P pool)
Statistical Considerations

Log-transformation: For statistical models, log1p transformation was applied to P stocks and other skewed variables
Samples with fractions < LOQ: Consider using LOQ status flags to filter data or apply appropriate censored data methods
Multiple drying temperatures: Use 105°C data for consistency with stock calculations


Reproducibility
Code Availability
R code for data processing, statistical analysis, and figure generation is available at:
[Add GitHub repository URL once created]
Software Requirements
All analyses were conducted in R version [R version 4.5.2 (2025-10-31 ucrt)]. Required packages are listed in the paper and accompanying code repository.

License
This dataset is made available under the Creative Commons Attribution 4.0 International (CC BY 4.0) license.
You are free to:

Share — copy and redistribute the material
Adapt — remix, transform, and build upon the material

Under the following terms:

Attribution — You must give appropriate credit, provide a link to the license, and indicate if changes were made


Contact
Corresponding Author:
Stephen B. Asabere
Department of Physical Geography 
University of Göttingen
stephenboahen.asabere@uni-goettingen.de
For questions about the dataset or methods, please contact: stephenboahen.asabere@uni-goettingen.de

Acknowledgments
We thank Jago Birk, Petra Voigt, and Anja Soedje (Department of Physical Geography, University of Göttingen) for invaluable technical support in the laboratory. We especially thank Dr. Harold J. Hughes for his expertise in implementing the sequential phosphorus fractionation procedure, with assistance from student assistants Jianghu Li and Tino Poeplau.

Version History
Version 1.0 (02/25/2026): Initial release

How to Cite This Dataset
In-text citation:
(Asabere et al., 2026)
Full citation:
Asabere, S.B.(2025). Soil Phosphorus Stocks and Partitioning Along an Urbanization Gradient in Kumasi, Ghana [Dataset]. University of Göttingen. https://doi.org/10.25625/DA3TOR

END OF README