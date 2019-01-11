directoryList = dir; subFolder = [directoryList(:).isdir]; %# returns logical vector
folderNames = {directoryList(subFolder).name}'; folderNames(ismember(folderNames,{'.','..'})) = [];
for folderNumber=1:size(folderNames(:),1)
    
    load(fullfile(folderNames{folderNumber},'allResults__ClassObj.mat'));
    disp(folderNames{folderNumber});
    
    load(fullfile(obj.foldername,obj.HSC_smooth));
    load(fullfile(obj.foldername,obj.HSC_all));
    hypercube=HSC_smooth;
    
    
    for i=1:size(position_array{1},1)
        %ROIresult(i,:)=hypercube(position_array{1}(i,2),position_array{1}(i,1),:);
        for j=1:4
            ROIEqualArea{j}(i,:)=pixel2range(obj,EqualAreaResult{j}(position_array{1}(i,2),position_array{1}(i,1),:));
        end
    end
    for i=1:size(position_array{2},1)
        %ROIresult(i,:)=hypercube(position_array{1}(i,2),position_array{1}(i,1),:);
        for j=1:4
            ROIEqualArea{j+4}(i,:)=pixel2range(obj,EqualAreaResult{j}(position_array{2}(i,2),position_array{2}(i,1),:));
        end
    end
    for i=1:size(position_array{3},1)
        %ROIresult(i,:)=hypercube(position_array{1}(i,2),position_array{1}(i,1),:);
        for j=1:4
            ROIEqualArea{j+8}(i,:)=pixel2range(obj,EqualAreaResult{j}(position_array{3}(i,2),position_array{3}(i,1),:));
        end
    end
    
    
    
    
    
    
    %ROIresult=mean(ROIresult,1);
    %figure;plot(ROIresult);
    for j=1:12
        ROIEqualArea{j}(:,2)=ROIEqualArea{j}(:,3)-ROIEqualArea{j}(:,2);
        ROIEqualAreaMean{j}=mean(ROIEqualArea{j},1);
        ROIEqualAreaStd{j}=std(ROIEqualArea{j},0,1);
        switch j
            case {2,4,6,11}
                fprintf('%6.1f %6.1f %6.1f %6.1f \n',ROIEqualAreaMean{j}(1),ROIEqualAreaStd{j}(1),ROIEqualAreaMean{j}(2),ROIEqualAreaStd{j}(2));
        end
    end
end