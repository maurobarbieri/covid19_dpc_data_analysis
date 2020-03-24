#set terminal png enhanced font "Arial,12" size 1600,1200
set terminal postscript color enhanced  "Helvetica" 12
set output "italia.ps"
    
set fit errorvariables
set fit limit 1e-6
set fit prescale
set datafile sep ','
#set key autotitle columnhead

#################################################################################################################
#
#
#
#
#################################################################################################################

stats 'covid_D.csv' u 2
time_max=STATS_max
stats 'covid_D.csv' u 4
deceaded_max=STATS_max
deceaded_tot=STATS_sum
#pause -1


set xrange [*:26]
set yrange [*:*]
erf1(x)=e01*0.5*(1+erf((x-e02)/(e03*sqrt(2))))
fit erf1(x) 'covid_D.csv' u 2:3:(sqrt($3)) yerror via e01,e02,e03
e01_26=e01
e02_26=e02
e03_26=e03
e04_26=e01/(e03*sqrt(2*pi))
e01_e_26=e01_err
e02_e_26=e02_err
e03_e_26=e03_err
e04_e_26=sqrt((e01_err**2+e01**2*e03_err**2)/(2*pi*e03**2))

set xrange [*:*]
set yrange [*:*]

print "###########################################################################"
print "FIT gaussian function on daily increases"
gaus2(x)=g21*exp(-0.5*((x-g22)/g23)**2)
fit gaus2(x) 'covid_D.csv' u 2:4:($4>0?sqrt($4):1) yerror via g21,g22,g23
g24=g21*g23*sqrt(2*pi)
#pause -1


print "###########################################################################"
print "FIT erf function on cumulatives data"
erf1(x)=e01*0.5*(1+erf((x-e02)/(e03*sqrt(2))))
fit erf1(x) 'covid_D.csv' u 2:3:(sqrt($3)) yerror via e01,e02,e03
e04 = e01/(e03*sqrt(2*pi))
e04_err=sqrt((e01_err**2+e01**2*e03_err**2)/(2*pi*e03**2))



#pause -1

#print "###########################################################################"
#print "FIT rayleigh function on cumulatives data"
#r01=15e3
#r02=31
#rayl1(x)=r01*(1-exp(-0.5*(x/r02)**2))
#fit rayl1(x) 'covid_D.csv' u 2:3:(sqrt($3)) yerror via r01,r02
#pause -1

tmax=60
set grid
set key box left
set xlabel "data"
set ylabel "deceduti"
set format y "%5.0f"
set ytics auto
set xrange [0:tmax]
set xtics 2 
set xtics nomirror out
set xtics rotate by 90
set xtics offset 0, screen -0.03
set x2tics 2
set x2range [0:tmax]

set logscale y
set yrange [1:15000]
#set yrange [0:3100]

#set output "italia_model_erf.png"
plot \
'covid_D.csv' u 2:3:(sqrt($3)) w l lw 1 lt 4 t " cumul",\
'covid_D.csv' u 2:3:(sqrt($3)) w yerrorbars lt 4 t "",\
erf1(x)      lw 1 lt 2 t " erf  ",\
e01_26*0.5*(1+erf((x-e02_26)/(e03_26*sqrt(2)))) lw 1 lt 1 t " erf26  ",\
'covid_D.csv' u 2:($4) w lp lt 7 t " giorn",\
'covid_D.csv' u 2:($4):(sqrt($4)) w yerrorbars lt 7 t "",\
gaus2(x)     lw 1 lt 6 t " gauss",\
e04*exp(-0.5*((x-e02)/e03)**2) lt 2 t " erf  ",\
e04_26*exp(-0.5*((x-e02_26)/e03_26)**2) lt 1 t " erf26  ",\
e04_26-1*e04_e_26 lt 8 t "",\
e04_26+1*e04_e_26 lt 8 t "",\
'covid_date.csv' u 2:(0):xtic(2) axes x1y1 w d t "",\
'covid_date.csv' u 2:(0):xtic(1) axes x2y1 w d t ""

