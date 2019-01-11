
classdef CHADNIS < handle
    %CHADNIS Summary of this class goes here
    %   Detailed explanation goes here
    properties
        experiment_type='';%hyperspectral or hyperdiffuse
        laser_power=1; %in ampere
        integ_time=0.1; %in second
        scan_size=[20,40]; %[width length] in millimeter
        grid_size=[100,200]; %var1 is the line grid number, var2 is the reframe grid number
        wavelength_range=linspace(850,1750,260); %linspace(850,1750,260) for HSC
        diffuse_range=[1:205]; %for HDC
        view_size=0.35; %0.35 mm per pixel for HDC
        band_measured=1575; %1125, 1175, 1375, 1575 for HDC
        detector_size=[256,320];
        detector_ROI=[31,225,1,260]; %calculation for wavelength average
        
        fixed_points=[0,0;40,0;0,20;40,20];
        moving_points=[60,80;60,120;80,80;80,120];
        
        range={[21:50],[71:110],[131:170],[191:230]};
        emspectrum0=[0.00665059,0.00657997,0.006506689,0.006433018,0.006359548,0.006285119,0.00620783,0.006125452,0.006037152,0.005944923,0.005853916,0.005773817,0.005737851,0.005827676,0.005940808,0.00590406,0.005727445,0.005487963,0.005227219,0.005023656,0.004879915,0.004662669,0.004296686,0.003831337,0.003348609,0.002942321,0.002750139,0.002879301,0.003250596,0.003722337,0.004143526,0.004434389,0.004678373,0.004948503,0.005249367,0.005546614,0.005762621,0.005813502,0.005690374,0.005457497,0.005165925,0.00484103,0.004477667,0.004054042,0.003548536,0.002888227,0.002135343,0.001421722,0.000875772,0.000559936,0.000495483,0.000632953,0.000865935,0.001093326,0.001210226,0.001260331,0.001381542,0.001635659,0.002011079,0.002450631,0.002851375,0.003120849,0.003348624,0.003624541,0.003952955,0.004397843,0.004975795,0.00559802,0.006168346,0.006520761,0.006629173,0.006561053,0.006369735,0.006126363,0.005979026,0.006030905,0.006330076,0.006805404,0.007346015,0.007846117,0.008246643,0.008618708,0.008977654,0.009298088,0.009537126,0.009634874,0.009536281,0.009158377,0.008501697,0.007700489,0.006878256,0.006114179,0.005473661,0.004961938,0.00460568,0.004367344,0.004141704,0.003906262,0.003749672,0.003698342,0.003796778,0.004025258,0.004314962,0.004522034,0.004575339,0.004520674,0.004305884,0.003942278,0.003507963,0.003110169,0.002820567,0.002721041,0.002802382,0.002942478,0.002999876,0.002961675,0.00288064,0.002742084,0.002550853,0.002366858,0.002263135,0.002277501,0.002383766,0.002516686,0.002625984,0.002642773,0.002611561,0.002599663,0.002700177,0.002954426,0.003270464,0.003462297,0.003354376,0.002960488,0.002472936,0.002148826,0.002103404,0.002318097,0.002724578,0.003262195,0.003774031,0.004089176,0.004138609,0.00392787,0.003590086,0.003252332,0.002931881,0.002612196,0.002237955,0.001750415,0.001184129,0.000593404,0.000150091,0,0.000142266,0.000445752,0.000780588,0.00114941,0.001607413,0.002178826,0.002782376,0.003357113,0.003929712,0.00459912,0.005414913,0.006363228,0.007395765,0.008524802,0.009852481,0.011490491,0.013541753,0.016183822,0.019563829,0.023789201,0.028983586,0.035485858,0.043839002,0.054514802,0.067853233,0.084146719,0.103722718,0.126870294,0.153707484,0.184199713,0.218199946,0.255486987,0.2957984,0.338748826,0.383871842,0.430594644,0.478423287,0.526936653,0.575682116,0.6242159,0.672113139,0.718949022,0.76423225,0.807458874,0.84806125,0.885584678,0.91950682,0.948996999,0.97297879,0.990232722,0.999590191,1,0.990527874,0.970551952,0.939837357,0.898557172,0.847319507,0.787143248,0.719668759,0.646925299,0.571336452,0.495420751,0.421510063,0.351654064,0.287532007,0.230281387,0.180600274,0.13866012,0.10416933,0.07666062,0.055490453,0.039697289,0.028191287,0.019965488,0.014181887,0.010231012,0.007632479,0.006002452,0.005067593,0.004610412,0.004446247,0.004446975,0.004597312,0.004850211,0.005142199,0.005382458,0.00548174,0.005372912,0.005027187,0.004492228,0.003971633,0.003528937,0.003152952,0.003005109,0.002735806,0.00244246,0.002173624,0.001947042,0.001768365,0.001639257,0.001557391,0.001517339,0.001512975,0.001540678,0.001598818,0.001688024];
        extincoeff=0.1*[3.153759341,3.137167204,3.188727051,3.231430854,3.323637846,3.5612259,3.823441809,4.146131877,4.57126782,5.125405597,5.72560597,6.432062961,7.164994773,7.770004162,8.230218387,8.681637859,9.31883684,10.28007336,11.43794893,12.48876207,13.36848075,14.26476103,15.03936638,15.32823681,14.81173686,13.57761972,11.80704073,9.986909792,8.489902049,7.432389346,6.641696258,6.073458602,5.735161952,5.505221364,5.262369645,5.145430159,5.028262648,5.039288676,4.996684435,5.113068152,5.285933269,5.62375469,5.997861126,6.355230789,6.725519719,7.231316986,7.756686344,8.28712725,8.743918709,9.058946749,9.226521846,9.415294981,9.730138051,10.03394171,10.19973325,10.2301985,10.08766477,9.888859882,9.632691261,9.407006437,9.123412627,8.849075374,8.609047665,8.460448381,8.356341622,8.225443253,8.147247896,8.155000529,8.092958973,8.137245342,8.117838615,8.21314175,8.694198872,1.524240537,1.562231176,1.599808108,1.636996845,1.663912396,1.714303204,1.780078666,1.895785414,2.031992149,2.259087172,2.465154892,2.791544257,3.075802835,3.291864944,3.473609276,3.6009088,3.652408532,3.699489109,3.707576582,3.713922864,3.752378261,3.742831597,3.755664085,3.770432477,3.781545155,3.791582116,3.801713014,3.807658374,3.777933409,3.784829139,3.758849386,3.74357324,3.72838711,3.690981755,3.676791907,3.651134652,3.64095549,3.611978185,3.583405372,3.570313129,3.547682352,3.520496797,3.498794543,3.47226829,3.465658341,3.451562496,3.431442547,3.424649105,3.422541843,3.447936363,3.463352361,3.489605166,3.536703921,3.566639664,3.609315634,3.668409221,3.744534288,3.81017833,3.915192998,4.031343136,4.140428262,4.280719614,4.415719456,4.586025532,4.731752629,4.941431109,5.093048637,5.327592232,5.473325277,5.638112917,5.887630422,6.016425776,6.136043423,6.311968794,6.463869948,6.620729899,6.867571982,7.183123628,7.541273613,8.019631045,8.647222337,9.558509155,10.98326096,12.42353849,14.22356154,16.04239268,17.67273873,19.19408786,20.6365461,21.8516153,22.74210893,23.47702224,24.26236422,24.9447322,25.4180074,25.85501059,26.22203034,26.34573446,26.48536161,26.58618409,26.6478537,26.6352238,26.5710538,26.43338328,25.99241359,25.45344245,24.9468766,24.36569813,23.69903512,23.10952932,22.54407199,21.72113339,20.84836133,20.35643742,19.63309086,19.01443223,18.46909766,17.75713216,17.22750359,16.65110614,16.07336534,15.65856024,15.33389131,14.9018749,14.46947209,14.09237603,13.58092761,13.17769432,12.9047586,12.57722468,12.22344096,11.92273239,11.6678251,11.40026746,11.15366301,10.94535409,10.7624709,10.57944985,10.39488027,10.21018135,10.01969533,9.85443847,9.715896951,9.571682774,9.434446389,9.313910171,9.2077732,9.110843123,9.012148322,8.904778818,8.810600916,8.72942752,8.644479097,8.567519654,8.502170079,8.435410689,8.376374655,8.324155934,8.257555253,8.200035042,8.166984972,8.129818989,8.091596311,8.067815337,8.041140403,8.016104824,8.014377554,8.005405327,7.989147295,8.027118504,8.047275195,8.042072114,8.032519128,8.041954557,8.091869648,8.148420921,8.186327179,8.223963244,8.279654256,8.365746749,8.441228206,8.42975123,8.415533721,8.564832077,8.891776545,9.030046389,9.136763785];
        
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
        Level1DataMatrix %binning allframes on 1,2,4,5 dimension  FILENAME:'allResults_Level1Data.mat'
        HSC %Hyperspectral_cube %I(x,y,lambda)
        HDC %Hyperdiffuse_cube %I(x,y,r) or I(x,y,a,b)
        HSC_smooth %Hyperspectral_cube_smooth
        HDC_smooth %Hyperdiffuse_cube_smooth
        HSC_all %all properties analyzed
        HDC_all %all properties analyzed
    end
    properties
        pointcloud_ply   %original ply file from 3D scan
        pointcloud_surface  %X by Y by 6 array of: XGrid, YGrid, topsurface, and R,G,B colors of each point on surface
        surfacefig
        surfaceeps
        
        HSC_3D %3D reconstruction
        HDC_3D %3D reconstruction
    end
    properties
        Level1fig
        Level1eps
        Montagefig
        Montageeps
        Demofig
        Demoeps
        
        Miji3Dtif
        
        Resultsfig
        Resultseps
        Reconstruct3Dfig
        Reconstruct3Deps
    end
    
    methods
        
        
        
        
        function obj=CHADNIS(foldername)
            obj.foldername=foldername;
            obj.infoParsing;
            obj.fileProcessing;
            obj.dataSmoothing;
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
            infolist={'experiment_type','laser_power','integ_time','scan_size','grid_size','wavelength_range','diffuse_range','view_size','band_measured','detector_size','detector_ROI','fixed_points','moving_points'};
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
            if ~strcmpi(obj.experiment_type,'HSC') && ~strcmpi(obj.experiment_type,'HDC')
                warning('experiment_type is not HSC or HDC. parsing this information from folder name.');
                index=strfind(obj.foldername,'\');
                if obj.foldername(index(end)+1)=='Z' || obj.foldername(index(end)+1)=='z'
                    obj.experiment_type='HSC';warning('experiment_type is not HSC or HDC. parsing this information from folder name. experiment_type set to %s.', obj.experiment_type);
                else
                    obj.experiment_type='HDC';warning('experiment_type is not HSC or HDC. parsing this information from folder name. experiment_type set to %s.', obj.experiment_type);
                end
            end
            if ~isnumeric(obj.laser_power)
                obj.laser_power=1;warning('laser_power is not numeric. using default value: %d.',obj.laser_power);
            end
            if ~isnumeric(obj.integ_time)
                obj.integ_time=0.1;warning('integ_time is not numeric. using default value: %d.',obj.integ_time);
            end
            if ~ismatrix(obj.scan_size) || size(obj.scan_size(:),1)~=2
                obj.scan_size=[20,40];warning('scan_size does not have valid value. using default value: s%.',mat2str(obj.scan_size));
            end
            if ~ismatrix(obj.grid_size) || size(obj.grid_size(:),1)~=2
                obj.grid_size=[100,200];warning('grid_size does not have valid value. using default value: s%.',mat2str(obj.grid_size));
            end
            if ~ismatrix(obj.wavelength_range) || size(size(obj.wavelength_range),2)~=2
                obj.wavelength_range=linspace(850,1750,260);warning('wavelength_range does not have valid value. using default value: s%.',mat2str(obj.wavelength_range));
            end
            if ~ismatrix(obj.diffuse_range) || size(size(obj.diffuse_range),2)~=2
                obj.diffuse_range=[1:205];warning('diffuse_range does not have valid value. using default value: s%.',mat2str(obj.diffuse_range));
            end
            if ~isnumeric(obj.view_size)
                obj.view_size=0.35;warning('view_size is not numeric. using default value: %d.',obj.view_size);
            end
            if ~isnumeric(obj.band_measured)
                obj.band_measured=1575;warning('band_measured is not numeric. using default value: %d.',obj.band_measured);
            end
            if ~ismatrix(obj.detector_size) || size(obj.detector_size(:),1)~=2
                obj.detector_size=[256,320];warning('detector_size does not have valid value. using default value: s%.',mat2str(obj.detector_size));
            end
            if ~ismatrix(obj.detector_ROI) || size(obj.detector_ROI(:),1)~=4
                obj.detector_ROI=[31,225,1,260];warning('detector_ROI does not have valid value. using default value: s%.',mat2str(obj.detector_ROI));
            end
            if ~ismatrix(obj.fixed_points) || size(size(obj.fixed_points),2)~=2
                obj.fixed_points=[0,0;0,40;20,0;20,40];warning('fixed_points does not have valid value. using default value: s%.',mat2str(obj.fixed_points));
            end
            if ~ismatrix(obj.moving_points) || size(size(obj.moving_points),2)~=2
                obj.moving_points=[60,80;60,120;80,80;80,120];warning('moving_points does not have valid value. using default value: s%.',mat2str(obj.moving_points));
            end
            obj.saveClassObj;
        end
        function fileProcessing(obj)
            disp('processing files...');
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
            temp=fullfile(obj.foldername, 'SuperFastScan2*.SPE');
            fileList=dir(temp);
            index = strfind(fileList(1).name, 'Integ');       
            tempfilehead=fileList(1).name(1:index(1)+length('Integ')-1);
            
            obj.allframes='allResults_allframes.mat';         %initializing obj.allframes

            sizeallframes=[obj.detector_size(1),obj.detector_size(2),1,obj.grid_size(1),obj.grid_size(2)];
            allframes=zeros(sizeallframes,'single');
            obj.Level1DataMatrix='allResults_Level1Data.mat'; %initializing obj.Level1DataMatrix
            NumOfBinning=4;

            sizeLevel1=[floor(sizeallframes(1)/NumOfBinning),floor(sizeallframes(2)/NumOfBinning),1,floor(sizeallframes(4)/NumOfBinning),floor(sizeallframes(5)/NumOfBinning)];
            Level1DataMatrix=zeros(sizeLevel1,'single');
            switch obj.experiment_type
                case 'HSC'
                    obj.HSC='allResults_HSC.mat';                 %initializing obj.HSC

                    sizeHSC=[sizeallframes(4),sizeallframes(5),size(obj.wavelength_range(:),1)];
                    HSC=zeros(sizeHSC,'single');
                case 'HDC'
                    obj.HDC='allResults_HDC.mat';                 %initializing obj.HDC

                    sizeHDC=[sizeallframes(4),sizeallframes(5),size(obj.diffuse_range(:),1)];
                    HDC=zeros(sizeHDC,'single');
                    load('distancemap.MAT','distancemap'); %distancemap is a 205 cell with distancemap and linear indexing
                otherwise
                    error('error determining experiment_type. %s', obj.experiment_type);
            end
            for fileNumber=1:obj.grid_size(1) %size(fileList(:),1)
%                 index = strfind(fileList(fileNumber).name, 'Integ');       %determining linenumber for each file
%                 linenumber=sscanf(fileList(fileNumber).name(index(1) + length('Integ'):end), '%d');
                obj.raw_filename{fileNumber}=sprintf('%s%d.SPE',tempfilehead,fileNumber);
                
                while ~exist(fullfile(obj.foldername,obj.raw_filename{fileNumber}),'file')
                    pause(1);
                end
                
                obj.readerobj{fileNumber}=SpeReader(fullfile(obj.foldername,obj.raw_filename{fileNumber}));
                
                tempallframes=read(obj.readerobj{fileNumber});
                if mod(fileNumber,2)==0
                    tempallframes=flip(tempallframes,4);
                end
                %calculate and store allframes
                tempallframes=reshape(permute(interp1(1:obj.readerobj{fileNumber}.NumberOfFrames,permute(single(tempallframes),[4 1 2 3]),linspace(1,obj.readerobj{fileNumber}.NumberOfFrames,obj.grid_size(2)),'linear'),[2 3 4 1]),sizeallframes(1),sizeallframes(2),sizeallframes(3),1,sizeallframes(5));
                tempallframes=single(tempallframes)-repmat(single(background_frame),1,1,1,1,sizeallframes(5));
                allframes(:,:,:,fileNumber,:)=tempallframes;
                %calculate and store Level1DataMatrix, i.e. allframesBin
                allframesBin=reshape(tempallframes,NumOfBinning,sizeLevel1(1),NumOfBinning,sizeLevel1(2),1,1,NumOfBinning,sizeLevel1(5));
                allframesBin=mean(mean(mean(allframesBin,7),3),1);
                allframesBin=reshape(allframesBin,sizeLevel1(1),sizeLevel1(2),sizeLevel1(3),1,sizeLevel1(5));
                Level1DataMatrix(:,:,:,fileNumber,:)=allframesBin;
                switch obj.experiment_type
                    case 'HSC'   %calculate and store HSC
                        try
                            allframesHSC=mean(tempallframes(obj.detector_ROI(1):obj.detector_ROI(2),obj.detector_ROI(3):obj.detector_ROI(4),:,:,:),1)-mean(tempallframes([1:obj.detector_ROI(1)-1,obj.detector_ROI(2)+1:end],obj.detector_ROI(3):obj.detector_ROI(4),:,:,:),1);
                        catch
                            warning('Problem calculating HSC using detector_ROI. Using detector_size instead.');
                            allframesHSC=mean(tempallframes);
                        end
                        HSC(fileNumber,:,:)=reshape(permute(squeeze(allframesHSC),[2 1]),1,sizeHSC(2),sizeHSC(3));
                    case 'HDC'   %calculate and store HSC
                        allframesHDCtemp=permute(squeeze(tempallframes),[3 1 2]);
                        allframesHDC=zeros(sizeHDC(2),sizeHDC(3));
                        [iterNum1,iterNum2]=size(allframesHDC);
                        parfor i=1:iterNum1
                            allframesHDCtempi=squeeze(allframesHDCtemp(i,:,:));
                            for kk=1:iterNum2
                                allframesHDC(i,kk)=mean(allframesHDCtempi(distancemap{kk}));  %linear indexing of array is much faster
                            end
                        end
                        HDC(fileNumber,:,:)=reshape(allframesHDC,1,sizeHDC(2),sizeHDC(3));
                end
                
                if mod(fileNumber,10)==0
                    fprintf('%d files processed.\n',fileNumber);
                end
                
            end
            
            switch obj.experiment_type
                case 'HSC'
                    save(fullfile(obj.foldername,obj.HSC),'HSC');
                case 'HDC'
                    save(fullfile(obj.foldername,obj.HDC),'HDC');
            end
            
            Level1DataMatrix=reshape(mean(reshape(Level1DataMatrix,sizeLevel1(1),sizeLevel1(2),1,NumOfBinning,[],sizeLevel1(5)),4),sizeLevel1);  %binning the 4th dimension of Level1DataMatrix
            save(fullfile(obj.foldername,obj.Level1DataMatrix),'Level1DataMatrix');
            globalmax=max(allframes(:));globalmin=min(allframes(:));
            allframes=uint16((allframes-globalmin)/(globalmax-globalmin)*65535);
            savefast(fullfile(obj.foldername,obj.allframes),'allframes','globalmax','globalmin');
            
            obj.saveClassObj;
        end
        function dataSmoothing(obj)
            disp('smoothing data...');
            SmoothSpan=0.1;SmoothMethodValue='loess';
            fprintf('smooth method is %s, smooth span is %d \n',SmoothMethodValue,SmoothSpan);
            switch obj.experiment_type
                case 'HSC'
                    load(fullfile(obj.foldername,obj.HSC)); %load variable HSC
                    obj.HSC_smooth='allResults_HSC_smooth.mat';
                    matobj_HSC_smooth=matfile(fullfile(obj.foldername,obj.HSC_smooth),'Writable',true);
                    sizeHSC=size(HSC);
                    HSC=reshape(HSC,[],sizeHSC(3));
                    SmoothMatrix=zeros(size(HSC));
                    parfor i=1:size(HSC,1)
                        SmoothMatrix(i,:)=smooth(squeeze(HSC(i,:)),SmoothSpan,SmoothMethodValue);
                    end
                    matobj_HSC_smooth.HSC_smooth=single(reshape(SmoothMatrix,sizeHSC));
                case 'HDC'
                    load(fullfile(obj.foldername,obj.HDC)); %load variable HDC
                    obj.HDC_smooth='allResults_HDC_smooth.mat';
                    matobj_HDC_smooth=matfile(fullfile(obj.foldername,obj.HDC_smooth),'Writable',true);
                    sizeHDC=size(HDC);
                    HDC=reshape(HDC,[],sizeHDC(3));
                    SmoothMatrix=zeros(size(HDC));
                    parfor i=1:size(HDC,1)
                        SmoothMatrix(i,:)=smooth(squeeze(HDC(i,:)),SmoothSpan,SmoothMethodValue);
                    end
                    matobj_HDC_smooth.HDC_smooth=single(reshape(SmoothMatrix,sizeHDC));
                otherwise
                    error('error determining experiment_type. %s', obj.experiment_type);
            end
            obj.saveClassObj;
        end
        function dataAnalysis(obj)
            disp('analyzing data...');
            switch obj.experiment_type
                case 'HSC'
                    load(fullfile(obj.foldername,obj.HSC_smooth)); %load variable HSC_smooth
                    obj.HSC_all='allResults_HSC_all.mat';
                    [PCA_coeff,PCA_score,PCA_latent,PCA_tsquared,PCA_explained,PCA_mu] = pca(reshape(HSC_smooth(:,:,:),[],size(HSC_smooth,3)));
                    PCA_score=reshape(PCA_score,size(HSC_smooth));
                    Range{1}=obj.range{1};Range{2}=obj.range{2};Range{3}=obj.range{3};Range{4}=obj.range{4};
                    %Range{1}=[31:40];Range{2}=[81:100];Range{3}=[141:160];Range{4}=[201:220];
                    for i=1:4
                        [PCA_coeff1{i},PCA_result{i},PCA_latent1{i},PCA_tsquared1{i},PCA_explained1{i},PCA_mu1{i}] = pca(reshape(HSC_smooth(:,:,Range{i}),[],size(Range{i}(:),1)));
                        PCA_result{i}=reshape(PCA_result{i}(:,1),size(HSC_smooth,1),[]);
                    end
                    for ii=1:4
                        resultgray{ii}=mat2gray(PCA_result{ii})+0.2;
                    end
                    for ii=1:4
                        for jj=1:4
                            if ii==jj
                                PCA_result16{ii*4-4+jj}=resultgray{jj};
                            else
                                PCA_result16{ii*4-4+jj}=resultgray{jj}./resultgray{ii};
                            end
                        end
                    end
                    %Range{1}=[21:50];Range{2}=[71:110];Range{3}=[131:170];Range{4}=[191:230];
                    sizeHSC_smooth=size(HSC_smooth);
                    parfor n=1:4
                        EqualAreaMatrix{n}=zeros(sizeHSC_smooth(1),sizeHSC_smooth(2),size(Range{n}(:),1));
                        EqualAreaResult{n}=NaN(sizeHSC_smooth(1),sizeHSC_smooth(2),3);%z=3 to store locations of, 50%, 15%, and 85% of total area
                        EqualAreaAlphaData{n}=sum(HSC_smooth(:,:,Range{n}),3);
                        for i=1:sizeHSC_smooth(1)
                            for j=1:sizeHSC_smooth(2)
                                EqualAreaMatrix{n}(i,j,:)=HSC_smooth(i,j,Range{n})-min(HSC_smooth(i,j,Range{n}));
                                EqualAreaMatrix{n}(i,j,:)=cumtrapz(EqualAreaMatrix{n}(i,j,:));
                                k=1;
                                while EqualAreaMatrix{n}(i,j,k)<EqualAreaMatrix{n}(i,j,end)/2
                                    k=k+1;
                                end
                                if (k>1) && (k<size(Range{n}(:),1))
                                    temp=k-1+(EqualAreaMatrix{n}(i,j,end)/2-EqualAreaMatrix{n}(i,j,k-1))/(EqualAreaMatrix{n}(i,j,k)-EqualAreaMatrix{n}(i,j,k-1));
                                    EqualAreaResult{n}(i,j,1)=temp-1+Range{n}(1);
                                end
                                l=1;
                                while EqualAreaMatrix{n}(i,j,l)<EqualAreaMatrix{n}(i,j,end)*0.15
                                    l=l+1;
                                end
                                if (l>1) && (l<size(Range{n}(:),1))
                                    temp=l-1+(EqualAreaMatrix{n}(i,j,end)*0.15-EqualAreaMatrix{n}(i,j,l-1))/(EqualAreaMatrix{n}(i,j,l)-EqualAreaMatrix{n}(i,j,l-1));
                                    EqualAreaResult{n}(i,j,2)=temp-1+Range{n}(1);
                                end
                                m=1;
                                while EqualAreaMatrix{n}(i,j,m)<EqualAreaMatrix{n}(i,j,end)*0.85
                                    m=m+1;
                                end
                                if (m>1) && (m<size(Range{n}(:),1))
                                    temp=m-1+(EqualAreaMatrix{n}(i,j,end)*0.85-EqualAreaMatrix{n}(i,j,m-1))/(EqualAreaMatrix{n}(i,j,m)-EqualAreaMatrix{n}(i,j,m-1));
                                    EqualAreaResult{n}(i,j,3)=temp-1+Range{n}(1);
                                end
                            end
                        end
                    end
                    save(fullfile(obj.foldername,obj.HSC_all),'PCA_coeff','PCA_score','PCA_latent','PCA_tsquared','PCA_explained','PCA_mu','PCA_result','PCA_result16','EqualAreaResult','EqualAreaAlphaData','PCA_coeff1','PCA_latent1','PCA_tsquared1','PCA_explained1','PCA_mu1');
                case 'HDC'
                    load(fullfile(obj.foldername,obj.HDC_smooth)); %load variable HDC_smooth
                    obj.HDC_all='allResults_HDC_all.mat';
                    [PCA_coeff,PCA_score,PCA_latent,PCA_tsquared,PCA_explained,PCA_mu] = pca(reshape(HDC_smooth(:,:,:),[],size(HDC_smooth,3)));
                    PCA_score=reshape(PCA_score,size(HDC_smooth));
                    PCA_result{1}=squeeze(max(HDC_smooth,[],3));
                    PCA_result{2}=squeeze(median(HDC_smooth,3));
                    PCA_result{3}=squeeze(mean(HDC_smooth,3));
                    Range=[1:205];
                    EqualAreaResult=zeros(size(HDC_smooth,1),size(HDC_smooth,2));
                    EqualAreaAlphaData=sum(HDC_smooth(:,:,Range),3);
                    for i=1:size(HDC_smooth,1)  %can be replaced by reshape + parfor, similar to earlier (above)
                        for j=1:size(HDC_smooth,2)
                            k=2;
                            while (k<Range(end)) && ((HDC_smooth(i,j,2)-HDC_smooth(i,j,k))<(HDC_smooth(i,j,2)-HDC_smooth(i,j,end))/2)
                                k=k+1;
                            end
                            l=Range(end);
                            while (l>1) && ((HDC_smooth(i,j,l)-HDC_smooth(i,j,end))<(HDC_smooth(i,j,2)-HDC_smooth(i,j,end))/2)
                                l=l-1;
                            end
                            EqualAreaResult(i,j)=(k+l)/2;
                        end
                    end
                    save(fullfile(obj.foldername,obj.HDC_all),'PCA_coeff','PCA_score','PCA_latent','PCA_tsquared','PCA_explained','PCA_mu','PCA_result','EqualAreaResult','EqualAreaAlphaData');
                otherwise
                    error('error determining experiment_type. %s', obj.experiment_type);
            end
            obj.saveClassObj;
        end
        function plotAll(obj)
            disp('ploting results...');
            obj.plotLevel1Data;
            obj.plotMontage;
            obj.plot3D_demo;
            obj.plotResults;
        end
        function plotLevel1Data(obj)
            load(fullfile(obj.foldername,obj.Level1DataMatrix));
            try
                load(fullfile(obj.foldername,obj.allframes),'allframes','globalmax','globalmin');
                allframes=(single(allframes)/65535)*(globalmax-globalmin)+globalmin;
            catch
                disp('error');
                %load(fullfile(obj.foldername,obj.allframes),'allframes');
            end

            sizeLevel1=size(Level1DataMatrix);globalmin=min(Level1DataMatrix(:));globalmax=max(Level1DataMatrix(:));
            x=linspace(0,obj.scan_size(2),obj.grid_size(2));y=linspace(0,obj.scan_size(1),obj.grid_size(1));z=pixel2range(obj);
            SmoothSpan=0.1;SmoothMethodValue='loess';
            Padding=[0.02 0.02];
            figurehandle=figure;
            
            [~,location]=max(sum(sum(reshape(Level1DataMatrix,sizeLevel1(1),sizeLevel1(2),[]))));
            [maxlinenumber,maxframenumber]=ind2sub([sizeLevel1(4) sizeLevel1(5)],location);
            tempframe=squeeze(allframes(:,:,1,maxlinenumber*4-2,maxframenumber*4-2));
            ax=subplot(2,2,1);
            imagesc(tempframe);caxis(ax,[globalmin globalmax]);ax.DataAspectRatio=[1 1 1];
            ax.XLabel.String='a (detector pixel)';ax.YLabel.String='b (detector pixel)';
            ax.Box='off';%ax.FontSize=20;ax.Title.String='raw frames captured';ax.Title.FontWeight='normal';
            colormap(ax,jet(256));hc=colorbar(ax);
            hc.Label.String='signal intensity (a.u.)';hc.Label.Rotation=270;hc.Label.VerticalAlignment='bottom';hc.Box='off';
            ax=subplot(2,2,2); %processed spectrum
            tempprocessed=frameprocess(obj,tempframe);
            plot(z,smooth(tempprocessed,SmoothSpan,SmoothMethodValue));ax.PlotBoxAspectRatio=[obj.scan_size(2),obj.scan_size(1),1];
            ax.YLabel.String='mean intensity (a.u.)';axis(ax,[z(1),z(end),globalmin,globalmax]);%ax.FontSize=20;ax.Title.FontWeight='normal';
            switch obj.experiment_type
                case 'HSC'
                    ax.XLabel.String='\lambda (nm)';%ax.Title.String='processed spectra';
                case 'HDC'
                    ax.XLabel.String='r (scattering radius /mm)';%ax.Title.String='processed diffuse data';
            end
            ax=subplot(2,2,[3,4]);
            Level1DataMatrix=reshape(permute(Level1DataMatrix,[1 2 3 5 4]),sizeLevel1(1),sizeLevel1(2),1,[]);%due to the order of dimension that reshape and montage taking place, the matrix has to be permuted first
            Level1DataMatrixpad=NaN(ceil(sizeLevel1(1).*(1+Padding(1))),ceil(sizeLevel1(2).*(1+Padding(2))),1,sizeLevel1(4)*sizeLevel1(5));
            Level1DataMatrixpad(1:sizeLevel1(1),1:sizeLevel1(2),1,:)=Level1DataMatrix(:,:,1,:);
            hmontage=montage(Level1DataMatrixpad,'DisplayRange',[],'Size',[sizeLevel1(4) sizeLevel1(5)]);
            hmontage.XData=[x(1),x(end)];hmontage.YData=[y(1),y(end)];  %rescaling x,y, axis function below is also required
            hmontage.AlphaData=~isnan(hmontage.CData);
            axis(ax,[x(1),x(end),y(1),y(end),-inf,inf,globalmin globalmax]);
            ax.DataAspectRatio=[sizeLevel1(2) sizeLevel1(1) 1];
            ax.XLabel.String='x (sample length /mm)';ax.YLabel.String='y (sample width /mm)';ax.Box='off';%ax.FontSize=20;ax.Title.String='sample scanning';ax.Title.FontWeight='normal';
            colormap(ax,jet(256));hc=colorbar(ax);
            hc.Label.String='signal intensity (a.u.)';hc.Label.Rotation=270;hc.Label.VerticalAlignment='bottom';hc.Box='off';
            
            figurehandle.PaperSize=[20 10];
            figurehandle.PaperPosition=[0 0 20 10];
            obj.Level1fig='allResults_Level1fig.fig';
            obj.Level1eps='allResults_Level1eps.eps';
            savefig(figurehandle, fullfile(obj.foldername,obj.Level1fig),'compact');
            print(figurehandle,fullfile(obj.foldername,obj.Level1eps),'-depsc','-tiff','-r300','-painters');
            close(figurehandle);
            obj.saveClassObj;
        end
        function plotMontage(obj)
            Padding=[0.05 0.02];
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
            x=linspace(0,obj.scan_size(2),obj.grid_size(2));y=linspace(0,obj.scan_size(1),obj.grid_size(1));z=pixel2range(obj);
            globalmin=min(hypercube(:));globalmax=max(hypercube(:));
            DisplaySize=[ceil(size(hypercube,3)/20) 20];
            hypercubepad=NaN(ceil(size(hypercube,1).*(Padding(1)+1)),ceil(size(hypercube,2).*(Padding(2)+1)),size(hypercube,3));
            hypercubepad(1:size(hypercube,1),1:size(hypercube,2),1:size(hypercube,3))=hypercube(:,:,:);
            hypercubepad=reshape(hypercubepad,size(hypercubepad,1),size(hypercubepad,2),1,size(hypercubepad,3)); %now the hypercube has padding for displaying montage
            
            figurehandle=figure;
            hmontage=montage(hypercubepad,'Size',DisplaySize,'DisplayRange',[]);
            hmontage.AlphaData=~isnan(hmontage.CData);
            hold on
            hypercubeBW=zeros(size(hypercubepad));
            switch obj.experiment_type
                case 'HSC'
                    for i=1:size(hypercubeBW,4)
                        hypercubeBW(:,:,1,i)=im2bw(insertText(squeeze(hypercubeBW(:,:,1,i)),[1,1],[num2str(floor(z(i)),'%d') 'nm'],'BoxOpacity',0,'TextColor','white','FontSize',24),0.5);
                    end
                case 'HDC'
                    for i=1:size(hypercubeBW,4)
                        hypercubeBW(:,:,1,i)=im2bw(insertText(squeeze(hypercubeBW(:,:,1,i)),[1,1],[num2str(floor(z(i)),3) 'mm'],'BoxOpacity',0,'TextColor','white','FontSize',24),0.5);
                    end
            end
            hypercubeBW=hypercubeBW.*globalmax.*1.1;
            hypercubeBW(hypercubeBW==0)=NaN;
            hmontage=montage(hypercubeBW,'Size',DisplaySize,'DisplayRange',[]);
            hmontage.AlphaData=~isnan(hmontage.CData);
            hold off
            ax=gca;ax.DataAspectRatio=[1 1 1];%ax.YLabel.String='HSC z-index';ax.YTick=[50:100:1250];ax.YTickLabel={'1-20','21-40','41-60','61-80','81-100','101-120','121-140','141-160','161-180','181-200','201-220','221-240','241-260'};
            axis(ax,'off');caxis(ax,[globalmin,globalmax]);
            colormap(ax,[jet(256);1,1,1]);hc=colorbar(ax);
            hc.Label.String='signal intensity (a.u.)';hc.Label.Rotation=270;hc.Label.VerticalAlignment='bottom';hc.Box='off';
            
            figurehandle.PaperSize=[20 10];
            figurehandle.PaperPosition=[0 0 20 10];
            obj.Montagefig='allResults_Montagefig.fig';
            obj.Montageeps='allResults_Montageeps.eps';
            savefig(figurehandle, fullfile(obj.foldername,obj.Montagefig),'compact');
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
        
        function plot3D_demo2(obj)
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
           %here's where can be proved by changing slice to other functions
            hslice=slice(X,Y,Z,hypercube,[],[],SliceArray(1:10));ax=gca;colormap(ax,jet(256));view(ax,-33,36);
            
            ax.YDir='reverse';ax.PlotBoxAspectRatio=[obj.scan_size(2),obj.scan_size(1),obj.scan_size(2)];axis(ax,'tight');
            for i=1:size(hslice(:),1)
                hslice(i).LineStyle='none';hslice(i).FaceColor='interp';hslice(i).FaceAlpha='interp';
                hslice(i).CDataMapping='scaled';hslice(i).AlphaData=hslice(i).CData;hslice(i).AlphaDataMapping='scaled';
            end
            hc=colorbar(ax);hc.Label.String='signal intensity (a.u.)';hc.Label.Rotation=270;hc.Label.VerticalAlignment='bottom';hc.Box='off';
            ax.XLabel.String='x (sample length /mm)';ax.YLabel.String='y (sample width /mm)';
            switch obj.experiment_type
                case 'HSC'
                    ax.ZLabel.String='\lambda (nm)';
                case 'HDC'
                    ax.ZLabel.String='r (scattering radius /mm)';
            end
            ax.Box='on';ax.BoxStyle='full';
            
            %draw the projection on x-y, x-z and y-z plane
            hold on;
            sumZ=squeeze(sum(hypercube,3));
            graysumZ=mat2gray(sumZ);indexedsumZ=gray2ind(graysumZ,256);rgbsumZ=ind2rgb(indexedsumZ,jet(256));
            sumY=squeeze(sum(hypercube,1));
            graysumY=mat2gray(sumY');indexedsumY=gray2ind(graysumY,256);rgbsumY=ind2rgb(indexedsumY,jet(256));
            sumX=squeeze(sum(hypercube,2));
            graysumX=mat2gray(sumX);indexedsumX=gray2ind(graysumX,256);rgbsumX=ind2rgb(indexedsumX,jet(256));
            surf([x(1) x(end)],[y(1) y(end)],[z(1) z(1);z(1) z(1)],rgbsumZ,'facecolor','texturemap','alphadata',graysumZ,'alphadatamapping','scaled','facealpha','texturemap');
            surf([x(1) x(end)],[y(1) y(1)],[z(1) z(1);z(end) z(end)],rgbsumY,'facecolor','texturemap','alphadata',graysumY,'alphadatamapping','scaled','facealpha','texturemap');
            surf([x(end) x(end)],[y(1) y(end)],[z(1) z(end);z(1) z(end)],rgbsumX,'facecolor','texturemap','alphadata',graysumX,'alphadatamapping','scaled','facealpha','texturemap');
            hold off
            amapthreshhold=0.4;amap=alphamap(ax);alphamap(ax,amap-amapthreshhold);
            
            figurehandle.PaperSize=[10 5];
            figurehandle.PaperPosition=[0 0 10 5];
            print(figurehandle,fullfile(obj.foldername,'allResults_Demoeps.pdf'),'-dpdf','-r300','-painters');
            
            close(figurehandle);
        end
        

        function plot3D_Miji3dViewer(obj)
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
            hypercube=flip(hypercube,3);
            hypercube=uint8(mat2gray(hypercube).*255);
            Miji(false);
            
            imp=MIJ.createImage('hypercube',hypercube,false);
            
            universe=ij3d.Image3DUniverse();
            
            universesettings=ij3d.UniverseSettings();
            universesettings.defaultBackground=javax.vecmath.Color3f(0.8, 0.8, 0.8);
            universesettings.showSelectionBox=false;
            universesettings.apply(universe);
            
            universe.show();
            
            content=universe.addVoltex(imp);
            content.showBoundingBox(true);
            content.showCoordinateSystem(false);
            map=uint8(jet(256).*255);
            content.setLUT(map(:,1)',map(:,2)',map(:,3)',(0:1:255));
            
            universe.rotateX(90*pi/180);pause(0.1)         
            universe.rotateY(-30*pi/180);pause(0.1)            
            universe.rotateX(-30*pi/180);pause(0.1)            

            snapshot=universe.takeSnapshot;
            snapshot.show;
            imgsnapshot=MIJ.getCurrentImage;
            imgsnapshot=uint8(mat2gray(imgsnapshot).*255);
            
            obj.Miji3Dtif='allResults_Miji3Dtif.tif';
            imwrite(imgsnapshot,fullfile(obj.foldername,obj.Miji3Dtif));
            
            obj.saveClassObj;
        end
        
        function plot3D_MijiVolumeViewer(obj)
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
            map=jet(256);
            hypercube=flip(hypercube,3);
            hypercube=gray2ind(mat2gray(hypercube),256);
            sizehypercube=size(hypercube);
            if exist(fullfile(obj.foldername,'a_temp.tif'),'file')
                delete(fullfile(obj.foldername,'a_temp.tif'));
            end
            
            for i=1:sizehypercube(3)
                imwrite(hypercube(:,:,i),map,fullfile(obj.foldername,'a_temp.tif'),'WriteMode','append')            
            end
            Miji(false);
            MIJ.run('Open...',['path=' fullfile(obj.foldername,'a_temp.tif')]);
            MIJ.run('Volume Viewer','display_mode=2 interpolation=2 bg_r=255 bg_g=255 bg_b=255 lut=0 z-aspect=1 axes=0 scale=2.5 angle_x=-50 angle_y=-32 angle_z=-24 alphamode=0 width=1000 height=1320 snapshot=1 ');
            %MIJ.closeAllWindows;
            pause(1);
            h = actxserver('WScript.Shell');
            h.SendKeys('%{F4}'); % close Notepad Alt+F4
            pause(1);
            imgsnapshot=MIJ.getCurrentImage;
            imgsnapshot=uint8(mat2gray(imgsnapshot).*255);
            obj.Miji3Dtif='allResults_Miji3Dtif.tif';
            imwrite(imgsnapshot,fullfile(obj.foldername,obj.Miji3Dtif));
            obj.saveClassObj;
        end

        function plotResults(obj)
            figurehandle=figure;
            screensize=get(groot,'ScreenSize');
            figurehandle.OuterPosition=screensize;
            x=linspace(0,obj.scan_size(2),obj.grid_size(2));y=linspace(0,obj.scan_size(1),obj.grid_size(1));z=pixel2range(obj);
            
            switch obj.experiment_type
                case 'HSC'
                    numbering={'1st','2nd','3rd','4th'};
                    load(fullfile(obj.foldername,obj.HSC_all));
                    
                    ax=subplot(5,9,1);plot(z,PCA_mu);axis(ax,'tight');ax.PlotBoxAspectRatio=[obj.scan_size(2),obj.scan_size(1),1];
                    ax.XLabel.String='\lambda (nm)';ax.YLabel.String='mean intensity (a.u.)';ax.XMinorTick='off';ax.YTick=[];
                    
                    ax=subplot(5,9,2);plot(PCA_explained(1:4));axis(ax,'tight');ax.PlotBoxAspectRatio=[obj.scan_size(2),obj.scan_size(1),1];
                    ax.XLabel.String='PC order';ax.YLabel.String='contribution (%)';ax.XMinorTick='off';ax.YMinorTick='on';axis(ax,[-inf,inf,0,100]);
%                     ax=subplot(5,9,2);plot(z,PCA_coeff(:,1:4));axis(ax,'tight');ax.PlotBoxAspectRatio=[obj.scan_size(2),obj.scan_size(1),1];
%                     ax.XLabel.String='\lambda (nm)';ax.YLabel.String='PC coefficient';ax.XMinorTick='off';%ax.YTick=[0];
%                     hlegend=legend(ax,'1st PC','2nd PC','3rd PC','4th PC');
%                     hlegend.Box='off';hlegend.Location='best';
                    
                    for i=1:4
                        ax=subplot(5,9,9*i+1);plot(z,PCA_coeff(:,i));axis(ax,'tight');ax.PlotBoxAspectRatio=[obj.scan_size(2),obj.scan_size(1),1];
                        ax.XLabel.String='\lambda (nm)';ax.YLabel.String=[numbering{i} ' PC coefficient'];ax.XMinorTick='off';%ax.YTick=[0];

                    end
                    
                    for i=3:9
                        ax=subplot(5,9,i);axis(ax,'off');
                    end
                    
                    for i=1:4
                        ax=subplot(5,9,9*i+2);imagesc(x,y,PCA_score(:,:,i));ax.DataAspectRatio=[1 1 1];
                        ax.XLabel.String='x (sample length /mm)';ax.YLabel.String='y (sample width /mm)';%ax.XTick=[];ax.YTick=[];
                        ax.Box='off';%ax.XColor=[1 1 1];ax.YColor=[1 1 1];ax.XLabel.Color=[0 0 0];ax.YLabel.Color=[0 0 0];
                        colormap(ax,jet(256));hc=colorbar(ax);
                        hc.Label.String=[numbering{i} ' PC intensity (a.u.)'];hc.Label.Rotation=270;hc.Label.VerticalAlignment='bottom';hc.Box='off';hc.Ticks=[];
                    end
                    
                    for i=1:4
                        ax=subplot(5,9,9*i+3);imagesc(x,y,PCA_result{i});ax.DataAspectRatio=[1 1 1];
                        ax.XLabel.String='x (sample length /mm)';ax.YLabel.String='y (sample width /mm)';%ax.XTick=[];ax.YTick=[];
                        ax.Box='off';%ax.XColor=[1 1 1];ax.YColor=[1 1 1];ax.XLabel.Color=[0 0 0];ax.YLabel.Color=[0 0 0];
                        colormap(ax,jet(256));hc=colorbar(ax);
                        hc.Label.String=[numbering{i} ' spectral peak intensity (a.u.)'];hc.Label.Rotation=270;hc.Label.VerticalAlignment='bottom';hc.Box='off';hc.Ticks=[];
                    end
                    
                    for ii=1:4
                        for jj=1:4
                            ax=subplot(5,9,9*ii+jj+5);imagesc(x,y,PCA_result16{ii*4-4+jj});ax.DataAspectRatio=[1 1 1];
                            ax.XLabel.String='x (sample length /mm)';ax.YLabel.String='y (sample width /mm)';%ax.XTick=[];ax.YTick=[];
                            ax.Box='off';%ax.XColor=[1 1 1];ax.YColor=[1 1 1];ax.XLabel.Color=[0 0 0];ax.YLabel.Color=[0 0 0];
                            colormap(ax,jet(256));hc=colorbar(ax);
                            if ii==jj
                                hc.Label.String=[numbering{ii} ' spectral peak intensity (a.u.)'];hc.Label.Rotation=270;hc.Label.VerticalAlignment='bottom';hc.Box='off';hc.Ticks=[];
                            else
                                hc.Label.String=[num2str(ii) '-' num2str(jj) ' inter-band intensity (a.u.)'];hc.Label.Rotation=270;hc.Label.VerticalAlignment='bottom';hc.Box='off';hc.Ticks=[];
                            end
                        end
                    end
                    Range{1}=[21:50];Range{2}=[71:110];Range{3}=[131:170];Range{4}=[191:230];
                    for k=1:4
                        Range{k}=pixel2range(obj,Range{k});EqualAreaResult{k}=pixel2range(obj,EqualAreaResult{k});%the extra calculation is for converting 1--320 pixel to 850--1750 nm
                        ax=subplot(5,9,9*k+4);imagehandle=imagesc(x,y,EqualAreaResult{k}(:,:,1));
                        imagehandle.AlphaDataMapping='scaled';imagehandle.AlphaData=PCA_result{k};ax.DataAspectRatio=[1 1 1];
                        caxis(ax,[min(Range{k})+(max(Range{k})-min(Range{k}))*3/8, max(Range{k})-(max(Range{k})-min(Range{k}))*3/8]);
                        ax.XLabel.String='x (sample length /mm)';ax.YLabel.String='y (sample width /mm)';%ax.XTick=[];ax.YTick=[];
                        ax.Box='off';%ax.XColor=[1 1 1];ax.YColor=[1 1 1];ax.XLabel.Color=[0 0 0];ax.YLabel.Color=[0 0 0];
                        colormap(ax,jet(256));hc=colorbar(ax);
                        hc.Label.String=[numbering{k} ' spectral peak position (nm)'];hc.Label.Rotation=270;hc.Label.VerticalAlignment='bottom';hc.Box='off';%hc.Ticks=[];
                        
                        ax=subplot(5,9,9*k+5);imagehandle=imagesc(x,y,EqualAreaResult{k}(:,:,3)-EqualAreaResult{k}(:,:,2)); %the extra calculation is for converting 1--320 pixel to 850--1750 nm
                        imagehandle.AlphaDataMapping='scaled';imagehandle.AlphaData=PCA_result{k};ax.DataAspectRatio=[1 1 1];
                        caxis(ax,[1, (max(Range{k})-min(Range{k}))/2]); %the extra calculation is for converting 1--320 pixel to 850--1750 nm
                        ax.XLabel.String='x (sample length /mm)';ax.YLabel.String='y (sample width /mm)';%ax.XTick=[];ax.YTick=[];
                        ax.Box='off';%ax.XColor=[1 1 1];ax.YColor=[1 1 1];ax.XLabel.Color=[0 0 0];ax.YLabel.Color=[0 0 0];
                        colormap 'jet(256)';hc=colorbar(ax);
                        hc.Label.String=[numbering{k} ' spectral peak width (nm)'];hc.Label.Rotation=270;hc.Label.VerticalAlignment='bottom';hc.Box='off';%hc.Ticks=[];
                    end
                    
                    figurehandle.PaperSize=[40 20];
                    figurehandle.PaperPosition=[0 0 40 20];
                    obj.Resultsfig='allResults_Resultsfig.fig';
                    obj.Resultseps='allResults_Resultseps.eps';
                    savefig(figurehandle, fullfile(obj.foldername,obj.Resultsfig),'compact');
                    spaceplots(figurehandle,[0.04 0.04 0.04 0.04],[0.04 0.04]);
                    print(figurehandle,fullfile(obj.foldername,obj.Resultseps),'-depsc','-tiff','-r300','-painters');
                    close(figurehandle);
                    
                case 'HDC'
                    load(fullfile(obj.foldername,obj.HDC_all));
                    
                    subplot(2,3,1);[ax,line1,line2]=plotyy(z,PCA_coeff(:,1)',z,PCA_mu);
                    axis(ax,'tight');ax(1).PlotBoxAspectRatio=[obj.scan_size(2) obj.scan_size(1) 1];ax(2).PlotBoxAspectRatio=[obj.scan_size(2) obj.scan_size(1) 1];
                    ax(1).XLabel.String='r (distance /mm)';ax(1).YLabel.String='PC coefficient';ax(2).YLabel.String='mean intensity (a.u.)';ax(2).YLabel.Rotation=270;ax(2).YLabel.VerticalAlignment='bottom';
                    ax(1).XMinorTick='on';ax(2).YTick=[];%ax(1).YTick=[0];
                    
                    ax=subplot(2,3,2);imagesc(x,y,PCA_score(:,:,1));ax.DataAspectRatio=[1,1,1];
                    ax.XLabel.String='x (sample length /mm)';ax.YLabel.String='y (sample width /mm)';%ax.XTick=[];ax.YTick=[];
                    ax.Box='off';%ax.XColor=[1 1 1];ax.YColor=[1 1 1];ax.XLabel.Color=[0 0 0];ax.YLabel.Color=[0 0 0];
                    colormap(ax,jet(256));hc=colorbar(ax);
                    hc.Label.String='PC intensity (a.u.)';hc.Label.Rotation=270;hc.Label.VerticalAlignment='bottom';hc.Box='off';%hc.Ticks=[];
                    
                    ax=subplot(2,3,3);imagehandle2=imagesc(x,y,pixel2range(obj,EqualAreaResult));   %the extra calculation is for converting 1--205 pixel distance to mm of view size
                    caxis(ax,[z(1),z(end)]);ax.DataAspectRatio=[1,1,1];
                    imagehandle2.AlphaDataMapping='scaled';imagehandle2.AlphaData=PCA_score(:,:,1);
                    ax.XLabel.String='x (sample length /mm)';ax.YLabel.String='y (sample width /mm)';%ax.XTick=[];ax.YTick=[];
                    ax.Box='off';%ax.XColor=[1 1 1];ax.YColor=[1 1 1];ax.XLabel.Color=[0 0 0];ax.YLabel.Color=[0 0 0];
                    colormap(ax,jet(256));hc=colorbar(ax);
                    hc.Label.String='scattering radius (mm)';hc.Label.Rotation=270;hc.Label.VerticalAlignment='bottom';hc.Box='off';%hc.Ticks=[];
                    
                    cbString={'max intensity (a.u.)','mean intensity (a.u.)','mean intensity (a.u.)'};
                    for i=1:3
                        ax=subplot(2,3,i+3);imagesc(x,y,PCA_result{i});ax.DataAspectRatio=[1,1,1];
                        ax.XLabel.String='x (sample length /mm)';ax.YLabel.String='y (sample width /mm)';%ax.XTick=[];ax.YTick=[];
                        ax.Box='off';%ax.XColor=[1 1 1];ax.YColor=[1 1 1];ax.XLabel.Color=[0 0 0];ax.YLabel.Color=[0 0 0];
                        colormap(ax,jet(256));hc=colorbar(ax);
                        hc.Label.String=cbString{i};hc.Label.Rotation=270;hc.Label.VerticalAlignment='bottom';hc.Box='off';%hc.Ticks=[];
                    end
                    
                    figurehandle.PaperSize=[20 10];
                    figurehandle.PaperPosition=[0 0 20 10];
                    obj.Resultsfig='allResults_Resultsfig.fig';
                    obj.Resultseps='allResults_Resultseps.eps';
                    savefig(figurehandle, fullfile(obj.foldername,obj.Resultsfig),'compact');
                    print(figurehandle,fullfile(obj.foldername,obj.Resultseps),'-depsc','-tiff','-r300','-painters');
                    close(figurehandle);
                otherwise
                    error('error determining experiment_type. %s', obj.experiment_type);
            end
            obj.saveClassObj;
        end
        
        function ROIresult=calculateROI(obj)
            
            switch obj.experiment_type
                case 'HSC'
                    load(fullfile(obj.foldername,obj.HSC_smooth));
                    load(fullfile(obj.foldername,obj.HSC_all));
                    hypercube=HSC_smooth;
                    
                    figure;imshow(mat2gray(squeeze(mean(hypercube,3))));
                    hROI=imfreehand;
                    position=uint16(wait(hROI));
                    
                    for i=1:size(position,1)
                        ROIresult(i,:)=hypercube(position(i,2),position(i,1),:);
                        for j=1:4
                            ROIEqualArea{j}(i,:)=EqualAreaResult{j}(position(i,2),position(i,1),:);
                        end
                    end
                    ROIresult=mean(ROIresult,1);
                    figure;plot(ROIresult);
                    for j=1:4
                        ROIEqualArea{j}=mean(ROIEqualArea{j},1);
                        fprintf('%6.1f %6.1f \n',pixel2range(obj,ROIEqualArea{j}(1)),pixel2range(obj,ROIEqualArea{j}(3))-pixel2range(obj,ROIEqualArea{j}(2)));
                    end
                    
                case 'HDC'
                    load(fullfile(obj.foldername,obj.HDC_smooth));
                    load(fullfile(obj.foldername,obj.HDC_all));
                    hypercube=HDC_smooth;
                    
                    figure;imshow(mat2gray(squeeze(mean(hypercube,3))));
                    hROI=imfreehand;
                    position=uint16(wait(hROI));
                    
                    for i=1:size(position,1)
                        ROIresult(i,:)=hypercube(position(i,2),position(i,1),:);
                        ROIEqualArea(i,1)=EqualAreaResult(position(i,2),position(i,1));
                    end
                    ROIresult=mean(ROIresult,1);
                    figure;plot(ROIresult);
                    ROIEqualArea=mean(ROIEqualArea,1);
                    disp(pixel2range(obj,ROIEqualArea));
                    
                    
                otherwise
                    error('error determining experiment_type. %s', obj.experiment_type);
            end
            
        end
        
        
        function pointcloud_processing(obj)
            temp=fullfile(obj.foldername,'*.ply');
            fileList=dir(temp);
            switch size(fileList(:),1)
                case 0
                    disp('no *.ply file in the folder.');
                    obj.pointcloud_surface='allResults_pointcloud_surface.mat';
                    Xasis=-40:obj.view_size:60;Yaxis=-40:obj.view_size:40;
                    [Xgrid,Ygrid]=meshgrid(Xaxis,Yaxis);
                    pointcloud_surface(:,:,1)=Xgrid;
                    pointcloud_surface(:,:,2)=Ygrid;
                    pointcloud_surface(:,:,3)=zeros(size(Xgrid));
                    pointcloud_surface(:,:,4:6)=zeros([size(Xgrid),3])+1;
                    save(fullfile(obj.foldername,obj.pointcloud_surface),'pointcloud_surface');
                    return;
                case 1
                    obj.pointcloud_ply=fileList(1).name;
                    obj.pointcloud_surface='allResults_pointcloud_surface.mat';
                otherwise
                    disp('more than one *.ply files found. using the first to calculate.');
                    obj.pointcloud_ply=fileList(1).name;
                    obj.pointcloud_surface='allResults_pointcloud_surface.mat';
            end
            pointcloud_rawdata=pcread(fullfile(obj.foldername,obj.pointcloud_ply));
            pointcloud_xyzrgb=[double(pointcloud_rawdata.Location),double(pointcloud_rawdata.Color)./255];
            pointcloud_xyzrgb=pointcloud_xyzrgb(:,[1,2,3,4,5,6]); %change x,y,z columns to right order
            pointcloud_xyzrgb(:,1:3)=pointcloud_xyzrgb(:,1:3)-repmat([min(pointcloud_xyzrgb(:,1)),min(pointcloud_xyzrgb(:,2)),max(pointcloud_xyzrgb(:,3))],pointcloud_rawdata.Count,1);  %put x,y zero points on the corner and z zero point to highest location
            
            tform=cp2tform(obj.moving_points,obj.fixed_points,'affine');
            [pointcloud_xyzrgb(:,1),pointcloud_xyzrgb(:,2)]=tformfwd(tform,pointcloud_xyzrgb(:,1),pointcloud_xyzrgb(:,2));
            
            xyzmin=min(pointcloud_xyzrgb);xyzmax=max(pointcloud_xyzrgb);
            Xaxis=[xyzmin(1):obj.view_size:xyzmax(1)];Yaxis=[xyzmin(2):obj.view_size:xyzmax(2)]; %this meshgrid has a density equivalent to the pixel density measured on camera for each frame
            [Xgrid,Ygrid]=meshgrid(Xaxis,Yaxis);
            
            pointcloud_surface(:,:,1)=Xgrid;pointcloud_surface(:,:,2)=Ygrid;
            pointcloud_surface(:,:,3:6)=NaN([size(Xgrid),4]); %3,4,5,6 pages are z,r,g,b respectively.
            pointcloud_surface(:,:,7)=zeros(size(Xgrid));  %7 is the counter for each grid
            for i=1:pointcloud_rawdata.Count
                xindex=floor((pointcloud_xyzrgb(i,1)-Xaxis(1))/(Xaxis(2)-Xaxis(1)))+1;
                yindex=floor((pointcloud_xyzrgb(i,2)-Yaxis(1))/(Yaxis(2)-Yaxis(1)))+1;
                if isnan(pointcloud_surface(yindex,xindex,3))
                    pointcloud_surface(yindex,xindex,3:6)=reshape(pointcloud_xyzrgb(i,3:6),1,1,4);
                else
                    pointcloud_surface(yindex,xindex,3:6)=pointcloud_surface(yindex,xindex,3:6)+reshape(pointcloud_xyzrgb(i,3:6),1,1,4);
                end
                pointcloud_surface(yindex,xindex,7)=pointcloud_surface(yindex,xindex,7)+1;
            end
            pointcloud_surface(:,:,3:6)=pointcloud_surface(:,:,3:6)./repmat(pointcloud_surface(:,:,7),1,1,4);
            
            nanindex=isnan(pointcloud_surface(:,:,3));
            newX=Xgrid(~nanindex);
            newY=Ygrid(~nanindex);
            
            for i=3:6
                temp=pointcloud_surface(:,:,i);
                new_temp=temp(~nanindex);
                F=scatteredInterpolant(newX,newY,new_temp,'linear','nearest');
                interp_temp=F(Xgrid,Ygrid);
                pointcloud_surface(:,:,i)=interp_temp;
            end
            
            pointcloud_surface(:,:,3)=pointcloud_surface(:,:,3)-max(max(pointcloud_surface(:,:,3)));
            
            zmin=(pointcloud_surface(1,1,3)+pointcloud_surface(1,end,3)+pointcloud_surface(end,1,3)+pointcloud_surface(end,end,3))/4;
            
            for i=1:size(pointcloud_surface,1)
                for j=1:size(pointcloud_surface,2)
                    if pointcloud_surface(i,j,3)<zmin
                        pointcloud_surface(i,j,3)=zmin;
                    end
                end
            end
            
            save(fullfile(obj.foldername,obj.pointcloud_surface),'pointcloud_surface');
            figurehandle=figure;
            hsurf=surf(pointcloud_surface(:,:,1),pointcloud_surface(:,:,2),pointcloud_surface(:,:,3),pointcloud_surface(:,:,4:6));
            ax=gca;
            hsurf.LineStyle='none';hsurf.FaceColor='interp';hsurf.FaceLighting='gouraud';hsurf.BackFaceLighting='lit';
            daspect([1 1 1]);axis tight;camlight left;view(ax,-33,36);ax.YDir='reverse';
            ax.XLabel.String='x (sample length /mm)';ax.YLabel.String='y (sample width /mm)';ax.ZLabel.String='z (sample height /mm)';
            ax.TickLength=[0.01 0.01];ax.Box='on';ax.BoxStyle='full';
            
            obj.surfacefig='allResults_pointcloud_surfacefig.fig';obj.surfaceeps='allResults_pointcloud_surfaceeps.eps';
            savefig(figurehandle,fullfile(obj.foldername,obj.surfacefig),'compact');
            print(figurehandle,fullfile(obj.foldername,obj.surfaceeps),'-depsc','-tiff','-r300','-opengl');
            close(figurehandle);
            obj.saveClassObj;
        end

        function calculate3D(obj)
%             function dummy=calculateHDCdepth(depth,tempframe)
%                 dummy=0;
%                 for ii=1:size(tempframe,1)
%                     for jj=1:size(tempframe,2)
%                         if isnan(tempframe(ii,jj,3))
%                         else
%                             tempintensity=tempframe(centerY,centerX,4)*(tempframe(centerY,centerX,3)-depth)^3/((tempframe(ii,jj,1)-tempframe(centerY,centerX,1))^2+(tempframe(ii,jj,2)-tempframe(centerY,centerX,2))^2+(tempframe(ii,jj,3)-depth)^2)^1.5;
%                             dummy=dummy+(tempframe(ii,jj,4)-tempintensity)^2;
%                         end
%                     end
%                 end
%             end
            
            switch obj.experiment_type
                case 'HSC'
                    load(fullfile(obj.foldername,obj.HSC_smooth));
                    load(fullfile(obj.foldername,obj.HSC_all));
                    load(fullfile(obj.foldername,obj.pointcloud_surface),'pointcloud_surface');
                    FinterpHeight=scatteredInterpolant(reshape(pointcloud_surface(:,:,1),[],1),reshape(pointcloud_surface(:,:,2),[],1),reshape(pointcloud_surface(:,:,3),[],1),'linear','linear');
                    zmax=max(max(pointcloud_surface(:,:,3)));zmin=min(min(pointcloud_surface(:,:,3)));
                    
                    HSC_3D=NaN(obj.grid_size(1),obj.grid_size(2),4); %HSC_3D, first page to store intensity information, second page to store height of fluorescent signal, (third intensity, fourth height from another band).
                    x=linspace(0,obj.scan_size(2),obj.grid_size(2));y=linspace(0,obj.scan_size(1),obj.grid_size(1));
                    
                    screeningmatrix{1}=mat2gray(PCA_result{2}(:,:));
                    screeningmatrix{2}=mat2gray(PCA_result{4}(:,:));
                    
                    for i=1:obj.grid_size(1)
                        for j=1:obj.grid_size(2)
                            if screeningmatrix{1}(i,j)>=0.2
                                height=FinterpHeight(x(j),y(i));
                                
                                depth=polyfit(-log(squeeze(HSC_smooth(i,j,obj.range{2}))./obj.emspectrum0(obj.range{2})'),obj.extincoeff(obj.range{2}),1);
                                
                                %depth=FinterpDepth1100Er(EqualAreaResult{2}(i,j));
                                HSC_3D(i,j,2)=height-depth(1);
                                HSC_3D(i,j,1)=screeningmatrix{1}(i,j);
                            end
                            if screeningmatrix{2}(i,j)>=0.2
                                height=FinterpHeight(x(j),y(i));
                                
                                depth=polyfit(-log(squeeze(HSC_smooth(i,j,obj.range{4}))./obj.emspectrum0(obj.range{4})'),obj.extincoeff(obj.range{4}),1);
                                %depth=FinterpDepth1500Er(EqualAreaResult{4}(i,j));
                                HSC_3D(i,j,4)=height-depth;
                                HSC_3D(i,j,3)=screeningmatrix{2}(i,j);
                            end

                        end
                    end
                    
                    obj.HSC_3D='allResults_HSC_3D.mat';
                    save(fullfile(obj.foldername,obj.HSC_3D),'HSC_3D');
                    
                case 'HDC'
                    try
                        load(fullfile(obj.foldername,obj.allframes),'allframes','globalmax','globalmin');
                        allframes=(single(allframes)/65535)*(globalmax-globalmin)+globalmin;
                    catch
                        load(fullfile(obj.foldername,obj.allframes),'allframes');
                    end
                    
                    load(fullfile(obj.foldername,obj.HDC_all),'PCA_score','EqualAreaResult');
                    load(fullfile(obj.foldername,obj.pointcloud_surface),'pointcloud_surface');
                    FinterpHeight=scatteredInterpolant(reshape(pointcloud_surface(:,:,1),[],1),reshape(pointcloud_surface(:,:,2),[],1),reshape(pointcloud_surface(:,:,3),[],1),'linear','linear');
                    zmax=max(max(pointcloud_surface(:,:,3)));zmin=min(min(pointcloud_surface(:,:,3)));
                    
                    sizeallframes=size(allframes);
                    HDC_3D=NaN(obj.grid_size(1),obj.grid_size(2),2); %HDC_3D, first page to store intensity information, second page to store height of fluorescent signal.
                    x=linspace(0,obj.scan_size(2),obj.grid_size(2));y=linspace(0,obj.scan_size(1),obj.grid_size(1));
                    %options=optimoptions('fmincon','Display','notify');
                    
                    screeningmatrix=mat2gray(squeeze(PCA_score(:,:,1)));
                    
                    for i=45:55%1:obj.grid_size(1)
                        fprintf('%d',i);
                        for j=110:130%1:obj.grid_size(2)
                            if screeningmatrix(i,j)>=0.01
                                Xaxis=linspace(x(j)-127.5*obj.view_size,x(j)+127.5*obj.view_size,256);Yaxis=linspace(y(i)-159.5*obj.view_size,y(i)+159.5*obj.view_size,320);
                                [Xgrid,Ygrid]=meshgrid(Xaxis,Yaxis);
                                tempframe{1}=Xgrid;tempframe{2}=Ygrid;
                                tempframe{3}=FinterpHeight(Xgrid,Ygrid);
                                tempframe{4}=rot90(allframes(:,:,1,i,j));
                                centerX=floor((size(tempframe{1},2)+1)/2);
                                centerY=floor((size(tempframe{1},1)+1)/2);
                                %fdepth=@(x)calculateHDCdepth(x,tempframe);
                                %[HDC_3D(i,j,2),~]=fmincon(fdepth,(zmin+tempframe(centerY,centerX,3))/2,[],[],[],[],zmin,tempframe(centerY,centerX,3),[],options);
                                depth=tempframe{3}(centerY,centerX):-1:zmin;
                                clear dummy;
                                thresholdindex=(mat2gray(tempframe{4})>=0.5);
                                parfor k=1:size(depth(:),1)
                                    tempsquare = (tempframe{4}(centerY,centerX).*(tempframe{3}(centerY,centerX)-depth(k)).^3./((tempframe{1}(thresholdindex)-tempframe{1}(centerY,centerX)).^2+(tempframe{2}(thresholdindex)-tempframe{2}(centerY,centerX)).^2+(tempframe{3}(thresholdindex)-depth(k)).^2).^1.5-tempframe{4}(thresholdindex)).^2;
                                    dummy(k)=sum(tempsquare(~isnan(tempsquare)));
                                end
                                try
                                [~,minindex]=min(dummy);
                                catch
                                    HDC_3D(i,j,2)=tempframe{3}(centerY,centerX);
                                end
                                if isnan(HDC_3D(i,j,2))
                                HDC_3D(i,j,2)=depth(minindex);
                                disp(depth(minindex));
                                end
                                
                                temptrueintensity=tempframe{4}(thresholdindex).*((tempframe{1}(thresholdindex)-tempframe{1}(centerY,centerX)).^2+(tempframe{2}(thresholdindex)-tempframe{2}(centerY,centerX)).^2+(tempframe{3}(thresholdindex)-HDC_3D(i,j,2)).^2).^1.5;
                                HDC_3D(i,j,1)=mean(temptrueintensity(:));
                            end
                        end
                    end
                    obj.HDC_3D='allResults_HDC_3D.mat';
                    save(fullfile(obj.foldername,obj.HDC_3D),'HDC_3D');
                otherwise
                    error('error determining experiment_type. %s', obj.experiment_type);
            end
            obj.saveClassObj;
        end
        function plot3D_Reconstruction(obj)
            switch obj.experiment_type
                
                case 'HSC'
                    
                case 'HDC'
                    load(fullfile(obj.foldername,obj.HDC_3D));
                    load(fullfile(obj.foldername,obj.pointcloud_surface),'pointcloud_surface');
                    obj.Reconstruct3Dfig='allResults_Reconstruct3Dfig.fig';
                    obj.Reconstruct3Deps='allResults_Reconstruct3Deps.eps';
                    
                    pointcloud_surface=imresize(pointcloud_surface,0.25);
                    
                    x=linspace(0,obj.scan_size(2),obj.grid_size(2));y=linspace(0,obj.scan_size(1),obj.grid_size(1));
                    [X,Y]=meshgrid(x,y);
                    
                    figurehandle=figure;
                    subplot(5,3,1);
                    hsurf=surf(pointcloud_surface(:,:,1),pointcloud_surface(:,:,2),pointcloud_surface(:,:,3),pointcloud_surface(:,:,4:6));
                    hsurf.LineStyle='none';hsurf.FaceColor='interp';hsurf.FaceLighting='gouraud';hsurf.BackFaceLighting='lit';hsurf.FaceAlpha=1;
                    ax=gca;ax.DataAspectRatio=[1 1 1];
                    view(ax,147,36);
                    %view(ax,-33,36);
                    %ax.Color=[1 1 1].*0.9;ax.GridLineStyle='-.';
                    axis(ax,[x(1),x(end),y(1),y(end),min(min(pointcloud_surface(:,:,3))),max(max(pointcloud_surface(:,:,3)))]);
                    ax.TickLength=[0.01 0.01];ax.YDir='reverse';%ax.FontSize=20;
                    ax.Box='on';ax.BoxStyle='back';%ax.XColor=[1 1 1];ax.YColor=[1 1 1];ax.XLabel.Color=[0 0 0];ax.YLabel.Color=[0 0 0];
                    %zlim([-35 0]);
                    camlight headlight;
                    
                    subplot(5,3,2);
                    hsurf=surf(X,Y,HDC_3D(:,:,2),HDC_3D(:,:,1),'LineStyle','none','CDataMapping','scaled','AlphaData',HDC_3D(:,:,1),'AlphaDataMapping','scaled','FaceColor','interp','FaceAlpha','interp');
                    ax=gca;ax.DataAspectRatio=[1 1 1];
                    view(ax,147,36);
                    %view(ax,-33,36);
                    %ax.Color=[1 1 1].*0.9;ax.GridLineStyle='-.';
                    axis(ax,[x(1),x(end),y(1),y(end),min(min(pointcloud_surface(:,:,3))),max(max(pointcloud_surface(:,:,3)))]);
                    ax.TickLength=[0.01 0.01];ax.YDir='reverse';%ax.FontSize=20;
                    ax.Box='on';ax.BoxStyle='back';%ax.XColor=[1 1 1];ax.YColor=[1 1 1];ax.XLabel.Color=[0 0 0];ax.YLabel.Color=[0 0 0];
                    %zlim([-35 0]);
                    
                    
                    subplot(5,3,[4,12]);
                    %hsurf=surf(X,Y,medfilt2(HDC_3D(:,:,2),[3 3]),HDC_3D(:,:,1),'LineStyle','none','CDataMapping','scaled','AlphaData',HDC_3D(:,:,1),'AlphaDataMapping','scaled','FaceColor','interp','FaceAlpha','interp');
                    hsurf=surf(X,Y,HDC_3D(:,:,2),HDC_3D(:,:,1),'LineStyle','none','CDataMapping','scaled','AlphaData',HDC_3D(:,:,1),'AlphaDataMapping','scaled','FaceColor','interp','FaceAlpha','interp');
                    ax=gca;ax.DataAspectRatio=[1 1 1];
                    view(ax,147,36);
                    %view(ax,-33,36);
                    %ax.Color=[1 1 1].*0.9;ax.GridLineStyle='-.';
                    axis(ax,[x(1),x(end),y(1),y(end),min(min(pointcloud_surface(:,:,3))),max(max(pointcloud_surface(:,:,3)))]);
                    ax.XLabel.String='length (mm)';ax.YLabel.String='width (mm)';ax.ZLabel.String='height (mm)';%ax.XTickLabel=[];ax.YTickLabel=[];ax.ZTickLabel=[];%ax.XTick=[];ax.YTick=[];ax.ZTick=[];
                    ax.TickLength=[0.01 0.01];ax.YDir='reverse';%ax.FontSize=20;
                    ax.Box='on';ax.BoxStyle='back';%ax.XColor=[1 1 1];ax.YColor=[1 1 1];ax.XLabel.Color=[0 0 0];ax.YLabel.Color=[0 0 0];
                    %zlim([-35 0]);
                    colormap(ax,jet(256));hc=colorbar;
                    hc.Label.String='intensity (a.u.)';hc.Label.Rotation=270;hc.Label.VerticalAlignment='bottom';hc.Box='off';%hc.Ticks=[];
                    hsurf.FaceLighting='gouraud';hsurf.BackFaceLighting='lit';camlight headlight;
                    hold on
                    hsurf=surf(pointcloud_surface(:,:,1),pointcloud_surface(:,:,2),pointcloud_surface(:,:,3),pointcloud_surface(:,:,4:6));
                    hsurf.LineStyle='none';hsurf.FaceColor='interp';hsurf.FaceLighting='gouraud';hsurf.BackFaceLighting='lit';hsurf.FaceAlpha=0.2;
                    hold off
                    
                    subplot(5,3,13);
                    %hsurf=surf(X,Y,medfilt2(HDC_3D(:,:,2),[3 3]),HDC_3D(:,:,1),'LineStyle','none','CDataMapping','scaled','AlphaData',HDC_3D(:,:,1),'AlphaDataMapping','scaled','FaceColor','interp','FaceAlpha','interp');
                    hsurf=surf(X,Y,HDC_3D(:,:,2),HDC_3D(:,:,1),'LineStyle','none','CDataMapping','scaled','AlphaData',HDC_3D(:,:,1),'AlphaDataMapping','scaled','FaceColor','interp','FaceAlpha','interp');
                    ax=gca;ax.DataAspectRatio=[1 1 1];
                    %view(ax,147,36);
                    %ax.Color=[1 1 1].*0.9;ax.GridLineStyle='-.';
                    axis(ax,[x(1),x(end),y(1),y(end),min(min(pointcloud_surface(:,:,3))),max(max(pointcloud_surface(:,:,3)))]);
                    ax.TickLength=[0.01 0.01];ax.YDir='reverse';%ax.FontSize=20;
                    ax.Box='on';ax.BoxStyle='back';%ax.XColor=[1 1 1];ax.YColor=[1 1 1];ax.XLabel.Color=[0 0 0];ax.YLabel.Color=[0 0 0];
                    %zlim([-35 0]);
                    hold on
                    hsurf=surf(pointcloud_surface(:,:,1),pointcloud_surface(:,:,2),pointcloud_surface(:,:,3),pointcloud_surface(:,:,4:6));
                    hsurf.LineStyle='none';hsurf.FaceColor='interp';hsurf.FaceAlpha=0.2;
                    hold off
                    view(ax,0,90);

                    
                    subplot(5,3,14);
                    %hsurf=surf(X,Y,medfilt2(HDC_3D(:,:,2),[3 3]),HDC_3D(:,:,1),'LineStyle','none','CDataMapping','scaled','AlphaData',HDC_3D(:,:,1),'AlphaDataMapping','scaled','FaceColor','interp','FaceAlpha','interp');
                    hsurf=surf(X,Y,HDC_3D(:,:,2),HDC_3D(:,:,1),'LineStyle','none','CDataMapping','scaled','AlphaData',HDC_3D(:,:,1),'AlphaDataMapping','scaled','FaceColor','interp','FaceAlpha','interp');
                    ax=gca;ax.DataAspectRatio=[1 1 1];
                    %view(ax,147,36);
                    view(ax,0,0);
                    %ax.Color=[1 1 1].*0.9;ax.GridLineStyle='-.';
                    axis(ax,[x(1),x(end),y(1),y(end),min(min(pointcloud_surface(:,:,3))),max(max(pointcloud_surface(:,:,3)))]);
                    ax.TickLength=[0.01 0.01];ax.YDir='reverse';%ax.FontSize=20;
                    ax.Box='on';ax.BoxStyle='back';%ax.XColor=[1 1 1];ax.YColor=[1 1 1];ax.XLabel.Color=[0 0 0];ax.YLabel.Color=[0 0 0];
                    %zlim([-35 0]);
                    hold on
                    hsurf=surf(pointcloud_surface(:,:,1),pointcloud_surface(:,:,2),pointcloud_surface(:,:,3),pointcloud_surface(:,:,4:6));
                    hsurf.LineStyle='none';hsurf.FaceColor='interp';hsurf.FaceAlpha=0.1;
                    hold off

                    subplot(5,3,15);
                    %hsurf=surf(X,Y,medfilt2(HDC_3D(:,:,2),[3 3]),HDC_3D(:,:,1),'LineStyle','none','CDataMapping','scaled','AlphaData',HDC_3D(:,:,1),'AlphaDataMapping','scaled','FaceColor','interp','FaceAlpha','interp');
                    hsurf=surf(X,Y,HDC_3D(:,:,2),HDC_3D(:,:,1),'LineStyle','none','CDataMapping','scaled','AlphaData',HDC_3D(:,:,1),'AlphaDataMapping','scaled','FaceColor','interp','FaceAlpha','interp');
                    ax=gca;ax.DataAspectRatio=[1 1 1];
                    %view(ax,147,36);
                    view(ax,90,0);
                    %ax.Color=[1 1 1].*0.9;ax.GridLineStyle='-.';
                    axis(ax,[x(1),x(end),y(1),y(end),min(min(pointcloud_surface(:,:,3))),max(max(pointcloud_surface(:,:,3)))]);
                    ax.TickLength=[0.01 0.01];ax.YDir='reverse';%ax.FontSize=20;
                    ax.Box='on';ax.BoxStyle='back';%ax.XColor=[1 1 1];ax.YColor=[1 1 1];ax.XLabel.Color=[0 0 0];ax.YLabel.Color=[0 0 0];
                    %zlim([-35 0]);
                    hold on
                    hsurf=surf(pointcloud_surface(:,:,1),pointcloud_surface(:,:,2),pointcloud_surface(:,:,3),pointcloud_surface(:,:,4:6));
                    hsurf.LineStyle='none';hsurf.FaceColor='interp';hsurf.FaceAlpha=0.1;
                    hold off
                    
                    figurehandle.PaperSize=[10 10];figurehandle.PaperPosition=[0 0 10 10];
                    savefig(figurehandle, fullfile(obj.foldername,obj.Reconstruct3Dfig),'compact');
                    %print(figurehandle,fullfile(obj.foldername,obj.Reconstruct3Deps),'-depsc','-tiff','-r300','-painters');
                    print(figurehandle,fullfile(obj.foldername,'allResults_Reconstruct3Deps.pdf'),'-dpdf','-r300','-painters');
                    
                    close(figurehandle);
                    
                otherwise
                    error('error determining experiment_type. %s', obj.experiment_type);
            end
            obj.saveClassObj;
            
        end

        function movieLevel1Data(obj)
            load(fullfile(obj.foldername,obj.Level1DataMatrix));
            
            try
                load(fullfile(obj.foldername,obj.allframes),'allframes','globalmax','globalmin');
                allframes=(single(allframes)/65535)*(globalmax-globalmin)+globalmin;
            catch
                load(fullfile(obj.foldername,obj.allframes),'allframes');
            end
            
            sizeLevel1=size(Level1DataMatrix);globalmin=min(Level1DataMatrix(:));globalmax=max(Level1DataMatrix(:));
            figurehandle=figure;screensize=get(groot,'ScreenSize');figurehandle.OuterPosition=screensize;
            Level1temp=NaN(sizeLevel1);
            writerObj = VideoWriter(fullfile(obj.foldername,'allResults_Level1Movie'),'Motion JPEG AVI');writerObj.FrameRate=60;open(writerObj);
            x=linspace(0,obj.scan_size(2),obj.grid_size(2));y=linspace(0,obj.scan_size(1),obj.grid_size(1));z=pixel2range(obj);
            SmoothSpan=0.1;SmoothMethodValue='loess';
            for i=1:sizeLevel1(4)*sizeLevel1(5)
                [ncol,nrow]=ind2sub([sizeLevel1(5) sizeLevel1(4)],i);
                if mod(nrow,2)==0
                    ncol=sizeLevel1(5)+1-ncol;              %to make the reverse scan direction on even rows
                end
                Level1temp(:,:,1,nrow,ncol)=Level1DataMatrix(:,:,1,nrow,ncol);
                ax=subplot(2,2,1);    %raw frame
                tempframe=squeeze(allframes(:,:,1,nrow*4-2,ncol*4-2));
                imagesc(tempframe);caxis(ax,[globalmin globalmax]);ax.DataAspectRatio=[1 1 1];
                ax.XLabel.String='a (detector pixel)';ax.YLabel.String='b (detector pixel)';
                ax.Box='off';ax.FontSize=20;ax.Title.String='raw frames captured';ax.Title.FontWeight='normal';
                colormap(ax,jet(256));hc=colorbar(ax);
                hc.Label.String='signal intensity (a.u.)';hc.Label.Rotation=270;hc.Label.VerticalAlignment='bottom';hc.Box='off';
                ax=subplot(2,2,2); %processed spectrum
                tempprocessed=frameprocess(obj,tempframe);
                plot(z,smooth(tempprocessed,SmoothSpan,SmoothMethodValue));ax.PlotBoxAspectRatio=[obj.scan_size(2),obj.scan_size(1),1];
                ax.YLabel.String='mean intensity (a.u.)';axis(ax,[z(1),z(end),globalmin,globalmax]);
                ax.FontSize=20;ax.Title.FontWeight='normal';
                switch obj.experiment_type
                    case 'HSC'
                        ax.XLabel.String='\lambda (nm)';ax.Title.String='processed spectra';
                    case 'HDC'
                        ax.XLabel.String='r (distance /mm)';ax.Title.String='processed diffuse data';
                end
                ax=subplot(2,2,[3,4]);     %demonstrating the scanning process
                hmontage=montage(reshape(permute(Level1temp,[1 2 3 5 4]),sizeLevel1(1),sizeLevel1(2),1,[]),'DisplayRange',[],'Size',[sizeLevel1(4) sizeLevel1(5)]); %due to the order of dimension that reshape and montage taking place, the matrix has to be reshaped first
                hmontage.XData=[x(1),x(end)];hmontage.YData=[y(1),y(end)];  %rescaling x,y, axis function below is also required
                hmontage.AlphaData=~isnan(hmontage.CData);axis(ax,[x(1),x(end),y(1),y(end),-inf,inf,globalmin globalmax]);
                ax.DataAspectRatio=[sizeLevel1(2) sizeLevel1(1) 1];
                ax.XLabel.String='x (sample length /mm)';ax.YLabel.String='y (sample width /mm)';ax.Box='off';
                colormap(ax,jet(256));hc=colorbar(ax);
                hc.Label.String='signal intensity (a.u.)';hc.Label.Rotation=270;hc.Label.VerticalAlignment='bottom';hc.Box='off';
                ax.FontSize=20;ax.Title.String='sample scanning';ax.Title.FontWeight='normal';
                frame=getframe(figurehandle);
                writeVideo(writerObj,frame);
            end
            close(figurehandle);close(writerObj);
        end
        function movieMontage_and_3D(obj)
            switch obj.experiment_type
                case 'HSC'
                    load(fullfile(obj.foldername,obj.HSC),'HSC');
                    hypercube=HSC;
                case 'HDC'
                    load(fullfile(obj.foldername,obj.HDC),'HDC');
                    hypercube=HDC;
                otherwise
                    error('error determining experiment_type. %s', obj.experiment_type);
            end
            figurehandle=figure;screensize=get(groot,'ScreenSize');figurehandle.OuterPosition=screensize;
            sizehypercube=size(hypercube);globalmin=min(hypercube(:));globalmax=max(hypercube(:));
            writerObj = VideoWriter(fullfile(obj.foldername,'allResults_Montage_and_3D'),'Motion JPEG AVI');
            writerObj.FrameRate=sizehypercube(3)/20;      %make video of 20 second
            open(writerObj);
            x=linspace(0,obj.scan_size(2),obj.grid_size(2));y=linspace(0,obj.scan_size(1),obj.grid_size(1));z=pixel2range(obj);
            [X,Y,Z]=meshgrid(x,y,z);
            for i=1:sizehypercube(3)
                ax=subplot(1,2,2);imagesc(x,y,hypercube(:,:,i));ax.DataAspectRatio=[1 1 1];
                ax.XLabel.String='x (sample length /mm)';ax.YLabel.String='y (sample width /mm)';%ax.XTick=[];ax.YTick=[];
                ax.Box='off';%ax.XColor=[1 1 1];ax.YColor=[1 1 1];ax.XLabel.Color=[0 0 0];ax.YLabel.Color=[0 0 0];
                colormap(ax,jet(256));hc=colorbar;
                hc.Label.String='signal intensity (a.u.)';hc.Label.Rotation=270;hc.Label.VerticalAlignment='bottom';hc.Box='off';%hc.Ticks=[];
                caxis(ax,[globalmin globalmax]);
                ax.FontSize=20;
                
                ax=subplot(1,2,1);hslice1=slice(X,Y,Z,hypercube,[],[],z(i));colormap(ax,jet(256));view(ax,-33,36);
                axis(ax,[x(1),x(end),y(1),y(end),z(1),z(end),globalmin,globalmax]);
                ax.YDir='reverse';ax.PlotBoxAspectRatio=[obj.scan_size(2),obj.scan_size(1),obj.scan_size(2)];%axis(ax,'tight');
                for j=1:size(hslice1(:),1)
                    hslice1(j).LineStyle='none';hslice1(j).FaceColor='interp';hslice1(j).FaceAlpha=1;
                    hslice1(j).CDataMapping='scaled';%hslice1(j).AlphaData=hslice1(j).CData;hslice1(j).AlphaDataMapping='scaled';
                end
                hc1=colorbar;hc1.Label.String='signal intensity (a.u.)';hc1.Label.Rotation=270;hc1.Label.VerticalAlignment='bottom';hc1.Box='off';%hc1.Ticks=[];
                ax.XLabel.String='x (sample length /mm)';ax.YLabel.String='y (sample width /mm)';%ax.XTick=[];ax.YTick=[];ax.ZTick=[];
                switch obj.experiment_type
                    case 'HSC'
                        ax.ZLabel.String='\lambda (nm)';ax.Title.String='slicing hyperspectral cube at wavelengths';
                    case 'HDC'
                        ax.ZLabel.String='r (distance /mm)';ax.Title.String='slicing hyperdiffuse cube at distance';
                end
                ax.Box='on';ax.BoxStyle='full';ax.Title.FontWeight='normal';
                ax.FontSize=20;
                frame=getframe(figurehandle);writeVideo(writerObj,frame);
            end
            close(figurehandle);close(writerObj);
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
        function tempprocessed=frameprocess(obj,tempframe)
            switch obj.experiment_type
                case 'HSC'
                    tempprocessed=mean(tempframe(obj.detector_ROI(1):obj.detector_ROI(2),obj.detector_ROI(3):obj.detector_ROI(4)))-mean(tempframe([1:obj.detector_ROI(1)-1,obj.detector_ROI(2)+1:end],obj.detector_ROI(3):obj.detector_ROI(4)));
                    tempprocessed=tempprocessed';
                case 'HDC'
                    load('distancemap.MAT','distancemap');
                    tempprocessed=zeros(1,size(distancemap(:),1));
                    for kk=1:size(distancemap(:),1)
                        tempprocessed(1,kk)=mean(tempframe(distancemap{kk}));  %linear indexing of array is much faster
                    end
                otherwise
                    error('error determining experiment_type. %s', obj.experiment_type);
            end
        end
    end
end
