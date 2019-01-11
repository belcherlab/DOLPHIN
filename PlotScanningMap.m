function varargout = PlotScanningMap(varargin)
% PLOTSCANNINGMAP MATLAB code for PlotScanningMap.fig
%      PLOTSCANNINGMAP, by itself, creates a new PLOTSCANNINGMAP or raises the existing
%      singleton*.
%
%      H = PLOTSCANNINGMAP returns the handle to a new PLOTSCANNINGMAP or the handle to
%      the existing singleton*.
%
%      PLOTSCANNINGMAP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOTSCANNINGMAP.M with the given input arguments.
%
%      PLOTSCANNINGMAP('Property','Value',...) creates a new PLOTSCANNINGMAP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PlotScanningMap_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PlotScanningMap_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PlotScanningMap

% Last Modified by GUIDE v2.5 08-Oct-2014 04:59:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @PlotScanningMap_OpeningFcn, ...
    'gui_OutputFcn',  @PlotScanningMap_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
end


% --- Executes just before PlotScanningMap is made visible.
function PlotScanningMap_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PlotScanningMap (see VARARGIN)

% Choose default command line output for PlotScanningMap
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PlotScanningMap wait for user response (see UIRESUME)
% uiwait(handles.figurePlotScanningMap);
end

% --- Outputs from this function are returned to the command line.
function varargout = PlotScanningMap_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on button press in pushbuttonPlotSpectralMap.
function pushbuttonPlotSpectralMap_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPlotSpectralMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%FileFullName=input('Please input the full file name\n','s');
FileFullName=[get(handles.editSpectralFilePath,'String') get(handles.editSpectralFileName,'String')];
%FirstLine=input('Please input the first line number\n','s');
FirstLine=str2num(get(handles.editFirstLineNumber,'String'));
%LastLine=input('Please input the last line number\n','s');
LastLine=str2num(get(handles.editLastLineNumber,'String'));

%Xmin=input('Please input Xmin\n','s');
Xmin=str2num(get(handles.editXmin,'String'));
%Xmax=input('Please input Xmax\n','s');
Xmax=str2num(get(handles.editXmax,'String'));
%Ymin=input('Please input Ymin\n','s');
Ymin=str2num(get(handles.editYmin,'String'));
%Ymax=input('Please input Ymax\n','s');
Ymax=str2num(get(handles.editYmax,'String'));

%NumOfReframe=input('Please input reframe number\n','s');
NumOfReframe=str2num(get(handles.editNumberOfReframe,'String'));

NetROIInterplated=zeros((LastLine-FirstLine+1),NumOfReframe,(Xmax-Xmin+1));

if get(handles.checkboxRealTimeDisplay,'Value')==1
    figurehandle=figure('units','normalized','outerposition',[0 0 1 1]);
    figurehandle=subplot(1,1,1);
    
    %figurehandle=axes;
    tightfig;
    MontageRange=str2num(get(handles.editMontageRange,'String'));
    MontageSize=str2num(get(handles.editMontageSize,'String'));
end

