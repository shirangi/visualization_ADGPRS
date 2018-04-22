function plotSwMaps(Nx,Ny,Nz, ninj,nprod,injLocs,prodLocs,Sw,Sor,Swi,tvec,tvecWell,NwDrill,option)
% M-file to plot saturations at different times
% function: plotSwMaps(Nx,Ny,Nz, ninj,nprod,injLocs,prodLocs,Sw,Sor,Swi,tvec,tvecWell,NwDrill)
% Inputs:
%       Nx, Ny, Nz:         Reservoir dimensions 
%       ninj,nprod:         Number of producers and injectors
%       injLocs,prodLocs:   Injector and producer well locations 
%       Sw:                 Contains water saturation maps at all time steps 
%       Sor,Swi:            Residual oil saturation, and initial water saturation
%       NwDrill:            Number of wells which are drilled at each control step 
%       option:             can take the following values:
%                   'all'--> plot saturation maps at all time steps 
%                   'end'--> plot saturation map only at the final time-step
% 
% Written by Mehrdad Gharib Shirangi, mehr@stanford.edu, 08-03-2013
% Modified on Aug 14 2013
% Last Modified on Aug 31-2016


ntstep = size(Sw,2);
nwells = NwDrill ;
nw = length(tvecWell);
switch lower(option)
    case {'all'}
        t1 = 1;
        tend = ntstep;
    case {'end'}
        t1 = ntstep - 1;
        tend = ntstep; 
    otherwise
            error('unknown value for option')
end
for j = t1:tend
    if max(tvec(j) == tvecWell ) == 1
        nwells =nwells +NwDrill ;
    end
    figure
%     imagesc(So(:,:,1,j)')
    for k = 1 : Nz
        imagesc(reshape(Sw(1+(k-1)*Nx*Ny:k*Nx*Ny,j),Nx,Ny)')
        colorbar
        axis square
        caxis([Sor 1-Swi])

        hold on 
    % Injection wells
        for i = 1:ninj
            if injLocs(i,3) <= k && injLocs(i,4) >= k || injLocs(i,3) >= k && injLocs(i,4) <= k             
                plot(injLocs(i,1),injLocs(i,2),'o','MarkerSize',20,'MarkerFaceColor','b',...
                    'MarkerEdgeColor','w','LineWidth',2)
                text(injLocs(i,1),injLocs(i,2),int2str(injLocs(i,6)),...
                    'FontSize',15,'FontWeight','bold','color','w',...
                    'HorizontalAlignment','center')
            end            
%             if nwells >= injLocs(i,4)
%             end
        end
        % Production wells
        for i = 1:nprod
           if prodLocs(i,4) == k 
                plot(prodLocs(i,1),prodLocs(i,2),'o','MarkerSize',20,'MarkerFaceColor','r',...
             'MarkerEdgeColor','w','LineWidth',2)
    %             -------
                xline = [prodLocs(i,1)  prodLocs(i,1)];
                yline = [prodLocs(i,2)  prodLocs(i,3)];            
                plot(xline,yline,'-w','LineWidth',2.5)            
    %             -------
                text(prodLocs(i,1),prodLocs(i,2),int2str(prodLocs(i,6)),...
                    'FontSize',15,'FontWeight','bold','color','w',...
                    'HorizontalAlignment','center')

           end                
%             if nwells >= prodLocs(i,4)
%                 plot(prodLocs(i,1),prodLocs(i,2),'o','MarkerSize',20,'MarkerFaceColor','r',...
%                     'MarkerEdgeColor','w','LineWidth',2)
%                 text(prodLocs(i,1),prodLocs(i,2),int2str(prodLocs(i,3)),...
%                     'FontSize',15,'FontWeight','bold','color','w',...
%                     'HorizontalAlignment','center')
%             end
        end
%     title(['t = ' num2str(tvec(j))]);
        title([ 'Layer ' num2str(k) ', ' num2str(tvec(j)) ' Days']);
        hold off

        s = ['sw-' num2str(round(tvec(j))) '_' num2str(k)];
%     s1 = [s '.fig'];   s2 = [s '.emf'];    s3 = [s '.pdf'];
%     saveas2(s3);
        if j > 3
            if tvec(j) - tvec(j-1) > 10 || round(tvec(j)) == tvec(j)
                saveas(gcf, s , 'emf')
                saveas(gcf, s, 'fig')           
                saveas2([s '.pdf'])           
            end
        else
            saveas(gcf, s , 'emf')
            saveas(gcf, s, 'fig')           
             saveas2([s '.pdf'])                   
        end
    end
end

