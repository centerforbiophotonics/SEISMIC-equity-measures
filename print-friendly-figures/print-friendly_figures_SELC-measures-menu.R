# Print-Friendly Figures for SELC Equity Measures Menu ####
# For Ashley Atkinson 

#The code from these figures pulled from chunks in `questions_version3_demo.Rmd`
#on 2023-04-20

#setup ####
library(tidyverse)
library(rmdformats) #output format: readthedown
library(kableExtra) #pretty html tables
library(gghalves) #for half-half geoms
library(ggdist) #for density plots 

#create some plot settings
theme_seismic <- 
  theme_classic(base_size = 18) + 
  theme(axis.text = element_text(color = "black"), 
        strip.text = element_text(color = "black"), 
        panel.border = element_rect(color = "black", fill = NA, size = 1), 
        strip.background = element_rect(color = "black", size = 1))

#load data 
#change this file name to the source of your properly formatted data file 
dat <- read.csv(file = "~/Downloads/synthetic_data_SEISMIC-format_BIO300_2023-04-08.csv")
course_of_interest <- "BIS101"

# 1. Who is in this course? ####
# demographics bar plot

fig1 <-
  dat %>% 
  #select course of interest only
  filter(crs_name == course_of_interest) %>%
  #add n for all students in course
  add_tally(name = "n_course") %>%
  #pivot to a long format dataframe
  pivot_longer(cols = c(ethniccode_cat, female, firstgen, lowincomeflag, international, transfer), 
               names_to = "demo_var",
               values_to = "value") %>% 
  group_by(demo_var, value) %>% 
  #count sample size by each group, then divide by course total
  summarise(n_total = n(),
            n_course = mean(n_course)) %>% 
  #convert to percent
  mutate(perc = n_total/n_course *100) %>% #percent for each level
  #select only students that belong to marginalized backgrounds
  filter(value == 1) %>%
  #rename labels to be more interpretable
  mutate(demo_var = factor(demo_var, 
                           levels = c("ethniccode_cat","female","firstgen","lowincomeflag","international","transfer"),
                           labels = c("PEER", "Women", "FirstGen", "LowIncome", "International", "Transfer"))) %>%
  arrange(desc(demo_var)) %>%
  #PLOT 
  ggplot(aes(x = fct_reorder(demo_var, perc), y = perc, fill = demo_var)) + 
  #add barplot for percent
  geom_col(color = "black") + 
  #add labels for actual percent values
  geom_text(aes(label = round(perc,0)), hjust = -1, size = 5) + 
  scale_fill_manual(values = c("#eb7e36","#4671c6","#70ac49","#ffbe07","#B35050","#a6a6a6")) + 
  labs(x = "Student identity", y = "Percent of class (%)") + 
  #set y axis to 100
  ylim(0,100)+
  theme_seismic +
  #hide redundant color legend
  theme(legend.position = "none") + 
  coord_flip()

#__export plot ####
ggsave(plot = fig1, filename = "~/Documents/GitHub/SEISMIC-equity-measures/print-friendly-figures//fig1_demographic-bar-plot_print-friendly.png", dpi = 300,
       width = 430/96, height = 330/96, units = "in", bg = "transparent") 




#2. Prior performance ####
#grade_anomaly ~ student identity

#calculate overall mean grade for course (will be plotted as an average line)
aga_coi <- mean(dat$numgrade[dat$crs_name == course_of_interest], na.rm = T) - 
  mean(dat$gpao[dat$crs_name == course_of_interest], na.rm = T)

fig2 <- 
  dat %>%
  filter(crs_name == course_of_interest) %>%
  #pivot to a long format dataframe
  pivot_longer(cols = c(ethniccode_cat, female, firstgen, lowincomeflag, international, transfer), 
               names_to = "demo_var",
               values_to = "value") %>% 
  #select all students who do belong to the group of interest
  filter(value == 1 ) %>%
  #rename labels to be more interpretable
  mutate(demo_var = factor(demo_var, 
                           levels = c("ethniccode_cat","female","firstgen","lowincomeflag","international","transfer"),
                           labels = c("PEER", "Woman", "FirstGen", "LowIncome", "International", "Transfer")))%>%
  add_count(demo_var, name = "n") %>%
  #PLOT
  ggplot(aes(x = fct_reorder(demo_var, n), y = numgrade-gpao, color = fct_reorder(demo_var, n))) +   
  #points for mean
  stat_summary(aes(size = n), geom = "point", fun = "mean") + 
  #add 95% CI errorbars
  stat_summary(geom = "errorbar", fun.data = "mean_cl_normal", width = 0.1) + 
  #plot average line for mean grade
  geom_hline(yintercept = aga_coi, linetype = "dashed") +
  #plot line and annotations for penalty vs bonus
  geom_hline(yintercept = 0) + 
  scale_y_continuous(breaks = seq(-0.8,0.2,by = 0.2)) +
  scale_color_manual(guide ="none",
                     values = rev(c("#eb7e36","#4671c6","#70ac49","#ffbe07","#B35050","#a6a6a6"))) + 
  annotate(geom = "text", x = 2, y = c(0.05,-0.05), label = c("grade bonus", "grade penalty"), 
           color = c("blue", "red"),vjust = -0.01, size = 4, angle = 270) + 
  #labels
  labs(size = "N", x = "Student identity", y = "Grade anomaly \n(course grade-GPAO)", color = "Student identity",
       caption = "Mean ± 95% CI shown \n Dashed line is course average grade anomaly") + 
  theme_seismic + 
  theme(text = element_text(size = 16)) + 
  theme(plot.caption = element_text(size = 10, hjust = 0.5)) + 
  coord_flip()


