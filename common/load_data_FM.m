function [X,G,img1,img2] = load_data_FM( sequencename, out )


if (nargin<2)
    % load inlier data
    out = 0;
end

load(sequencename)
img1=img1;
X= data;G =label'; N=size(X,2);
%   X = [X1;ones(size(aprioriLabels));X2;ones(size(aprioriLabels))];data=X;
%   G = aprioriLabels'; N=size(X,2);
 if(out==0)
%      disp('only inlier are loaded')
     X = X(:,G~=0);
     G = G(G~=0);
 end
 

[X,flg] = remove_repeated_points(X);
G=G(flg);

% reorder data
[~, order]=sort(G);
G=G(order);
X=X(:,order);
% figure;subplot(2,1,1);imshow(img1); hold on; gscatter(X(1,:),X(2,:), G)
% subplot(2,1,2);imshow(img2); hold on; gscatter(X(4,:),X(5,:), G);
% suptitle('Ground truth labels')
% figure;imshow(img1); hold on; gscatter(X(1,:),X(2,:), G);title([sequencename '1 gt']);
% figure;imshow(img2); hold on; gscatter(X(4,:),X(5,:), G);title([sequencename '2 gt']);
% suptitle('Ground truth labels')
% imwrite(img1, [extractBefore(sequencename,["."]), '1.png']);
% imwrite(img2, [extractBefore(sequencename,["."]), '2.png']);

% fileID = fopen([extractBefore(sequencename,["."]),'_label.txt'],'w');
% formatSpec = '%d \n';
% [nrows,ncols] = size(label');
% for row = 1:nrows
% fprintf(fileID,formatSpec,label(row)');
% end
% fclose(fileID);
end

