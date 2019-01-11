directoryList = dir; subFolder = [directoryList(:).isdir]; %# returns logical vector
folderNames = {directoryList(subFolder).name}'; folderNames(ismember(folderNames,{'.','..'})) = [];
for folderNumber=1:size(folderNames(:),1)
    
    load(fullfile(folderNames{folderNumber},'allResults__ClassObj.mat'));
    disp(folderNames{folderNumber});
    
    load(fullfile(obj.foldername,obj.HDC_smooth));
    load(fullfile(obj.foldername,obj.HDC_all));
    hypercube=HDC_smooth;
    
    
    for i=1:size(position_array{1},1)
        %ROIresult(i,:)=hypercube(position_array{1}(i,2),position_array{1}(i,1),:);
            ROIEqualArea{1}(i,1)=pixel2range(obj,EqualAreaResult(position_array{1}(i,2),position_array{1}(i,1)));
    end
    for i=1:size(position_array{2},1)
        %ROIresult(i,:)=hypercube(position_array{1}(i,2),position_array{1}(i,1),:);
            ROIEqualArea{2}(i,1)=pixel2range(obj,EqualAreaResult(position_array{2}(i,2),position_array{2}(i,1)));
    end
    for i=1:size(position_array{3},1)
        %ROIresult(i,:)=hypercube(position_array{1}(i,2),position_array{1}(i,1),:);
            ROIEqualArea{3}(i,1)=pixel2range(obj,EqualAreaResult(position_array{3}(i,2),position_array{3}(i,1)));
    end
    
    
    
    
    
    
    %ROIresult=mean(ROIresult,1);
    %figure;plot(ROIresult);
    for j=1:3
        ROIEqualAreaMean{j}=mean(ROIEqualArea{j},1);
        ROIEqualAreaStd{j}=std(ROIEqualArea{j},0,1);
                fprintf('%6.1f %6.1f \n',ROIEqualAreaMean{j},ROIEqualAreaStd{j});
    end
end