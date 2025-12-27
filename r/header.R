rm(list = ls())

library(checkmate)
library(dplyr)
library(furrr)
library(ggplot2)
library(googlesheets4)
library(jpeg)
library(magick)
library(purrr)
library(readr)
library(stringr)
library(tidyr)

source("r/functions.R")

li600_headers = c(
  "Obs#","Time","Date","configName", "configAuthor","remark","plant number",
  "gsw","gbw","gtw","E_apparent","VPcham","VPref","VPleaf","VPDleaf","H2O_r",
  "H2O_s","H2O_leaf","leaf_area","rh_s","rh_r","Tref","Tleaf","P_atm","flow",
  "flow_s","leak_pct","Qamb","batt","match_time","match_date","rh_adj",
  "gsw1sec","gsw2sec","gsw4sec","flr1sec","flr2sec","flr4sec","auto","flow_set",
  "gsw_limit","gsw_period","v_humA","v_humB","v_flowIn","v_flowOut","v_temp",
  "v_irt","v_pres","v_par","v_F","i_LED","b_rhr","m_rhr","span_rhr","b_rhs",
  "m_rhs","span_rhs","z_flowIn","z_flowOut","z_quantum","z_flr","flashId",
  "lciSerNum","lcpSerNum","lcfSerNum","lcrhSerNum","version","configUpdatedAt",
  "slope_leaf"
)
