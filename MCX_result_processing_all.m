%%
NumOfCalculation=floor(sqrt(250*250+250*250))+1;
for i=1:NumOfCalculation
distance{i}={};
end
for ii=1:500
    for jj=1:500
        disttemp=floor(sqrt((ii-250)^2+(jj-250)^2))+1;
        celltemp=distance{disttemp};
        distance{disttemp}=[celltemp,[ii,jj]];
    end
end
counter=0;
d = dir; isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}'; nameFolds(ismember(nameFolds,{'.','..'})) = [];
for iii=1:size(nameFolds)
    tempfile=fullfile(nameFolds(iii), '\*.MAT'); filelist=dir(tempfile{1});
    for jjj=1:size(filelist)
        tempfile2=fullfile(nameFolds(iii),filelist(jjj).name); tempfile3=tempfile2{1};
        load(tempfile3);
        figurehandle=figure;
        subplot('Position',[0.15 0.2 0.35 0.35]);
        imagesc(log10(abs(double(temp.fcw(:,:,100)))));colormap 'jet';colorbar;axis equal;axis tight;
        subplot('Position', [0.15 0.05 0.35 0.07]);
        imagesc(log10(abs(double(rot90(squeeze(temp.fcw(250,:,:)))))));colormap 'jet';colorbar;axis equal;axis tight;
        
        plottemp=zeros(NumOfCalculation,1);
        for kk=1:NumOfCalculation
            for ll=1:size(distance{kk},2)
                plottemp(kk,1)=plottemp(kk,1)+temp.fcw(distance{kk}{ll}(1,1),distance{kk}{ll}(1,2),100);
            end
            plottemp(kk,1)=plottemp(kk,1)/ll;
        end
        
        subplot('Position',[0.15 0.6 0.35 0.35]);
        plot((abs(double(plottemp))));axis tight;pbaspect([1,1,1]);
        
        savefig(figurehandle, [tempfile3(1:end-4) '_MCX_all' '.fig']);
        close(figurehandle);
        counter=counter+1
    end
end
counter