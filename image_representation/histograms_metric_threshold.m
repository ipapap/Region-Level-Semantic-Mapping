clear;
clc;
close all;
loadSaved=false;
%fileNamestr = 'results';
myPath = '/home/gns/Downloads/seq3_cloudy1 (3)/std_cam';

temp = dir(myPath);
temp=temp(3:end);
%temp(1).name;

%myVideo = VideoReader('/home/gryphonlab/Desktop/gns/std_cam.mpg');
img=1;
aa=1;
%isLong = true;



peak_thresh = 1;
numOfFeaturesPerImage = 300;

%fileNamestr = [fileNamestr '_L' num2str(isLong)];

%fileNamestr = [fileNamestr '_' num2str(numOfFeaturesPerImage)];

if(~loadSaved)
    array_vectors=[];
    
for i = 1:1:length(temp)
     disp('Getting image');
    fileName = [myPath '/' temp(i).name];
    b = imread(fileName);
                   
    b=double(b)/255;
       b=single(rgb2gray(b));
        b=single(b);
        disp('detecting features');
        points = detectSURFFeatures(b);
        disp('getting descriptors');
        [features, validPoints] = extractFeatures(b, points);
        
        disp('retaining only numOfFeaturesPerImage');
        if (size(features,1) > numOfFeaturesPerImage )
            features = features(1:numOfFeaturesPerImage,:);
        end
        
        disp('getting histogram descriptor');
        photo_table = table_photo(features,tree);
        disp('Adding to histogram table');
        VideoTable_fr_300(aa).histogram = photo_table; % ������� ����������� ���������������
        aa=aa+1;
 
        img = img + 1;
        %disp([filename ' ' num2str(myVideo.CurrentTime < myVideo.Duration)]);
    
end

    
    save('VideoTable_FR3_1_300_DEFAULT.mat', 'VideoTable_fr_300', '-v7.3');
    
end

 numOfLevels = 5;
    numOfBranches = 10;

    Compare.difference=ones(length(VideoTable_fr_300),length(VideoTable_fr_300))*0.2929; % ������� �� ��� ���������� ��� ����������� ���������������

    for i=1:size(VideoTable_fr_300,2)
        for j=i:size(VideoTable_fr_300,2)

            unit1 = VideoTable_fr_300(i).histogram / norm(VideoTable_fr_300(i).histogram);
            unit2 = VideoTable_fr_300(j).histogram / norm(VideoTable_fr_300(j).histogram);

            Compare.difference(i, j) = 1 - 0.5*norm(unit1 - unit2); % ���������� ����������        
        end
    end
    
  

 for i = 1:size(Compare.difference,1)
     Compare.difference(i,i) = 0;
 end

 figure(1);
 clf;
 imagesc(Compare.difference);
 
 loops = zeros(size(Compare.difference));
 loopsIds = Compare.difference > 0.35; 
 loops(loopsIds) = 1;
 figure(2);
 clf;
 spy(loops);
 
 sum = 0;
for i=1:(size(loops,2))
    for j=i:(size(loops,2))
        if loops(i,j) == 1
            sum = sum + 1;
        end
    end
end

disp(sum);
 
