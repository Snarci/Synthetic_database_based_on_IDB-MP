function [background_img,background_gt_crops] = create_syntetic()
%CREATE_SYNTETIC Summary of this function goes here
path_gt="extracted_from_smear\gt";
path_img="extracted_from_smear\img";
path_crops="D:\Testing_on _images\Synthetic_Dataset\MP-IDB\Falciparumb\crops";
sizey=2592;
sizex=1944;
background_img=uint8(zeros(sizex,sizey,3));
background_gt=uint8(zeros(sizex,sizey));

background_black(:,:,1)=0;
background_black(:,:,2)=0;
background_black(:,:,3)=0;
background_black=uint8(background_black);


background_color_r=218;
background_color_g=224;
background_color_b=240;
background_color(:,:,1)=background_color_r;
background_color(:,:,2)=background_color_g;
background_color(:,:,3)=background_color_b;
background_color=uint8(background_color);
background_img=background_img+background_color;

img_list = dir(fullfile(path_img,'*.jpg'));
gt_list = dir(fullfile(path_gt,'*.jpg'));

noe=100;
retry=5;
for i=1:noe
    r = randi([1 length(img_list)]);
    img_path=fullfile(img_list(r).folder,img_list(r).name);
    gt_path=fullfile(gt_list(r).folder,gt_list(r).name);
    gt=imread(gt_path);
    gt3=[];
    gt3(:,:,1)=gt;
    gt3(:,:,2)=gt;
    gt3(:,:,3)=gt;
    gt3=uint8(gt3);
    img=imread(img_path);
    
    %img=img.*gt3;
    for t=1:retry
        [dimcx,dimcy]=size(gt);
        randx= randi([1 (sizex-dimcx-1)]);
        randy= randi([1 (sizey-dimcy-1)]);
        %controllo se è tutto zero o fitta
        flag=1;
        gtx=1;
        gty=1;
        for cx=randx:randx+dimcx-1
            gty=1;
            for cy=randy:randy+dimcy-1
                if img(gtx,gty,1)<=30 && img(gtx,gty,2)<=30 && img(gtx,gty,2)<=30
                    img(gtx,gty,:)=background_color;
                end
                if background_gt(cx,cy)==0 || gt(gtx,gty)==0

                else
                    flag=0;
                end
                gty=gty+1;
            end
            gtx=gtx+1;
        end
        gtx=1;
        gty=1;
        if flag==1
            for cx=randx:randx+dimcx-1
                gty=1;
                for cy=randy:randy+dimcy-1
                    
                    background_gt(cx,cy)=gt(gtx,gty);
                    background_img(cx,cy,:)=img(gtx,gty,:);
                    
                    gty=gty+1;
                end
                gtx=gtx+1;
            end

            break
        end
        
    end
end
%imshow(background_img);

%ora possoaggiungere i crops
max_crops=30;
retry_crops=8;
imds = imageDatastore(path_crops,"IncludeSubfolders",true,"LabelSource","foldernames");
[~,imds2] = splitEachLabel(imds,0.5);
background_gt_crops=uint8(zeros(sizex,sizey));
r = randi([1 max_crops]);
for i=1:r
    dsrand = shuffle(imds2);
    [img,info]=read(dsrand);
    if info.Label == 'R'
    elseif info.Label == 'G'
        fprintf('Diverso \n')
    end
    img=agument_image(img);
    gt=uint8(imbinarize(rgb2gray(img)))*255;
    gt3=[];
    gt3(:,:,1)=gt;
    gt3(:,:,2)=gt;
    gt3(:,:,3)=gt;
    gt3=uint8(gt3);
    
    %img=img.*gt3;
    for t=1:retry_crops
        [dimcx,dimcy]=size(gt);
        randx= randi([1 (sizex-dimcx-1)]);
        randy= randi([1 (sizey-dimcy-1)]);
        %controllo se è tutto zero o fitta
        flag=1;
        gtx=1;
        gty=1;
        for cx=randx:randx+dimcx-1
            gty=1;
            for cy=randy:randy+dimcy-1
                if img(gtx,gty,1)<=30 && img(gtx,gty,2)<=30 && img(gtx,gty,2)<=30
                    img(gtx,gty,:)=background_color;
                end
                if (background_gt(cx,cy)==255 || gt(gtx,gty)==255) && (info.Label == 'R' || info.Label == 'T')

                elseif (background_gt(cx,cy)==0 || gt(gtx,gty)==0) && (info.Label ~= 'R' && info.Label ~= 'T')
                else
                    flag=0;
                end
                gty=gty+1;
            end
            gtx=gtx+1;
        end
        gtx=1;
        gty=1;
        if flag==1
            for cx=randx:randx+dimcx-1
                gty=1;
                for cy=randy:randy+dimcy-1
                    
                    background_gt(cx,cy)=gt(gtx,gty);
                    background_gt_crops(cx,cy)=gt(gtx,gty);
                    if(img(gtx,gty,:)==background_color)
                    else
                    background_img(cx,cy,:)=img(gtx,gty,:);
                    end
                    gty=gty+1;
                end
                gtx=gtx+1;
            end 
            break
        end
    end
end
%montage({background_img,background_gt,background_gt_crops});
%imshow(background_img);


end

