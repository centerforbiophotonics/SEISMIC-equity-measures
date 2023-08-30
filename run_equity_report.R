
#generate a list to easily add to sql code
#crse_instructor_list <- read.csv("/Users/jthomas/Documents/Work Documents/SELC/List of courses and pidms.csv")
#
#for(i in 1:dim(crse_instructor_list)){
#  print(paste0("(c.SUBJ||c.CRSE = '",crse_instructor_list$Course[i],"' AND c.INSTRUCTOR_PIDM = ",crse_instructor_list$PIDM[i],")"))
#}



#the location of the data file for the equity reports - must be updated each time
file_name <- "/Users/jthomas/Documents/Work Documents/SELC/Version 3 files - 6:8:23/SELC_combo_data_file.csv"

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


#function to create the reports for each course
render_report = function(course, file_name, majors) {
  rmarkdown::render("/Users/jthomas/Documents/Work Documents/GitHub/SEISMIC-equity-measures/SELC_equity_report.Rmd", 
                     params = list(course = course, data = file_name, majors = majors), output_file = paste0("SELC_",course,"_equity_report.html"),
                    output_dir = "/Users/jthomas/Documents/Work Documents/SELC/New_github_files")
}

#creating the reports for each course
for (i in course_list) {
  major_percent_calc (i, file_name)
  render_report(i, file_name, major_percentages)
}





