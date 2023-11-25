library(causalTree)
library(survival)
library(partykit)
library(openxlsx)
library(treeClust)
library(ggplot2)
library(survminer)

set.seed(1)

# load data file
d = read.csv('/path/to/data')

# make log dir
km_logpath = paste0("../log/km/")
if(dir.exists(km_logpath)==FALSE){
  dir.create(km_logpath)
}

draw_km <- function(leaf_df, q, km_path) {
  png(km_path, width = 20, height = 20, units = "cm", res = 100)
  surv <- do.call(survfit, args = list(formula = q, data = leaf_df))
  gg = ggsurvplot(surv, data=leaf_df, break.time.by=12, risk.table=T,
                  legend.labs=c("TC", "ddTC"), legend.text = element_text(size = 14, color = "black", face = "bold"),
                  ylab='Overall survival rate', xlab='Time (months)')
  gg$plot <- gg$plot + theme(legend.title = element_text(size = 14),
                             legend.text = element_text(size = 14))
  print(gg)
  dev.off()
}

get_pvalue <- function(leaf_df, q) {
  diff = survdiff(formula=q, data=leaf_df)
  p = substr(as.character(pchisq(diff$chisq, length(diff$n)-1, lower.tail = FALSE)), 1,6)
  return(p)
}

# draw km on OS and PFS
for (col in c('rec', 'death')){
  if(col=='rec'){
    outcome = 'os'
    q = as.formula('Surv(os, death) ~ treatment')
  }else if(col=='death'){
    outcome = 'pfs'
    q = as.formula('Surv(pfs, rec) ~ treatment')
  }
  
  # get pvalue
  pvalue = get_pvalue(d, q)
  
  # draw km
  split_strings <- unlist(strsplit(path, "_"))
  selected_mode <- split_strings[2]
  node_name <- gsub("[^0-9]", "", split_strings[4])
  
  km_path = paste0(km_logpath, 'km_', outcome, '_p_', pvalue, '.png')
  draw_km(d, q, km_path)  
}



