function [] = img_to_cell_and_gt(img,path_img,path_gt,index_to_write)
gs=[];
gs=rgb2gray(img);
gs1=[];
gs1=gs/10;
gs1=uint8(gs1);
gs1(gs1>17)=0;
gs1=medfilt2(gs1);

gs1 = imbinarize(imfill(gs1,'holes'));
gs1 = bwareafilt(gs1,[3500 1470000]);
size_max=10;
for index=1:size_max
    se = strel('disk',index);
    gs1=imopen(gs1,se);
    gs1 = imfill(gs1,'holes');
end
gs1 = bwareafilt(gs1,[3500 1470000]);
[Label,Total]=bwlabel(gs1,8);
props=regionprops(Label,'BoundingBox','Circularity','Eccentricity','Area','ConvexArea');
[dx , dy ,dz]=size(img);
for i=1:Total
    if props(i).Circularity > 0.45 && (props(i).ConvexArea/props(i).Area) >=0.85
        bb=props(i).BoundingBox;
        %non prendo roba spiccicata ne che finisce prima del bordo
        
        %if bb(1) > 100 && (bb(1)+bb(3))<(dx-100) && bb(2) > 100 && (bb(2)+bb(4))<(dy-100)
        if bb(1) > 10 && bb(2) > 10 && (bb(1)+bb(3))<(dy-10) && (bb(2)+bb(4))<(dx-10)
            Img=imcrop(img,props(i).BoundingBox);
            Name_img=strcat('img_',num2str(i),"_",num2str(index_to_write),".jpg");
            Gt=imcrop(gs1,props(i).BoundingBox);
            Gt = bwareafilt(Gt,1);
            
            
            NameGt=strcat('gt_',num2str(i),"_",num2str(index_to_write),".jpg");
            gs2=uint8([]);
            gs2(:,:,1) = Gt;
            gs2(:,:,2) = Gt;
            gs2(:,:,3) = Gt;
            Img=Img.*gs2;
            imwrite(Img,fullfile(path_img,Name_img));
            imwrite(Gt,fullfile(path_gt,NameGt));
        end
        
    end
end
end

