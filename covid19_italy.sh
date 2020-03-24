#!/bin/bash
function get_data ()
{
curl -o dpc-covid19-ita-andamento-nazionale.csv https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-andamento-nazionale/dpc-covid19-ita-andamento-nazionale.csv
curl -o dpc-covid19-ita-regioni.csv https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-regioni/dpc-covid19-ita-regioni.csv
curl -o dpc-covid19-ita-province.csv https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-province/dpc-covid19-ita-province.csv
}

function prepare_italia ()
{
echo "#data,giorni,"> col0
echo "D,d1D"        > col1
echo "D,d1D,d2D"    > col2
echo "D,d1D,d2D,d3D"> col3
grep -v "data" dpc-covid19-ita-andamento-nazionale.csv | cut -d" " -f1 | awk -F"-" '{printf"%s/%s/%s,%i,\n",$3,$2,$1,NR}' >> col0
grep -v "data" dpc-covid19-ita-andamento-nazionale.csv | awk -F","  'NR == 1{old = $10;printf"%i,%i\n",$10,0; next}   {printf"%i,%i\n",$10,$10-old; old = $10}' >> col1
grep -v "D"    col1                                    | awk -F","  'NR == 1{old = $2 ;printf"%i,%i,%i\n",$1,$2,0; next} {printf"%i,%i,%i\n",$1,$2,$2-old; old = $2}' >> col2
grep -v "D"    col2                                    | awk -F","  'NR == 1{old = $3 ;printf"%i,%i,%i,%i\n",$1,$2,$3,0; next} {printf"%i,%i,%i,%i\n",$1,$2,$3,$3-old; old = $3}' >> col3
paste col0 col3 | expand | sed -e "s/ //g" > covid_data/covid_D.csv
rm -rf col0 col1 col2 col3

echo "#data,giorni,"> col0
echo "C,d1C"        > col1
echo "C,d1C,d2C"    > col2
echo "C,d1C,d2C,d3C"> col3
grep -v "data" dpc-covid19-ita-andamento-nazionale.csv | cut -d" " -f1 | awk -F"-" '{printf"%s/%s/%s,%i,\n",$3,$2,$1,NR}' >> col0
grep -v "data" dpc-covid19-ita-andamento-nazionale.csv | awk -F","  'NR == 1{old = $11;printf"%i,%i\n",$11,0; next}   {printf"%i,%i\n",$11,$11-old; old = $11}' >> col1
grep -v "C"    col1                                    | awk -F","  'NR == 1{old = $2 ;printf"%i,%i,%i\n",$1,$2,0; next} {printf"%i,%i,%i\n",$1,$2,$2-old; old = $2}' >> col2
grep -v "C"    col2                                    | awk -F","  'NR == 1{old = $3 ;printf"%i,%i,%i,%i\n",$1,$2,$3,0; next} {printf"%i,%i,%i,%i\n",$1,$2,$3,$3-old; old = $3}' >> col3
paste col0 col3 | expand | sed -e "s/ //g" > covid_data/covid_C.csv
rm -rf col0 col1 col2 col3

echo "#data,giorni,"> col0
echo "T,d1T"        > col1
echo "T,d1T,d2T"    > col2
echo "T,d1T,d2T,d3T"> col3
grep -v "data" dpc-covid19-ita-andamento-nazionale.csv | cut -d" " -f1 | awk -F"-" '{printf"%s/%s/%s,%i,\n",$3,$2,$1,NR}' >> col0
grep -v "data" dpc-covid19-ita-andamento-nazionale.csv | awk -F","  'NR == 1{old = $4 ;printf"%i,%i\n",$4,0; next}   {printf"%i,%i\n",$4,$4-old; old = $4}' >> col1
grep -v "T"    col1                                    | awk -F","  'NR == 1{old = $2 ;printf"%i,%i,%i\n",$1,$2,0; next} {printf"%i,%i,%i\n",$1,$2,$2-old; old = $2}' >> col2
grep -v "T"    col2                                    | awk -F","  'NR == 1{old = $3 ;printf"%i,%i,%i,%i\n",$1,$2,$3,0; next} {printf"%i,%i,%i,%i\n",$1,$2,$3,$3-old; old = $3}' >> col3
paste col0 col3 | expand | sed -e "s/ //g" > covid_data/covid_T.csv
rm -rf col0 col1 col2 col3
}


