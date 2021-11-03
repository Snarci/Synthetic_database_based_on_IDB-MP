path_crops="D:\Testing_on _images\Synthetic_Dataset\MP-IDB\Falciparum\crops";
imds = imageDatastore(path_crops,"IncludeSubfolders",true,"LabelSource","foldernames");
[imds1,imds2] = splitEachLabel(imds,0.5);
dsrand = shuffle(imds2);
[img,info]=read(dsrand);
mask=imbinarize(rgb2gray(img));