print ""
print ""
print time_max
print deceaded_max
print deceaded_tot
print ""
print sprintf("%8.1f %8.1f %8.1f %8.1f",e01_26,e01_e_26, e01,e01_err)
print sprintf("%8.1f %8.1f %8.1f %8.1f",e02_26,e02_e_26, e02,e02_err)
print sprintf("%8.1f %8.1f %8.1f %8.1f",e03_26,e03_e_26, e03,e03_err)
print sprintf("%8.1f %8.1f %8.1f %8.1f",e04_26,e04_e_26, e04,e04_err)

set print $random_t
do for [i=1:2000] {
    print sprintf("%8.3g", (tmax*rand(0)))
}
unset print


simulated(x)=e04*exp(-0.5*((x-e02)/e03)**2)
noise(x)=0.3*simulated(x)*(2*(rand(0)-0.5))


#set output "italia_model_erf_zoom.png"
set yrange [1:1000]
plot \
$random_t u 1:(simulated($1)+noise($1)) w p lt 5  t "",\
'covid_D.csv' u 2:($4) w lp lt 7 t " giorn",\
'covid_D.csv' u 2:($4):(sqrt($4)) w yerrorbars lt 7 t "",\
e04*exp(-0.5*((x-e02)/e03)**2) lt 2 t " erf  ",\
'covid_date.csv' u 2:(0):xtic(2) axes x1y1 w d t "",\
'covid_date.csv' u 2:(0):xtic(1) axes x2y1 w d t ""


unset logscale y
set xrange [0:tmax]
set yrange [-400:400]
set ytics auto
plot 'covid_D.csv' u 2:($5) w lp lt 7 t " d1 ",\
     'covid_D.csv' u 2:($5):(sqrt(abs($5))) w yerrorbars lt 7 t "",\
     'covid_D.csv' u 2:($6) w lp lt 6 t " d2 ",\
     'covid_D.csv' u 2:($6):(sqrt(abs($5))) w yerrorbars lt 6 t "",\
'covid_date.csv' u 2:(0):xtic(2) axes x1y1 w d t "",\
'covid_date.csv' u 2:(0):xtic(1) axes x2y1 w d t ""



#set output "italia_model_erf_diff.png"
unset x2tics
unset xtics
set xtics 50
set mxtics 5
set ytics 10
unset logscale y
set xrange [-5:*]
set yrange [-75:75]
set xlabel 'numero decessi'
set ylabel 'differenza percentuale tra decessi e il modello'
unset k
plot \
'covid_D.csv' u 4:(100*($4-e04*exp(-0.5*(($2-e02)/e03)**2))/$4) w p ps 2 pt 7 lc 7 t " ",\
'covid_D.csv' u ($4+15):(100*($4-e04*exp(-0.5*(($2-e02)/e03)**2))/$4+2):($1) w labels t "",\








#################################################################################################################
#
#
#
#
#################################################################################################################

stats 'covid_C.csv' u 2
time_max=STATS_max
stats 'covid_C.csv' u 4
deceaded_max=STATS_max
deceaded_tot=STATS_sum
#pause -1


set xrange [*:26]
set yrange [*:*]
erf1(x)=e01*0.5*(1+erf((x-e02)/(e03*sqrt(2))))
fit erf1(x) 'covid_C.csv' u 2:3:(sqrt($3)) yerror via e01,e02,e03
e01_26=e01
e02_26=e02
e03_26=e03
e04_26=e01/(e03*sqrt(2*pi))
e01_e_26=e01_err
e02_e_26=e02_err
e03_e_26=e03_err
e04_e_26=sqrt((e01_err**2+e01**2*e03_err**2)/(2*pi*e03**2))

set xrange [*:*]
set yrange [*:*]

print "###########################################################################"
print "FIT gaussian function on daily increases"
gaus2(x)=g21*exp(-0.5*((x-g22)/g23)**2)
fit gaus2(x) 'covid_C.csv' u 2:4:($4>0?sqrt($4):1) yerror via g21,g22,g23
g24=g21*g23*sqrt(2*pi)
#pause -1


