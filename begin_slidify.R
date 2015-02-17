# Code to set working directory (enabled):
if (TRUE) {
    working.directory <- paste0(Sys.getenv("HOME"), "/WA/School/Coursera/DataScience_JohnsHopkins/09_DataProducts/Project")
    setwd(working.directory)
    #getwd()
}

library(slidify)
library(knitr)

# Populates a new directory: only do once.
# Use the first working.directory above when running this.
# Will create a directory called "presentation" at that directory level.
#author("presentation")

# 'Compiles' Rmd into html:
slidify("index.Rmd")

# Uses 'knitr' for viewing in browser:
browseURL("index.html")

# Following Caffo's directions:
publish(user="JohnTD500", repo="09_DataProducts/presentation")
