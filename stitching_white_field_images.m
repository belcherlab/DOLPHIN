%%
clear;clc;
fighandle=figure;
axeshandle=axes;
[FileName,PathName] = uigetfile('*.*','Select the fixed white field data','MultiSelect','off');
cd(PathName);
fixedImage=imread(FileName);
while 1
    [FileName,PathName] = uigetfile('*.*','Select the moving white field data','MultiSelect','off');
    if PathName==0
        break
    end
    cd(PathName);
    movingImage=imread(FileName);
    [movingPoints,fixedPoints]=cpselect(mat2gray(movingImage),imadjust(mat2gray(fixedImage)),'Wait',true);
    
    tform = fitgeotrans(movingPoints,fixedPoints,'similarity');
    [registered2, Rregistered] = imwarp(movingImage, tform,'FillValues', 0);
    
    %figure;imshow(registered2);
    fixedImage=imfuse(fixedImage,imref2d(size(fixedImage)),registered2,Rregistered,'blend');
    imshow(fixedImage,'Parent',axeshandle);
end
imwrite(fixedImage,['Stitched_white_field_' '.tif']);


%%
PseudoCenterCoordinates=[928 1006];  %Defined by the overlap between laser and visible camera

%Select four conners with the order of 11, 13, 31, 33
for i=1:4
    [FileName,PathName] = uigetfile('*.*','Select the white field image for one corner','MultiSelect','off');
    cd(PathName);
    movingImage=imread(FileName);
    [movingPoints,fixedPoints]=cpselect(mat2gray(movingImage),imadjust(mat2gray(fixedImage)),'Wait',true);
    
    TFORM{i} = cp2tform(movingPoints,fixedPoints,'similarity');
    
    %tform = fitgeotrans(movingPoints,fixedPoints,'similarity');
    
    [CornerX(i),CornerY(i)]=tformfwd(TFORM{i},PseudoCenterCoordinates(1),PseudoCenterCoordinates(2));
    fixedImage(round(CornerY(i)),round(CornerX(i)))=255;
    %[registered2, Rregistered] = imwarp(movingImage, tform,'FillValues', 0);
    
    %figure;imshow(registered2);
    %fixedImage=imfuse(fixedImage,imref2d(size(fixedImage)),registered2,Rregistered,'blend');
    %imshow(fixedImage,'Parent',axeshandle);
end
imwrite(fixedImage,['Stitched_white_field_labeled' '.tif']);


%exampleImage is the reconstructed fluorescent image that needs to be
%overlayed on the stitched white field image
exampleImage=; 
%exampleImage=ones(100,200);exampleImage(21:40,1:100)=0;

u=[1 1 1 size(exampleImage,1) size(exampleImage,1)]';
v=[1 0.2+0.8*size(exampleImage,2) size(exampleImage,2) 1 size(exampleImage,2)]';
x=[CornerX(1) 0.2*CornerX(1)+0.8*CornerX(2) CornerX(2) CornerX(3) CornerX(4)]';
y=[CornerY(1) 0.2*CornerY(1)+0.8*CornerY(2) CornerY(2) CornerY(3) CornerY(4)]';
tform_overlay=fitgeotrans([x y],[v u],'nonreflectivesimilarity');
[fixedImage_overlay,RfixedImage_overlay]=imwarp(fixedImage,tform_overlay,'FillValues',0);

figure; imshowpair(fixedImage_overlay,RfixedImage_overlay,exampleImage,imref2d(size(exampleImage)),'blend')

% tform_overlay=cp2tform([x y],[u v],'similarity');
% [fixedImage_overlay,fixed_xdata,fixed_ydata]=imtransform(fixedImage,tform_overlay,'FillValues',0);
% figure;imshow(fixedImage_overlay,'XData',fixed_xdata,'YData',fixed_ydata);
% 
% %[row, col]=find(imread('Stitched_white_field_labeled.tif')-imread('Stitched_white_field_.tif'));
% hold on;
% subhandle=imagesc(exampleImage);  %mat2gray(exampleImage_overlay).*255
% hold off;
% alpha=exampleImage;
% set(subhandle, 'AlphaData', alpha);
% F=getframe;