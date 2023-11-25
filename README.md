# ovca-chemo-causal-tree

### Overview
A Japanese clinical trial (JGOG3016) showed that dose-dense weekly paclitaxel in combination with carboplatin significantly prolonged overall survival (OS) in patients with advanced ovarian cancer. However, other clinical trials have not found dose-dense paclitaxel regimens to be superior to triweekly regimens. This study aimed to identify subgroups that would benefit from dose-dense paclitaxel using causal tree analysis. This module is used to draw the causal tree that was used to determine the treatment effects and to analyze the data
### Requirements
The execution environment is intended for use in RStudio. The project file is `src/ovca_tree.Rproj`.
### Usage
- `src/tree.R`
	- Draw a causal tree from the data.
- `src/KM.R`
	- Draw a Kaplan-Meier curve from the data.
### Reference
Heterogeneous treatment effect of dose-dense paclitaxel plus carboplatin therapy for advanced ovarian cancer