%%
clear;

[FileName,PathName] = uigetfile('*.*','Select the movie files','MultiSelect','on');
cd(PathName);

readerobj=SpeReader(FileName);
allframes=read(readerobj);


clims=[min(allframes(:)) max(allframes(:))];
aheallframes=zeros(size(allframes,1),size(allframes,2),size(allframes,4));
writerObj = VideoWriter('movie_uncompressed.avi','uncompressed AVI');
writerObj.FrameRate=30;

open(writerObj);
figurehandle=figure;

for i=1:1:size(allframes,4)
    
    %imagesc(squeeze(allframes(61:196,:,1,i)),clims);
    currentframe=double(squeeze(allframes(:,:,1,i)));
    ahecurrentframe=adapthisteq(mat2gray(currentframe),'NumTiles',[8 8],...
        'Distribution','exponential','ClipLimit',0.02,'NBins',256,'Range','full','Alpha',0.4);
    aheallframes(:,:,i)=ahecurrentframe;
    imagesc(ahecurrentframe(61:196,:));
    colormap 'hot';
    axis off;
    daspect([1 1 1]);
    frame=getframe;
    writeVideo(writerObj,frame);
end

close(writerObj);
%%
map1='jet';
map2=zeros(256,3);for i=1:256 map2(i,1)=i-1; end; map2=map2/255;
map3=zeros(256,3);for i=1:256 map3(i,2)=i-1; end; map3=map3/255;
map4=zeros(256,3);for i=1:256 map4(i,3)=i-1; end; map4=map4/255;


CUTFRAMES=40;
aheallframes2=aheallframes(61:196,61:260,CUTFRAMES+1:CUTFRAMES+120);
[coeff,score,latent,tsquared,explained,mu] = pca(reshape(aheallframes2,[],size(aheallframes2,3)));
figurehandle=figure;
subplot(4,3,1);plot(coeff(:,1:4));axis tight;pbaspect([1,1,1]);
subplot(4,3,4);plot(explained(1:4));axis tight;pbaspect([1,1,1]);
subplot(4,3,7);plot(mu);axis tight;pbaspect([1,1,1]);
subplot(4,3,10);axis off;
ax1=subplot(4,3,2);imagesc(reshape(abs(score(:,1))+score(:,1),size(aheallframes2,1),[]));colormap(ax1,map1);daspect([1 1 1]);axis off;
ax2=subplot(4,3,3);imagesc(reshape(abs(score(:,1))-score(:,1),size(aheallframes2,1),[]));colormap(ax2,map1);daspect([1 1 1]);axis off;
ax3=subplot(4,3,5);imagesc(reshape(abs(score(:,2))+score(:,2),size(aheallframes2,1),[]));colormap(ax3,map2);daspect([1 1 1]);axis off;
ax4=subplot(4,3,6);imagesc(reshape(abs(score(:,2))-score(:,2),size(aheallframes2,1),[]));colormap(ax4,map2);daspect([1 1 1]);axis off;
ax5=subplot(4,3,8);imagesc(reshape(abs(score(:,3))+score(:,3),size(aheallframes2,1),[]));colormap(ax5,map3);daspect([1 1 1]);axis off;
ax6=subplot(4,3,9);imagesc(reshape(abs(score(:,3))-score(:,3),size(aheallframes2,1),[]));colormap(ax6,map3);daspect([1 1 1]);axis off;
ax7=subplot(4,3,11);imagesc(reshape(abs(score(:,4))+score(:,4),size(aheallframes2,1),[]));colormap(ax7,map4);daspect([1 1 1]);axis off;
ax8=subplot(4,3,12);imagesc(reshape(abs(score(:,4))-score(:,4),size(aheallframes2,1),[]));colormap(ax8,map4);daspect([1 1 1]);axis off;
tightfig;
savefig(figurehandle, [FileName(1:end-4) '_video_PCA' '.fig']);