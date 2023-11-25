library(causalTree)
library(survival)
library(partykit)
library(openxlsx)
library(treeClust)
library(ggplot2)
library(survminer)
library(rpart)

set.seed(1)

# load xlsx data
df = read.xlsx("/path/to/data", sheet=1)
covariate = c('bmi_d', 'tube', 'peri', 'stage', 'ageo50', 'ageo60', 
              'clearmuci2', 'ps', 'ca125o35', 'ca125o100', 'ca125o1000', 
              'neoadjuvant', 'remain_bc', 'remain_c')

# make log dir
dirpath = paste0("../log/")
if(dir.exists(dirpath)==FALSE){
  dir.create(dirpath)
}
csvdata_path = "../log/csvdata/"
dir.create(csvdata_path)

# norec1: 1 if no recurrence when 12 months after 1st treatment otherwise 0
# alive3: 1 if alive when 36 month after 1st treatment otherwise 0

for (col in c('norec1', 'alive3')){
  # plot causal tree
  tree <- causalTree(as.formula(paste(col, "~", paste(covariate, collapse = " + "))),
                     data = df, treatment = as.numeric(df$treatment),
                     split.Rule = "CT", cv.option = "CT", 
                     split.Honest = T, cv.Honest = T, 
                     split.Bucket = F, xval = 5, cp = 0, minsize = 10, propensity = 0.5)
  png(paste0(dirpath, col, '_tree.png'), width = 50, height = 30, units = "cm", res = 100)
  rpart.plot(tree, nn=TRUE)
  dev.off()
  
  # get query for p value and KM
  if(col=='alive3'){
    outcome = 'os'
    q = as.formula('Surv(os, death) ~ treatment')
  }else if(col=='norec1'){
    outcome = 'pfs'
    q = as.formula('Surv(pfs, rec) ~ treatment')
  }
  
  # 
  leaves = as.party(tree)$fitted[, 1]
  for(i in unique(leaves)){
    leaf_df = df[leaves==i, ]
    leave_name = rownames(tree$frame)[i]
    
    # get csv
    csv_path = paste0(csvdata_path, 'data_', col, '_', outcome, '_', leave_name, '.csv')
    write.csv(x=leaf_df, csv_path, row.names = FALSE)
  }
}

