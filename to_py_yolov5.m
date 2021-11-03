
dataset_path="D:\Testing_on _images\Synthetic_Dataset\new_dataset\train\img";
ground_truth_path="D:\Testing_on _images\Synthetic_Dataset\new_dataset\train\gt";



testing_set_crops=imageDatastore(dataset_path,'IncludeSubFolders',true','LabelSource','foldernames');
testing_set_gt=imageDatastore(ground_truth_path,'IncludeSubFolders',true','LabelSource','foldernames');


boxlabel_array={};
for i=1:numel(testing_set_gt.Files)
    O = imread(testing_set_crops.Files{i});
    L = imread(testing_set_gt.Files{i});
    L = bwareaopen(L,20);
    [bwLabel,num]=bwlabel(L,8);
    [width, height] = size(L);
    
    L_props = regionprops(L, 'BoundingBox'); % for Object Detection
    L_props_cell=struct2cell(L_props);
    L_props_mat=cell2mat(L_props_cell');
    boxlabel_array{i}=L_props_mat;
    bboxNumber = max(size(L_props));
    
    
    
    
end
%da cambiare con il nome della classe corretta

crop=boxlabel_array';
boxlabel_array=cell2table(crop);
boxlabel_array=boxLabelDatastore(boxlabel_array);


train_crops=testing_set_crops;
train_b=boxlabel_array;






destination_img="D:\Testing_on _images\Synthetic_Dataset\yolo_dataset\images\train";
destination_gt="D:\Testing_on _images\Synthetic_Dataset\yolo_dataset\labels\train";
image_index=1;

while(hasdata(train_crops))
    %creazione nomi
    name_img=strcat("img","_",string(image_index));
    
    
    %creazione path
    img_name_complete=fullfile(destination_img,name_img);
    gt_name_complete=fullfile(destination_gt,name_img);
    gt_name_complete=strcat(gt_name_complete,".txt");
    img_name_complete=strcat(img_name_complete,".jpg");
    [img,~]=read(train_crops);
    
    [gt,~]=read(train_b);
    
    labels=gt{1};
    if not(isempty(labels))
        [x,y]=size(labels);
        classes=zeros(x,1);
        con=horzcat(classes,labels);
        con(:,2)=con(:,2)+con(:,4)/2;
        con(:,3)=con(:,3)+con(:,5)/2;
        con=con/1280;
        imwrite(img, img_name_complete);
        dlmwrite(gt_name_complete,con,'delimiter',' ');
        image_index=image_index+1;
    end
end



dataset_path="D:\Testing_on _images\Synthetic_Dataset\new_dataset\val\img";
ground_truth_path="D:\Testing_on _images\Synthetic_Dataset\new_dataset\val\gt";
%[testing_set_gt,~] = test_datastore(dataset_path,"");
%[testing_set_crops,numClasses] = test_datastore(dataset_path,"");

testing_set_crops=imageDatastore(dataset_path,'IncludeSubFolders',true','LabelSource','foldernames');
testing_set_gt=imageDatastore(ground_truth_path,'IncludeSubFolders',true','LabelSource','foldernames');

%testing_set_crops.ReadFcn = @customReadDatastoreImage224;
%testing_set_gt.ReadFcn = @customReadDatastoreImage224;

boxlabel_array={};
for i=1:numel(testing_set_gt.Files)
    O = imread(testing_set_crops.Files{i});
    L = imread(testing_set_gt.Files{i});
    L = bwareaopen(L,20);
    [bwLabel,num]=bwlabel(L,8);
    [width, height] = size(L);
    % Obtain Bounding Boxes --- TODO transform to function
    L_props = regionprops(L, 'BoundingBox'); % for Object Detection
    L_props_cell=struct2cell(L_props);
    L_props_mat=cell2mat(L_props_cell');
    boxlabel_array{i}=L_props_mat;
    bboxNumber = max(size(L_props));
    
    
    
    
end
%da cambiare con il nome della classe corretta

crop=boxlabel_array';
boxlabel_array=cell2table(crop);
boxlabel_array=boxLabelDatastore(boxlabel_array);


validation_crops=testing_set_crops;
validation_b=boxlabel_array;


destination_img="D:\Testing_on _images\Synthetic_Dataset\yolo_dataset\images\val";
destination_gt="D:\Testing_on _images\Synthetic_Dataset\yolo_dataset\labels\val";


while(hasdata(validation_crops))
    %creazione nomi
    name_img=strcat("img","_",string(image_index));
    
    
    %creazione path
    img_name_complete=fullfile(destination_img,name_img);
    gt_name_complete=fullfile(destination_gt,name_img);
    gt_name_complete=strcat(gt_name_complete,".txt");
    img_name_complete=strcat(img_name_complete,".jpg");
    [img,~]=read(validation_crops);
    [gt,~]=read(validation_b);
    
    labels=gt{1};
    if not(isempty(labels))
        [x,y]=size(labels);
        classes=zeros(x,1);
        con=horzcat(classes,labels);
        con(:,2)=con(:,2)+con(:,4)/2;
        con(:,3)=con(:,3)+con(:,5)/2;
        con=con/1280;
        imwrite(img, img_name_complete);
        dlmwrite(gt_name_complete,con,'delimiter',' ');
        image_index=image_index+1;
    end
end













