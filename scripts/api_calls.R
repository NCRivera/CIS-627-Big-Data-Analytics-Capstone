#82fc4cc0c0ba42608845036022e0975b


Current data for all states, counties, or metros


These endpoints contain the latest available data (a single, scalar value per field) for all states, counties, and CBSAs (metros).

Each file contains all locations in the region type. For example, https://api.covidactnow.org/v2/counties.csv?apiKey=YOUR_KEY_HERE contains all US counties.

https://api.covidactnow.org/v2/states.csv?apiKey=YOUR_KEY_HERE
https://api.covidactnow.org/v2/counties.csv?apiKey=YOUR_KEY_HERE
https://api.covidactnow.org/v2/cbsas.csv?apiKey=YOUR_KEY_HERE

https://api.covidactnow.org/v2/states.json?apiKey=YOUR_KEY_HERE
https://api.covidactnow.org/v2/counties.json?apiKey=YOUR_KEY_HERE
https://api.covidactnow.org/v2/cbsas.json?apiKey=YOUR_KEY_HERE



Historic data for all states, counties, or metros#
These files contain the entire history (a timeseries for every field) for all states, counties, and cbsas (metros).

https://api.covidactnow.org/v2/states.json?apiKey=YOUR_KEY_HERE
https://api.covidactnow.org/v2/counties.json?apiKey=YOUR_KEY_HERE
https://api.covidactnow.org/v2/cbsas.json?apiKey=YOUR_KEY_HERE


https://api.covidactnow.org/v2/states.timeseries.csv?apiKey=YOUR_KEY_HERE
https://api.covidactnow.org/v2/counties.timeseries.csv?apiKey=YOUR_KEY_HERE
https://api.covidactnow.org/v2/cbsas.timeseries.csv?apiKey=YOUR_KEY_HERE



Data for individual locations

Current Data
https://api.covidactnow.org/v2/state/{state}.json?apiKey=YOUR_KEY_HERE
https://api.covidactnow.org/v2/county/{fips}.json?apiKey=YOUR_KEY_HERE
https://api.covidactnow.org/v2/cbsa/{cbsa_code}.json?apiKey=YOUR_KEY_HERE

Historic Data
https://api.covidactnow.org/v2/state/{state}.timeseries.json?apiKey=YOUR_KEY_HERE
https://api.covidactnow.org/v2/state/{state}.timeseries.csv?apiKey=YOUR_KEY_HERE
https://api.covidactnow.org/v2/county/{fips}.timeseries.json?apiKey=YOUR_KEY_HERE
https://api.covidactnow.org/v2/cbsa/{cbsa_code}.timeseries.json?apiKey=YOUR_KEY_HERE

Data for all counties in a state

You can also query all counties for a single state.

https://api.covidactnow.org/v2/county/{state}.json?apiKey=YOUR_KEY_HERE
https://api.covidactnow.org/v2/county/{state}.csv?apiKey=YOUR_KEY_HERE
https://api.covidactnow.org/v2/county/{state}.timeseries.json?apiKey=YOUR_KEY_HERE
https://api.covidactnow.org/v2/county/{state}.timeseries.csv?apiKey=YOUR_KEY_HERE


Aggregated US data

https://api.covidactnow.org/v2/country/US.json?apiKey=YOUR_KEY_HERE
https://api.covidactnow.org/v2/country/US.timeseries.json?apiKey=YOUR_KEY_HERE
https://api.covidactnow.org/v2/country/US.timeseries.csv?apiKey=YOUR_KEY_HERE

