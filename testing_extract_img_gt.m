path_gt="extracted_from_smear\gt";
path_img="extracted_from_smear\img";
gs=[];
gs=rgb2gray(img);
gs1=[];
gs1=gs/10;
gs1=uint8(gs1);
gs1(gs1>17)=0;
gs1=medfilt2(gs1);

gs1 = imbinarize(imfill(gs1,'holes'));
gs1 = bwareafilt(gs1,[500 370000]);
size_max=5;
for index=1:size_max
    se = strel('disk',index);
    gs1=imclose(gs1,se);
    gs1 = imfill(gs1,'holes');
end
gs1 = bwareafilt(gs1,[500 370000]);
gs2=uint8([]);
gs2(:,:,1) = gs1;
gs2(:,:,2) = gs1;
gs2(:,:,3) = gs1;
masked=img.*gs2;
%montage({masked,img,gs1,gs2});
%imshow(masked);
[Label,Total]=bwlabel(gs1,8);
props=regionprops(Label,'BoundingBox','Circularity','Eccentricity');
for i=1:Total
    if props(i).Circularity > 0.7 ||  props(i).Eccentricity < 0.4
        Img=imcrop(img,props(i).BoundingBox);
        Name_img=strcat('img_',num2str(i),".jpg");
        Gt=imcrop(gs1,props(i).BoundingBox);
        [LabelG,TotalG]=bwlabel(Gt,8);
        if TotalG == 1
        NameGt=strcat('gt_',num2str(i),".jpg");
        gs2=uint8([]);
        gs2(:,:,1) = Gt;
        gs2(:,:,2) = Gt;
        gs2(:,:,3) = Gt;
        Img=Img.*gs2;
        %figure,imshow(Img); title(Name);
        %figure,imshow(Gt); title(NameGt);
        imwrite(Img,fullfile(path_img,Name_img));
        imwrite(Gt,fullfile(path_gt,NameGt));
        end
    end
end