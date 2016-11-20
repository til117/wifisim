%        Wifi_simulator ( [x_min, x_max, y_min, y_max, resolution],[AP_x, AP_y],[Pt, Gt, Gr, frequency],[n, sigma])


% run this first: load myData.mat map_size AP_location signal_params environment_params

function M=Wifi_simulator (map_size, AP_location, signal_params, environment_params,movie_type,output,camera)

clc;
close all;


if strcmp(camera,'rotated')
  rotate=1;
elseif strcmp(camera,'fixed')
  rotate=0;
end

%picking up parameters
[X,Y]=meshgrid(map_size(1):map_size(5):map_size(2) , map_size(3):map_size(5):map_size(4));
Pt=signal_params(1);
Gt=signal_params(2);
Gr=signal_params(3);
f=signal_params(4);
n=environment_params(1);
sigma=environment_params(2);
C=Gt+Gr+20*log10( 3e8 /(4*pi*f) );

%calculating the distance matrix
X_rel=X-AP_location(1);                         %relative distances
Y_rel=Y-AP_location(2);
d=( (X_rel.^2)+(Y_rel.^2) ).^0.5;

%apply some exceptions for some points aroud AP
AP_mask_2=(abs(d)<1 & abs(d)>0);
AP_mask_2=not(AP_mask_2);


%initiate the viwepoint
if rotate==1
    az=180;
    el=0;
else
    az=45;
    el=45;
end    

flag=1;

figure(1)

if strcmp(output,'plot')
        AP_mask_2=(abs(d)<2 & abs(d)>0);
        AP_mask_2=not(AP_mask_2);
        R = random('Normal',0,sigma, size(X));      %some random values with sigma , size of mat
        S1=Pt+C-AP_mask_2.*(10*n*log10(abs(d))+R);
        AP_mask_1=find(S1==inf);
        S1(AP_mask_1)=Pt;
        surf(X,Y,S1);
        xlabel('x')
        ylabel('y')
        title('Single plot')
        M=0;                                %if outpu=plot 
elseif strcmp(output,'movie')       
        F=1;
        disp('Recording frames to M ...')
        for i=1:130
        cla;
         if strcmp(movie_type,'AP')                         %change d!
                X_rel=X_rel-1;                              %move the AP along X_axis
                d=( (X_rel.^2)+(Y_rel.^2) ).^0.5;
                AP_mask_2=(abs(d)<2 & abs(d)>0);
                AP_mask_2=not(AP_mask_2);
                R=0;                                        %not random values
         elseif  strcmp(movie_type,'temporal') 
                R = random('Normal',0,sigma, size(X));      %some random values with sigma , size of mat
         end

        S1=Pt+C-AP_mask_2.*(10*n*log10(abs(d))+R);          %calculate signal by considering the exception!
        AP_mask_1=find(S1==inf);
        S1(AP_mask_1)=Pt;                                   %set the max signal value as Pt itself

        surf(X,Y,S1);
        xlabel('x')
        ylabel('y')

        view(az,el);                                        %apply the initiated viwepoint
        if rotate                                           %change the viwepoint during recording
                    az=az-1;
                    if flag
                        el=el+1;
                        if el==90 
                           flag=0;
                        end   
                    else
                        el=el-1;
                    end 
        end    

        M(F)=getframe(gcf,[30 40 530 380]);
        F=F+1;

        end
        title('M is ready to play!')
        figure(2)
        axis off;
        tic;
        disp('Playing M...')
        movie(M)
        time=toc
end

%{
%-------------------------------Generate data sets-------------------------
    for i=1:10                                   %it should be 10 datasets
        
        %should I also change them?!
        Pt=signal_params(1);
        Gt=signal_params(2);
        Gr=signal_params(3);
        f=signal_params(4);

        %n=environment_params(1);
        n = 4*rand + 2;                         % a random num. between 2~6  (n)

        %sigma=environment_params(2);
        sigma = 6*rand + 2;                     % a random num. between 2~8 (sigma)

        AP_x_rand=randi([map_size(1),map_size(2)]);
        AP_y_rand=randi([map_size(3),map_size(4)]);
        X_rel=X-AP_x_rand;  
        Y_rel=Y-AP_y_rand;

        C=Gt+Gr+20*log10( 3e8 /(4*pi*f) );
        d=( (X_rel.^2)+(Y_rel.^2) ).^0.5;
        AP_mask_2=(abs(d)<1 & abs(d)>0);
        AP_mask_2=not(AP_mask_2);

        R = random('Normal',0,sigma, size(X));  

        S=Pt+C-AP_mask_2.*(10*n*log10(abs(d))+R);
        AP_mask_1=find(S==inf);
        S(AP_mask_1)=Pt;
        
        figure
        surf(X,Y,S);
        title (strcat('n=',num2str(n),' sigma=',num2str(sigma),' AP=',num2str(AP_x_rand),' ',num2str(AP_y_rand)))
        xlabel('x')
        ylabel('y')
        file_name=strcat('wifidata_',num2str(i),'.mat')
        save (file_name ,'X' ,'Y' ,'S' ,'n')
        
    end   
  %}   
  
end