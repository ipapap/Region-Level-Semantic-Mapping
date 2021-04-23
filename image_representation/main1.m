clear all;
clc;


%Read images from the folder
folder='/home/gns/codes/matlab_files/voc/';
I=dir(folder);
I=I(3:end);
subsamplingRate = 1;

numOfFeaturesPerImage =300;

total_features=0;
counter = 1;
array_vectors = [];

for k=1:subsamplingRate:numel(I)
% for k=1:numel(I)
    filename=fullfile(folder,I(k).name);
    I2{k}=imread(filename);


    %Extract SURF features from an image
    %IM = rgb2gray(I2{k});
    IM=I2{k};
    points = detectSURFFeatures(IM);
    points = points(1:min(numOfFeaturesPerImage, length(points)));
    [features, valid_points] = extractFeatures(IM, points);
    total_features=total_features+size(features,1);
    [m,n]=size(features);
    
%     for i=1:m
%         
%         array_vectors(counter, :) = features(i, :);
%         counter = counter + 1;
%         
%     end

% OR 
     array_vectors(end+1:end+m, :) = features;
     disp([num2str(k) '/' num2str(numel(I))]);
    
end
numOfImages = numel(I);
save('output_localization', 'array_vectors', 'numOfImages');

% declare tree properties
numOfLevels =5;
numOfBranches = 15;
% numOfLevels = 3;
% numOfBranches = 8;
% create tree
tree = createTree(array_vectors, numOfLevels, numOfBranches, numOfImages);

save('VocabTree', 'tree');
