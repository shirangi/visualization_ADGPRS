function [t,npv, fop, fwp, fwi] = plotRates_adgprs(rateFileName, Nprod, Ninj, ro, cwp, cwi, wellcost)

% This function plots the cumulative rates from adgprs output rate file 
% This is particulary important to plot the rats of the true model at the
% end of each CLFD update step.
% Inputs:
%   rateFileName: Stanford ADGPRS output rate file 
%   Nprod: number of producer wells 
%   Ninj: number of injection wells 
%   ro: oil price 
%   cwp: water production cost
%   cwi: water injection cost
%   wellcost: cost of drilling & completion of a well 
% Outputs:
%   t: time vector 
%   npv: NPV (net present value) vector 
%   fop: field oil production vector 
%   fwp: field water production vector 
%   fwi: field water injection vector 
% 
% Example:
%   rateFileName = 'OUTPUT1.sim.rates.txt'; 
%   Npord = 4;
%   Ninj = 4; 
%   ro = 566.07; cwp = 62.9; cwi = 62.9;
%   wellcost = 25e6;
%   [t,npv, fop, fwp, fwi] = plotRates_adgprs(rateFileName, Npord, Ninj, ro, cwp, cwi ) 
% 
% Note: You must comment the first two lines of the rate file (output of ADGPRS simulation run), 
%       using % at the beginning of the first two lines. 
% 
% Written by Mehrdad Gharib Shirangi, 
% First date: 08-03-2013
% Last updated: 02/06/2018

    mat = load(rateFileName);

    np = 3; % number of data per well 
    [Nt, Nc] = size(mat);

    Np = Nprod;
    Ni =  Ninj;
    FOP = 0; FWI = 0 ; FWP = 0;
    fop = zeros(Nt,1); fwi = zeros(Nt,1); fwp = zeros(Nt,1); npv  = zeros(Nt,1);
    i=1;
    for j = 1 : Ni
        FWI = FWI + mat(1,2) * mat(i,3+np*(j-1)+2);
    end

    for j = 1 + Ni : Np + Ni
        FOP = FOP + mat(1,2) * mat(i,3+np*(j-1)+3);
        FWP = FWP + mat(1,2) * mat(i,3+np*(j-1)+2);
    end


    fop(1) = FOP; fwp(1) = FWP; fwi(1) = FWI;
    for i = 2 : Nt
        for j = 1 : Ni
            FWI = FWI + (mat(i,2)-mat(i-1,2)) * mat(i,3+np*(j-1)+2);
        end
%         disp('i = ')
%         disp(i);
%         disp('j = ')
        for j = 1 + Ni : Np + Ni
            FOP = FOP + (mat(i,2)-mat(i-1,2)) * mat(i,3+np*(j-1)+3);
            FWP = FWP + (mat(i,2)-mat(i-1,2)) * mat(i,3+np*(j-1)+2);
%             disp(3+4*(j-1)+4)            
        end
        fop(i) = FOP; fwp(i) = FWP; 
        fwi(i) = FWI;    
%         disp(FWP)
    end

    NPV = ro * FOP - cwp * abs(FWP) - cwi * abs(FWI);


    NPV = NPV - (Np + Ni) * wellcost;
    npv = ro * fop - cwp * abs(fwp) - cwi * abs(fwi)- (Np + Ni) * wellcost;


    figure(1);
%     hold off
    set(gcf,'units','normalized','outerposition',[0 0 1 1]);        
    set(0,'defaultaxesfontsize',50);
    set(0,'defaulttextfontsize',50);
    hold on 

    plot(mat(:,2),fop, ':r', 'LineWidth', 2.5)
    hold on 
    plot(mat(:,2),fwp, ':m', 'LineWidth', 2.5)
    plot(mat(:,2),abs(fwi), ':b', 'LineWidth', 2.5)

    xlabel('Time (Days)'); 
    ylabel('Cum Production, m^3');
    legend('FOP','FWP','FWI','Location','NorthWest')

    fprintf('NPV for this model is $ %10.1f \n' , npv(end));
    grid on;

    s = 'FPR-FIR';
    saveas(gcf, s , 'emf')
    saveas(gcf, s, 'fig')       
    %     s4 = [s '.pdf'];
    %     saveas2(s4,500)        

    figure(2);
    hold on 
%     hold off
    set(gcf,'units','normalized','outerposition',[0 0 1 1]);        
    set(0,'defaultaxesfontsize',50);
    set(0,'defaulttextfontsize',50);
    plot(mat(:,2),npv, ':r', 'LineWidth', 3)
    grid on;
    ylabel('NPV $')
    s = 'npv';
    saveas(gcf, s , 'emf')
    saveas(gcf, s, 'fig')       

    t = mat(:,2);