function prepare_regioni ()
{
for regione in Veneto Lombardia Emilia Friuli Piemonte Trento Bolzano Aosta Liguria Toscana Umbria Marche Lazio Abruzzo Molise Puglia Campania Basilicata Calabria Sicilia Sardegna
do
   echo $regione
   echo "#data,giorni,"> col0
   echo "D,d1D"        > col1
   echo "D,d1D,d2D"    > col2
   echo "D,d1D,d2D,d3D"> col3
   grep $regione dpc-covid19-ita-regioni.csv  | cut -d" " -f1 | awk -F"-" '{printf"%s/%s/%s,%i,\n",$3,$2,$1,NR}' >> col0
   grep $regione dpc-covid19-ita-regioni.csv  | awk -F","  'NR == 1{old = $14;printf"%i,%i\n",$14,0; next}   {printf"%i,%i\n",$14,$14-old; old = $14}' >> col1
   grep -v "D"   col1                         | awk -F","  'NR == 1{old = $2 ;printf"%i,%i,%i\n",$1,$2,0; next} {printf"%i,%i,%i\n",$1,$2,$2-old; old = $2}' >> col2
   grep -v "D"   col2                         | awk -F","  'NR == 1{old = $3 ;printf"%i,%i,%i,%i\n",$1,$2,$3,0; next} {printf"%i,%i,%i,%i\n",$1,$2,$3,$3-old; old = $3}' >> col3
   paste col0 col2 | expand | sed -e "s/ //g" > "covid_data/covid_D_"$regione".csv"
   rm -rf col0 col1 col2 col3
done
}






function prepare_provincie ()
{
for provincia in Aosta Vercelli Verbano Torino Novara Cuneo Biella Asti Alessandria Imperia Savona Genova Milano Brescia Bergamo Lecco Monza Sondrio Varese Como Pavia Lodi Cremona Mantova Trento Bolzano Pordenone Udine Gorizia Trieste Padova Venezia Treviso Belluno Vicenza Verona Rovigo Rimini Ravenna Piacenza Parma Modena Ferrara Bologna Siena Prato Pistoia Lucca Livorno Grosseto Firenze Arezzo Perugia Terni Macerata Fermo Ancona Teramo Pescara Chieti Viterbo Roma Rieti Latina Frosinone Salerno Napoli Caserta Benevento Avellino Campobasso Isernia Taranto Lecce Foggia Brindisi Barletta Bari Matera Potenza Vibo Crotone Cosenza Catanzaro Trapani Siracusa Ragusa Palermo Messina Enna Caltanissetta Agrigento Sassari Oristano Nuoro Cagliari
do
   echo $provincia
   echo "#data,giorni,"> col0
   echo "C,d1C"        > col1
   echo "C,d1C,d2C"    > col2
   echo "D,d1D,d2D,d3D"> col3
   grep $provincia dpc-covid19-ita-province.csv| cut -d" " -f1 | awk -F"-" '{printf"%s/%s/%s,%i,\n",$3,$2,$1,NR}' >> col0
   grep $provincia dpc-covid19-ita-province.csv| awk -F","  'NR == 1{old = $10;printf"%i,%i\n",$10,0; next}   {printf"%i,%i\n",$10,$10-old; old = $10}' >> col1
   grep -v "C"   col1                         | awk -F","  'NR == 1{old = $2 ;printf"%i,%i,%i\n",$1,$2,0; next} {printf"%i,%i,%i\n",$1,$2,$2-old; old = $2}' >> col2
   grep -v "C"   col2                         | awk -F","  'NR == 1{old = $3 ;printf"%i,%i,%i,%i\n",$1,$2,$3,0; next} {printf"%i,%i,%i,%i\n",$1,$2,$3,$3-old; old = $3}' >> col3
   paste col0 col2 | expand | sed -e "s/ //g" > "covid_data/covid_C_"$provincia".csv"
   rm -rf col0 col1 col2 col3
done


#provincie difficili


lista[0]="MassaCarrara"
lista[1]="LaSpezia"
lista[2]="ForliCesena"
lista[3]="PesaroUrbino"
lista[4]="AscoliPiceno"
lista[5]="LAquila"
lista[6]="SudSardegna"
lista[7]="ReggioCalabria"
lista[8]="ReggioEmilia"
lista[9]="Roma"
lista[10]="Venezia"
lista[11]="Aosta"
lista[12]="Bolzano"
lista[13]="Trento"


listaf[0]="MS"
listaf[1]="SP"
listaf[2]="FC"
listaf[3]="PU"
listaf[4]="AP"
listaf[5]="AQ"
listaf[6]="SU"
listaf[7]="RC"
listaf[8]="RE"
listaf[9]="RM"
listaf[10]="VE"
listaf[11]="AO"
listaf[12]="BZ"
listaf[13]="TN"

i=-1
for provincia in "${lista[@]}"
do
   let i=$i+1
   provinciaf="${listaf["$i"]}"
   echo $i "$provincia" $provinciaf
   echo "#data,giorni,"> col0
   echo "C,d1C"        > col1
   echo "C,d1C,d2C"    > col2
   echo "D,d1D,d2D,d3D"> col3
   grep "$provinciaf" dpc-covid19-ita-province.csv| cut -d" " -f1 | awk -F"-" '{printf"%s/%s/%s,%i,\n",$3,$2,$1,NR}' >> col0
   grep "$provinciaf" dpc-covid19-ita-province.csv| awk -F","  'NR == 1{old = $10;printf"%i,%i\n",$10,0; next}   {printf"%i,%i\n",$10,$10-old; old = $10}' >> col1
   grep -v "C"   col1                         | awk -F","  'NR == 1{old = $2 ;printf"%i,%i,%i\n",$1,$2,0; next} {printf"%i,%i,%i\n",$1,$2,$2-old; old = $2}' >> col2
   grep -v "C"   col2                         | awk -F","  'NR == 1{old = $3 ;printf"%i,%i,%i,%i\n",$1,$2,$3,0; next} {printf"%i,%i,%i,%i\n",$1,$2,$3,$3-old; old = $3}' >> col3
   paste col0 col2 | expand | sed -e "s/ //g" > "covid_data/covid_C_"$provincia".csv"
   rm -rf col0 col1 col2 col3
done
}

