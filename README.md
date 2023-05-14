# SEISMIC-equity-measures

**Goal**: Piloting an initial "menu" of equity measures for introductory STEM courses for the SEISMIC collaboration. Currently, the documents in this repository will guide institutional researchers (IRs) and data analysts through the process of preparing institutional data to generate equity reports for local SELC grant teams.

More information about the SELC grant can be found here: [The SELC Grant \| SEISMIC Collaboration](https://www.seismicproject.org/seismic-central/the_selc_grant/).

**Collaborators:** [Victoria Farrar](mailto:vsfarrar@ucdavis.edu) (UC Davis), [Nita Tarchinski](mailto:nitaked@umich.edu) (U Michigan), Matt Steinwachs (UC Davis), Jenna Thomas (UC Davis)

Notes from SELC team meetings: [Menu of Equity Measures \| Google Doc](https://docs.google.com/document/d/1TceXPFyIDZ0ZC06XFtYz6fWkgvnNYbpq7F11voeGLFA/edit#heading=h.h9qcp91x0k23) *(permissions required)*

\-\-\-\--

## Code Workflow for SELC IR Users

When using the code, SELC project institutional researchers should go through the following steps:

0.  (*Before working through code*) Determine what courses are of interest and get access to relevant institutional data.

1.  Prepare institutional data for use with the code by viewing and following the [Data Preparation Guide here](https://htmlpreview.github.io/?https://github.com/vsfarrar/SEISMIC-equity-measures/blob/main/data_preparation_guide.html) (.html). This guide contains instructions for formatting the dataset and selecting the necessary variables to run the code.

2.  Check that your dataset has been formatted properly by downloading and working through the [Check Your Data guide](https://github.com/vsfarrar/SEISMIC-equity-measures/blob/main/check_your_data.Rmd) (.Rmd) in R.

3.  Run the SELC Level 1 R Markdown report ([SELC_equity_report.Rmd](https://github.com/vsfarrar/SEISMIC-equity-measures/blob/main/SELC_equity_report.Rmd)) code and generate a report (.html) to share with stakeholders. To edit the report code for your institution, change the following:

    -   [ ] Line 2: Add your course of interest to the title. i.e. Replace [YOUR COURSE HERE] in `title: "SEISMIC Equity Learning Communities Report: [YOUR COURSE HERE]"`

    -   [ ] Chunk 3 (Line 54): Load data - Change the directory in `dat <-read.csv` to the full path of your properly-formatted dataset.

    -   [ ] Chunk 4 (Line 61): Select course of interest - type the name of your course of interest *exactly* as it is entered in your dataset in `course_of_interest <- "YOUR COURSE HERE"`

    -   [ ] Chunk 5 (Line 67): Select majors of interest - type the name of the majors you would want to focus on in your report *exactly* as it is entered in your dataset in `majors_of_interest`
    
    -   [ ] Save the document locally and then press "Knit" to generate .html. 

Preview the demo/example report from the SELC May Institute 2023: [SELC Level 1 R Markdown report](https://htmlpreview.github.io/?https://github.com/vsfarrar/SEISMIC-equity-measures/blob/main/archive/questions_version3_demo.html) (DEMO).
