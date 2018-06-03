% Plotting random well controls for a BHP contol problem.
% The BHP range for producers is between 68.95 and 310.26 MPascal  and for injectors is between 482.64 and 310.26 MPascal 
% Written by Mehrdad Gharib Shirangi 
% Results utilized for computations in the following paper  
% "Joint Optimization of Economic Project Life and Well Controls"
% https://doi.org/10.2118/182642-PA


% 
%x1 = [242.7*ones(5,1);196.8*ones(5,1);221.0*ones(5,1);151.0*ones(5,1);305.4*ones(5,1);269.2];
%x2 = [165.5*ones(5,1);182.4*ones(5,1);146.2*ones(5,1);165.5*ones(5,1);252.3*ones(5,1);278.9];
%x3 = [194.4*ones(5,1);283.7*ones(5,1);237.9*ones(5,1);295.8*ones(5,1);180.0*ones(5,1);170.3];

% Each control step is 90 days 
t = [90:90:2340]; 

x1 = [];
x2 = [];
x3 = [];
n = 5;
for i = 1 : 6
    prodBHP1 = 68.95 + rand(1,1)*(310.26 - 68.95);
%     injBHP = 310.26 + rand(Ni,1)*(482.64 - 310.26);
    prodBHP2 = 68.95 + rand(1,1)*(310.26 - 68.95);
    prodBHP3 = 68.95 + rand(1,1)*(310.26 - 68.95);    
    
    if i == 6
        n= 1;
    end
    x1 = [x1;prodBHP1*ones(n,1)];
    x2 = [x2;prodBHP2*ones(n,1)];
    x3 = [x3;prodBHP3*ones(n,1)];    
end


figure
stairs([0;t'],[x1;x1(end)],'LineWidth',2)
hold on
stairs([0;t'],[x2;x2(end)],'r.-','LineWidth',2)
hold on
stairs([0;t'],[x3;x3(end)],'c:','LineWidth',2)

ylim([68.95 310.26])
xlim([0 2340])

xlabel('time (days)')
ylabel('BHP (psi)')
s = 'initGuess_randCtrls';
s1 = [s '.fig'];   s2 = [s '.emf'];    s3 = [s '.pdf'];
saveas2(s1); saveas2(s2); saveas2(s3);
