num_images_train=300;
num_images_val=50;
path_train="D:\Testing_on _images\Synthetic_Dataset\new_dataset\train";
path_val="D:\Testing_on _images\Synthetic_Dataset\new_dataset\val";
for i=1:num_images_train
    img_name=strcat("img_",num2str(i),".jpg");
    filename_img=fullfile(path_train,"img",img_name);
    gt_name=strcat("img_",num2str(i),".jpg");
    filename_gt=fullfile(path_train,"gt",gt_name);
    [img, gt]=create_syntetic();
    img=imresize(img, [1280 1280]);
    gt=imresize(gt, [1280 1280]);
    imwrite(img,filename_img);
    imwrite(gt,filename_gt);
end

for i=1:num_images_val
    img_name=strcat("img_",num2str(i),".jpg");
    filename_img=fullfile(path_val,"img",img_name);
    gt_name=strcat("img_",num2str(i),".jpg");
    filename_gt=fullfile(path_val,"gt",gt_name);
    [img, gt]=create_syntetic();
    img=imresize(img, [1280 1280]);
    gt=imresize(gt, [1280 1280]);
    imwrite(img,filename_img);
    imwrite(gt,filename_gt);
end