# SEISMIC-equity-measures

**Goal**: This code generates an initial equity measures report for an introductory STEM course for the SEISMIC SELC project. Currently, the documents in this repository will guide institutional researchers (IRs) and data analysts through the process of preparing institutional data to generate equity reports for local SELC grant teams.

More information about the SELC grant can be found here: [The SELC Grant | SEISMIC Collaboration](https://www.seismicproject.org/seismic-central/the_selc_grant/).

**Project contacts:**

-   [Matt Steinwachs](mailto:mksteinwachs@ucdavis.edu) (UC Davis)

-   [Jenna Thomas](mailto:jmathomas@ucdavis.edu) (UC Davis)

-   [Nita Tarchinski](mailto:nitaked@umich.edu) (U Michigan)

-   [Victoria Farrar](mailto:vsfarrar@ucdavis.edu) (formerly UC Davis)

**Funding:** The SELC project is funded by National Science Foundation award [DUE-2215398](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2215398&HistoricalAwards=false) and the SEISMIC collaboration is funded by the Alfred P. Sloan foundation.

\-\-\-\--

## Code Workflow for SELC IR Users

When using the code, SELC project institutional researchers should go through the following steps:

0.  (*Before working through code*) Determine what courses are of interest and get access to relevant institutional data.

1.  Prepare institutional data for use with the code by viewing and following the [Data Preparation Guide here](https://htmlpreview.github.io/?https://github.com/centerforbiophotonics/SEISMIC-equity-measures/blob/main/data_preparation_guide.html) (.html). This guide contains instructions for formatting the dataset and selecting the necessary variables to run the code.

2.  Check that your dataset has been formatted properly by downloading and working through the [Check Your Data guide](https://github.com/centerforbiophotonics/SEISMIC-equity-measures/blob/main/check_your_data.Rmd) (.Rmd) in R.

3.  Run the SELC Level 1 R Markdown report ([SELC_equity_report.Rmd](https://github.com/centerforbiophotonics/SEISMIC-equity-measures/blob/main/SELC_equity_report.Rmd)) code and generate a report (.html) to share with stakeholders. To edit the report code for your institution, change the following:

    -   [ ] Line 2: Add your course of interest to the title. i.e. Replace [YOUR COURSE HERE] in `title: "SEISMIC Equity Learning Communities Report: [YOUR COURSE HERE]"`

    -   [ ] Chunk 3 (Line 54): Load data - Change the directory in `dat <-read.csv` to the full path of your properly-formatted dataset.

    -   [ ] Chunk 4 (Line 61): Select course of interest - type the name of your course of interest *exactly* as it is entered in your dataset in `course_of_interest <- "YOUR COURSE HERE"`

    -   [ ] Chunk 5 (Line 67): Select majors of interest - type the name of the majors you would want to focus on in your report *exactly* as it is entered in your dataset in `majors_of_interest`

    -   [ ] Chunk 6 (Line 74): Define sample size cutoffs for excluding groups - define the minimum sample size a specific demographic group (`cutoff_general`) or demographic group within an individual course offering (for plots that show over time; `cutoff_sections`) must meet to be included in plots.
    
    -   [ ] Text on Line 1300: If you have a feedback form for your stakeholders/report viewers, you can edit the text here to add a link to your institutional feedback form (if desired). Otherwise, you can delete the "Feedback" section from the text.

    -   [ ] Save the document locally and then press "Knit" to generate .html. The .html report can be shared with your stakeholders/users via a private Box or Google Drive folder. Instruct your users to open the .html using a web browser like Chrome or Safari for best results.

\-\-\-\--

### Want to see an example?

Preview the demo/example report from the SELC May Institute 2023: [SELC Level 1 R Markdown report](https://htmlpreview.github.io/?https://github.com/vsfarrar/SEISMIC-equity-measures/blob/main/archive/questions_version3_demo.html) (DEMO). 

If you wish to download this demo report and view it locally on your browser, you can do so at this link: [https://github.com/centerforbiophotonics/SEISMIC-equity-measures/blob/main/archive/demo_equity_report_SELC-May-Institute-2023.html](https://github.com/centerforbiophotonics/SEISMIC-equity-measures/blob/main/archive/questions_version3_demo.html)