#__export plot ####
ggsave(plot = fig2, filename = "~/Documents/GitHub/SEISMIC-equity-measures/print-friendly-figures/fig2_grade-anomaly-by-identity_print-friendly.png", dpi = 300,
       width = 575/96, height = 335/96, units = "in", bg = "transparent") 

#3. Grades across levels of SAI ####
# grades ~ SAI

#define SAI
dat <-
  dat %>% mutate(sai = case_when(
    female == "0" & ethniccode_cat != "1" & firstgen == "0" & lowincomeflag == "0"  ~ "4",
    female == "1" & ethniccode_cat != "1" & firstgen == "0" & lowincomeflag == "0"  ~ "3",
    female == "0" & ethniccode_cat == "1" & firstgen == "0" & lowincomeflag == "0"  ~ "3", 
    female == "0" & ethniccode_cat != "1" & firstgen == "0" & lowincomeflag == "1"  ~ "3", 
    female == "0" & ethniccode_cat != "1" & firstgen == "1" & lowincomeflag == "0"  ~ "3", 
    female == "0" & ethniccode_cat == "1" & firstgen == "1" & lowincomeflag == "0"  ~ "2", 
    female == "0" & ethniccode_cat == "1" & firstgen == "0" & lowincomeflag == "1"  ~ "2", 
    female == "1" & ethniccode_cat == "1" & firstgen == "0" & lowincomeflag == "0"  ~ "2", 
    female == "0" & ethniccode_cat != "1" & firstgen == "1" & lowincomeflag == "1"  ~ "2", 
    female == "1" & ethniccode_cat != "1" & firstgen == "1" & lowincomeflag == "0"  ~ "2", 
    female == "1" & ethniccode_cat != "1" & firstgen == "0" & lowincomeflag == "1"  ~ "2", 
    female == "1" & ethniccode_cat != "1" & firstgen == "1" & lowincomeflag == "1"  ~ "1", 
    female == "1" & ethniccode_cat == "1" & firstgen == "1" & lowincomeflag == "0"  ~ "1",
    female == "1" & ethniccode_cat == "1" & firstgen == "0" & lowincomeflag == "1"  ~ "1", 
    female == "0" & ethniccode_cat == "1" & firstgen == "1" & lowincomeflag == "1"  ~ "1",
    female == "1" & ethniccode_cat == "1" & firstgen == "1" & lowincomeflag == "1"  ~ "0",
    TRUE ~ "NA"))

#average grade anomaly line
mean_grade_coi <- mean(dat$numgrade[dat$crs_name == course_of_interest], na.rm = T)


fig3 <-
dat %>%
  mutate(sai = as.numeric(sai)) %>%
  add_count(sai, name = "n") %>% #add sample size per SAI
  filter(crs_name == course_of_interest) %>%
  ggplot(aes(x = as.factor(sai), y = numgrade, color = as.factor(sai))) + 
  stat_summary(aes(size = n), geom = "point", fun = "mean") + 
  stat_summary(geom = "errorbar", fun.data = "mean_cl_normal", 
               width = 0.1) +
  geom_hline(yintercept = mean_grade_coi, linetype = "dashed") + 
  #plot line and annotations for penalty vs bonus
  scale_color_manual(guide = "none", #hide legend
                     values = c("#4671c6","#70ac49", "#ffbe07","#eb7e36","#B35050")) + 
  scale_size_continuous(range = c(1,5)) + 
  labs(x = "SAI", y = "Course grade", color = "SAI", size = "N",
       caption = "Mean ± 95% CI shown \nDashed line is course average grade") + 
  theme_seismic + 
  theme(text = element_text(size = 16)) + 
  theme(plot.caption = element_text(size = 10, hjust = 0.5)) + 
  coord_flip()


#__export plot ####
ggsave(plot = fig3, filename = "~/Documents/GitHub/SEISMIC-equity-measures/print-friendly-figures/fig3_grades-by-SAI_print-friendly.png", dpi = 300,
       width = 575/96, height = 335/96, units = "in", bg = "transparent") 