print "###########################################################################"
print "FIT erf function on cumulatives data"
erf1(x)=e01*0.5*(1+erf((x-e02)/(e03*sqrt(2))))
fit erf1(x) 'covid_C.csv' u 2:3:(sqrt($3)) yerror via e01,e02,e03
e04 = e01/(e03*sqrt(2*pi))
e04_err=sqrt((e01_err**2+e01**2*e03_err**2)/(2*pi*e03**2))



#pause -1

#print "###########################################################################"
#print "FIT rayleigh function on cumulatives data"
#r01=15e3
#r02=31
#rayl1(x)=r01*(1-exp(-0.5*(x/r02)**2))
#fit rayl1(x) 'covid_C.csv' u 2:3:(sqrt($3)) yerror via r01,r02
#pause -1

tmax=60
set grid
set key box left
set xlabel "data"
set ylabel "contagiati"
set format y "%5.0f"
set ytics auto
set xrange [0:tmax]
set xtics 2 
set xtics nomirror out
set xtics rotate by 90
set xtics offset 0, screen -0.03
set x2tics 2
set x2range [0:tmax]

set logscale y
set yrange [1:*]
#set yrange [0:3100]

#set output "italia_model_erf.png"
plot \
'covid_C.csv' u 2:3:(sqrt($3)) w l lw 1 lt 4 t " cumul",\
'covid_C.csv' u 2:3:(sqrt($3)) w yerrorbars lt 4 t "",\
erf1(x)      lw 1 lt 2 t " erf  ",\
e01_26*0.5*(1+erf((x-e02_26)/(e03_26*sqrt(2)))) lw 1 lt 1 t " erf26  ",\
'covid_C.csv' u 2:($4) w lp lt 7 t " giorn",\
'covid_C.csv' u 2:($4):(sqrt($4)) w yerrorbars lt 7 t "",\
gaus2(x)     lw 1 lt 6 t " gauss",\
e04*exp(-0.5*((x-e02)/e03)**2) lt 2 t " erf  ",\
e04_26*exp(-0.5*((x-e02_26)/e03_26)**2) lt 1 t " erf26  ",\
e04_26-1*e04_e_26 lt 8 t "",\
e04_26+1*e04_e_26 lt 8 t "",\
'covid_date.csv' u 2:(0):xtic(2) axes x1y1 w d t "",\
'covid_date.csv' u 2:(0):xtic(1) axes x2y1 w d t ""

print ""
print ""
print time_max
print deceaded_max
print deceaded_tot
print ""
print sprintf("%8.1f %8.1f %8.1f %8.1f",e01_26,e01_e_26, e01,e01_err)
print sprintf("%8.1f %8.1f %8.1f %8.1f",e02_26,e02_e_26, e02,e02_err)
print sprintf("%8.1f %8.1f %8.1f %8.1f",e03_26,e03_e_26, e03,e03_err)
print sprintf("%8.1f %8.1f %8.1f %8.1f",e04_26,e04_e_26, e04,e04_err)

set print $random_t
do for [i=1:2000] {
    print sprintf("%8.3g", (tmax*rand(0)))
}
unset print


simulated(x)=e04*exp(-0.5*((x-e02)/e03)**2)
noise(x)=0.3*simulated(x)*(2*(rand(0)-0.5))


#set output "italia_model_erf_zoom.png"
set yrange [1:*]
plot \
$random_t u 1:(simulated($1)+noise($1)) w p lt 5  t "",\
'covid_C.csv' u 2:($4) w lp lt 7 t " giorn",\
'covid_C.csv' u 2:($4):(sqrt($4)) w yerrorbars lt 7 t "",\
e04*exp(-0.5*((x-e02)/e03)**2) lt 2 t " erf  ",\
'covid_date.csv' u 2:(0):xtic(2) axes x1y1 w d t "",\
'covid_date.csv' u 2:(0):xtic(1) axes x2y1 w d t ""


