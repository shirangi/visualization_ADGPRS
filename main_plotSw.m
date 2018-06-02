% main_plotSw
% This script plot water saturation distribution for a reservoir simulation case 
% based on Stanford AD-GPRS results 
% Note: you need to run ADGPRS simulation to create the OUTPUT1.vars.txt file
%       which contains all the saturations and pressures at all time-steps 
% 
% Written by Mehrdad Gharib Shirangi, mehr@stanford.edu 
% Last update: 01/20/2017

% ===========================================================================
% =========== Parameters:  ==================================================

% Grid dimensions 
Nx = 50; Ny = 50; Nz = 6; 
% Residual oil saturation 
Sor = 0.2; 
% Initial water saturation 
Swi = 0.1;
% Number of wells:
nwells = 11;
% Number of wells which are drilled at each control-step 
NwDrill = 11;
% Simulation time (in days):
ctrlPeriodVec = 3060;
% The directory where the .vars.txt file is located
wpath = '3D_Example_files\';  
disp('Please unzip 3D_Example_files')
% Locations of producer wells: Each horizontal well is constrained to lay in y-direction, in the same layer
%   i ,j1, j2, k, injNumber, WellNumber ==> i: x-index
%                                           j1: y-index (first block)
%                                           j2: y-index (last block) 
%                                           k: z-index (layer) 
%                                           injNumber: assign a number to this well 
%                                           wellNumber: assign a number to this well 
prodLocs = [...
    10 41   48  1   1   1
    40 41   48  1   2   2
    10	2   9   1   3   3
    40 2    9   1   4   4
    25 21   29  2   5   5];   

% Location of injection wells: Each injection well is vertical
%   i ,j, k1, k2, injNumber, WellNumber ==> i: x-index
%                                           j: y-index 
%                                           k1: z-index (first block)
%                                           k2: z-index (last block)
%                                           injNumber: assign a number to this well 
%                                           wellNumber: assign a number to this well 
injLocs = [ ...
    5   45  4   6  1    6
    25  47  4   6  2    7
    46  46  4   6  3    8
    5   5   5   6  4    9
    25  3   5   6  5    10
    46  5   5   6  6    11];

% ===========================================================================
% Additional parameters
% File that contains all the saturations at all time-steps 
swfileName = [wpath 'OUTPUT1.vars.txt'];
% Number of producers
nprod = size(prodLocs,1);
% Number of injectors 
ninj = size(injLocs,1);
% Drilling Time for each well 
tvecWell = zeros(nwells,1);

tvec = ctrlPeriodVec;
Tend = ctrlPeriodVec(end);

% ===========================================================================

[sw,tvec2] = readSw(swfileName,Tend, Nx, Ny, Nz, tvec);
plotSwMaps(Nx,Ny,Nz, ninj,nprod,injLocs,prodLocs,sw,Sor,Swi,tvec2,tvecWell,NwDrill,'end');
% plotSwMaps(Nx,Ny,Nz, ninj,nprod,injLocs,prodLocs,sw,Sor,Swi,tvec2,tvecWell,NwDrill,'all');

rateFileName = [wpath 'OUTPUT1.rates.txt'];
% main file for plotting rates:
[t,npv, fop, fwp, fwi] =  plotRates_adgprs(rateFileName, nprod, ninj, ro, cwp, cwi,wellcost );
