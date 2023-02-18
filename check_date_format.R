#!/usr/bin/env Rscript

# # Add a command to set the executable permission on this script
# system(paste("chmod +x", commandArgs(trailingOnly = TRUE)[0]))

# Define the regular expression pattern to match the date string
DATE_PATTERN <- "\\d{2}/\\d{2}/\\d{4}"

# Get the file path from the command-line argument
args <- commandArgs(trailingOnly = TRUE)
file_path <- args[1]


# Read the contents of the file
file_contents <- readr::read_file(file_path)


# Extract the YAML header from the file
file_contents <- gsub("\\\\n", "\n", file_contents)
file_lines <- strsplit(file_contents, "\n")[[1]]
header_lines <- grep("^---$|^\\s*---\\s*$", file_lines)

if (length(header_lines) == 2) {
  header <- file_lines[(header_lines[1] + 1):(header_lines[2] - 1)]
} else {
  cat("Error: Invalid YAML header.\n", file = stderr())
  quit(status = 1)
}


# Extract the date from the YAML header
date_str <- NULL
for (line in header) {
  if (grepl("^date:", line, ignore.case = TRUE)) {
    date_str <- trimws(gsub("^date:", "", line))
    date_str <- gsub("\\\\", "", date_str)
    date_str <- gsub("\"", "", date_str)
    break
  }
}

# Check if the date string matches the expected format

if (!is.null(date_str) && grepl(DATE_PATTERN, date_str)) {
  # Remove escape characters from date_str


  # Check if the extracted substring matches the entire string
  if (unlist(regmatches(date_str, regexpr(DATE_PATTERN, date_str))) == date_str) {
    # Date format is valid
    print("valid")
  } else {
    cat("Error: Invalid date format in YAML header. Please use mm/dd/yyyy.\n", file = stderr())
    quit(status = 1)
  }
} else {
  cat("Error: Invalid date format in YAML header. Please use mm/dd/yyyy.\n", file = stderr())
  quit(status = 1)
}
