# Data Directory

The dataset is **not stored in this repository**. It is hosted publicly on the
University of Göttingen Research Data Repository (GRO.data) under a CC0 1.0
licence — no restrictions on reuse.

**DOI:** https://doi.org/10.25625/DA3TOR  
**Direct link:** [Göttingen Dataverse](https://data.goettingen-research-online.de/dataset.xhtml?persistentId=doi:10.25625/DA3TOR)

---

## Download

### Automatic (recommended)

Open R from the repo root and run:

```r
source("data/download_data.R")
```

This fetches `MAIN_DATA_P_fractions_2026.csv` from Dataverse and saves it to
this `data/` folder. The file is excluded from Git (see `.gitignore`).

### Manual

1. Visit https://doi.org/10.25625/DA3TOR
2. Download **MAIN_DATA_P_fractions_2026.tab** (original CSV format)
3. Rename to `MAIN_DATA_P_fractions_2026.csv` and place in this `data/` folder

---

## Dataset Description

| Property | Value |
|---|---|
| **File** | `MAIN_DATA_P_fractions_2026.csv` |
| **Samples** | 650 topsoil samples (0–10 cm) |
| **Variables** | 82 columns |
| **Licence** | CC0 1.0 (public domain) |

> **Note:** 225 of the 650 samples have full sequential P fractionation data.
> The remaining 425 (urban short- and long-duration soils) have total P (HNO₃)
> measurements only. All 650 are included to preserve the full sampling context.

---

## Variable Dictionary

★ = used in manuscript figures (Figures 4–7)

### Naming convention

| Suffix | Meaning |
|---|---|
| `_40_gkg` | Concentration at 40 °C oven-dry (g kg⁻¹) |
| `_105_gkg` / `_105_mgkg` | Concentration at 105 °C oven-dry (g kg⁻¹ / mg kg⁻¹) |
| `_gm2` | Stock standardised to 10 cm depth (g P m⁻²) |
| `_lod0` | LOD-zeroed: values below detection limit set to 0 |
| `_q` | LOQ-corrected: values below LOQ set to LOQ ÷ 2 |
| `_pct_HNO3` | Fraction as % of HNO₃ total P |
| `_PERCENT_sumtotalP` | Fraction as % of sum of four extractable fractions |
| `_PERCENT_sumtotalP_lod0` | Same, using LOD-zeroed stocks |

---

### 1. Identifiers

| Variable | Type | Description |
|---|---|---|
| `sample_id` | integer | Unique sample identifier |
| `field_ID` | character | Field location label |
| `farms` | character | Farm name |
| `profile_info` | character | Soil profile descriptor (where applicable) |

---

### 2. Urbanisation classification ★

| Variable | Type | Values | Description |
|---|---|---|---|
| `class` | character | `RURAL`, `FOREST`, `Short-duration`, `Long-duration`, `Profile` | Urbanisation duration class |
| `road_class` | character | `Reference`, `Low-intensity`, `High-intensity`, `Profile` | Urbanisation intensity class |
| `urbimpact` | character | `RURAL`, `FOREST`, `Weak`, `Mild`, `Moderate`, `Strong`, `Profile` | Combined urbanisation impact level |

---

### 3. Soil physical properties

| Variable | Type | Unit | Description |
|---|---|---|---|
| `bulkdensity_gcm3` | numeric | g cm⁻³ | Bulk density at 105 °C |
| `fine_earth_kgdm3` | numeric | kg dm⁻³ | Fine earth bulk density |
| `fine_earth_g` | numeric | g | Fine earth mass per sample |
| `skeleton` | numeric | % | Coarse fragment (>2 mm) content |
| `soil_moisture` | numeric | — | Gravimetric soil moisture ratio |
| `water_factor` | numeric | — | Correction factor (40 °C → 105 °C) |

---

### 4. Soil chemical properties ★

| Variable | Type | Unit | Description |
|---|---|---|---|
| `pH` | numeric | — | Soil pH (CaCl₂) ★ |
| `SOCf_gkg` | numeric | g kg⁻¹ | Soil organic carbon concentration |
| `SOC_kgm2` | numeric | kg m⁻² | SOC stock (0–10 cm) ★ |
| `C_N` | numeric | — | C:N ratio |
| `ECEC_105` | numeric | cmol kg⁻¹ | Effective cation exchange capacity |
| `exch_ca_105_cmolkg` | numeric | cmol kg⁻¹ | Exchangeable Ca concentration |
| `exch_Ca_stocks_gm2` | numeric | g m⁻² | Exchangeable Ca stock (0–10 cm) ★ |

---

### 5. Total P — HNO₃ extraction ★

| Variable | Type | Unit | Description |
|---|---|---|---|
| `P_HNO3total_40_gkg` | numeric | g kg⁻¹ | Total P by HNO₃ at 40 °C |
| `P_HNO3total_105_gkg` | numeric | g kg⁻¹ | Total P by HNO₃ at 105 °C |
| `P_HNO3total_105_mgkg` | numeric | mg kg⁻¹ | Total P by HNO₃ at 105 °C |
| `P_total_HNO3_gm2` | numeric | g m⁻² | HNO₃ total P stock ★ |
| `P_total_HNO3_gm2_pred` | numeric | g m⁻² | Predicted total P (regression with multi-acid) |
| `P_total_HNO3_gm2_filled` | numeric | g m⁻² | Gap-filled total P stock (pred where HNO₃ missing) ★ |

---

### 6. Total P — multi-acid extraction

| Variable | Type | Unit | Description |
|---|---|---|---|
| `p_total_multiacid_40_mgkg` | integer | mg kg⁻¹ | Total P by multi-acid at 40 °C |
| `p_total_multiacid_105_mgkg` | numeric | mg kg⁻¹ | Total P by multi-acid at 105 °C |
| `p_total_multiacid_105_gkg` | numeric | g kg⁻¹ | Total P by multi-acid at 105 °C |
| `p_total_multiacid_gm2` | numeric | g m⁻² | Multi-acid total P stock |

---

### 7. P fractions — raw concentrations (40 °C)

| Variable | Type | Unit | Description |
|---|---|---|---|
| `p_available_40_gkg` | numeric | g kg⁻¹ | Plant-available P (PPa) raw |
| `p_SOM_40_gkg` | numeric | g kg⁻¹ | SOM-bound P (PSOM) raw |
| `p_Ca_40_gkg` | numeric | g kg⁻¹ | Ca-bound P (PCa) raw |
| `p_OCC_40_gkg` | numeric | g kg⁻¹ | Oxide-occluded P (POCC) raw |
| `p_available_40_gkg_q` | numeric | g kg⁻¹ | PPa LOQ-corrected |
| `p_SOM_40_gkg_q` | numeric | g kg⁻¹ | PSOM LOQ-corrected |
| `p_Ca_40_gkg_q` | numeric | g kg⁻¹ | PCa LOQ-corrected |
| `p_OCC_40_gkg_q` | numeric | g kg⁻¹ | POCC LOQ-corrected |

---

### 8. P fractions — concentrations (105 °C)

| Variable | Type | Unit | Description |
|---|---|---|---|
| `p_available_105_gkg` | numeric | g kg⁻¹ | PPa at 105 °C |
| `p_available_105_mgkg` | numeric | mg kg⁻¹ | PPa at 105 °C |
| `p_SOM_105_gkg` | numeric | g kg⁻¹ | PSOM at 105 °C |
| `p_SOM_105_mgkg` | numeric | mg kg⁻¹ | PSOM at 105 °C |
| `p_Ca_105_gkg` | numeric | g kg⁻¹ | PCa at 105 °C |
| `p_Ca_105_mgkg` | numeric | mg kg⁻¹ | PCa at 105 °C |
| `p_OCC_105_gkg` | numeric | g kg⁻¹ | POCC at 105 °C |
| `p_OCC105_mgkg` | numeric | mg kg⁻¹ | POCC at 105 °C |

---

### 9. P fractions — stocks (g P m⁻²) ★

| Variable | Type | Unit | Description |
|---|---|---|---|
| `p_available_gm2` | numeric | g m⁻² | PPa stock |
| `p_available_gm2_lod0` | numeric | g m⁻² | PPa stock, LOD-zeroed ★ |
| `p_SOM_gm2` | numeric | g m⁻² | PSOM stock |
| `p_SOM_gm2_lod0` | numeric | g m⁻² | PSOM stock, LOD-zeroed ★ |
| `p_Ca_gm2` | numeric | g m⁻² | PCa stock |
| `p_Ca_gm2_lod0` | numeric | g m⁻² | PCa stock, LOD-zeroed ★ |
| `p_OCC_gm2` | numeric | g m⁻² | POCC stock |
| `p_OCC_gm2_lod0` | numeric | g m⁻² | POCC stock, LOD-zeroed ★ |

---

### 10. Extractable P sum ★

| Variable | Type | Unit | Description |
|---|---|---|---|
| `p_EXT_total_gkg` | numeric | g kg⁻¹ | Sum of four fraction concentrations |
| `p_EXT_total_gm2` | numeric | g m⁻² | Sum of four fraction stocks ★ |
| `p_EXT_total_gm2_lod0` | numeric | g m⁻² | Sum of four fraction stocks, LOD-zeroed ★ |

---

### 11. LOD / LOQ quality flags ★

| Variable | Type | Values | Description |
|---|---|---|---|
| `pavail_status` | character | `<LOD`, `LOD–LOQ`, `>=LOQ` | PPa quantification status ★ |
| `psom_status` | character | `<LOD`, `LOD–LOQ`, `>=LOQ` | PSOM quantification status ★ |
| `pca_status` | character | `<LOD`, `LOD–LOQ`, `>=LOQ` | PCa quantification status ★ |
| `pocc_status` | character | `<LOD`, `LOD–LOQ`, `>=LOQ` | POCC quantification status ★ |
| `pavail_ge_loq` | logical | TRUE/FALSE | PPa ≥ LOQ |
| `psom_ge_loq` | logical | TRUE/FALSE | PSOM ≥ LOQ |
| `pca_ge_loq` | logical | TRUE/FALSE | PCa ≥ LOQ |
| `pocc_ge_loq` | logical | TRUE/FALSE | POCC ≥ LOQ |
| `n_fractions_ge_loq` | integer | 0–4 | Number of fractions ≥ LOQ ★ |
| `all4_ge_loq` | logical | TRUE/FALSE | All four fractions ≥ LOQ |
| `frac_ge_loq_list` | character | — | Comma-separated list of fractions ≥ LOQ |
| `flag_over100` | logical | TRUE/FALSE | Flag: fraction percentages sum > 100 % |

---

### 12. P fractions as % of HNO₃ total P

| Variable | Type | Description |
|---|---|---|
| `p_avail_pct_HNO3` | numeric | PPa as % of HNO₃ total P |
| `p_SOM_pct_HNO3` | numeric | PSOM as % of HNO₃ total P |
| `p_Ca_pct_HNO3` | numeric | PCa as % of HNO₃ total P |
| `p_OCC_pct_HNO3` | numeric | POCC as % of HNO₃ total P |
| `p_sum_pct_HNO3` | numeric | Sum of fractions as % of HNO₃ total P |

---

### 13. P fractions as % of extractable sum ★

| Variable | Type | Description |
|---|---|---|
| `p_avail_PERCENT_sumtotalP` | numeric | PPa % of extractable sum |
| `p_avail_PERCENT_sumtotalP_lod0` | numeric | PPa % of extractable sum, LOD-zeroed ★ |
| `p_SOM_PERCENT_sumtotalP` | numeric | PSOM % of extractable sum |
| `p_SOM_PERCENT_sumtotalP_lod0` | numeric | PSOM % of extractable sum, LOD-zeroed ★ |
| `p_Ca_PERCENT_sumtotalP` | numeric | PCa % of extractable sum |
| `p_Ca_PERCENT_sumtotalP_lod0` | numeric | PCa % of extractable sum, LOD-zeroed ★ |
| `p_OCC_PERCENT_sumtotalP` | numeric | POCC % of extractable sum |
| `p_OCC_PERCENT_sumtotalP_lod0` | numeric | POCC % of extractable sum, LOD-zeroed ★ |

---

## Citation

```
Asabere, S.B. (2026). Soil Phosphorus Stocks and Partitioning Along an
Urbanization Gradient in Kumasi, Ghana [Dataset]. University of Göttingen.
https://doi.org/10.25625/DA3TOR
```
