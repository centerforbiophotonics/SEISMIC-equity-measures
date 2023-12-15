
#the location of the data file for the equity reports - must be updated each time
file_name <- "/Users/jthomas/Work Documents/SELC/12:01:23 all sections files/all_sections_combined_data.csv"

#the rest of the script is automatic and may be run without any changes

#load required library
library(tidyverse)

#load the data file
selc_data <- read.csv(file_name)

#create a list of the courses included in the dataset
course_list <- unique(selc_data$crs_name)

major_percent_calc = function(course, file_name) {
  major_percentages <- read.csv(file_name) %>% filter(crs_name==course) %>% 
    group_by(major) %>% 
    summarise(Percentage=(n()/nrow(.))*100)
  major_percentages <-  major_percentages[order(major_percentages$Percentage, decreasing = T),]
  major_percentages <- major_percentages[1:3,] 
  major_percentages <<- as.array(major_percentages$major)
}

terms_calc = function(course,file_name) {
  course_data <- read.csv(file_name) %>% filter(crs_name==course) %>% 
    mutate(season=case_match(crs_semq, 1~"Winter", 2~"Spring", 3~"Summer", 4~"Summer", 5~"Fall"))
  min_term_data <- course_data %>% filter(crs_term==min(crs_term))
  min_term <<- paste(min_term_data$season[1], sep = ' ', min_term_data$crs_year[1])
  max_term_data <- course_data %>% filter(crs_term==max(crs_term))
  max_term <<- paste(max_term_data$season[1], sep = ' ', max_term_data$crs_year[1])
}



#function to create the reports for each course
render_report = function(course, file_name, majors) {
  rmarkdown::render("/Users/jthomas/Work Documents/GitHub/SEISMIC-equity-measures/SELC_equity_report.Rmd", 
                     params = list(course = course, data = file_name, majors = majors), output_file = paste0("SELC_",course,"_equity_report.html"),
                    output_dir = "/Users/jthomas/Work Documents/SELC/practice files")
}

#creating the reports for each course
for (i in course_list) {
  major_percent_calc (i, file_name)
  terms_calc(i,file_name)
  render_report(i, file_name, major_percentages)
}





