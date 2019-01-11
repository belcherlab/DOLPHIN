clear;
load('allResults__ClassObj.mat');
load(fullfile(obj.foldername,obj.HSC));
ImageToBeProcessed=squeeze(mean(HSC(:,:,obj.range{2}),3));
MIJ.createImage('ImageToBeProcessed',ImageToBeProcessed,true);