tstart=tic;
for m=FirstLine:LastLine
    
    if get(handles.checkboxFileExistence,'Value')==1
        while exist([FileFullName num2str(m) '.SPE'], 'file')==0
            pause(1);
        end
        tempFile=dir([FileFullName num2str(m) '.SPE']);
        tempFileSize=tempFile.bytes;
        pause(2);
        tempFile1=dir([FileFullName num2str(m) '.SPE']);
        tempFileSize1=tempFile1.bytes;
        while tempFileSize1~=tempFileSize
            tempFile=dir([FileFullName num2str(m) '.SPE']);
            tempFileSize=tempFile.bytes;
            pause(2);
            tempFile1=dir([FileFullName num2str(m) '.SPE']);
            tempFileSize1=tempFile1.bytes;
        end
    end
    set(handles.editCurrentLineNumber,'string',num2str(m));
    drawnow;
    
    readerobj=SpeReader([FileFullName num2str(m) '.SPE']);
    allframes=read(readerobj);
    
    SumROI=zeros((Xmax-Xmin+1),readerobj.NumberOfFrames);
    AveROI=zeros((Xmax-Xmin+1),readerobj.NumberOfFrames);
    SumALL=zeros((Xmax-Xmin+1),readerobj.NumberOfFrames);
    SumELSE=zeros((Xmax-Xmin+1),readerobj.NumberOfFrames);
    AveELSE=zeros((Xmax-Xmin+1),readerobj.NumberOfFrames);
    NetROI=zeros((Xmax-Xmin+1),readerobj.NumberOfFrames);
    
    parfor l=1:readerobj.NumberOfFrames
        
        for i=1:Xmax-Xmin+1
            for j=Ymin:Ymax
                SumROI(i,l)=SumROI(i,l)+allframes(j,i-1+Xmin,1,l);
            end
        AveROI(i,l)=SumROI(i,l)/(Ymax-Ymin+1);    
            for j=1:readerobj.Width
                SumALL(i,l)=SumALL(i,l)+allframes(j,i-1+Xmin,1,l);
            end
        SumELSE(i,l)=SumALL(i,l)-SumROI(i,l);
        if (readerobj.Height*readerobj.Width-(Xmax-Xmin+1)*(Ymax-Ymin+1))~=0
            AveELSE(i,l)=SumELSE(i,l)/(readerobj.Height*(Xmax-Xmin+1)-(Xmax-Xmin+1)*(Ymax-Ymin+1));
        else
            AveELSE(i,l)=0;
        end
        NetROI(i,l)=AveROI(i,l)-AveELSE(i,l);    
            
        end
        
    end
    if mod(m,2)==1
        NetROIInterplated(m-FirstLine+1,:,:)=interp1(1:readerobj.NumberOfFrames,NetROI',1:(readerobj.NumberOfFrames-1)/(NumOfReframe-1):readerobj.NumberOfFrames,'linear');
    else
        NetROIInterplated(m-FirstLine+1,:,:)=interp1(1:readerobj.NumberOfFrames,flip(NetROI'),1:(readerobj.NumberOfFrames-1)/(NumOfReframe-1):readerobj.NumberOfFrames,'linear');
    end
    
    if get(handles.checkboxRealTimeDisplay,'Value')==1
        
        ExpandNetROIInterplated(:,:,1,:)=NetROIInterplated(:,:,MontageRange);
        montage(ExpandNetROIInterplated,'Size',MontageSize,'DisplayRange',[],'parent',figurehandle);
        daspect(figurehandle,[2 1 1]);
        colormap(figurehandle,jet);
        colorbar('peer',figurehandle);
    end
    
end
toc(tstart)
save([FileFullName '.MAT'],'NetROIInterplated');
handles.SpectralMatrix=NetROIInterplated;
guidata(hObject,handles);
end

% --- Executes on button press in pushbuttonPlotMultiSpectralMap.
function pushbuttonPlotMultiSpectralMap_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPlotMultiSpectralMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FileFullName=[get(handles.editSpectralFilePath,'String') get(handles.editSpectralFileName,'String')];
%FirstLine=input('Please input the first line number\n','s');
FirstLine=str2num(get(handles.editFirstLineNumber,'String'));
%LastLine=input('Please input the last line number\n','s');
LastLine=str2num(get(handles.editLastLineNumber,'String'));

%Xmin=input('Please input Xmin\n','s');
Xmin=str2num(get(handles.editXmin,'String'));
%Xmax=input('Please input Xmax\n','s');
Xmax=str2num(get(handles.editXmax,'String'));
%Ymin=input('Please input Ymin\n','s');
Ymin=str2num(get(handles.editYmin,'String'));
%Ymax=input('Please input Ymax\n','s');
Ymax=str2num(get(handles.editYmax,'String'));

%NumOfReframe=input('Please input reframe number\n','s');
NumOfReframe=str2num(get(handles.editNumberOfReframe,'String'));

NumOfCalculation=floor((Ymax-Ymin+1)/2);
YCalcStep=1;
YCenter=floor((Ymax+Ymin+1)/2);
for z=1:NumOfCalculation
    Ymin(z)=YCenter-YCalcStep*z;
    Ymax(z)=YCenter-1+YCalcStep*z;
end

NetROIInterplated=zeros((LastLine-FirstLine+1),NumOfReframe,(Xmax-Xmin+1),NumOfCalculation);

if get(handles.checkboxRealTimeDisplay,'Value')==1
    figurehandle=figure;
    figurehandle=subplot(1,1,1);
    MontageRange=str2num(get(handles.editMontageRange,'String'));
    MontageSize=str2num(get(handles.editMontageSize,'String'));
end

tstart=tic;
for m=FirstLine:LastLine
    
    if get(handles.checkboxFileExistence,'Value')==1
        while exist([FileFullName num2str(m) '.SPE'], 'file')==0
            pause(1);
        end
        tempFile=dir([FileFullName num2str(m) '.SPE']);
        tempFileSize=tempFile.bytes;
        pause(1);
        tempFile1=dir([FileFullName num2str(m) '.SPE']);
        tempFileSize1=tempFile1.bytes;
        while tempFileSize1~=tempFileSize
            tempFile=dir([FileFullName num2str(m) '.SPE']);
            tempFileSize=tempFile.bytes;
            pause(1);
            tempFile1=dir([FileFullName num2str(m) '.SPE']);
            tempFileSize1=tempFile1.bytes;
        end
    end
    set(handles.editCurrentLineNumber,'string',num2str(m));
    drawnow;
    
    readerobj=SpeReader([FileFullName num2str(m) '.SPE']);
    allframes=read(readerobj);
    
    SumROI=zeros((Xmax-Xmin+1),readerobj.NumberOfFrames,NumOfCalculation);
    AveROI=zeros((Xmax-Xmin+1),readerobj.NumberOfFrames,NumOfCalculation);
    SumALL=zeros((Xmax-Xmin+1),readerobj.NumberOfFrames);
    SumELSE=zeros((Xmax-Xmin+1),readerobj.NumberOfFrames,NumOfCalculation);
    AveELSE=zeros((Xmax-Xmin+1),readerobj.NumberOfFrames,NumOfCalculation);
    NetROI=zeros((Xmax-Xmin+1),readerobj.NumberOfFrames,NumOfCalculation);
    
    parfor l=1:readerobj.NumberOfFrames
        for i=1:Xmax-Xmin+1
            for j=1:readerobj.Width
                SumALL(i,l)=SumALL(i,l)+allframes(j,i-1+Xmin,1,l);
            end
        end
    end
    
    parfor l=1:readerobj.NumberOfFrames
        for z=1:NumOfCalculation
            
            for i1=1:Xmax-Xmin+1
                if z==1
                    for j1=Ymin(z):Ymax(z)
                        SumROI(i1,l,z)=SumROI(i1,l,z)+allframes(j1,i1-1+Xmin,1,l);
                    end
                else
                    for j1=Ymin(z):Ymin(z-1)-1
                        SumROI(i1,l,z)=SumROI(i1,l,z)+allframes(j1,i1-1+Xmin,1,l);
                    end
                    for j1=Ymax(z-1)+1:Ymax(z)
                        SumROI(i1,l,z)=SumROI(i1,l,z)+allframes(j1,i1-1+Xmin,1,l);
                    end
                end
            end
        end
    end
    SumROI=cumsum(SumROI,3);
    
    parfor l=1:readerobj.NumberOfFrames
        for z=1:NumOfCalculation
            
            for i1=1:Xmax-Xmin+1
                AveROI(i1,l,z)=SumROI(i1,l,z)/(Ymax(z)-Ymin(z)+1);
                
                SumELSE(i1,l,z)=SumALL(i1,l)-SumROI(i1,l,z);
                if (readerobj.Height*readerobj.Width-(Xmax-Xmin+1)*(Ymax(z)-Ymin(z)+1))~=0
                    AveELSE(i1,l,z)=SumELSE(i1,l,z)/(readerobj.Height*(Xmax-Xmin+1)-(Xmax-Xmin+1)*(Ymax(z)-Ymin(z)+1));
                else
                    AveELSE(i1,l,z)=0;
                end
                NetROI(i1,l,z)=AveROI(i1,l,z)-AveELSE(i1,l,z);
                
            end
            
        end
    end
    if mod(m,2)==1
        NetROIInterplated(m-FirstLine+1,:,:,:)=interp1(1:readerobj.NumberOfFrames,permute(NetROI,[2,1,3]),1:(readerobj.NumberOfFrames-1)/(NumOfReframe-1):readerobj.NumberOfFrames,'linear');
    else
        NetROIInterplated(m-FirstLine+1,:,:,:)=interp1(1:readerobj.NumberOfFrames,flip((permute(NetROI,[2,1,3]))),1:(readerobj.NumberOfFrames-1)/(NumOfReframe-1):readerobj.NumberOfFrames,'linear');
    end
    
    if get(handles.checkboxRealTimeDisplay,'Value')==1
        
        ExpandNetROIInterplated(:,:,1,:)=NetROIInterplated(:,:,MontageRange);
        montage(ExpandNetROIInterplated,'Size',MontageSize,'DisplayRange',[],'parent',figurehandle);
        colormap(figurehandle,jet);
        colorbar('peer',figurehandle);
    end
    
end
toc(tstart)
save([FileFullName '_MultiSpec' '.MAT'],'NetROIInterplated');
handles.SpectralMatrix=NetROIInterplated;
guidata(hObject,handles);
end

% --- Executes on button press in pushbuttonPlotIntensityMap.
function pushbuttonPlotIntensityMap_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPlotIntensityMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%FileFullName=input('Please input the full file name\n','s');
FileFullName=[get(handles.editIntensityFilePath,'String') get(handles.editIntensityFileName,'String')];
%FirstLine=input('Please input the first line number\n','s');
FirstLine=str2num(get(handles.editFirstLineNumber1,'String'));
%LastLine=input('Please input the last line number\n','s');
LastLine=str2num(get(handles.editLastLineNumber1,'String'));

%Xmin=input('Please input Xmin\n','s');
Xmin=str2num(get(handles.editXmin1,'String'));
%Xmax=input('Please input Xmax\n','s');
Xmax=str2num(get(handles.editXmax1,'String'));
%Ymin=input('Please input Ymin\n','s');
Ymin=str2num(get(handles.editYmin1,'String'));
%Ymax=input('Please input Ymax\n','s');
Ymax=str2num(get(handles.editYmax1,'String'));

%NumOfReframe=input('Please input reframe number\n','s');
NumOfReframe=str2num(get(handles.editNumberOfReframe1,'String'));


NetROIInterplated=zeros((LastLine-FirstLine+1),NumOfReframe);

if get(handles.checkboxRealTimeDisplay1,'Value')==1
    figure;
    figurehandle=subplot(1,1,1);
end

tstart=tic;
for m=FirstLine:LastLine
    if get(handles.checkboxFileExistence1,'Value')==1
        while exist([FileFullName num2str(m) '.SPE'], 'file')==0
            pause(1);
        end
        tempFile=dir([FileFullName num2str(m) '.SPE']);
        tempFileSize=tempFile.bytes;
        pause(1);
        tempFile1=dir([FileFullName num2str(m) '.SPE']);
        tempFileSize1=tempFile1.bytes;
        while tempFileSize1~=tempFileSize
            tempFile=dir([FileFullName num2str(m) '.SPE']);
            tempFileSize=tempFile.bytes;
            pause(1);
            tempFile1=dir([FileFullName num2str(m) '.SPE']);
            tempFileSize1=tempFile1.bytes;
        end
    end
    set(handles.editCurrentLineNumber1,'string',num2str(m));
    drawnow;
    
    readerobj=SpeReader([FileFullName num2str(m) '.SPE']);

    allframes=read(readerobj);
    
    SumROI=zeros(1,readerobj.NumberOfFrames);
    AveROI=zeros(1,readerobj.NumberOfFrames);
    SumALL=zeros(1,readerobj.NumberOfFrames);
    SumELSE=zeros(1,readerobj.NumberOfFrames);
    AveELSE=zeros(1,readerobj.NumberOfFrames);
    NetROI=zeros(1,readerobj.NumberOfFrames);
    
    parfor l=1:readerobj.NumberOfFrames
        
        for i=Xmin:Xmax
            for j=Ymin:Ymax
                SumROI(l)=SumROI(l)+allframes(j,i,1,l);
            end
        end
        AveROI(l)=SumROI(l)/((Xmax-Xmin+1)*(Ymax-Ymin+1));
        
        for i=1:readerobj.Height
            for j=1:readerobj.Width
                SumALL(l)=SumALL(l)+allframes(j,i,1,l);
            end
        end
        SumELSE(l)=SumALL(l)-SumROI(l);
        if (readerobj.Height*readerobj.Width-(Xmax-Xmin+1)*(Ymax-Ymin+1))~=0
            AveELSE(l)=SumELSE(l)/(readerobj.Height*readerobj.Width-(Xmax-Xmin+1)*(Ymax-Ymin+1));
        else
            AveELSE(l)=0;
        end
        NetROI(l)=AveROI(l)-AveELSE(l);
    end
    if mod(m,2)==1
        NetROIInterplated(m-FirstLine+1,:)=interp1(1:readerobj.NumberOfFrames,NetROI,1:(readerobj.NumberOfFrames-1)/(NumOfReframe-1):readerobj.NumberOfFrames,'linear');
    else
        if get(handles.checkboxUniDirection1,'Value')==0
            NetROIInterplated(m-FirstLine+1,:)=interp1(1:readerobj.NumberOfFrames,flip(NetROI),1:(readerobj.NumberOfFrames-1)/(NumOfReframe-1):readerobj.NumberOfFrames,'linear');
        else
            NetROIInterplated(m-FirstLine+1,:)=interp1(1:readerobj.NumberOfFrames,NetROI,1:(readerobj.NumberOfFrames-1)/(NumOfReframe-1):readerobj.NumberOfFrames,'linear');
        end
    end
    
    if get(handles.checkboxRealTimeDisplay1,'Value')==1
        imagesc(NetROIInterplated,'parent',figurehandle);
        colorbar('peer',figurehandle);
        
    end
    
end
toc(tstart)
save([FileFullName '_Single' '.MAT'],'NetROIInterplated');
handles.IntensityMatrix=NetROIInterplated;
guidata(hObject,handles);
end

% --- Executes on button press in pushbuttonPlotMultiIntensityMap.
function pushbuttonPlotMultiIntensityMap_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPlotIntensityMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%FileFullName=input('Please input the full file name\n','s');
FileFullName=[get(handles.editIntensityFilePath,'String') get(handles.editIntensityFileName,'String')];
%FirstLine=input('Please input the first line number\n','s');
FirstLine=str2num(get(handles.editFirstLineNumber1,'String'));
%LastLine=input('Please input the last line number\n','s');
LastLine=str2num(get(handles.editLastLineNumber1,'String'));

%Xmin=input('Please input Xmin\n','s');
Xmin=str2num(get(handles.editXmin1,'String'));
%Xmax=input('Please input Xmax\n','s');
Xmax=str2num(get(handles.editXmax1,'String'));
%Ymin=input('Please input Ymin\n','s');
Ymin=str2num(get(handles.editYmin1,'String'));
%Ymax=input('Please input Ymax\n','s');
Ymax=str2num(get(handles.editYmax1,'String'));

%NumOfReframe=input('Please input reframe number\n','s');
NumOfReframe=str2num(get(handles.editNumberOfReframe1,'String'));

%NumOfCalculation=15; %calculate 16 different ROI sizes

if get(handles.checkboxRealTimeDisplay1,'Value')==1
    figure;
    figurehandle=subplot(1,1,1);
    
    DisplaySize=str2num(get(handles.editDisplaySize,'String'));
end

NumOfCalculation=str2num(get(handles.editNumberOfCalculation,'String'));
XCalcStep=floor((160)/NumOfCalculation);
YCalcStep=floor((128)/NumOfCalculation);
NetROIInterplated=zeros((LastLine-FirstLine+1),NumOfReframe,NumOfCalculation);
for z=1:NumOfCalculation
    Xmin(z)=161-XCalcStep*z;
    Xmax(z)=160+XCalcStep*z;
    Ymin(z)=129-YCalcStep*z;
    Ymax(z)=128+YCalcStep*z;
end
tstart=tic;
for m=FirstLine:LastLine
    if get(handles.checkboxFileExistence1,'Value')==1
        while exist([FileFullName num2str(m) '.SPE'], 'file')==0
            pause(1);
        end
        tempFile=dir([FileFullName num2str(m) '.SPE']);
        tempFileSize=tempFile.bytes;
        pause(1);
        tempFile1=dir([FileFullName num2str(m) '.SPE']);
        tempFileSize1=tempFile1.bytes;
        while tempFileSize1~=tempFileSize
            tempFile=dir([FileFullName num2str(m) '.SPE']);
            tempFileSize=tempFile.bytes;
            pause(1);
            tempFile1=dir([FileFullName num2str(m) '.SPE']);
            tempFileSize1=tempFile1.bytes;
        end
    end
    set(handles.editCurrentLineNumber1,'string',num2str(m));
    drawnow;
    
    readerobj=SpeReader([FileFullName num2str(m) '.SPE']);
    allframes=read(readerobj);
    
    SumROI=zeros(NumOfCalculation,readerobj.NumberOfFrames);
    AveROI=zeros(NumOfCalculation,readerobj.NumberOfFrames);
    SumALL=zeros(readerobj.NumberOfFrames);
    SumELSE=zeros(NumOfCalculation,readerobj.NumberOfFrames);
    AveELSE=zeros(NumOfCalculation,readerobj.NumberOfFrames);
    NetROI=zeros(NumOfCalculation,readerobj.NumberOfFrames);
    
    parfor l=1:readerobj.NumberOfFrames
        
        for i=1:readerobj.Height
            for j=1:readerobj.Width
                SumALL(l)=SumALL(l)+allframes(j,i,1,l);
            end
        end

        for z=1:NumOfCalculation
%             for i=Xmin(z):Xmax(z)
%                 for j=Ymin(z):Ymax(z)
%                     if z==1
%                         SumROI(z,l)=SumROI(z,l)+allframes(j,i,1,l);
%                     elseif z>1
%                         if ~(((i>=Xmin(z-1)) && (i<=Xmax(z-1))) && ((j>=Ymin(z-1)) && (j<=Ymax(z-1))))
%                             SumROI(z,l)=SumROI(z,l)+allframes(j,i,1,l);
%                         end
%                     end
%                 end
%             end
            
            if z==1
                for i=Xmin(z):Xmax(z)
                    for j=Ymin(z):Ymax(z)
                        SumROI(z,l)=SumROI(z,l)+allframes(j,i,1,l);
                        
                    end
                end
            elseif z>1
                
                for i=Xmin(z):1:Xmax(z)
                    for j=Ymin(z):1:(Ymin(z-1)-1)
                        SumROI(z,l)=SumROI(z,l)+allframes(j,i,1,l);
                        
                    end
                end
                
                for i=Xmin(z):1:(Xmin(z-1)-1)
                    for j=Ymin(z-1):1:Ymax(z-1)
                        SumROI(z,l)=SumROI(z,l)+allframes(j,i,1,l);
                        
                    end
                end
                
                for i=(Xmax(z-1)+1):1:Xmax(z)
                    for j=Ymin(z-1):1:Ymax(z-1)
                        SumROI(z,l)=SumROI(z,l)+allframes(j,i,1,l);
                        
                    end
                end

                for i=Xmin(z):1:Xmax(z)
                    for j=(Ymax(z-1)+1):1:Ymax(z)
                        SumROI(z,l)=SumROI(z,l)+allframes(j,i,1,l);
                    end
                end

            end
        end
    end
    
    SumROI=cumsum(SumROI);
    
    parfor l=1:readerobj.NumberOfFrames
        for z=1:NumOfCalculation
            AveROI(z,l)=SumROI(z,l)/((Xmax(z)-Xmin(z)+1)*(Ymax(z)-Ymin(z)+1));
            
            SumELSE(z,l)=SumALL(l)-SumROI(z,l);
            if (readerobj.Height*readerobj.Width-(Xmax(z)-Xmin(z)+1)*(Ymax(z)-Ymin(z)+1))~=0
                AveELSE(z,l)=SumELSE(z,l)/(readerobj.Height*readerobj.Width-(Xmax(z)-Xmin(z)+1)*(Ymax(z)-Ymin(z)+1));
            else
                AveELSE(z,l)=0;
            end
            NetROI(z,l)=AveROI(z,l)-AveELSE(z,l);
        end
    end
    
    if mod(m,2)==1
        NetROIInterplated(m-FirstLine+1,:,:)=interp1(1:readerobj.NumberOfFrames,NetROI',1:(readerobj.NumberOfFrames-1)/(NumOfReframe-1):readerobj.NumberOfFrames,'linear');
    else
        if get(handles.checkboxUniDirection1,'Value')==0
            NetROIInterplated(m-FirstLine+1,:,:)=interp1(1:readerobj.NumberOfFrames,flip(NetROI'),1:(readerobj.NumberOfFrames-1)/(NumOfReframe-1):readerobj.NumberOfFrames,'linear');
        else
            NetROIInterplated(m-FirstLine+1,:,:)=interp1(1:readerobj.NumberOfFrames,NetROI',1:(readerobj.NumberOfFrames-1)/(NumOfReframe-1):readerobj.NumberOfFrames,'linear');
        end
    end
    
    if get(handles.checkboxRealTimeDisplay1,'Value')==1
        ExpandNetROIInterplated(:,:,1,:)=NetROIInterplated(:,:,:);
        montage(ExpandNetROIInterplated,'Size',DisplaySize,'DisplayRange',[],'parent',figurehandle);
        colormap(figurehandle,jet);
        colorbar('peer',figurehandle);
    end
    
end
toc(tstart)
save([FileFullName '_Multi' get(handles.editNumberOfCalculation,'String') '.MAT'],'NetROIInterplated');
handles.IntensityMatrix=NetROIInterplated;
guidata(hObject,handles);
end

% --- Executes on button press in pushbuttonPlotMultiDistanceMap.
function pushbuttonPlotMultiDistanceMap_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPlotIntensityMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%FileFullName=input('Please input the full file name\n','s');
FileFullName=[get(handles.editIntensityFilePath,'String') get(handles.editIntensityFileName,'String')];
%FirstLine=input('Please input the first line number\n','s');
FirstLine=str2num(get(handles.editFirstLineNumber1,'String'));
%LastLine=input('Please input the last line number\n','s');
LastLine=str2num(get(handles.editLastLineNumber1,'String'));


%NumOfReframe=input('Please input reframe number\n','s');
NumOfReframe=str2num(get(handles.editNumberOfReframe1,'String'));


if get(handles.checkboxRealTimeDisplay1,'Value')==1
    figurehandle=figure('units','normalized','outerposition',[0 0 1 1]);
    figurehandle=subplot(1,1,1);
    
    %figurehandle=axes;
    tightfig;
    
    DisplaySize=str2num(get(handles.editDisplaySize,'String'));
end
tstart=tic;
NumOfCalculation=floor(sqrt(160*160+128*128))+1;
NetROIInterplated=zeros((LastLine-FirstLine+1),NumOfReframe,NumOfCalculation);
for i=1:NumOfCalculation
distance{i}={};
end
for ii=1:320
    for jj=1:256
        disttemp=floor(sqrt((ii-160)^2+(jj-128)^2))+1;
        celltemp=distance{disttemp};
        distance{disttemp}=[celltemp,[ii,jj]];
    end
end

for m=FirstLine:LastLine
    if get(handles.checkboxFileExistence1,'Value')==1
        while exist([FileFullName num2str(m) '.SPE'], 'file')==0
            pause(1);
        end
        tempFile=dir([FileFullName num2str(m) '.SPE']);
        tempFileSize=tempFile.bytes;
        pause(1);
        tempFile1=dir([FileFullName num2str(m) '.SPE']);
        tempFileSize1=tempFile1.bytes;
        while tempFileSize1~=tempFileSize
            tempFile=dir([FileFullName num2str(m) '.SPE']);
            tempFileSize=tempFile.bytes;
            pause(1);
            tempFile1=dir([FileFullName num2str(m) '.SPE']);
            tempFileSize1=tempFile1.bytes;
        end
    end
    set(handles.editCurrentLineNumber1,'string',num2str(m));
    drawnow;
    readerobj=SpeReader([FileFullName num2str(m) '.SPE']);
    allframes=read(readerobj);
    
    NetROI=zeros(NumOfCalculation,readerobj.NumberOfFrames);
    
    parfor l=1:readerobj.NumberOfFrames
        NetROItemp=zeros(NumOfCalculation,1);
        for kk=1:NumOfCalculation
            for ll=1:size(distance{kk},2)
                NetROItemp(kk,1)=NetROItemp(kk,1)+allframes(distance{kk}{ll}(1,2),distance{kk}{ll}(1,1),1,l);
            end
            NetROItemp(kk,1)=NetROItemp(kk,1)/ll;
        end
        NetROI(:,l)=NetROItemp;
    end
    if mod(m,2)==1
        NetROIInterplated(m-FirstLine+1,:,:)=interp1(1:readerobj.NumberOfFrames,NetROI',1:(readerobj.NumberOfFrames-1)/(NumOfReframe-1):readerobj.NumberOfFrames,'linear');
    else
        if get(handles.checkboxUniDirection1,'Value')==0
            NetROIInterplated(m-FirstLine+1,:,:)=interp1(1:readerobj.NumberOfFrames,flip(NetROI'),1:(readerobj.NumberOfFrames-1)/(NumOfReframe-1):readerobj.NumberOfFrames,'linear');
        else
            NetROIInterplated(m-FirstLine+1,:,:)=interp1(1:readerobj.NumberOfFrames,NetROI',1:(readerobj.NumberOfFrames-1)/(NumOfReframe-1):readerobj.NumberOfFrames,'linear');
        end
    end
    
    if get(handles.checkboxRealTimeDisplay1,'Value')==1
        ExpandNetROIInterplated(:,:,1,:)=NetROIInterplated(:,:,:);
        montage(ExpandNetROIInterplated,'Size',DisplaySize,'DisplayRange',[],'parent',figurehandle);
        daspect(figurehandle,[2 1 1]);
        colormap(figurehandle,jet);
        colorbar('peer',figurehandle);
    end
    
end
toc(tstart)
save([FileFullName '_MultiDistance' '.MAT'],'NetROIInterplated');
handles.IntensityMatrix=NetROIInterplated;
guidata(hObject,handles);
end





% --- Executes when figurePlotScanningMap is resized.
function figurePlotScanningMap_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figurePlotScanningMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbuttonOpenSpectralFile.
function pushbuttonOpenSpectralFile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonOpenSpectralFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,filepath]=uigetfile([get(handles.editSpectralFilePath,'string') '\*.*'],'Select the Input Spectral File');
set(handles.editSpectralFileName,'string',filename(1:length(filename)-4));
set(handles.editSpectralFilePath,'string',filepath);
guidata(hObject,handles);
end
% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


function editSpectralFileName_Callback(hObject, eventdata, handles)
% hObject    handle to editSpectralFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSpectralFileName as text
%        str2double(get(hObject,'String')) returns contents of editSpectralFileName as a double
end

% --- Executes during object creation, after setting all properties.
function editSpectralFileName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSpectralFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function editSpectralFilePath_Callback(hObject, eventdata, handles)
% hObject    handle to editSpectralFilePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSpectralFilePath as text
%        str2double(get(hObject,'String')) returns contents of editSpectralFilePath as a double
end

% --- Executes during object creation, after setting all properties.
function editSpectralFilePath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSpectralFilePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function editFirstLineNumber_Callback(hObject, eventdata, handles)
% hObject    handle to editFirstLineNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editFirstLineNumber as text
%        str2double(get(hObject,'String')) returns contents of editFirstLineNumber as a double
end

% --- Executes during object creation, after setting all properties.
function editFirstLineNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editFirstLineNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function editLastLineNumber_Callback(hObject, eventdata, handles)
% hObject    handle to editLastLineNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editLastLineNumber as text
%        str2double(get(hObject,'String')) returns contents of editLastLineNumber as a double
end

% --- Executes during object creation, after setting all properties.
function editLastLineNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editLastLineNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function editXmin_Callback(hObject, eventdata, handles)
% hObject    handle to editXmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editXmin as text
%        str2double(get(hObject,'String')) returns contents of editXmin as a double
end

% --- Executes during object creation, after setting all properties.
function editXmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editXmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function editXmax_Callback(hObject, eventdata, handles)
% hObject    handle to editXmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editXmax as text
%        str2double(get(hObject,'String')) returns contents of editXmax as a double
end

% --- Executes during object creation, after setting all properties.
function editXmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editXmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function editYmin_Callback(hObject, eventdata, handles)
% hObject    handle to editYmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editYmin as text
%        str2double(get(hObject,'String')) returns contents of editYmin as a double
end

% --- Executes during object creation, after setting all properties.
function editYmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editYmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function editYmax_Callback(hObject, eventdata, handles)
% hObject    handle to editYmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editYmax as text
%        str2double(get(hObject,'String')) returns contents of editYmax as a double
end

% --- Executes during object creation, after setting all properties.
function editYmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editYmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function editNumberOfReframe_Callback(hObject, eventdata, handles)
% hObject    handle to editNumberOfReframe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editNumberOfReframe as text
%        str2double(get(hObject,'String')) returns contents of editNumberOfReframe as a double
end

% --- Executes during object creation, after setting all properties.
function editNumberOfReframe_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editNumberOfReframe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in pushbuttonImplay.
function pushbuttonImplay_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonImplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FileFullName=[get(handles.editSpectralFilePath,'String') get(handles.editSpectralFileName,'String')];
load([FileFullName '.MAT']);
handle=implay(NetROIInterplated,20);
handle.Visual.ColorMap.UserRangeMin = min(min(min(NetROIInterplated)));
handle.Visual.ColorMap.UserRangeMax = max(max(max(NetROIInterplated)));
handle.Visual.ColorMap.UserRange = 1;
handle.Visual.ColorMap.MapExpression = 'jet';
end


% --- Executes on button press in pushbuttonSlice.
function pushbuttonSlice_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSlice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FileFullName=[get(handles.editSpectralFilePath,'String') get(handles.editSpectralFileName,'String')];
load([FileFullName '.MAT']);
SliceArray=str2num(get(handles.editSliceArray,'String'));
figure;
handle=slice(NetROIInterplated,0,0,SliceArray);
shading interp;
colormap jet;
alpha('color');
alpha('interp');
colorbar;
view(-33,36);
amap=alphamap;
alphamap(amap-0.2);

%draw the projection on x-y, x-z and y-z plane
hold on;
sizeNetROIInterplated=size(NetROIInterplated);
%calculate and plot projection on x-y plane
sumZ=zeros(sizeNetROIInterplated(1),sizeNetROIInterplated(2));
for i=1:sizeNetROIInterplated(3)
    sumZ=sumZ+squeeze(NetROIInterplated(:,:,i));
end
graysumZ=mat2gray(sumZ);
indexedsumZ=gray2ind(graysumZ,256);
rgbsumZ=ind2rgb(indexedsumZ,jet(256));
surf([1 sizeNetROIInterplated(2)],[1 sizeNetROIInterplated(1)],[1 1;1 1],rgbsumZ,'facecolor','texture');

%calculate and plot projection on x-z plane
sumY=zeros(sizeNetROIInterplated(2),sizeNetROIInterplated(3));
for i=1:sizeNetROIInterplated(1)
    sumY=sumY+squeeze(NetROIInterplated(i,:,:));
end
graysumY=mat2gray(sumY');
indexedsumY=gray2ind(graysumY,256);
rgbsumY=ind2rgb(indexedsumY,jet(256));
surf([1 sizeNetROIInterplated(2)],[sizeNetROIInterplated(1) sizeNetROIInterplated(1)],[1 1;sizeNetROIInterplated(3) sizeNetROIInterplated(3)],rgbsumY,'facecolor','texture');

%calculate and plot projection on y-z plane
sumX=zeros(sizeNetROIInterplated(1),sizeNetROIInterplated(3));
for i=1:sizeNetROIInterplated(2)
    sumX=sumX+squeeze(NetROIInterplated(:,i,:));
end
graysumX=mat2gray(sumX);
indexedsumX=gray2ind(graysumX,256);
rgbsumX=ind2rgb(indexedsumX,jet(256));
surf([sizeNetROIInterplated(2) sizeNetROIInterplated(2)],[1 sizeNetROIInterplated(1)],[1 sizeNetROIInterplated(3);1 sizeNetROIInterplated(3)],rgbsumX,'facecolor','texture');

%modify figure appearance
axis tight;

savefig([FileFullName '_slice' '.fig']);
epsName=[FileFullName '_slice' '.eps']
end



function editSliceArray_Callback(hObject, eventdata, handles)
% hObject    handle to editSliceArray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSliceArray as text
%        str2double(get(hObject,'String')) returns contents of editSliceArray as a double
end

% --- Executes during object creation, after setting all properties.
function editSliceArray_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSliceArray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in pushbuttonOpenIntensityFile.
function pushbuttonOpenIntensityFile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonOpenIntensityFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,filepath]=uigetfile([get(handles.editIntensityFilePath,'string') '\*.*'],'Select the Input Intensity File');
set(handles.editIntensityFileName,'string',filename(1:length(filename)-4));
set(handles.editIntensityFilePath,'string',filepath);
guidata(hObject,handles);
end


function editIntensityFilePath_Callback(hObject, eventdata, handles)
% hObject    handle to editIntensityFilePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editIntensityFilePath as text
%        str2double(get(hObject,'String')) returns contents of editIntensityFilePath as a double
end

% --- Executes during object creation, after setting all properties.
function editIntensityFilePath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editIntensityFilePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function editIntensityFileName_Callback(hObject, eventdata, handles)
% hObject    handle to editIntensityFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editIntensityFileName as text
%        str2double(get(hObject,'String')) returns contents of editIntensityFileName as a double
end

% --- Executes during object creation, after setting all properties.
function editIntensityFileName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editIntensityFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function editFirstLineNumber1_Callback(hObject, eventdata, handles)
% hObject    handle to editFirstLineNumber1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editFirstLineNumber1 as text
%        str2double(get(hObject,'String')) returns contents of editFirstLineNumber1 as a double
end

% --- Executes during object creation, after setting all properties.
function editFirstLineNumber1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editFirstLineNumber1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function editLastLineNumber1_Callback(hObject, eventdata, handles)
% hObject    handle to editLastLineNumber1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editLastLineNumber1 as text
%        str2double(get(hObject,'String')) returns contents of editLastLineNumber1 as a double
end

% --- Executes during object creation, after setting all properties.
function editLastLineNumber1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editLastLineNumber1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function editXmin1_Callback(hObject, eventdata, handles)
% hObject    handle to editXmin1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editXmin1 as text
%        str2double(get(hObject,'String')) returns contents of editXmin1 as a double
end

% --- Executes during object creation, after setting all properties.
function editXmin1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editXmin1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function editXmax1_Callback(hObject, eventdata, handles)
% hObject    handle to editXmax1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editXmax1 as text
%        str2double(get(hObject,'String')) returns contents of editXmax1 as a double
end

% --- Executes during object creation, after setting all properties.
function editXmax1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editXmax1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function editYmin1_Callback(hObject, eventdata, handles)
% hObject    handle to editYmin1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editYmin1 as text
%        str2double(get(hObject,'String')) returns contents of editYmin1 as a double
end

% --- Executes during object creation, after setting all properties.
function editYmin1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editYmin1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function editYmax1_Callback(hObject, eventdata, handles)
% hObject    handle to editYmax1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editYmax1 as text
%        str2double(get(hObject,'String')) returns contents of editYmax1 as a double
end

% --- Executes during object creation, after setting all properties.
function editYmax1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editYmax1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function editNumberOfReframe1_Callback(hObject, eventdata, handles)
% hObject    handle to editNumberOfReframe1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editNumberOfReframe1 as text
%        str2double(get(hObject,'String')) returns contents of editNumberOfReframe1 as a double
end

% --- Executes during object creation, after setting all properties.
function editNumberOfReframe1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editNumberOfReframe1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in pushbuttonImageScaleData.
function pushbuttonImageScaleData_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonImageScaleData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure;
FileFullName=[get(handles.editIntensityFilePath,'String') get(handles.editIntensityFileName,'String')];
load([FileFullName '.MAT']);
imagesc(NetROIInterplated);
colorbar;
savefig([FileFullName '_imagesc' '.fig']);
epsName=[FileFullName '_imagesc' '.eps']
end

% --- Executes on button press in pushbuttonMultiImageSC.
function pushbuttonMultiImageSC_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonMultiImageSC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure;
FileFullName=[get(handles.editIntensityFilePath,'String') get(handles.editIntensityFileName,'String')];
load([FileFullName '.MAT']);
DisplaySize=str2num(get(handles.editDisplaySize,'String'));
ExpandNetROIInterplated(:,:,1,:)=NetROIInterplated(:,:,:);
montage(ExpandNetROIInterplated,'Size',DisplaySize,'DisplayRange',[]);
colormap 'jet';
colorbar;
daspect([2 1 1]);
savefig([FileFullName '_multiimagesc' '.fig']);
epsName=[FileFullName '_multiimagesc' '.eps']
end


% --- Executes on button press in pushbuttonPseudoColor.
function pushbuttonPseudoColor_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPseudoColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure;
FileFullName=[get(handles.editIntensityFilePath,'String') get(handles.editIntensityFileName,'String')];
load([FileFullName '.MAT']);
pcolor(NetROIInterplated);
colorbar;
end


% --- Executes on button press in checkboxUniDirection1.
function checkboxUniDirection1_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxUniDirection1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxUniDirection1
end


% --- Executes on button press in checkboxFileExistence.
function checkboxFileExistence_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxFileExistence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxFileExistence
end

% --- Executes on button press in checkboxFileExistence1.
function checkboxFileExistence1_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxFileExistence1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxFileExistence1
end



function editCurrentLineNumber_Callback(hObject, eventdata, handles)
% hObject    handle to editCurrentLineNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editCurrentLineNumber as text
%        str2double(get(hObject,'String')) returns contents of editCurrentLineNumber as a double
end

% --- Executes during object creation, after setting all properties.
function editCurrentLineNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editCurrentLineNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function editCurrentLineNumber1_Callback(hObject, eventdata, handles)
% hObject    handle to editCurrentLineNumber1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editCurrentLineNumber1 as text
%        str2double(get(hObject,'String')) returns contents of editCurrentLineNumber1 as a double
end

% --- Executes during object creation, after setting all properties.
function editCurrentLineNumber1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editCurrentLineNumber1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in pushbuttonMontage.
function pushbuttonMontage_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonMontage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FileFullName=[get(handles.editSpectralFilePath,'String') get(handles.editSpectralFileName,'String')];
load([FileFullName '.MAT']);
MontageRange=str2num(get(handles.editMontageRange,'String'));
MontageSize=str2num(get(handles.editMontageSize,'String'));
ExpandNetROIInterplated(:,:,1,:)=NetROIInterplated(:,:,MontageRange);
figure;
montage(ExpandNetROIInterplated,'Size',MontageSize,'DisplayRange',[]);
colormap 'jet';
colorbar;
daspect([2 1 1]);
savefig([FileFullName '_montage' '.fig']);
epsName=[FileFullName '_montage' '.eps']
end



function editBackgroundCorrection_Callback(hObject, eventdata, handles)
% hObject    handle to editBackgroundCorrection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editBackgroundCorrection as text
%        str2double(get(hObject,'String')) returns contents of editBackgroundCorrection as a double
end

% --- Executes during object creation, after setting all properties.
function editBackgroundCorrection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editBackgroundCorrection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in pushbuttonBackgroundCorrection.
function pushbuttonBackgroundCorrection_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonBackgroundCorrection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FileFullName=[get(handles.editSpectralFilePath,'String') get(handles.editSpectralFileName,'String')];
load([FileFullName '.MAT']);
sizeNetROIInterplated=size(NetROIInterplated);
BackgroundRange=str2num(get(handles.editBackgroundCorrection,'String'));
BackgroundMatrix=zeros(sizeNetROIInterplated(1),sizeNetROIInterplated(2));
tempCounter=0;
for i=1:sizeNetROIInterplated(3)
    if any(i==BackgroundRange)
        tempCounter=tempCounter+1;
        BackgroundMatrix=BackgroundMatrix+NetROIInterplated(:,:,i);
    end
end
AveBackgroundMatrix=BackgroundMatrix/tempCounter;
for i=1:sizeNetROIInterplated(3)
    NetROIInterplated(:,:,i)=NetROIInterplated(:,:,i)-AveBackgroundMatrix;
end
for i=1:sizeNetROIInterplated(1)
    for j=1:sizeNetROIInterplated(2)
        minTemp=min(NetROIInterplated(i,j,:));
        NetROIInterplated(i,j,:)=NetROIInterplated(i,j,:)-minTemp;
    end
end

save([FileFullName '_BcgCor' '.MAT'],'NetROIInterplated');

end



function editEqualArea_Callback(hObject, eventdata, handles)
% hObject    handle to editEqualArea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editEqualArea as text
%        str2double(get(hObject,'String')) returns contents of editEqualArea as a double
end

% --- Executes during object creation, after setting all properties.
function editEqualArea_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editEqualArea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in pushbuttonEqualArea.
function pushbuttonEqualArea_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonEqualArea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FileFullName=[get(handles.editSpectralFilePath,'String') get(handles.editSpectralFileName,'String')];
load([FileFullName '.MAT']);
sizeNetROIInterplated=size(NetROIInterplated);
EqualAreaRange=str2num(get(handles.editEqualArea,'String'));
sizeEqualAreaRange=size(EqualAreaRange);
EqualAreaMatrix=zeros(sizeNetROIInterplated(1),sizeNetROIInterplated(2),sizeEqualAreaRange(2));
EqualAreaResult=zeros(sizeNetROIInterplated(1),sizeNetROIInterplated(2));
EqualAreaAlphaData=zeros(sizeNetROIInterplated(1),sizeNetROIInterplated(2));
for i=1:sizeNetROIInterplated(1)
    for j=1:sizeNetROIInterplated(2)
        EqualAreaAlphaData(i,j)=trapz(NetROIInterplated(i,j,EqualAreaRange));
        EqualAreaMatrix(i,j,:)=cumtrapz(NetROIInterplated(i,j,EqualAreaRange));
        k=1;
        while EqualAreaMatrix(i,j,k)<EqualAreaMatrix(i,j,sizeEqualAreaRange(2))/2
            k=k+1;
        end
        temp=k-1+(EqualAreaMatrix(i,j,sizeEqualAreaRange(2))/2-EqualAreaMatrix(i,j,k-1))/(EqualAreaMatrix(i,j,k)-EqualAreaMatrix(i,j,k-1));
        EqualAreaResult(i,j)=temp-1+EqualAreaRange(1);
    end
end
figure;
imagesc(EqualAreaResult);

colormap 'jet';
colorbar;
alpha(EqualAreaAlphaData);
alpha('scaled');
daspect([2 1 1]);
savefig([FileFullName '_equalarea' '.fig']);
epsName=[FileFullName '_equalarea' '.eps']
end



function editFWHM_Callback(hObject, eventdata, handles)
% hObject    handle to editFWHM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editFWHM as text
%        str2double(get(hObject,'String')) returns contents of editFWHM as a double
end

% --- Executes during object creation, after setting all properties.
function editFWHM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editFWHM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in pushbuttonFWHM.
function pushbuttonFWHM_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonFWHM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FileFullName=[get(handles.editSpectralFilePath,'String') get(handles.editSpectralFileName,'String')];
load([FileFullName '.MAT']);
sizeNetROIInterplated=size(NetROIInterplated);
FWHMRange=str2num(get(handles.editEqualArea,'String'));
sizeFWHMRange=size(FWHMRange);
FWHMMatrix=zeros(sizeNetROIInterplated(1),sizeNetROIInterplated(2),sizeFWHMRange(2));
FWHMResult=zeros(sizeNetROIInterplated(1),sizeNetROIInterplated(2),3); %z=3 to store locations of, max, distance between max and left half and distance between max and right half
FWHMAlphaData=zeros(sizeNetROIInterplated(1),sizeNetROIInterplated(2));
for i=1:sizeNetROIInterplated(1)
    for j=1:sizeNetROIInterplated(2)
        FWHMAlphaData(i,j)=trapz(NetROIInterplated(i,j,FWHMRange));
        FWHMMatrix(i,j,:)=NetROIInterplated(i,j,FWHMRange);
        [maxTemp,maxLocationTemp]=max(FWHMMatrix(i,j,:));
        FWHMResult(i,j,1)=maxLocationTemp;
        k=1;
        while FWHMMatrix(i,j,maxLocationTemp+k)>maxTemp/2
            k=k+1;
        end
        k=k-1+(maxTemp/2-FWHMMatrix(i,j,maxLocationTemp+k-1))/(FWHMMatrix(i,j,maxLocationTemp+k)-FWHMMatrix(i,j,maxLocationTemp+k-1));
        FWHMResult(i,j,3)=k;
        k=1;
        while FWHMMatrix(i,j,maxLocationTemp-k)>maxTemp/2
            k=k+1;
        end
        k=k-1+(maxTemp/2-FWHMMatrix(i,j,maxLocationTemp-k+1))/(FWHMMatrix(i,j,maxLocationTemp-k)-FWHMMatrix(i,j,maxLocationTemp-k+1));
        FWHMResult(i,j,2)=k;
    end
end
figure;
imagesc(FWHMResult(:,:,2)+FWHMResult(:,:,3));

colormap 'jet';
colorbar;
alpha(FWHMAlphaData);
alpha('scaled');
daspect([2 1 1]);
savefig([FileFullName '_equalarea' '.fig']);
epsName=[FileFullName '_equalarea' '.eps']
end


% --- Executes on button press in pushbuttonSmoothLamda.
function pushbuttonSmoothLamda_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSmoothLamda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FileFullName=[get(handles.editSpectralFilePath,'String') get(handles.editSpectralFileName,'String')];
load([FileFullName '.MAT']);
sizeNetROIInterplated=size(NetROIInterplated);
SmoothSpan=str2num(get(handles.editSmoothSpan,'String'));
SmoothMethod=get(handles.popupmenuSmoothMethod,'String');
SmoothMethodValue=SmoothMethod{get(handles.popupmenuSmoothMethod,'Value')};
SmoothMatrix=zeros(sizeNetROIInterplated(1),sizeNetROIInterplated(2),sizeNetROIInterplated(3));

for i=1:sizeNetROIInterplated(1)
    for j=1:sizeNetROIInterplated(2)
        temp=zeros(sizeNetROIInterplated(3),1);
        temp=smooth(squeeze(NetROIInterplated(i,j,:)),SmoothSpan,SmoothMethodValue);
        temp2(1,1,:)=temp';
        SmoothMatrix(i,j,:)=temp2;
    end
end
NetROIInterplated=SmoothMatrix;
save([FileFullName '_' SmoothMethodValue '.MAT'],'NetROIInterplated');
end


function editSmoothSpan_Callback(hObject, eventdata, handles)
% hObject    handle to editSmoothSpan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSmoothSpan as text
%        str2double(get(hObject,'String')) returns contents of editSmoothSpan as a double
end

% --- Executes during object creation, after setting all properties.
function editSmoothSpan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSmoothSpan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in popupmenuSmoothMethod.
function popupmenuSmoothMethod_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuSmoothMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuSmoothMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuSmoothMethod
end

% --- Executes during object creation, after setting all properties.
function popupmenuSmoothMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuSmoothMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function editMontageRange_Callback(hObject, eventdata, handles)
% hObject    handle to editMontageRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMontageRange as text
%        str2double(get(hObject,'String')) returns contents of editMontageRange as a double
end

% --- Executes during object creation, after setting all properties.
function editMontageRange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMontageRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function editMontageSize_Callback(hObject, eventdata, handles)
% hObject    handle to editMontageSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMontageSize as text
%        str2double(get(hObject,'String')) returns contents of editMontageSize as a double
end

% --- Executes during object creation, after setting all properties.
function editMontageSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMontageSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in checkboxRealTimeDisplay.
function checkboxRealTimeDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxRealTimeDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxRealTimeDisplay
end

% --- Executes on button press in checkboxRealTimeDisplay1.
function checkboxRealTimeDisplay1_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxRealTimeDisplay1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxRealTimeDisplay1
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2
end

% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on selection change in listboxIntensityFilePath.
function listboxIntensityFilePath_Callback(hObject, eventdata, handles)
% hObject    handle to listboxIntensityFilePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxIntensityFilePath contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxIntensityFilePath
end

% --- Executes during object creation, after setting all properties.
function listboxIntensityFilePath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxIntensityFilePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in listboxIntensityFileName.
function listboxIntensityFileName_Callback(hObject, eventdata, handles)
% hObject    handle to listboxIntensityFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxIntensityFileName contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxIntensityFileName
end

% --- Executes during object creation, after setting all properties.
function listboxIntensityFileName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxIntensityFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in pushbuttonAddFile1.
function pushbuttonAddFile1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonAddFile1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
IntensityFilePath=get(handles.listboxIntensityFilePath,'String');
sizeIntensityFilePath=size(IntensityFilePath);
IntensityFileName=get(handles.listboxIntensityFileName,'String');
sizeIntensityFileName=size(IntensityFileName);
set(handles.listboxIntensityFilePath,'String',cellstr([IntensityFilePath; get(handles.editIntensityFilePath, 'String')]));
set(handles.listboxIntensityFileName,'String',cellstr([IntensityFileName; get(handles.editIntensityFileName, 'String')]));


end


% --- Executes on button press in pushbuttonClearFile1.
function pushbuttonClearFile1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonClearFile1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.listboxIntensityFilePath,'String',{});
set(handles.listboxIntensityFileName,'String',{});
set(handles.listboxIntensityFilePath,'Value',1);
set(handles.listboxIntensityFileName,'Value',1);
end


% --- Executes on button press in pushbuttonRemoveFile1.
function pushbuttonRemoveFile1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonRemoveFile1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
IntensityFilePath=get(handles.listboxIntensityFilePath,'String');
sizeIntensityFilePath=size(IntensityFilePath);
RemoveFileValue=get(handles.listboxIntensityFilePath,'Value')
if RemoveFileValue==sizeIntensityFilePath(1)
    set(handles.listboxIntensityFilePath,'Value',RemoveFileValue-1);
end
IntensityFilePath(RemoveFileValue,:)=[];
set(handles.listboxIntensityFilePath,'String',IntensityFilePath);

IntensityFileName=get(handles.listboxIntensityFileName,'String');
IntensityFileName(RemoveFileValue,:)=[];
set(handles.listboxIntensityFileName,'String',IntensityFileName);
set(handles.listboxIntensityFileName,'Value',get(handles.listboxIntensityFilePath,'Value'));

end


% --- Executes on selection change in listboxSpectralFilePath.
function listboxSpectralFilePath_Callback(hObject, eventdata, handles)
% hObject    handle to listboxSpectralFilePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxSpectralFilePath contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxSpectralFilePath
end

% --- Executes during object creation, after setting all properties.
function listboxSpectralFilePath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxSpectralFilePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in listboxSpectralFileName.
function listboxSpectralFileName_Callback(hObject, eventdata, handles)
% hObject    handle to listboxSpectralFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxSpectralFileName contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxSpectralFileName
end

% --- Executes during object creation, after setting all properties.
function listboxSpectralFileName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxSpectralFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in pushbuttonAddFile.
function pushbuttonAddFile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonAddFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SpectralFilePath=get(handles.listboxSpectralFilePath,'String');
sizeSpectralFilePath=size(SpectralFilePath);
SpectralFileName=get(handles.listboxSpectralFileName,'String');
sizeSpectralFileName=size(SpectralFileName);
set(handles.listboxSpectralFilePath,'String',cellstr([SpectralFilePath; get(handles.editSpectralFilePath, 'String')]));
set(handles.listboxSpectralFileName,'String',cellstr([SpectralFileName; get(handles.editSpectralFileName, 'String')]));
end


% --- Executes on button press in pushbuttonClearFile.
function pushbuttonClearFile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonClearFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.listboxSpectralFilePath,'String',{});
set(handles.listboxSpectralFileName,'String',{});
set(handles.listboxSpectralFilePath,'Value',1);
set(handles.listboxSpectralFileName,'Value',1);
end


% --- Executes on button press in pushbuttonRemoveFile.
function pushbuttonRemoveFile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonRemoveFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SpectralFilePath=get(handles.listboxSpectralFilePath,'String');
sizeSpectralFilePath=size(SpectralFilePath);
RemoveFileValue=get(handles.listboxSpectralFilePath,'Value')
if RemoveFileValue==sizeSpectralFilePath(1)
    set(handles.listboxSpectralFilePath,'Value',RemoveFileValue-1);
end
SpectralFilePath(RemoveFileValue,:)=[];
set(handles.listboxSpectralFilePath,'String',SpectralFilePath);

SpectralFileName=get(handles.listboxSpectralFileName,'String');
SpectralFileName(RemoveFileValue,:)=[];
set(handles.listboxSpectralFileName,'String',SpectralFileName);
set(handles.listboxSpectralFileName,'Value',get(handles.listboxSpectralFilePath,'Value'));
end



function editNumberOfCalculation_Callback(hObject, eventdata, handles)
% hObject    handle to editNumberOfCalculation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editNumberOfCalculation as text
%        str2double(get(hObject,'String')) returns contents of editNumberOfCalculation as a double
end

% --- Executes during object creation, after setting all properties.
function editNumberOfCalculation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editNumberOfCalculation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function editDisplaySize_Callback(hObject, eventdata, handles)
% hObject    handle to editDisplaySize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDisplaySize as text
%        str2double(get(hObject,'String')) returns contents of editDisplaySize as a double
end

% --- Executes during object creation, after setting all properties.
function editDisplaySize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDisplaySize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function editSmoothSpan1_Callback(hObject, eventdata, handles)
% hObject    handle to editSmoothSpan1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSmoothSpan1 as text
%        str2double(get(hObject,'String')) returns contents of editSmoothSpan1 as a double
end

% --- Executes during object creation, after setting all properties.
function editSmoothSpan1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSmoothSpan1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in popupmenuSmoothMethod1.
function popupmenuSmoothMethod1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuSmoothMethod1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuSmoothMethod1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuSmoothMethod1
end

% --- Executes during object creation, after setting all properties.
function popupmenuSmoothMethod1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuSmoothMethod1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in pushbuttonSmoothSigma.
function pushbuttonSmoothSigma_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonSmoothSigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FileFullName=[get(handles.editIntensityFilePath,'String') get(handles.editIntensityFileName,'String')];
load([FileFullName '.MAT']);
sizeNetROIInterplated=size(NetROIInterplated);
SmoothSpan=str2num(get(handles.editSmoothSpan1,'String'));
SmoothMethod=get(handles.popupmenuSmoothMethod1,'String');
SmoothMethodValue=SmoothMethod{get(handles.popupmenuSmoothMethod1,'Value')};
SmoothMatrix=zeros(sizeNetROIInterplated(1),sizeNetROIInterplated(2),sizeNetROIInterplated(3));

for i=1:sizeNetROIInterplated(1)
    for j=1:sizeNetROIInterplated(2)
        temp=zeros(sizeNetROIInterplated(3),1);
        temp=smooth(squeeze(NetROIInterplated(i,j,:)),SmoothSpan,SmoothMethodValue);
        temp2(1,1,:)=temp';
        SmoothMatrix(i,j,:)=temp2;
    end
end
NetROIInterplated=SmoothMatrix;
save([FileFullName '_' SmoothMethodValue '.MAT'],'NetROIInterplated');
end



function editEqualArea1_Callback(hObject, eventdata, handles)
% hObject    handle to editEqualArea1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editEqualArea1 as text
%        str2double(get(hObject,'String')) returns contents of editEqualArea1 as a double
end

% --- Executes during object creation, after setting all properties.
function editEqualArea1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editEqualArea1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in pushbuttonEqualArea1.
function pushbuttonEqualArea1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonEqualArea1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FileFullName=[get(handles.editIntensityFilePath,'String') get(handles.editIntensityFileName,'String')];
load([FileFullName '.MAT']);
sizeNetROIInterplated=size(NetROIInterplated);
EqualAreaRange=str2num(get(handles.editEqualArea1,'String'));
sizeEqualAreaRange=size(EqualAreaRange);
EqualAreaMatrix=zeros(sizeNetROIInterplated(1),sizeNetROIInterplated(2),sizeEqualAreaRange(2));
EqualAreaResult=zeros(sizeNetROIInterplated(1),sizeNetROIInterplated(2));
EqualAreaAlphaData=zeros(sizeNetROIInterplated(1),sizeNetROIInterplated(2));

%shift the minimum of each pixel (along Sigma) to 0
% for i=1:sizeNetROIInterplated(1)
%     for j=1:sizeNetROIInterplated(2)
%         minTemp=min(NetROIInterplated(i,j,:));
%         NetROIInterplated(i,j,:)=NetROIInterplated(i,j,:)-minTemp;
%     end
% end

for i=1:sizeNetROIInterplated(1)
    for j=1:sizeNetROIInterplated(2)
        EqualAreaAlphaData(i,j)=trapz(NetROIInterplated(i,j,EqualAreaRange));
        EqualAreaMatrix(i,j,:)=cumtrapz(NetROIInterplated(i,j,EqualAreaRange));
        k=1;
        while EqualAreaMatrix(i,j,k)<EqualAreaMatrix(i,j,sizeEqualAreaRange(2))/2
            k=k+1;
        end
        if (k>1) && (k<sizeEqualAreaRange(2))
            temp=k-1+(EqualAreaMatrix(i,j,sizeEqualAreaRange(2))/2-EqualAreaMatrix(i,j,k-1))/(EqualAreaMatrix(i,j,k)-EqualAreaMatrix(i,j,k-1));
            EqualAreaResult(i,j)=temp-1+EqualAreaRange(1);
        else
            EqualAreaResult(i,j)=NaN;
            
        end
    end
end
figure;
imagesc(EqualAreaResult);
colormap 'jet';
colorbar;
alpha(EqualAreaAlphaData);
alpha('scaled');
daspect([2 1 1]);
savefig([FileFullName '_equalarea' '.fig']);
epsName=[FileFullName '_equalarea' '.eps']
end
