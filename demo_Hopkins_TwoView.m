clear all;
close all
addpath(genpath([pwd '/']));

%% reading Hopkins dataset
dataPath = fullfile([pwd '/Datasets/HopkinsClean/']); out=0;
% dataPath = fullfile([pwd '/Datasets/HopkinsOutlier/']); out=1;%set to 0 if there is no outliers

addpath(genpath(dataPath));
folderList = dir(dataPath);
folderList(strncmp({folderList.name}, '.', 1)) = [];
folderList(strncmp({folderList.name}, '..', 1)) = [];
folderNames = {folderList.name};
%% 
totErrSOS =nan*ones(1,length(folderNames));
timesSOS = nan*ones(1,length(folderNames));

% for ri=1:5 %Uncomment to run multiple random runs
% rng(ri);
for jj =1:length(folderNames)
%     out = 0;% set to 0 if there is no outliers
    sequencename = folderNames{jj};
    load(sequencename)
    y = data; G = label';
    % normalization
    [dat_img_1, ~] = normalise2dpts(y(1:3,:));
    [dat_img_2, ~] = normalise2dpts(y(4:6,:));
    
    % five dimensional data matrix
    X = [ dat_img_1(1:2,:); dat_img_2 ];
    
    ngroups = max(G); % number of models
    s = G';

    [rr,~] = size(X);
    
    tic;[groupsSOS,X_i_rel] = sos_spaces_vestF(X,ngroups,s,rr,out);
    timesSOS(jj) = toc;
    missrate = segmentation_error(groupsSOS(:)', s(:)');
    disp(strcat(num2str(jj),' ',sequencename,':',num2str(missrate)))
    totErrSOS(jj) =  missrate;
    
    
    %% Uncomment this section to plot figures with detected segmentation
%     figure;hold on;
%     subplot(2,1,1);hold on;imshow(img1); gscatter(y(1,:),y(2,:), groupsSOS);
%     subplot(2,1,2);hold on; imshow(img2);gscatter(y(4,:),y(5,:), groupsSOS);
%     suptitle([sequencename,', Seg. Error ',num2str(missrate),'%' ]);
end
% end %end of multiple random runs