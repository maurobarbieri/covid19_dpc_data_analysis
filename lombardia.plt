set terminal postscript color enhanced      
set output "lombardia.ps"

set datafile sep ','
set xrange [0:28]
set logscale y
set yrange [1:12000]
set key box left


set style line 1 lt 1 lc rgb '#A6CEE3' # light blue
set style line 2 lt 1 lc rgb '#1F78B4' # dark blue
set style line 3 lt 1 lc rgb '#B2DF8A' # light green
set style line 4 lt 1 lc rgb '#33A02C' # dark green
set style line 5 lt 1 lc rgb '#FB9A99' # light red
set style line 6 lt 1 lc rgb '#E31A1C' # dark red
set style line 7 lt 1 lc rgb '#FDBF6F' # light orange
set style line 8 lt 1 lc rgb '#FF7F00' # dark orange
set style line 9 lt 1 lc rgb '#1B9E77' # dark teal
set style line 10 lt 1 lc rgb '#D95F02' # dark orange
set style line 11 lt 1 lc rgb '#7570B3' # dark lilac
set style line 12 lt 1 lc rgb '#E7298A' # dark magenta
set style line 13 lt 1 lc rgb '#66A61E' # dark lime green
set style line 14 lt 1 lc rgb '#E6AB02' # dark banana
set style line 15 lt 1 lc rgb '#A6761D' # dark tan
set style line 16 lt 1 lc rgb '#666666' # dark gray
set style line 17 lc rgb '#800000' lt 1 lw 2
set style line 18 lc rgb '#ff0000' lt 1 lw 2
set style line 19 lc rgb '#ff4500' lt 1 lw 2
set style line 20 lc rgb '#ffa500' lt 1 lw 2
set style line 21 lc rgb '#006400' lt 1 lw 2
set style line 22 lc rgb '#0000ff' lt 1 lw 2
set style line 23 lc rgb '#9400d3' lt 1 lw 2

set yrange [1:8000]

plot 'covid_C_Milano.csv'     u 2:3 w lp ls  1 lw 4 t " MI",\
     'covid_C_Brescia.csv'    u 2:3 w lp ls  2 lw 4 t " BS",\
     'covid_C_Bergamo.csv'    u 2:3 w lp ls  3 lw 4 t " BG",\
     'covid_C_Cremona.csv'    u 2:3 w lp ls  4 lw 4 t " CR",\
     'covid_C_Lodi.csv'       u 2:3 w lp ls  5 lw 4 t " LO",\

plot 'covid_C_Mantova.csv'    u 2:3 w lp ls  1 lw 4 t " MN",\
     'covid_C_Como.csv'       u 2:3 w lp ls  2 lw 4 t " CO",\
     'covid_C_Lecco.csv'      u 2:3 w lp ls  3 lw 4 t " LC",\
     'covid_C_Varese.csv'     u 2:3 w lp ls  4 lw 4 t " VA",\
     'covid_C_Sondrio.csv'    u 2:3 w lp ls  5 lw 4 t " SO",\
     'covid_C_Pavia.csv'      u 2:3 w lp ls  6 lw 4 t " PV"

set yrange [1:1000]


plot 'covid_C_Milano.csv'     u 2:4 w lp ls  1 lw 4 t " MI",\
     'covid_C_Brescia.csv'    u 2:4 w lp ls  2 lw 4 t " BS",\
     'covid_C_Bergamo.csv'    u 2:4 w lp ls  3 lw 4 t " BG",\
     'covid_C_Cremona.csv'    u 2:4 w lp ls  4 lw 4 t " CR",\
     'covid_C_Lodi.csv'       u 2:4 w lp ls  5 lw 4 t " LO",\

plot 'covid_C_Mantova.csv'    u 2:4 w lp ls  1 lw 4 t " MN",\
     'covid_C_Como.csv'       u 2:4 w lp ls  2 lw 4 t " CO",\
     'covid_C_Lecco.csv'      u 2:4 w lp ls  3 lw 4 t " LC",\
     'covid_C_Varese.csv'     u 2:4 w lp ls  4 lw 4 t " VA",\
     'covid_C_Sondrio.csv'    u 2:4 w lp ls  5 lw 4 t " SO",\
     'covid_C_Pavia.csv'      u 2:4 w lp ls  6 lw 4 t " PV"

unset logscale y
set yrange [-500:500]


plot 'covid_C_Milano.csv'     u 2:5 w lp ls  1 lw 4 t " MI",\
     'covid_C_Brescia.csv'    u 2:5 w lp ls  2 lw 4 t " BS",\
     'covid_C_Bergamo.csv'    u 2:5 w lp ls  3 lw 4 t " BG",\
     'covid_C_Cremona.csv'    u 2:5 w lp ls  4 lw 4 t " CR",\
     'covid_C_Lodi.csv'       u 2:5 w lp ls  5 lw 4 t " LO",\

plot 'covid_C_Mantova.csv'    u 2:5 w lp ls  1 lw 4 t " MN",\
     'covid_C_Como.csv'       u 2:5 w lp ls  2 lw 4 t " CO",\
     'covid_C_Lecco.csv'      u 2:5 w lp ls  3 lw 4 t " LC",\
     'covid_C_Varese.csv'     u 2:5 w lp ls  4 lw 4 t " VA",\
     'covid_C_Sondrio.csv'    u 2:5 w lp ls  5 lw 4 t " SO",\
     'covid_C_Pavia.csv'      u 2:5 w lp ls  6 lw 4 t " PV"
