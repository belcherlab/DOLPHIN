classdef FastHSI < handle
    %FastHSI Summary of this class goes here
    %   Detailed explanation goes here
    properties
        laser_power=1; %in ampere
        integ_time=0.1; %in second
        scan_size=[25,100]; %[width length] in millimeter
        grid_size=[1,400]; %var1 is the line grid number, var2 is the reframe grid number
        excitation_range=690:5:940;
        wavelength_range=linspace(850,1650,230); %linspace(850,1750,260) for HSC
        detector_size=[256,320];
        detector_ROI=[31,225,1,230]; %calculation for wavelength average
    end
    properties
        foldername %
        filename='allResults__ClassObj.mat'; %
        infofile %info text file for the above properties
        background_filename
        raw_filename %1...100
        readerobj %1...100
        allframes %flip corrected  I(a,b,1,x,y) FILENAME:'allResults_allframes.mat'
    end
    properties
        HSC %Hyperspectral_cube %I(x,y,lambda)
        HSC_smooth %Hyperspectral_cube_smooth
        HSC_all %all properties analyzed
    end
    properties
        Montagefig
        Montageeps
        Resultsfig
        Resultseps
    end
    methods
        function obj=FastHSI(foldername)
            obj.foldername=foldername;
            obj.infoParsing;
            obj.fileProcessing;
            %obj.dataSmoothing;
            obj.dataAnalysis;
            obj.plotAll;
            obj.saveClassObj;
        end
        function saveClassObj(obj)
            save(fullfile(obj.foldername,'allResults__ClassObj.mat'),'obj');
        end
        function infoParsing(obj)
            disp('parsing experiment info...');
            obj.infofile='allResults__infofile.txt';
            infolist={'laser_power','integ_time','scan_size','grid_size','excitation_range','wavelength_range','detector_size','detector_ROI'};
            if ~exist(fullfile(obj.foldername,obj.infofile),'file')
                warning('infofile does not exist, using default values.');
            else
                fid=fopen(fullfile(obj.foldername,obj.infofile),'r');
                if fid~=-1
                    filestring=textscan(fid,'%s=%s');
                    filestruct=cell2struct(filestring{2},filestring{1},1);
                    for i=1:size(infolist(:),1)
                        if isfield(filestruct,infolist{i}) && ~isempty(filestruct.(infolist{i}))
                            if ischar(obj.(infolist{i}))
                                obj.(infolist{i})=filestruct.(infolist{i});
                            else
                                obj.(infolist{i})=str2num(filestruct.(infolist{i}));   %str2num uses 'eval' function, which can process vector and expressions
                            end
                        end
                    end
                end
                fclose(fid);
            end
            obj.validate;
            fid=fopen(fullfile(obj.foldername,obj.infofile),'w');
            if fid~=-1
                for i=1:size(infolist(:),1)
                    if ischar(obj.(infolist{i}))
                        fprintf(fid,[infolist{i} ' = ' obj.(infolist{i}) '\r\n']);
                    else
                        fprintf(fid,[infolist{i} ' = ' strrep(mat2str(obj.(infolist{i})),' ',',') '\r\n']);
                    end
                end
            end
            fclose(fid);
            obj.saveClassObj;
        end
        function validate(obj)
            disp('validating experiment info...');
            if ~isnumeric(obj.laser_power)
                obj.laser_power=1;warning('laser_power is not numeric. using default value: %d.',obj.laser_power);
            end
            if ~isnumeric(obj.integ_time)
                obj.integ_time=0.1;warning('integ_time is not numeric. using default value: %d.',obj.integ_time);
            end
            if ~ismatrix(obj.scan_size) || size(obj.scan_size(:),1)~=2
                obj.scan_size=[25,400];warning('scan_size does not have valid value. using default value: s%.',mat2str(obj.scan_size));
            end
            if ~ismatrix(obj.grid_size) || size(obj.grid_size(:),1)~=2
                obj.grid_size=[1,400];warning('grid_size does not have valid value. using default value: s%.',mat2str(obj.grid_size));
            end
            if ~ismatrix(obj.excitation_range) || size(size(obj.excitation_range),2)~=2
                obj.excitation_range=690:5:940;warning('excitation_range does not have valid value. using default value: s%.',mat2str(obj.excitation_range));
            end
            if ~ismatrix(obj.wavelength_range) || size(size(obj.wavelength_range),2)~=2
                obj.wavelength_range=linspace(850,1650,230);warning('wavelength_range does not have valid value. using default value: s%.',mat2str(obj.wavelength_range));
            end
            if ~ismatrix(obj.detector_size) || size(obj.detector_size(:),1)~=2
                obj.detector_size=[256,320];warning('detector_size does not have valid value. using default value: s%.',mat2str(obj.detector_size));
            end
            if ~ismatrix(obj.detector_ROI) || size(obj.detector_ROI(:),1)~=4
                obj.detector_ROI=[31,225,1,260];warning('detector_ROI does not have valid value. using default value: s%.',mat2str(obj.detector_ROI));
            end
            obj.saveClassObj;
        end
        function fileProcessing(obj)
            disp('processing files...');
            obj.allframes='allResults_allframes.mat';         %initializing obj.allframes
            sizeallframes=[obj.detector_size(1),obj.detector_size(2),numel(obj.excitation_range),obj.grid_size(1),obj.grid_size(2)];
            allframes=zeros(sizeallframes,'single');
            obj.HSC='allResults_HSC.mat';                 %initializing obj.HSC
            sizeHSC=[obj.grid_size(1)*(obj.detector_ROI(2)-obj.detector_ROI(1)+1),obj.grid_size(2),numel(obj.excitation_range),numel(obj.wavelength_range)];
            HSC=zeros(sizeHSC,'single');
            
            temp=fullfile(obj.foldername,'*bcgnd*.SPE');
            dir_bcgnd=dir(temp);
            switch size(dir_bcgnd(:),1)
                case 1
                    obj.background_filename=dir_bcgnd(1).name;
                    background_frame=read(SpeReader(fullfile(obj.foldername,obj.background_filename)));
                case 0
                    obj.background_filename='';
                    background_frame=zeros(obj.detector_size(1),obj.detector_size(2));
                    warning('no background file found.');
                otherwise
                    obj.background_filename=dir_bcgnd(1).name;
                    background_frame=read(SpeReader(fullfile(obj.foldername,obj.background_filename)));
                    warning('more than one background files found. Using the first file in the file list.');
            end
            
            for i=1:numel(obj.excitation_range)
                folderList(i)=dir(fullfile(obj.foldername,['*_',num2str(obj.excitation_range(i)),'nm']));
                for j=1:numel(dir(fullfile(folderList(i).name,'SuperFastScan2*.SPE')))
                    obj.raw_filename{i,j}=dir(fullfile(folderList(i).name,['*Integ',num2str(j),'.SPE']));
                    obj.readerobj{i,j}=SpeReader(fullfile(obj.foldername,folderList(i).name,obj.raw_filename{i,j}.name));
                    
                    tempallframes=read(obj.readerobj{i,j});
                    if mod(j,2)==0
                        tempallframes=flip(tempallframes,4);
                    end
                    tempallframes=reshape(permute(interp1(1:obj.readerobj{i,j}.NumberOfFrames,permute(single(tempallframes),[4 1 2 3]),linspace(1,obj.readerobj{i,j}.NumberOfFrames,obj.grid_size(2)),'linear'),[2 3 4 1]),sizeallframes(1),sizeallframes(2),1,1,sizeallframes(5));
                    tempallframes=single(tempallframes)-repmat(single(background_frame),1,1,1,1,sizeallframes(5));
                    allframes(:,:,i,j,:)=tempallframes;
                    
                end
                if mod(i,10)==0
                    fprintf('%d excitation wavelengths processed.\n',i);
                end
            end
            
            temparray=allframes(obj.detector_ROI(1):obj.detector_ROI(2),obj.detector_ROI(3):obj.detector_ROI(4),:,:,:)-repmat(mean(allframes([1:obj.detector_ROI(1),obj.detector_ROI(2):end],obj.detector_ROI(3):obj.detector_ROI(4),:,:,:)),obj.detector_ROI(2)-obj.detector_ROI(1)+1,1,1,1,1);
            HSC=reshape(permute(temparray,[1,4,5,3,2]),sizeHSC);
            clear allframes;
            
