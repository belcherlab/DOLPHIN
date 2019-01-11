%%
clear;
GridSize=[100 100];
CutOffHeight=0;
[FileName,PathName] = uigetfile('*.*','Select the 3D xyz file and image for texture map','MultiSelect','on');
cd(PathName);
for i=1:size(FileName(:),1)
    temp=FileName{i};
    if strcmpi(temp(end-3:end),'.jpg')
        texturefile=temp;
    end
    if strcmpi(temp(end-3:end),'.xyz')
        xyzfile=temp;
    end
end

pointcloud=dlmread(xyzfile);%pointcloud=pointcloud(:,[3 1 2]);
textureimage=imread(texturefile);

figurehandle=figure;
% ax1=subplot(1,2,1);hscatter=scatter3(pointcloud(:,1),pointcloud(:,2),pointcloud(:,3));daspect([1 1 1]);
% axis(ax1,'tight');
% hscatter.CData=hscatter.ZData;colormap jet(256);%hscatter.SizeData=18;
% view(ax1,-33,36);ax1.Color=[1 1 1].*0.9;ax1.GridLineStyle='-.';
% ax1.XLabel.String='x (sample length)';ax1.YLabel.String='y (sample width)';ax1.ZLabel.String='z (sample height)';
% ax1.TickLength=[0.01 0.01];
% ax1.Box='on';ax1.BoxStyle='full';

xyzmin=min(pointcloud);xyzmax=max(pointcloud);
Xaxis=linspace(xyzmin(1),xyzmax(1),GridSize(1));
Yaxis=linspace(xyzmin(2),xyzmax(2),GridSize(2));

[Xgrid,Ygrid]=meshgrid(Xaxis,Yaxis);
topsurface=NaN(size(Xgrid));

for i=1:size(pointcloud,1)
    xindex=floor((pointcloud(i,1)-Xaxis(1))/(Xaxis(2)-Xaxis(1)))+1;
    yindex=floor((pointcloud(i,2)-Yaxis(1))/(Yaxis(2)-Yaxis(1)))+1;
    if isnan(topsurface(yindex,xindex))
        topsurface(yindex,xindex)=pointcloud(i,3);
    else
        topsurface(yindex,xindex)=max([topsurface(yindex,xindex) pointcloud(i,3)]);
    end
end

nanindex=isnan(topsurface);
nanindex=nanindex; %| (topsurface<=CutOffHeight);
newX=Xgrid(~nanindex);
newY=Ygrid(~nanindex);
new_topsurface=topsurface(~nanindex);

F=scatteredInterpolant(newX,newY,new_topsurface,'linear','none');
interp_topsurface=F(Xgrid,Ygrid);
interp_topsurface=interp_topsurface-xyzmax(3);

ax2=subplot(1,2,2);
hsurf=surf(Xgrid,Ygrid,interp_topsurface,flip(textureimage,1));
hsurf.LineStyle='none';hsurf.CDataMapping='scaled';hsurf.FaceColor='texturemap';hsurf.FaceLighting='gouraud';
daspect([1 1 1]);axis tight;camlight left;view(ax2,-33,36);%ax2.YDir='reverse';
ax2.Color=[1 1 1].*0.9;ax2.GridLineStyle='-.';
ax2.XLabel.String='x (sample length)';ax2.YLabel.String='y (sample width)';ax2.ZLabel.String='z (sample height)';
ax2.TickLength=[0.01 0.01];
ax2.Box='on';ax2.BoxStyle='full';

