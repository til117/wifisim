# wifisim
A function that accepts several input arguments and simulates a free space WiFi signal strength

Implemented in MATLAB for a programming course at KTH.

# Description

A Matlab function is created that accepts several input arguments and simulates a free space 
WiFi signal strength. 

The created data are visualized with a dynamic movie (and plot) 

Given a sample signal strength data, the parameters are extracted.

# Some theory

Use the formula below to calculate the signal strength S at each point in space. 

S = Pt + C – 10 n log(|d|) + X

Where, Pt is the transmit power of the Access Point, C is the channel gain. 

C = Gt + Gr + 20 log (v/(4*pi*f)) 

with Gt being the transmit antenna gain, Gr being the receive antenna gain, v being the velocity of light and f being the frequency of the WiFi signal used (typically 2.4 GHz but can also be 5.2GHz), n is the environmental parameter that represent the loss exponent (usually 2 to 6), d is the Euclidean distance between the point (where the strength is measured) and 
the Access Point/AP (signal source) location, X=N (0, sigma) is a Gaussian random variable with zero mean and standard deviation 
sigma depending on the environment. Sigma usually ranges between 2 to 8. 

Note 1: log is the base to 10 (log10) and not the natural logarithm. 
Note 2: At the AP location, S = Pt 
Note 3: If 0 < |d| <= 1, then S = Pt + C 
Note 4: All units (for S, Pt, C, and sigma) are in dBm. 

# Wifi_simulator (map_size, AP_location, signal_params, environment_params, options) 

Where the inputs are:

map_size = [x_min, x_max, y_min, y_max, resolution] 

AP_location = [AP_x, AP_y] 

signal_params = [Pt, Gt, Gr, frequency] 

environment_params = [n, sigma] 

Optional parameters (options): 

1.  arg: ‘output’, values: ‘plot’ or ‘movie’ – a simple surf plot or a surf plot movie for 10 
seconds 

2.  arg:’movie type’, values = ‘AP’ or ‘temporal’ – this option is for the movie output. AP 
means show the movie with the AP location moving linearly (on any axis) from the 
given location. Temporal means show the movie with a new random sequence in 
each frame for the X variable so that the movie shows the dynamic nature of the 
changes in the WiFi signal strength. 

Set the options ‘output’ and ‘movie type’ as ‘movie’ and ‘temporal’ by default respectively. 

Output: 

1.   A plot or a 10 second movie as per the option passed 

2.  Save the variables x, y, S, n in “wifidata.mat”. Generate 10 datasets with different 
arbitrary parameters and call them “wifidata_x.mat” with x=1:10. 

# estimate.m

A Matlab script to predict the WiFi signal model given a dataset.
 
Clear all your workspace variables before executing this function. 
 
Load the datasets you saved in the previous function (wifidata_x.mat) one by one. 

1.  Create a subplot figure with size [1, 2] and surface plot the loaded data in the first 
subplot. 
 
2.  Fit a simpler version of the signal strength formula 

S = C1 – 10 n log (|d|)

Note 1: use any fitting function to find a solution for the parameters C1 and n. 

Note 2: you cannot assume that you know the AP location. 
 
3.  Check if the predicted parameter n is close to the ones you used to create the data. 
Print the error in the predicted n value.  
 
4.  Now calculate S with the fitted parameters for the same x and y values using eqn. (2).  
 
5.  Plot the predicted signal strength in the second subplot that you created. 
 
Repeat steps 1-5 for every dataset and plot the errors of the predicted n values from all 
the 10 datasets. Calculate the Root Mean Squared Error (RMSE) and print it. 
 
Try to reduce the RMSE as much as possible. 
