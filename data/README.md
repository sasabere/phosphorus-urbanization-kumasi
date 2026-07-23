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

### Key variable groups

| Group | Variables |
|---|---|
| Identifiers | `sample_id`, `field_ID` |
| Urbanisation | `class`, `road_class`, `urbimpact` |
| Total P | HNO₃ and multi-acid digestion stocks (g P m⁻²) |
| P fractions | PPa, PSOM, PCa, POCC — stocks, concentrations, LOQ flags |
| Soil properties | `pH`, `SOC_kgm2`, `exch_Ca_stocks_gm2`, `fine_earth_kgdm3` |
| Quality flags | `pavail_status`, `psom_status`, `pca_status`, `pocc_status` |

For a full variable dictionary see the README on the Dataverse page.

---

## Citation

```
Asabere, S.B. (2026). Soil Phosphorus Stocks and Partitioning Along an
Urbanization Gradient in Kumasi, Ghana [Dataset]. University of Göttingen.
https://doi.org/10.25625/DA3TOR
```
