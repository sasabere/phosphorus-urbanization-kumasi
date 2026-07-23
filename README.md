[README.md](https://github.com/user-attachments/files/30095826/README.md)
------------------------------------------------------------------------



# Urbanization and Soil Phosphorus in Tropical West Africa

[![DOI](https://img.shields.io/badge/DOI-10.25625%2FDA3TOR-blue)](https://doi.org/10.25625/DA3TOR) [![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/) [![R](https://img.shields.io/badge/R-%3E%3D4.0.0-blue)](https://www.r-project.org/)

## Overview

R code and analysis pipeline for the peer-reviewed manuscript:

**"Oxide-occluded to calcium-bound: Urbanization increases soil phosphorus stocks and diversifies pools in tropical West African agroecosystems"**

*Journal of Geophysical Research: Biogeosciences* (2026) [DOI pending ...]

------------------------------------------------------------------------

## Key Findings

- **Urbanization more than doubles soil P stocks** in tropical urban croplands
- **Tailored sequential extraction resolves calcium-bound P** emerges as major pool (atypical in strongly weathered tropical soils) masked in standard P fractionation of tropical soils
- **Dual-pathway control on available P**: natively by pedogenic oxides + introduced calcium pathways under urbanization
- **Tropical urban arable soils act as inadvertent P sinks**, potential to be harnessed for sustainable food production

------------------------------------------------------------------------

## Quick Start

``` r
# 1. Install packages
source("scripts/load_packages.R")

# 2. Download data from Dataverse
source("data/download_data.R")

# 3. Run complete analysis
source("scripts/run_full_analysis.R")
```

------------------------------------------------------------------------

## Repository Structure

```         
phosphorus-urbanization-kumasi/
├── README.md                      # This file
├── LICENSE                        # CC BY 4.0 license
├── CITATION.cff                   # Citation metadata
├── .gitignore                     # Git ignore rules
│
├── scripts/
│   ├── run_full_analysis.R        # Master script (runs entire pipeline)
│   │
│   ├── modules/
│   │   ├── 01_Figure4.R  # Comparing P fractions
│   │   ├── 02_Figure5.R # Proportions of P fractions
│   │   ├── 03_Figure6.R    # Bivariate relationships
│   │   └── 04_Figure7.R      # Structural equation modeling
│   │
│   └─── load_packages.R        # Package management
│
├── data/
│   ├── README.md                  # Data access instructions
│   └── download_data.R            # Download from Dataverse
│
│
└── docs/
    └── packages.txt               # Package dependencies
```

------------------------------------------------------------------------

## Dataset

**Location:** University of Göttingen Research Data Repository\
**DOI:** <https://doi.org/10.25625/DA3TOR>\
**File:** MAIN_DATA_P_Fractions2026(650 top-soil samples in total but 225 for P fractions × 81 variables)

**Contents:** - Soil P fractionation data (PPa, PSOM, PCa, POCC) - Total P stocks (HNO₃ and multi-acid extraction) - Soil properties (pH, SOC, exchangeable Ca, ECEC) - Urbanization classification (duration: shor-term, long-term, and intensity: low-intensity, high-intensity ) - Quality flags (limits of detection (LOD) and quantification (LOQ) status for each P fraction)

------------------------------------------------------------------------

## Installation

### System Requirements

- **R:** ≥ 4.0.0 (tested on R 4.3.0)
- **OS:** Windows, macOS, or Linux\
- **RAM:** ≥ 4 GB recommended

### Setup

1.  **Clone repository:**

    ``` bash
    git clone https://github.com/sasabere/phosphorus-urbanization-kumasi.git
    cd phosphorus-urbanization-kumasi
    ```

2.  **Install R packages:**

    ``` r
    source("scripts/utils/load_packages.R")
    ```

3.  **Download dataset:**

    ``` r
    source("data/download_data.R")
    # OR download manually from https://doi.org/10.25625/DA3TOR
    ```

------------------------------------------------------------------------

## Usage

### Run Full Pipeline

``` r
source("scripts/run_full_analysis.R")
```

Executes: 1. Data preparation & stock calculations 2. Descriptive statistics & linear models\
3. Figure generation (all manuscript plots) 4. SEM analysis

### Run Individual Modules

``` r
# Data prep only
source("scripts/modules/01_data_preparation.R")

# Stats only
source("scripts/modules/02_descriptive_stats.R")

# Figures only  
source("scripts/modules/03_visualizations.R")

# SEM only
source("scripts/modules/04_SEM_analysis.R")
```

------------------------------------------------------------------------

## Methods Summary

### P Fractionation

Sequential extraction separating four operational pools:

| Fraction    | Extraction                     | Interpretation              |
|-------------|--------------------------------|-----------------------------|
| **PPa**     | 0.5 M NaHCO₃ (pH 8.5)          | Plant-available P           |
| **PSOM**    | H₂O₂–acetate                   | Soil organic matter-bound P |
| **PCa**     | Mild HCl–acetate               | Calcium-bound P             |
| **POCC**    | Dithionite–citrate–bicarbonate | Oxide-occluded P            |
| **Total P** | HNO₃ digestion                 | All soil P                  |

### Statistical Analysis

- **Linear models (Two-way anova):** Urbanization effects on P stocks
- **Contrasts:** Šidák-adjusted pairwise comparisons
- **Bivariate regressions:** PPa vs. reserve pools (PSOM, PCa, POCC)
- **SEM:** Multi-group structural equation models

------------------------------------------------------------------------

## Figures

The code reproduces all manuscript figures:

- **Figure 1:** Study area and location of sampled points (not coded)
- **Figure 2:** Soil profile in the middle of the sampling area depicting the strongly weathered properties
- **Figure 3:** Sequential fractionation of soil P
- **Figure 4:** Comparisons of the P fractions across urbanization classes
- **Figure 5:** Relative proportion of the P fractions to total P
- **Figure 6:** Bivariate regressions showing the PPa and reserve P pools
- **Figure 7:** Path diagrams of structural equation models (SEM)

Output: `output/figures/` (PDF + PNG formats)

------------------------------------------------------------------------

## Citation

### Paper

```         
Asabere, S.B., Sauer D. (2026). Oxide-occluded to calcium-bound: 
Urbanization increases soil phosphorus stocks and diversifies pools in 
tropical West African agroecosystems. Journal of Geophysical Research: 
Biogeosciences. https://doi.org/[pending]
```

### Data

```         
Asabere, S.B. (2026). Soil Phosphorus Stocks and 
Partitioning Along an Urbanization Gradient in Kumasi, Ghana [Dataset]. 
University of Göttingen. https://doi.org/10.25625/DA3TOR
```

### Code

```         
Asabere, S.B. (2025). R code for: Urbanization and soil phosphorus in 
tropical West Africa (v1.0). GitHub. 
https://github.com/sasabere/phosphorus-urbanization-kumasi
```

Or use `CITATION.cff` for automatic citation.

------------------------------------------------------------------------

## License

**Code:** CC BY 4.0 (Creative Commons Attribution 4.0 International)\
**Data:** CC BY 4.0 (see Dataverse)

You are free to share and adapt with attribution. See [LICENSE](LICENSE).

------------------------------------------------------------------------

## Funding

Deutsche Forschungsgemeinschaft (DFG), project **467340364**

------------------------------------------------------------------------

## Acknowledgments

- **Lab support:** Jago Birk, Petra Voigt, Anja Soedje (Physical Geography lab, University Göttingen)
- **P fractionation:** Dr. Harold J. Hughes
- **Research assistance:** Jianghu Li, Tino Poeplau
- **Field access:** Farmers in Kumasi, Ghana

------------------------------------------------------------------------

## Contact

**Stephen B. Asabere**\
Department of Physical Geography\
University of Göttingen\
📧 [stephen.asabere\@icloud.de](mailto:stephen.asabere@uni-goettingen.de)
🔗 [GitHub](https://github.com/sasabere)

------------------------------------------------------------------------

## Version History

- **v1.0.0** (July 2026): Initial release with manuscript publication

------------------------------------------------------------------------

*Repository maintained by Stephen Asabere \| Last updated: July 2026*
