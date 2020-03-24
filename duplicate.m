file1=csvread(file="covid_D.csv");
t=file1(:,2);
y=file1(:,3);

n=length(t);

for i=n:-1:2
    dy2=9e9;
    for j=i-1:-1:1
        dy=abs((y(i)-2*y(j))/y(i));
        dt=t(i)-t(j);
        if(dy<dy2)
          dy2=dy;
          j2=j;
          t2=dt;
        endif
    endfor
    printf("%i %i %i %i\n",i,j2,dy2,t2)
#    printf("\n")
endfor

