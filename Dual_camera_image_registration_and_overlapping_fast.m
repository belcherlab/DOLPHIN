%%
clear;
load('D:\xiangnan on nir-acquire\WinView\20150123\tform.mat');
[FileName,PathName] = uigetfile('*.*','Select the visible white field and NIR fluorescence data pairs','MultiSelect','on');
cd(PathName);

for ii=1:2:size(FileName,2)
    
    for i=0:1
        temp=FileName{ii+i};
        if strcmpi(temp(end-3:end),'.tif')
            movingFileName=temp;
        end
        if strcmpi(temp(end-3:end),'.SPE')
            fluoFileName=temp;
        end
    end
    movingImage=imread(movingFileName);
    
    movingImage_registered = imwarp(movingImage,tform,'OutputView',imref2d([256 320]));
    imwrite(mat2gray(movingImage_registered),['Registered_' movingFileName]);
    
    
    readerobj=SpeReader(fluoFileName);
    allframes=read(readerobj);
    %plotframenumber=floor((1+size(allframes,4))/2);
    %fluofixedImage=squeeze(allframes(:,:,1,plotframenumber));
    
    fluofixedImage=squeeze(sum(allframes(:,:,1,:),4))/size(allframes,4);
    save(['Registered_' fluoFileName(1:end-4) '.MAT'],'fluofixedImage');
    grayfluofixedImage=mat2gray(fluofixedImage);
    imwrite(grayfluofixedImage,['Registered_' fluoFileName(1:end-4) '_BW.tif']);
    %figure;imshow(grayfluofixedImage,[0.125 1],'colormap',jet);
    imwrite(gray2ind(grayfluofixedImage,256),jet(256),['Registered_' fluoFileName(1:end-4) '_RGB.tif']);
    %grayfluofixedImage(find(grayfluofixedImage<=0.1))=0;
    %imwrite(grayfluofixedImage,['Registered_' fluoFileName(1:end-4) '_BW2.tif']);
    %imwrite(gray2ind(grayfluofixedImage,256),jet(256),['Registered_' fluoFileName(1:end-4) '_RGB2.tif']);
    
    % to further process and overlay the images, use the following two
    % functions
    %imcrop;getframe;
    
    alpha=grayfluofixedImage;
    background=grayfluofixedImage([1:50, 207:256],:,:);
    alphathreshhold=mean(background(:))+3*std(background(:))
    alpha(find(alpha>=alphathreshhold))=1;
    alpha(find(alpha<alphathreshhold))=0;
    
    ahegrayfluofixedImage=adapthisteq(grayfluofixedImage,'NumTiles',[8 8],...
        'Distribution','exponential','ClipLimit',0.02,'NBins',256,'Range','full','Alpha',0.4);
    
    figure;imshow(ahegrayfluofixedImage);
    
    figure;
    imshow(mat2gray(movingImage_registered).*1);
    hold on;
    imagehandle=imshow(ahegrayfluofixedImage);
    hold off;
    set(imagehandle, 'AlphaData', alpha);
    F=getframe;
    imwrite(F.cdata(51:206,1:320,:),['Registered_' fluoFileName(1:end-4) '_overlay_BW.tif']);
    
    indfluofixedImage=gray2ind(ahegrayfluofixedImage,256);
    rgbfluofixedImage=ind2rgb(indfluofixedImage,hot(256));
    figure;
    imshow(mat2gray(movingImage_registered).*1);
    hold on;
    imagehandle=imshow(rgbfluofixedImage);
    hold off;
    set(imagehandle, 'AlphaData', alpha);
    F=getframe;
    imwrite(F.cdata(51:206,1:320,:),['Registered_' fluoFileName(1:end-4) '_overlay_HOT.tif']);
    
end