unset logscale y
set xrange [0:tmax]
set yrange [-3000:3000]
set ytics auto
plot 'covid_C.csv' u 2:($5) w lp lt 7 t " d1 ",\
     'covid_C.csv' u 2:($5):(sqrt(abs($5))) w yerrorbars lt 7 t "",\
     'covid_C.csv' u 2:($6) w lp lt 6 t " d2 ",\
     'covid_C.csv' u 2:($6):(sqrt(abs($5))) w yerrorbars lt 6 t "",\
'covid_date.csv' u 2:(0):xtic(2) axes x1y1 w d t "",\
'covid_date.csv' u 2:(0):xtic(1) axes x2y1 w d t ""


#set output "italia_model_erf_diff.png"
unset x2tics
unset xtics
set xtics auto
set mxtics 5
set ytics 10
unset logscale y
set xrange [-5:*]
set yrange [-75:75]
set xlabel 'numero decessi'
set ylabel 'differenza percentuale tra contagiati e il modello'
unset k
plot \
'covid_C.csv' u 4:(100*($4-e04*exp(-0.5*(($2-e02)/e03)**2))/$4) w p ps 2 pt 7 lc 7 t " ",\
'covid_C.csv' u ($4+15):(100*($4-e04*exp(-0.5*(($2-e02)/e03)**2))/$4+2):($1) w labels t "",\






        
#################################################################################################################
#
#
#
#
#################################################################################################################

stats 'covid_T.csv' u 2
time_max=STATS_max
stats 'covid_T.csv' u 4
deceaded_max=STATS_max
deceaded_tot=STATS_sum
#pause -1


set xrange [*:26]
set yrange [*:*]
erf1(x)=e01*0.5*(1+erf((x-e02)/(e03*sqrt(2))))
fit erf1(x) 'covid_T.csv' u 2:3:(sqrt($3)) yerror via e01,e02,e03
e01_26=e01
e02_26=e02
e03_26=e03
e04_26=e01/(e03*sqrt(2*pi))
e01_e_26=e01_err
e02_e_26=e02_err
e03_e_26=e03_err
e04_e_26=sqrt((e01_err**2+e01**2*e03_err**2)/(2*pi*e03**2))

set xrange [*:*]
set yrange [*:*]

print "###########################################################################"
print "FIT gaussian function on daily increases"
gaus2(x)=g21*exp(-0.5*((x-g22)/g23)**2)
fit gaus2(x) 'covid_T.csv' u 2:4:($4>0?sqrt($4):1) yerror via g21,g22,g23
g24=g21*g23*sqrt(2*pi)
#pause -1


print "###########################################################################"
print "FIT erf function on cumulatives data"
erf1(x)=e01*0.5*(1+erf((x-e02)/(e03*sqrt(2))))
fit erf1(x) 'covid_T.csv' u 2:3:(sqrt($3)) yerror via e01,e02,e03
e04 = e01/(e03*sqrt(2*pi))
e04_err=sqrt((e01_err**2+e01**2*e03_err**2)/(2*pi*e03**2))



#pause -1

#print "###########################################################################"
#print "FIT rayleigh function on cumulatives data"
#r01=15e3
#r02=31
#rayl1(x)=r01*(1-exp(-0.5*(x/r02)**2))
#fit rayl1(x) 'covid_T.csv' u 2:3:(sqrt($3)) yerror via r01,r02
#pause -1

tmax=60
set grid
set key box left
set xlabel "data"
set ylabel "terapia intensiva"
set format y "%5.0f"
set ytics auto
set xrange [0:tmax]
set xtics 2 
set xtics nomirror out
set xtics rotate by 90
set xtics offset 0, screen -0.03
set x2tics 2
set x2range [0:tmax]

set logscale y
set yrange [1:*]
#set yrange [0:3100]

