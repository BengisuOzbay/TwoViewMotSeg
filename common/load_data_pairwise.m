function [Xs,labels,img1s,img2s,pairNames] = load_data_pairwise( dataPath,sequencename, out )
% Returns a list of X containing every pair in total ncams*(ncams-1)/2

if (nargin<3)
    % load inlier data
    out = 0;
end

load(strcat(dataPath,sequencename,'/data.mat'));

% load(strcat(dataPath,sequencename,'/gt_labels.mat'));
pairNames = {};
img1s = {};
img2s = {};
Xs = {};
labels = {};
pairID = 0;
for i=1:length(imnames)
    for j = i+1:length(imnames)
        pairID =pairID+1;
        img1s{pairID} =imread(imnames(i).name);
        img2s{pairID} = imread(imnames(j).name);
        
        pairNames{pairID} = {imnames(i).name; imnames(j).name}  ;
        
        idxPairs = pairwiseEst{i,j};
        im1Locs = SIFT{i}.locs(idxPairs.ind1,:)';
        im2Locs = SIFT{j}.locs(idxPairs.ind2,:)';
        
        Xs{pairID} = [im1Locs;ones(1,size(im1Locs,2));...
            im2Locs;ones(1,size(im2Locs,2))];
        
%         %Uncomment below if using groundtruth labels        
%         label1 = labels_gt(1+cumDim(i):cumDim(i)+dim(i));
%         label1 = label1(idxPairs.ind1);
%         label2 = labels_gt(1+cumDim(j):cumDim(j)+dim(j));
%         label2 = label2(idxPairs.ind2);
%         labels{pairID} = label1;

        label = labels_pairwise{i,j};
        labels{pairID} = label;
        
%         figureImPair(img1s{pairID}, img2s{pairID}, Xs{pairID}, label,...
%             sequencename);
    end
end

% X = data; 
G = label; N=length(G);

% if(out==0)
%     %      disp('only inlier are loaded')
%     X = X(:,G~=0);
%     G = G(G~=0);
% end
% 
% 
% [X,flg] = remove_repeated_points(X);
% G=G(flg);
% 
% % reorder data
% [~, order]=sort(G);
% G=G(order);
% X=X(:,order);

end