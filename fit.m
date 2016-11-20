clc;
close all;

coef=[
      -20  4.7;     %C1  n_hat  ----> for wifidata_1.mat
      -15  2.7;
      -10  3.8; 
      -13  2.0;
      -10  4.6;
      
      -13  3.5;     %C1  n_hat  ----> for wifidata_6.mat
      -10  2.4;
      -12  3.2;
      -10  5.4;
      -13  3.6;     %C1  n_hat  ----> for wifidata_10.mat
      ];
  
errors=[];  
for i=1:10
    load (  strcat('wifidata_',num2str(i),'.mat'),'X','Y','S','n' )         %load 10 datasets
    C1=coef(i,1);
    n_hat=coef(i,2);
    error=estimate(X,Y,S,n,C1,n_hat);
    errors=[errors error];
    
end

errors
RMSE=sqrt(sum(errors.^2)/10);

figure
plot (errors)
xlabel('num. of dataset' )
ylabel('error')
title(strcat('RMSE= ',num2str(RMSE)))

