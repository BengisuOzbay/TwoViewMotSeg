clear all;
close all
addpath(genpath([pwd '/']));

%% reading Adelaide dataset

dataPath = fullfile([pwd '/Datasets/Adelaide-F']);
addpath(genpath(dataPath));
folderList = dir(dataPath);
folderList(strncmp({folderList.name}, '.', 1)) = [];
folderList(strncmp({folderList.name}, '..', 1)) = [];
folderNames = {folderList.name};
%%
totErrSOS =[];timesSOS = [];

% for ri=1:5 %Uncomment to run multiple random runs
% rng(ri);
for jj =1:length(folderNames)
    out = 1;% if 0 no outliers
    sequencename = folderNames{jj};
    [y,G,img1,img2] = load_data_FM(sequencename,out);
    
    % normalization
    [dat_img_1 T1] = normalise2dpts(y(1:3,:));
    [dat_img_2 T2] = normalise2dpts(y(4:6,:));
    X = [ dat_img_1(1:2,:); dat_img_2 ];

    ngroups = max(G); % number of models
    s = G';
    
    [rr,Np] = size(X);
    
    tic;[groupsSOS,X_i_rel] = sos_spaces_vestF(X,ngroups,s,rr,out);
    timesSOS = [timesSOS toc];
    missrate = segmentation_error(groupsSOS(:)', s(:)');
    disp(strcat(num2str(jj),' ',sequencename,':',num2str(missrate)))
    totErrSOS = [totErrSOS missrate];
    
    
    %% Uncomment this section to plot figures with detected segmentation
    figure;hold on;
    subplot(2,1,1);hold on;imshow(img1); gscatter(y(1,:),y(2,:), groupsSOS);
    subplot(2,1,2);hold on; imshow(img2);gscatter(y(4,:),y(5,:), groupsSOS);
    suptitle([sequencename,', Seg. Error ',num2str(missrate),'%' ]);
end
% end %end of multiple random runs
