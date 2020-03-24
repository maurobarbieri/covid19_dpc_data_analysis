# covid19_dpc_data_analysis
Data analysis of Covid19 pandemic in Italy, based on data released by Protezione Civile Italiana.


This package is a suite of tools for analysis of data released by Protezione Civile.
The tools uses bash scripting, gnuplot and octave, and produces as results .csv files along with postscript output.

The actual version focus on 3 datasets: number of infected people, number of people in intensive care units and number of deceased. The data are analyzed at national, regional and provincial level.
For provincial data, as today (24 March 2020) the data contains only the number of infected people.

The data are fitted in order to find the most probable date of the peak in contagion. The fit based on the assumption that the probability distribution function of the daily data count is gaussian. However the fit of the daily data shows to be unstable, on the other side the cumulative data shows a good stability on the fit with the corresponding cumulative probability distribution (i.e. the error function).




