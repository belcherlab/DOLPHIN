clear;
%Miji;
threshold=0.1;

emissionfiles=dir('*emission*.spe');
whitefiles=dir('*white*.spe');
if numel(emissionfiles)~=numel(whitefiles)
    warning('numbre of emission files is NOT equal to number of white files.');
end

for i=1:numel(emissionfiles)
    emissionimage=read(SpeReader(emissionfiles(i).name));
    whiteimage=read(SpeReader(whitefiles(i).name));
    
    emissionimage=squeeze(sum(emissionimage,4))./size(emissionimage,4);
    whiteimage=squeeze(sum(whiteimage,4))./size(whiteimage,4);
    
    
    result(i)=mean(emissionimage(emissionimage>(mean(emissionimage(:))+1*std(emissionimage(:)))));
    resultsum(i)=sum(emissionimage(emissionimage>(mean(emissionimage(:))+1*std(emissionimage(:)))));
    resultnumel(i)=numel(emissionimage(emissionimage>(mean(emissionimage(:))+1*std(emissionimage(:)))));

    %whiteimage=imtophat(whiteimage,strel('disk',30));
    
    emissionimage=mat2gray(medfilt2(emissionimage,[3,3]));
    whiteimage=mat2gray(medfilt2(whiteimage,[3,3]));
    
    MIJ.createImage('temp',whiteimage,true);
    MIJ.run('Subtract Background...', 'rolling=20 light');
    whiteimage=MIJ.getCurrentImage;
    MIJ.run('Close All')
    whiteimage=imadjust(mat2gray(whiteimage),stretchlim(mat2gray(whiteimage),0.001));
    emissionimage=imadjust(mat2gray(emissionimage),stretchlim(mat2gray(emissionimage),0.001));
    
    emissionimage(emissionimage<threshold)=0;
    
    indwhiteimage=repmat(whiteimage,1,1,3);
    indemissionimage=zeros(size(indwhiteimage));indemissionimage(:,:,2)=emissionimage;
    
%     emissionimage_thresh=emissionimage;
%     emissionimage_thresh(emissionimage_thresh<threshold)=0;
%     emissionimage_thresh(emissionimage_thresh>=threshold)=1;
%     whiteimage_thresh=whiteimage;
%     %whiteimage_thresh(emissionimage_thresh>=threshold)=0;
%     
%     %indcompositeimage=bsxfun(@max,indwhiteimage,indemissionimage);
%     
%     indcompositeimage(:,:,1)=whiteimage_thresh;
%     indcompositeimage(:,:,2)=bsxfun(@max,whiteimage_thresh,emissionimage_thresh);
%     indcompositeimage(:,:,3)=whiteimage_thresh;
    
    
    finaloutputimage=cat(2,indwhiteimage,indemissionimage,mat2gray(imfuse(indwhiteimage,indemissionimage,'blend')));
    
    imwrite(finaloutputimage,[emissionfiles(i).name(1:end-4),'finaloutput.tif']);
    
end