function make_figs ()
{
cd covid_data
scr_prov=plot_provincie.plt
echo set terminal postscript color enhanced > $scr_prov
echo set output "'"provincie.ps"'" >> $scr_prov
echo set datafile sep "'","'" >> $scr_prov
ls covid_C*.csv | while read f
do
   p=$(echo $f | sed -e 's/.csv//g' | sed -e 's/covid_C_//g')
   echo set multiplot layout 3,1 >> $scr_prov
   echo unset key >> $scr_prov
   echo set format y "'"%5.0f"'" >> $scr_prov
   echo set logscale y >> $scr_prov
   echo set yrange [1:*] >> $scr_prov
   echo set title "'provincia di "$p"'" >> $scr_prov
   echo set ylabel "'"totale contagiati"'" >> $scr_prov
   echo plot "'"$f"'" u 2:3 w lp ls  7 lw 4 t "'"$p"'" >> $scr_prov
   echo unset title >> $scr_prov
   echo unset logscale y >> $scr_prov
   echo set yrange [*:*] >> $scr_prov
   echo set ylabel "'"contagiati giornalieri"'" >> $scr_prov
   echo plot "'"$f"'" u 2:4 w lp ls  7 lw 4 t "'"$p"'" >> $scr_prov
   echo set ylabel "'"differenza contagiati"'" >> $scr_prov
   echo set xlabel "'"giorni"'" >> $scr_prov
   echo plot "'"$f"'" u 2:5 w lp ls  7 lw 4 t "'"$p"'" >> $scr_prov
   echo unset multiplot >> $scr_prov
   echo unset xlabel >> $scr_prov
done
gnuplot $scr_prov
gnuplot covid.plt
gnuplot italia.plt
gnuplot italia2.plt
gnuplot regioni.plt
gnuplot veneto.plt
gnuplot lombardia.plt
cd ..
}


get_data
prepare_italia
prepare_regioni
prepare_provincie
make_figs
