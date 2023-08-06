rm(list=ls())
pacman::p_load(tidyverse,microeco,magrittr)

install.packages('microeco')
install.packages('tidyverse')
install.packages('magrittr')
library(microeco)
library(tidyverse)
library(magrittr)
library(ggplot2)
install.packages('ggsci')
library(ggsci)
install.packages('tidytree')
library(tidytree)
library(ggtree)


feature_table <- read.csv('feature_table.csv', row.names = 1)
sample_table <- read.csv('sample_table.csv', row.names = 1)
tax_table <- read.csv('tax_table.csv', row.names = 1)

head(feature_table)[1:6,1:6]; head(sample_table)[1:6, ]; head(tax_table)[,1:6]

# 创建microtable对象
dataset <- microtable$new(sample_table = sample_table,
                          otu_table = feature_table, 
                          tax_table = tax_table)
dataset

lefse <- trans_diff$new(dataset = dataset, 
                        method = "lefse", 
                        group = "Group", 
                        alpha = 0.01, 
                        lefse_subgroup = NULL)
# 查看分析结果
head(lefse$res_diff)

# From v0.8.0, threshold is used for the LDA score selection.
lefse$plot_diff_bar(threshold = 4)

# we show 20 taxa with the highest LDA (log10)
lefse$plot_diff_bar(use_number = 1:30, 
                    width = 0.8, 
                    group_order = c("AR13", "ARS13", "WR13", "WRS13")) +
  ggsci::scale_color_npg() +
  ggsci::scale_fill_npg()
  

# clade_label_level 5 represent phylum level in this analysis
# require ggtree package    
#use_taxa_num = 200, use_feature_num = 25；前200个分类单元的25个特征
lefse$plot_diff_cladogram(use_taxa_num = 100, 
                          use_feature_num = 25, 
                          clade_label_level = 7, 
                          group_order = c("AR13", "ARS13", "WR13", "WRS13"))

# 图中可能存在与分类标签相关的问题。 当显示的级别过多时，分类标签可能会有太多重叠。 
# 但是，如果只标明门的标签，图例中带有标记字母的分类群太多了。 此时，可以手动选择分类群以显示如下操作。
# choose some taxa according to the positions in the previous picture; those taxa labels have minimum overlap
use_labels <- c("c__Deltaproteobacteria", "c__Actinobacteria", "o__Rhizobiales", "p__Proteobacteria", "p__Bacteroidetes", 
                "o__Micrococcales", "p__Acidobacteria", "p__Verrucomicrobia", "p__Firmicutes", 
                "p__Chloroflexi", "c__Acidobacteria", "c__Gammaproteobacteria", "c__Betaproteobacteria", "c__KD4-96",
                "c__Bacilli", "o__Gemmatimonadales", "f__Gemmatimonadaceae", "o__Bacillales", "o__Rhodobacterales")
# then use parameter select_show_labels to show
lefse$plot_diff_cladogram(use_taxa_num = 200, 
                       use_feature_num = 50, 
                       select_show_labels = use_labels)
# Now we can see that more taxa names appear in the tree









