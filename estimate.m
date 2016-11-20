function error=estimate(X,Y,S,n,C1,n_hat)

error=abs(n-n_hat);

figure
title(strcat('Error: ',num2str(abs(n-n_hat))))
subplot(1,2,1)
surf(X,Y,S)
xlabel('x')
ylabel('y')
title(strcat('n= ',num2str(n)));
hold on

%find location of AP
[M,I] = max(S(:));
[AP_y, AP_x] = ind2sub(size(S),I);

%create distance matrix
X_rel=X-AP_x;                         
Y_rel=Y-AP_y;
d=( (X_rel.^2)+(Y_rel.^2) ).^0.5;

S_hat=C1-10*n_hat*log10(abs(d));
AP_mask_1=find(S_hat==inf);
S_hat(AP_mask_1)=C1;


surf(X,Y,S_hat)         %if you want to see two plots together on left side

subplot(1,2,2)
surf(X,Y,S_hat)
title(strcat('n-hat= ',num2str(n_hat), ' C1= ',num2str(C1),' Error: ',num2str(error)));

end