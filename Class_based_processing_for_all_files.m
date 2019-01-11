%%
clear;
counter=1;
while 1
    
    
    currentDirectory=pwd;
    directoryList = dir; subFolder = [directoryList(:).isdir]; %# returns logical vector
    folderNames = {directoryList(subFolder).name}'; folderNames(ismember(folderNames,{'.','..'})) = [];
    for folderNumber=1:size(folderNames(:),1)
        if ~exist(fullfile(currentDirectory,folderNames{folderNumber},'allResults_Resultsfig.fig'),'file')
            tstart=tic;
            fprintf('processing folder %d.\n',folderNumber);
            %[status,fileInfo]=fileattrib(folderNames{folderNumber});
            try
            obj(counter)=CHADNIS(fullfile(currentDirectory,folderNames{folderNumber}));%allResults=CHADNIS(fullfile(currentDirectory,folderNames(folderNumber)));
            catch
                continue;
            end
            toc(tstart)
        end
        
    end
    counter=counter+1;
    
    pause(10);
end
