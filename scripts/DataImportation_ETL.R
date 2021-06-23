# LIBRARIES ----
library(RSQLite)
library(tidyverse)


# FUNCTIONS ----
source(file = "scripts/functions_scripts.R")
connection <- dbConnect(RSQLite::SQLite(), "data/COVID.db")


# INITIAL DATABASE CREATION ----
county_data <- get_county_data(cnty = NULL, state = NULL)
county_data <- get_county_data()
county_data_broward <- get_county_data(cnty = "Broward County")

# state_data  <- get_state_data(state = "US")
# dbWriteTable(conn = connection, name = "county", value = county_data)
# dbWriteTable(conn = connection, name = "state", value = state_data)

# UPDATE SQLITE DATABASE TABLES ----
dbListTables(connection)

dbGetQuery(conn = connection, statement = "SELECT count(*) AS ROW_COUNT FROM county")
dbGetQuery(conn = connection, statement = "SELECT count(*) AS ROW_COUNT FROM state")


RSQLite::db
dbDisconnect(conn = connection)
