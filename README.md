# Urbanization and Soil Phosphorus in Tropical West Africa

[![DOI](https://img.shields.io/badge/DOI-10.25625%2FDA3TOR-blue)](https://doi.org/10.25625/DA3TOR) [![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/) [![R](https://img.shields.io/badge/R-%3E%3D4.0.0-blue)](https://www.r-project.org/)

## Overview

R code and analysis pipeline for the peer-reviewed manuscript:

**"Oxide-occluded to calcium-bound: Urbanization increases soil phosphorus stocks and diversifies pools in tropical West African agroecosystems"**

*Journal of Geophysical Research: Biogeosciences* (2026) [DOI pending]

------------------------------------------------------------------------

## Key Findings

- **Urbanization more than doubles soil P stocks** in tropical urban croplands
- **Calcium-bound P emerges as a major pool** — atypical in strongly weathered tropical soils and masked in standard P fractionation schemes
- **Dual-pathway control on available P**: natively by pedogenic oxides + introduced calcium pathways under urbanization
- **Tropical urban arable soils act as inadvertent P sinks**, with potential to be harnessed for sustainable food production

------------------------------------------------------------------------

## Quick Start

```r
# 1. Install required packages
source("scripts/load_packages.R")

# 2. Download data from Göttingen Dataverse
source("data/download_data.R")

# 3. Reproduce Figure 4
source("scripts/Figure4.R")
```

------------------------------------------------------------------------

## Repository Structure

```
phosphorus-urbanization-kumasi/
├── README.md                        # This file
├── LICENSE                          # CC BY 4.0 license
├── CITATION.cff                     # Citation metadata
├── .gitignore                       # Excludes data files and local outputs
│
├── scripts/
│   ├── load_packages.R              # Installs and loads all required packages
│   ├── Figure4.R                    # P fractions across urbanisation classes (panels a–f)
│   ├── run_full_analysis.R          # Master script (runs entire pipeline)
│   │
│   └── utils/
│       ├── function_twoway_boxplot.R
│       ├── function_twoway_boxplot_points_Shape.R
│       └── function_twoway_boxplot_points_Shape_totalPfractions.R
│
├── data/
│   ├── download_data.R              # Downloads dataset from Dataverse
│   └── README.md                    # Data access instructions
│
└── output/
    ├── figures/                     # Generated plots — not tracked by Git
    └── tables/                      # Statistical outputs — not tracked by Git
```

------------------------------------------------------------------------

## Dataset

**Repository:** University of Göttingen Research Data Repository (GRO.data)  
**DOI:** <https://doi.org/10.25625/DA3TOR>  
**File:** `MAIN_DATA_P_fractions_2026.csv` — 650 topsoil samples × 82 variables

**Contents:**
- Soil P fractionation data (PPa, PSOM, PCa, POCC) as stocks (g P m⁻²)
- Total P stocks (HNO₃ and multi-acid extraction)
- Soil properties (pH, SOC, exchangeable Ca, ECEC)
- Urbanization classification (duration: short-term / long-term; intensity: low / high)
- Quality flags (LOD and LOQ status for each P fraction)

Data are publicly available under **CC0 1.0** — no restrictions on reuse.

------------------------------------------------------------------------

## Installation

### System Requirements

- **R:** ≥ 4.0.0 (tested on R 4.6.1)
- **OS:** Windows, macOS, or Linux
- **RAM:** ≥ 4 GB recommended

### Setup

1. **Clone the repository:**

    ```bash
    git clone https://github.com/sasabere/phosphorus-urbanization-kumasi.git
    cd phosphorus-urbanization-kumasi
    ```

2. **Install R packages:**

    ```r
    source("scripts/load_packages.R")
    ```

3. **Download the dataset from Dataverse:**

    ```r
    source("data/download_data.R")
    # OR download manually from https://doi.org/10.25625/DA3TOR
    ```

------------------------------------------------------------------------

## Usage

### Reproduce individual figures

```r
source("scripts/Figure4.R")   # P fraction stocks (panels a–f)
source("scripts/Figure5.R")   # Mean relative P proportions
```

Saves PNG and PDF files to `output/figures/`.

### Run Full Pipeline

```r
source("scripts/run_full_analysis.R")
```

------------------------------------------------------------------------

## Methods Summary

### P Fractionation

Sequential extraction separating four operational pools:

| Fraction    | Extraction                      | Interpretation              |
|-------------|---------------------------------|-----------------------------|
| **PPa**     | 0.5 M NaHCO₃ (pH 8.5)          | Plant-available P           |
| **PSOM**    | H₂O₂–acetate                   | Soil organic matter-bound P |
| **PCa**     | Mild HCl–acetate                | Calcium-bound P             |
| **POCC**    | Dithionite–citrate–bicarbonate  | Oxide-occluded P            |
| **Total P** | HNO₃ digestion                  | All soil P                  |

### Statistical Analysis

- **Linear models (two-way ANOVA):** Urbanization effects on P stocks
- **Contrasts:** Tukey-adjusted pairwise comparisons via `emmeans`
- **Bivariate regressions:** PPa vs. reserve pools (PSOM, PCa, POCC)
- **SEM:** Multi-group structural equation models (`lavaan`)

------------------------------------------------------------------------

## Figures

| Figure | Description | Script |
|--------|-------------|--------|
| 1 | Study area map | — (not coded) |
| 2 | Soil profile photograph | — (not coded) |
| 3 | Sequential P fractionation scheme | — (not coded) |
| 4 | P fraction stocks across urbanisation classes (a–f) | `scripts/Figure4.R` |
| 5 | Mean relative proportions of P fractions | `scripts/Figure5.R` |
| 6 | Bivariate regressions: PPa vs reserve pools | — (in progress) |
| 7 | SEM path diagrams | — (in progress) |

Output: `output/figures/` (PNG + PDF formats)

------------------------------------------------------------------------

## Citation

### Paper

```
Asabere, S.B., Sauer, D. (2026). Oxide-occluded to calcium-bound:
Urbanization increases soil phosphorus stocks and diversifies pools in
tropical West African agroecosystems. Journal of Geophysical Research:
Biogeosciences. https://doi.org/[pending]
```

### Dataset

```
Asabere, S.B. (2026). Soil Phosphorus Stocks and Partitioning Along an
Urbanization Gradient in Kumasi, Ghana [Dataset]. University of Göttingen.
https://doi.org/10.25625/DA3TOR
```

### Code

```
Asabere, S.B. (2026). R code for: Urbanization and soil phosphorus in
tropical West Africa (v1.0). GitHub.
https://github.com/sasabere/phosphorus-urbanization-kumasi
```

Or use `CITATION.cff` for automatic citation export.

------------------------------------------------------------------------

## License

**Code:** CC BY 4.0 (Creative Commons Attribution 4.0 International)  
**Data:** CC0 1.0 (see Dataverse)

You are free to share and adapt with attribution. See [LICENSE](LICENSE).

------------------------------------------------------------------------

## Funding

Deutsche Forschungsgemeinschaft (DFG), project **467340364**

------------------------------------------------------------------------

## Acknowledgments

- **Lab support:** Jago Birk, Petra Voigt, Anja Soedje (Physical Geography lab, University of Göttingen)
- **P fractionation:** Dr. Harold J. Hughes
- **Research assistance:** Jianghu Li, Tino Poeplau
- **Field access:** Farmers in Kumasi, Ghana

------------------------------------------------------------------------

## Contact

**Stephen B. Asabere**  
Department of Physical Geography  
University of Göttingen  
✉ [stephen.asabere@uni-goettingen.de](mailto:stephen.asabere@uni-goettingen.de)  
🔗 [GitHub](https://github.com/sasabere)

------------------------------------------------------------------------

## Version History

- **v1.0.0** (July 2026): Initial release — `load_packages.R`, `download_data.R`, `Figure4.R`

------------------------------------------------------------------------

*Repository maintained by Stephen Asabere | Last updated: July 2026*
