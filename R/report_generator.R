library(readxl)
library(dplyr)
library(tinytex)

# Read the Excel file and get sheet names
excel_file <- "C:/Users/pepec/Desktop/estudios/master/Report_Generator/Inst/Investors_database.xlsx"
sheet_names <- excel_sheets(excel_file)

# Read each sheet into a data frame
data_list <- lapply(sheet_names, function(sheet) {
  read_excel(excel_file, sheet = sheet)
})

# Extract the "investors" sheet
investors <- data_list[[1]]

investor_ids <- as.character(investors$ID) 

for (investor_id in investor_ids) {
  # Set the investor ID in the R Markdown file
  params <- list(ID = investor_id,
                 month = format(Sys.Date(), '%B'),
                 year = format(Sys.Date(), '%Y'),
                 excel_file = excel_file)
  
  # Render the R Markdown file with the parameters
  rmarkdown::render("C:/Users/pepec/Desktop/estudios/master/Report_Generator/R/report_template.Rmd",
                    params = params)
  
  # Create a unique filename
  filtered_data <- filter(investors, ID == investor_id)
  investor_name <- filtered_data$name
  investor_lastname <- filtered_data$last_name
  output_filename <- paste0(investor_name, "_", investor_lastname, "_", params$month, "_", params$year)
  
  # Define the source and destination file paths
  source_file <- "C:/Users/pepec/Desktop/estudios/master/Report_Generator/R/report_template.pdf"  # Replace with the correct path to the rendered file
  destination_file <- paste0("C:/Users/pepec/Desktop/estudios/master/Report_Generator/report_files/", output_filename, ".pdf")
  
  # Copy the rendered file to the desired location with the unique filename
  file.copy(source_file, destination_file, overwrite = T)
}