#set output "italia_model_erf.png"
plot \
'covid_T.csv' u 2:3:(sqrt($3)) w l lw 1 lt 4 t " cumul",\
'covid_T.csv' u 2:3:(sqrt($3)) w yerrorbars lt 4 t "",\
erf1(x)      lw 1 lt 2 t " erf  ",\
e01_26*0.5*(1+erf((x-e02_26)/(e03_26*sqrt(2)))) lw 1 lt 1 t " erf26  ",\
'covid_T.csv' u 2:($4) w lp lt 7 t " giorn",\
'covid_T.csv' u 2:($4):(sqrt($4)) w yerrorbars lt 7 t "",\
gaus2(x)     lw 1 lt 6 t " gauss",\
e04*exp(-0.5*((x-e02)/e03)**2) lt 2 t " erf  ",\
e04_26*exp(-0.5*((x-e02_26)/e03_26)**2) lt 1 t " erf26  ",\
e04_26-1*e04_e_26 lt 8 t "",\
e04_26+1*e04_e_26 lt 8 t "",\
'covid_date.csv' u 2:(0):xtic(2) axes x1y1 w d t "",\
'covid_date.csv' u 2:(0):xtic(1) axes x2y1 w d t ""

print ""
print ""
print time_max
print deceaded_max
print deceaded_tot
print ""
print sprintf("%8.1f %8.1f %8.1f %8.1f",e01_26,e01_e_26, e01,e01_err)
print sprintf("%8.1f %8.1f %8.1f %8.1f",e02_26,e02_e_26, e02,e02_err)
print sprintf("%8.1f %8.1f %8.1f %8.1f",e03_26,e03_e_26, e03,e03_err)
print sprintf("%8.1f %8.1f %8.1f %8.1f",e04_26,e04_e_26, e04,e04_err)

set print $random_t
do for [i=1:2000] {
    print sprintf("%8.3g", (tmax*rand(0)))
}
unset print


simulated(x)=e04*exp(-0.5*((x-e02)/e03)**2)
noise(x)=0.3*simulated(x)*(2*(rand(0)-0.5))


#set output "italia_model_erf_zoom.png"
set yrange [1:*]
plot \
$random_t u 1:(simulated($1)+noise($1)) w p lt 5  t "",\
'covid_T.csv' u 2:($4) w lp lt 7 t " giorn",\
'covid_T.csv' u 2:($4):(sqrt($4)) w yerrorbars lt 7 t "",\
e04*exp(-0.5*((x-e02)/e03)**2) lt 2 t " erf  ",\
'covid_date.csv' u 2:(0):xtic(2) axes x1y1 w d t "",\
'covid_date.csv' u 2:(0):xtic(1) axes x2y1 w d t ""

unset logscale y
set xrange [0:tmax]
set yrange [-200:200]
set ytics auto
plot 'covid_T.csv' u 2:($5) w lp lt 7 t " d1 ",\
     'covid_T.csv' u 2:($5):(sqrt(abs($5))) w yerrorbars lt 7 t "",\
     'covid_T.csv' u 2:($6) w lp lt 6 t " d2 ",\
     'covid_T.csv' u 2:($6):(sqrt(abs($5))) w yerrorbars lt 6 t "",\
'covid_date.csv' u 2:(0):xtic(2) axes x1y1 w d t "",\
'covid_date.csv' u 2:(0):xtic(1) axes x2y1 w d t ""


#set output "italia_model_erf_diff.png"
unset x2tics
unset xtics
set xtics 50
set mxtics 5
set ytics 10
unset logscale y
set xrange [-5:*]
set yrange [-75:75]
set xlabel 'numero decessi'
set ylabel 'differenza percentuale tra terapie intensive e il modello'
unset k
plot \
'covid_T.csv' u 4:(100*($4-e04*exp(-0.5*(($2-e02)/e03)**2))/$4) w p ps 2 pt 7 lc 7 t " ",\
'covid_T.csv' u ($4+15):(100*($4-e04*exp(-0.5*(($2-e02)/e03)**2))/$4+2):($1) w labels t "",\










