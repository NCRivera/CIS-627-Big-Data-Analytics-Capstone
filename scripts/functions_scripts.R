library(tidyverse)

get_state_data <- function(state = "US"){
    api_key <- "82fc4cc0c0ba42608845036022e0975b"
    if (state == "US") {
        api_data <- read.csv(file = str_glue("https://api.covidactnow.org/v2/states.timeseries.csv?apiKey={api_key}")) %>% tibble()
    } else if (state != "US") {
        api_data <- read.csv(file = str_glue("https://api.covidactnow.org/v2/state/{state}.timeseries.csv?apiKey={api_key}")) %>% tibble()
    }
    return(api_data)
}

get_county_data <- function(cnty = "Miami-Dade", state = "FL"){
    api_key <- "82fc4cc0c0ba42608845036022e0975b"
    if (is.null(cnty) & is.null(state)) {
        api_data <- read.csv(file = str_glue("https://api.covidactnow.org/v2/counties.timeseries.csv?apiKey={api_key}")) %>% tibble()
    } else if (is.null(cnty) & !is.null(state)) {
        api_data <- read.csv(file = str_glue("https://api.covidactnow.org/v2/county/{state}.timeseries.csv?apiKey={api_key}")) %>% tibble()
    } else if (!is.null(cnty) & !is.null(state)) {
        api_data <- read.csv(file = str_glue("https://api.covidactnow.org/v2/county/{state}.timeseries.csv?apiKey={api_key}")) %>% 
            tibble() %>% 
            filter(str_detect(string = county, pattern = cnty))
    }
    return(api_data)
}