path_gt="extracted_from_smear\gt";
path_img="extracted_from_smear\img";
path_hd="D:\Testing_on _images\Synthetic_Dataset\MP-IDB\Falciparum\img";
path_hd_gt="D:\Testing_on _images\Synthetic_Dataset\MP-IDB\Falciparum\gt";
hd_list = dir(fullfile(path_hd,'*.jpg'));
hd_gt_list = dir(fullfile(path_hd_gt,'*.jpg'));
for i=1:length(hd_list)
%for i=1:1
    hd_path=fullfile(hd_list(i).folder,hd_list(i).name);
    hd_gt_path=fullfile(hd_gt_list(i).folder,hd_gt_list(i).name);
    img=imread(hd_path);
    gt=imread(hd_gt_path);
    gt = uint8(imcomplement(imbinarize(gt)));
    gt3=uint8([]);
    gt3(:,:,1)=gt;
    gt3(:,:,2)=gt;
    gt3(:,:,3)=gt;
    img=img.*gt3;
    img_to_cell_and_gt(img,path_img,path_gt,i);
end