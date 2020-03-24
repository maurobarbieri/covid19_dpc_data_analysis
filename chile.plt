set fit errorvariables
set fit limit 1e-6
set fit prescale
set datafile sep ','

print "###########################################################################"
print "FIT erf function on cumulatives data"
erf1(x)=e01*0.5*(1+erf((x-e02)/(e03*sqrt(2))))
fit erf1(x) 'chile.csv' u 2:3:(sqrt($3)) yerror via e01,e02,e03
e04 = e01/(e03*sqrt(2*pi))
e04_err=sqrt((e01_err**2+e01**2*e03_err**2)/(2*pi*e03**2))


plot \
'chile.csv' u 2:3:(sqrt($3)) w l lw 1 lt 4 t " cumul",\
'chile.csv' u 2:3:(sqrt($3)) w yerrorbars lt 4 t "",\
erf1(x)      lw 1 lt 2 t " erf  "


print e04, e04_err
