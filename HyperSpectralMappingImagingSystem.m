clear;
wavelength=linspace(690,1040,36);
HSMC=zeros(100,200,260,36,'single');

imageResizeFactor=1;

for i=1:36
    folder=dir(['*',num2str(wavelength(i)),'nm*']);
    clear obj;
    load([folder.name '\allResults__ClassObj.mat']);
    load(fullfile(obj.foldername,obj.HSC));
    HSMC(:,:,:,i)=HSC;
    
end

HSMC=reshape(imresize(permute(imresize(HSMC,[100/imageResizeFactor,200/imageResizeFactor]),[4,3,2,1]),[36,65]),36,65,1,[]);
globalmin=min(HSMC(:));globalmax=max(HSMC(:));

figure;montage(flip(HSMC,1),'size',[100/imageResizeFactor,200/imageResizeFactor]);daspect([65,36,1]);caxis([globalmin,globalmax]);colormap jet(256);colorbar;
%savefig(gcf,'HyperSpectralMapping.fig');