%             savefast(fullfile(obj.foldername,obj.HSC),'HSC');
% 
%             savefast(fullfile(obj.foldername,obj.allframes),'allframes');
%             obj.saveClassObj;
%         end
%         function dataSmoothing(obj)
            disp('smoothing data...');
            %SmoothSpan=0.1;SmoothMethodValue='loess';
            SmoothSpan=5;SmoothMethodValue='sgolay';
            fprintf('smooth method is %s, smooth span is %d \n',SmoothMethodValue,SmoothSpan);
%             load(fullfile(obj.foldername,obj.HSC)); %load variable HSC
            obj.HSC_smooth='allResults_HSC_smooth.mat';
            sizeHSC=size(HSC);
            HSC=reshape(HSC,[],sizeHSC(3)*sizeHSC(4));
            SmoothMatrix=zeros(size(HSC));
            parfor i=1:size(HSC,1)
                SmoothMatrix(i,:)=smooth(squeeze(HSC(i,:)),SmoothSpan,SmoothMethodValue);
            end
            HSC_smooth=single(reshape(SmoothMatrix,sizeHSC));
            savefast(fullfile(obj.foldername,obj.HSC_smooth),'HSC_smooth');
            obj.saveClassObj;
        end
        function dataAnalysis(obj)
            disp('analyzing data...');
            load(fullfile(obj.foldername,obj.HSC_smooth)); %load variable HSC_smooth
            obj.HSC_all='allResults_HSC_all.mat';
            %[PCA_coeff,PCA_score,PCA_latent,PCA_tsquared,PCA_explained,PCA_mu] = pca(reshape(HSC_smooth(:,:,:),[],size(HSC_smooth,3)*size(HSC_smooth,4)),'NumComponents',100,'Algorithm','svd');
            [PCA_coeff,PCA_score,PCA_mu] = pcasecon(transpose(double(reshape(HSC_smooth,[],size(HSC_smooth,3)*size(HSC_smooth,4)))),100); %NOTICE: pcasecon used different definition and transpose of matrix, be CAUTIOUS when changing
            
            [~,min_index]=min(PCA_coeff);[~,max_index]=max(PCA_coeff);
            [min_subrow,min_subcol]=ind2sub([size(HSC_smooth,3),size(HSC_smooth,4)],min_index);
            [max_subrow,max_subcol]=ind2sub([size(HSC_smooth,3),size(HSC_smooth,4)],max_index);
            for i=1:100
                minPCA_HSC_smooth(:,:,i)=HSC_smooth(:,:,min_subrow(i),min_subcol(i));
                maxPCA_HSC_smooth(:,:,i)=HSC_smooth(:,:,max_subrow(i),max_subcol(i));
            end
            
            PCA_explained=var(PCA_score,0,2)/sum(var(PCA_score,0,2))*100;
            PCA_score=reshape(transpose(PCA_score),size(HSC_smooth,1),size(HSC_smooth,2),[]);
            PCA_coeff=reshape(PCA_coeff,size(HSC_smooth,3),size(HSC_smooth,4),[]);
            PCA_mu=reshape(PCA_mu,size(HSC_smooth,3),size(HSC_smooth,4));
            
            
            save(fullfile(obj.foldername,obj.HSC_all),'PCA_coeff','PCA_score','PCA_explained','PCA_mu','minPCA_HSC_smooth','maxPCA_HSC_smooth','min_subrow','min_subcol','max_subrow','max_subcol');
            obj.saveClassObj;
        end
        function plotAll(obj)
            disp('ploting results...');
            %obj.plotMontage;
            %obj.plot3D_demo;
            obj.plotResults;
        end
        function plotMontage(obj)
            load(fullfile(obj.foldername,obj.HSC_smooth));
            sizeHSC=size(HSC_smooth);
            hypercube=reshape(permute(HSC_smooth,[3,4,2,1]),sizeHSC(3),sizeHSC(4),1,[]);
            
            globalmin=min(hypercube(:));globalmax=max(hypercube(:));
            
            DisplaySize=[sizeHSC(1),sizeHSC(2)];
            
            hypercubepad=padarray(hypercube,[ceil(sizeHSC(3)*0.05),ceil(sizeHSC(4)*0.02)],NaN);
            
            
            figurehandle=figure;
            hmontage=montage(hypercubepad,'Size',DisplaySize,'DisplayRange',[]);
            hmontage.AlphaData=~isnan(hmontage.CData);

            ax=gca;ax.DataAspectRatio=[1 1 1];%ax.YLabel.String='HSC z-index';ax.YTick=[50:100:1250];ax.YTickLabel={'1-20','21-40','41-60','61-80','81-100','101-120','121-140','141-160','161-180','181-200','201-220','221-240','241-260'};
            axis(ax,'off');caxis(ax,[globalmin,globalmax]);
            colormap(ax,[jet(256);1,1,1]);hc=colorbar(ax);
            hc.Label.String='signal intensity (a.u.)';hc.Label.Rotation=270;hc.Label.VerticalAlignment='bottom';hc.Box='off';
            
            figurehandle.PaperSize=[20 10];
            figurehandle.PaperPosition=[0 0 20 10];
            obj.Montagefig='allResults_Montagefig.fig';
            obj.Montageeps='allResults_Montageeps.eps';
            %savefig(figurehandle, fullfile(obj.foldername,obj.Montagefig),'compact');
            print(figurehandle,fullfile(obj.foldername,obj.Montageeps),'-depsc','-tiff','-r300','-opengl');
            close(figurehandle);
            obj.saveClassObj;
        end
        function plot3D_demo(obj)
            switch obj.experiment_type
                case 'HSC'
                    load(fullfile(obj.foldername,obj.HSC));
                    hypercube=HSC;
                case 'HDC'
                    load(fullfile(obj.foldername,obj.HDC));
                    hypercube=HDC;
                otherwise
                    error('error determining experiment_type. %s', obj.experiment_type);
            end
            sizehypercube=size(hypercube);
            x=linspace(0,obj.scan_size(2),obj.grid_size(2));y=linspace(0,obj.scan_size(1),obj.grid_size(1));z=pixel2range(obj);
            SliceArray=z;
            [X,Y,Z]=meshgrid(x,y,z);
            figurehandle=figure;
            for j=1:3
                ax(j)=subplot(1,3,j);hslice=slice(X,Y,Z,hypercube,[],[],SliceArray);colormap(ax(j),jet(256));view(ax(j),-33,36);
                ax(j).YDir='reverse';ax(j).PlotBoxAspectRatio=[obj.scan_size(2),obj.scan_size(1),obj.scan_size(2)];axis(ax(j),'tight');
                switch j
                    case 1
                        for i=1:size(hslice(:),1)
                            hslice(i).LineStyle='none';hslice(i).FaceColor='interp';hslice(i).FaceAlpha=1;
                            hslice(i).CDataMapping='scaled';%hslice1(i).AlphaData=hslice1(i).CData;hslice1(i).AlphaDataMapping='scaled';
                        end
                    case 2
                        for i=1:size(hslice(:),1)
                            hslice(i).LineStyle='none';hslice(i).FaceColor='interp';hslice(i).FaceAlpha=0;
                            hslice(i).CDataMapping='scaled';%hslice2(i).AlphaData=hslice2(i).CData;hslice2(i).AlphaDataMapping='scaled';
                        end
                    case 3
                        for i=1:size(hslice(:),1)
                            hslice(i).LineStyle='none';hslice(i).FaceColor='interp';hslice(i).FaceAlpha='interp';
                            hslice(i).CDataMapping='scaled';hslice(i).AlphaData=hslice(i).CData;hslice(i).AlphaDataMapping='scaled';
                        end
                end
                hc(j)=colorbar(ax(j));hc(j).Label.String='signal intensity (a.u.)';hc(j).Label.Rotation=270;hc(j).Label.VerticalAlignment='bottom';hc(j).Box='off';
                ax(j).XLabel.String='x (sample length /mm)';ax(j).YLabel.String='y (sample width /mm)';
                switch obj.experiment_type
                    case 'HSC'
                        ax(j).ZLabel.String='\lambda (nm)';
                    case 'HDC'
                        ax(j).ZLabel.String='r (scattering radius /mm)';
                end
                ax(j).Box='on';ax(j).BoxStyle='full';
                
                %draw the projection on x-y, x-z and y-z plane
                hold on;
                sumZ=squeeze(sum(hypercube,3));
                graysumZ=mat2gray(sumZ);indexedsumZ=gray2ind(graysumZ,256);rgbsumZ=ind2rgb(indexedsumZ,jet(256));
                sumY=squeeze(sum(hypercube,1));
                graysumY=mat2gray(sumY');indexedsumY=gray2ind(graysumY,256);rgbsumY=ind2rgb(indexedsumY,jet(256));
                sumX=squeeze(sum(hypercube,2));
                graysumX=mat2gray(sumX);indexedsumX=gray2ind(graysumX,256);rgbsumX=ind2rgb(indexedsumX,jet(256));
                switch j
                    case 1
                        surf([x(1) x(end)],[y(1) y(end)],[z(1) z(1);z(1) z(1)],rgbsumZ,'facecolor','texturemap');
                        surf([x(1) x(end)],[y(1) y(1)],[z(1) z(1);z(end) z(end)],rgbsumY,'facecolor','texturemap');
                        surf([x(end) x(end)],[y(1) y(end)],[z(1) z(end);z(1) z(end)],rgbsumX,'facecolor','texturemap');
                    case 2
                        surf([x(1) x(end)],[y(1) y(end)],[z(1) z(1);z(1) z(1)],rgbsumZ,'facecolor','texturemap','facealpha',0.5);
                        surf([x(1) x(end)],[y(1) y(1)],[z(1) z(1);z(end) z(end)],rgbsumY,'facecolor','texturemap','facealpha',0.5);
                        surf([x(end) x(end)],[y(1) y(end)],[z(1) z(end);z(1) z(end)],rgbsumX,'facecolor','texturemap','facealpha',0.5);
                    case 3
                        surf([x(1) x(end)],[y(1) y(end)],[z(1) z(1);z(1) z(1)],rgbsumZ,'facecolor','texturemap','alphadata',graysumZ,'alphadatamapping','scaled','facealpha','texturemap');
                        surf([x(1) x(end)],[y(1) y(1)],[z(1) z(1);z(end) z(end)],rgbsumY,'facecolor','texturemap','alphadata',graysumY,'alphadatamapping','scaled','facealpha','texturemap');
                        surf([x(end) x(end)],[y(1) y(end)],[z(1) z(end);z(1) z(end)],rgbsumX,'facecolor','texturemap','alphadata',graysumX,'alphadatamapping','scaled','facealpha','texturemap');
                end
                hold off
            end
            amapthreshhold=0.4;amap=alphamap(ax(3));alphamap(ax(3),amap-amapthreshhold);
            
            figurehandle.PaperSize=[20 4];
            figurehandle.PaperPosition=[0 0 20 4];
            obj.Demofig='allResults_Demofig.fig';
            obj.Demoeps={'allResults_Demoeps1.eps','allResults_Demoeps2.eps','allResults_Demoeps3.eps'};
            savefig(figurehandle, fullfile(obj.foldername,obj.Demofig),'compact');
            print(figurehandle,fullfile(obj.foldername,obj.Demoeps{1}),'-depsc','-tiff','-r300','-opengl');
            
            for j=1:3
                axislim=axis(ax(j));
                for i=1:numel(ax(j).Children)
                    ax(j).Children(i).Visible='off';
                end
                axis(ax(j),axislim);
                ax(j).Box='off';
                ax(j).GridLineStyle='none';
                ax(j).Color='none';
                
            end
            print(figurehandle,fullfile(obj.foldername,obj.Demoeps{3}),'-depsc','-tiff','-r300','-painters');
            for j=1:3
                %ax(j).XTick=[];ax(j).YTick=[];ax(j).ZTick=[];
                %hc(j).Visible='off';
                for i=1:numel(ax(j).Children)
                    ax(j).Children(i).Visible='on';
                end
                ax(j).Box='on';
                ax(j).GridLineStyle='-';
                %ax(j).XLabel.Color='none';ax(j).YLabel.Color='none';ax(j).ZLabel.Color='none';
                ax(j).XColor=[1,1,1];ax(j).YColor=[1,1,1];ax(j).ZColor=[1,1,1];
                ax(j).Color=[1,1,1];hc(j).Color=[1,1,1];
            end
            figurehandle.InvertHardcopy='off';figurehandle.Color=[1,1,1];
            print(figurehandle,fullfile(obj.foldername,obj.Demoeps{2}),'-depsc','-tiff','-r300','-opengl');
            close(figurehandle);
            obj.saveClassObj;
        end
        function plotResults(obj)
            NFIG=10; %plotting figures related to the first NFIG PCA components
            
            figurehandle=figure;
            screensize=get(groot,'ScreenSize');
            figurehandle.OuterPosition=screensize;
            
            
            load(fullfile(obj.foldername,obj.HSC_all));
            x=linspace(0,obj.scan_size(2),size(PCA_score,2));y=linspace(0,obj.scan_size(1),size(PCA_score,1));ex=obj.excitation_range;em=obj.wavelength_range;
            
            ax=subplot(5,NFIG,1);
            imagesc(em,ex,PCA_mu);ax.DataAspectRatio=[1 1 1];ax.YDir='normal';
            ax.XLabel.String='emission wavelength (nm)';ax.YLabel.String='excitation wavelength (nm)';%ax.XTick=[];ax.YTick=[];
            ax.Box='off';%ax.XColor=[1 1 1];ax.YColor=[1 1 1];ax.XLabel.Color=[0 0 0];ax.YLabel.Color=[0 0 0];
            colormap(ax,jet(256));%hc=colorbar(ax);hc.Label.String='mean intensity (a.u.)';hc.Label.Rotation=270;hc.Label.VerticalAlignment='bottom';hc.Box='off';hc.Ticks=[];
            
            ax=subplot(5,NFIG,2);
            plot(PCA_explained(1:10));axis(ax,'tight');ax.PlotBoxAspectRatio=[1,1,1];
            ax.XLabel.String='PC order';ax.YLabel.String='contribution (%)';ax.XMinorTick='off';ax.YMinorTick='on';
            ax.YScale='log';axis(ax,[-inf,inf,0.01,100]);
            
            for i=3:NFIG
            ax=subplot(5,NFIG,i);axis off;
            end
            
            for i=1:NFIG
                ax=subplot(5,NFIG,NFIG+i);
                imagesc(em,ex,PCA_coeff(:,:,i));ax.DataAspectRatio=[1 1 1];ax.YDir='normal';
                %ax.XLabel.String='emission wavelength (nm)';ax.YLabel.String='excitation wavelength (nm)';%ax.XTick=[];ax.YTick=[];
                ax.Box='off';%ax.XColor=[1 1 1];ax.YColor=[1 1 1];ax.XLabel.Color=[0 0 0];ax.YLabel.Color=[0 0 0];
                colormap(ax,jet(256));%hc=colorbar(ax);hc.Label.String=[num2str(i) 'PC intensity (a.u.)'];hc.Label.Rotation=270;hc.Label.VerticalAlignment='bottom';hc.Box='off';hc.Ticks=[];
                
                ax=subplot(5,NFIG,2*NFIG+i);
                imagesc(x,y,PCA_score(:,:,i));ax.DataAspectRatio=[1 1 1];
                %ax.XLabel.String='x (sample length /mm)';ax.YLabel.String='y (sample width /mm)';%ax.XTick=[];ax.YTick=[];
                ax.Box='off';%ax.XColor=[1 1 1];ax.YColor=[1 1 1];ax.XLabel.Color=[0 0 0];ax.YLabel.Color=[0 0 0];
                colormap(ax,jet(256));%hc=colorbar(ax);hc.Label.String=[num2str(i) ' PC intensity (a.u.)'];hc.Label.Rotation=270;hc.Label.VerticalAlignment='bottom';hc.Box='off';hc.Ticks=[];
                                
                ax=subplot(5,NFIG,3*NFIG+i);
                imagesc(x,y,squeeze(maxPCA_HSC_smooth(:,:,i)));ax.DataAspectRatio=[1 1 1];
                %ax.XLabel.String='x (sample length /mm)';ax.YLabel.String='y (sample width /mm)';%ax.XTick=[];ax.YTick=[];
                ax.Box='off';%ax.XColor=[1 1 1];ax.YColor=[1 1 1];ax.XLabel.Color=[0 0 0];ax.YLabel.Color=[0 0 0];
                colormap(ax,jet(256));%hc=colorbar(ax);hc.Label.String=[num2str(i) ' PC intensity (a.u.)'];hc.Label.Rotation=270;hc.Label.VerticalAlignment='bottom';hc.Box='off';hc.Ticks=[];
 
                ax=subplot(5,NFIG,4*NFIG+i);
                imagesc(x,y,squeeze(minPCA_HSC_smooth(:,:,i)));ax.DataAspectRatio=[1 1 1];
                %ax.XLabel.String='x (sample length /mm)';ax.YLabel.String='y (sample width /mm)';%ax.XTick=[];ax.YTick=[];
                ax.Box='off';%ax.XColor=[1 1 1];ax.YColor=[1 1 1];ax.XLabel.Color=[0 0 0];ax.YLabel.Color=[0 0 0];
                colormap(ax,jet(256));%hc=colorbar(ax);hc.Label.String=[num2str(i) ' PC intensity (a.u.)'];hc.Label.Rotation=270;hc.Label.VerticalAlignment='bottom';hc.Box='off';hc.Ticks=[];
                
            end
            
            figurehandle.PaperSize=[40 20];
            figurehandle.PaperPosition=[0 0 40 20];
            obj.Resultsfig='allResults_Resultsfig.fig';
            obj.Resultseps='allResults_Resultseps.eps';
            savefig(figurehandle, fullfile(obj.foldername,obj.Resultsfig),'compact');
            spaceplots(figurehandle);%,[0.04 0.04 0.04 0.04],[0.04 0.04]
            print(figurehandle,fullfile(obj.foldername,obj.Resultseps),'-depsc','-tiff','-r300','-painters');
            print(figurehandle,fullfile(obj.foldername,'allResults_Resultseps.pdf'),'-dpdf','-r1200','-painters');
            close(figurehandle);
            obj.saveClassObj;
        end
        
        function range=pixel2range(obj,varargin)
            switch obj.experiment_type
                case 'HSC'
                    z=obj.wavelength_range;
                    if nargin==1
                        range=z;
                    else
                        range=(varargin{1}-1).*(z(2)-z(1))+z(1);
                    end
                case 'HDC'
                    z=obj.diffuse_range.*obj.view_size;
                    if nargin==1
                        range=z;
                    else
                        range=(varargin{1}-1).*(z(2)-z(1))+z(1);
                    end
                otherwise
                    error('error determining experiment_type. %s', obj.experiment_type);
            end
        end
    end
end
