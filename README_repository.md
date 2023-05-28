# README for repository: vsfarrar/SESIMIC-Equity-Measures

This README is intended to walk through the directory structure and each individual file for future code developers ( SELC project team leaders, e.g., Matt, Nita, Jenna).

## Directory structure

### [main directory]

-   `check_your_data.Rmd` : R Markdown code chunks that users can directly edit to "check" that their data meets formatting requirements for the equity report.

-   `data_dictionary.csv`: .csv file that includes required variable names, descriptions and allowed values. This .csv file is sourced by the `data_preparation_guide.Rmd` and exported as an HTML table in that document. Users should not be accessing the .csv file here directly.

-   `data_preparation_guide.Rmd` / `.html` : an R Markdown document that includes instructions on what data is needed and how to format the data for the equity report code. Includes the Data Dictionary (sourced from the above .csv file) and an example for users (sourced from the synthetic data), as well as helpful R functions. *Note: Users should be accesssing the data_preparation_guide.html through a link, but not the actual .Rmd document*

-   `demo_equity_report_SELC-May-Institute_2023.html`: the demo equity report .html page created for the SELC May Institute at UC Davis in May 2023. Uses synthetic data. (Linked by the README as an example for users)

-   `README.md`:a Markdown document that underlies the IR-facing repository README on the main page of the GitHub repo.

\-`SAI_assignment.tif`: an image sourced by the equity report code for describing how SAI is assigned.

-   `SELC_equity_report.Rmd`: the main equity report code that will be accessed and modified by IR users.

-   `synthetic_data_SEISMIC-format_BIO300_2023-05-08.csv`: synthetic data created using the "synthpop" package in R used to make the demo equity report and populate examples in the Data Preparation Guide. 

### /archive

Archived files that are no longer needed for the final scripts, reports, or outputs.

-   `custom.css`: a first pass attempt to customize colors in the readthedown template using css

-   `example_equity_measures_markdown.Rmd` / `.html`: a first pass equity measures report, last updated

-   `questions_version3_demo.Rmd`/`.html`: the equity measures report created for and demoed at the SELC May Institute meeting at UC Davis in May 2023. The .html report from this demo has since been renamed as `demo_equity_report_SELC-May-Institute_2023.html` and moved to the main repository.

-   `SELC_plot_overflow_sandbox.R`: a script for testing R code for plots

-   `workshop_markdown_sandbox.Rmd`: a script for testing R markdown code

### /print-friendly

This folder contains versions of 3 plots made using synthetic data, specifically formatted for the physical "Menu of Equity Measures" brochure for the May Institute, prepared by Ashley Atkinson and Nita Tarchinski.

\-\-\-\--

Document created: 5/27/2023 - VF

Last updated: 5/27/2023 - VF
