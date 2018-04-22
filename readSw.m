function [sw,tvec2] = readSw(fileName,Tend, Nx, Ny,Nz, tvec)

% readSw reads the adgprs output file .sim.timesteps.vars.txt file and 
% plots the sw map at some given time steps and saves them in fig and emf
% formats. 
%   readSw(filename,Tend, Nx, Ny, tvec)
% Inputs:
%   filename: input file name (string)
%   Tend: end time of simulation ( last time that the simulation state
%         variables are saved in the file) 
%   Nx, Ny: dimension of the reservoir 
%   tvec: vector of time steps that the saturation map should be plotted 
% Note: Tend must be the last entry of tvec
% Outputs:
%   X: a 2 dimensional matrix that contains the saturations at tvec 
% Example:
%   tvec = [210,420,630,840,1050,1260,1470,1680,3000];
%   Tend = 3000;
%   %fileName = 'OUTPUT1.sim.timesteps.vars.txt';
%   fileName = 'D:\Academic\Research\sequential well placement\CLFD\60 by 60\failed_job.1.1\simForOptFiles\OUTPUT1.sim.timesteps.vars.txt'
%   Nx = 60; Ny = 60; 
%   sw = readSw(fileName,Tend, Nx, Ny, tvec)
% -------------------------
% Written by Mehrdad Gharib Shirangi
% July 13 2013


tvec2 = [];
fid = fopen(fileName, 'r');
% format = '%s %s %f'; 
Nsteps = length(tvec);
% sw = zeros(Nx*Ny*Nz,Nsteps);
sw = [];
counter = 0;
format = '%f ';
for i = 1 : 13
    format = [format '%f '];
end 
disp(fileName);
while 1
    tline = fgetl(fid);
    if tline == -1
        break
    end
    [time count ]  = sscanf(tline(7:end),'%f');    
    disp(time)
%     if (time == tvec(counter+1)) 
        counter = counter+1;
        %skip the next line (title line)
        tline = fgetl(fid);
        sat = zeros(Nx*Ny*Nz,1);
%         for k = 1 : Nz
            for i = 1 : Nz*Nx*Ny
                tline = fgetl(fid);            
                [A count] = sscanf(tline,format);
                %p             T          S1          S2          S3          Z1          Z2          Z3         X11         X21         X31         X12         X22         X32         X13         X23         X33
                sat(i) = A(5); % oil saturation 
            end
%         end
%         sw(:,counter) =  sat;
        sw =  [sw, sat];
        tvec2 = [tvec2; time];
%     else
%         % the states at this time step are not required 
%         tline = fgetl(fid);                
%         for i = 1 : Nx*Ny
%             fgetl(fid);                    
%         end
%     end
    if (time == Tend), break, end    
    tline = fgetl(fid);      % skip the empty line before each time step              
end

fclose(fid);

close all
figure(1)
% set(gcf,'units','normalized','outerposition',[0 0 1 1]);        
set(0,'defaultaxesfontsize',20);
set(0,'defaulttextfontsize',20);

% for counter = 1 : Nsteps 
%     swmap = reshape(sw(:,counter),60,60)';
%     imagesc(swmap);
%     colorbar;
%     s = sprintf('sw%d',tvec(counter));
%     saveas(gcf, s , 'emf')
%     saveas(gcf, s, 'fig')       
%     s4 = [s '.pdf'];
% %     saveas2(s4,500)        
% end
% 
% 
