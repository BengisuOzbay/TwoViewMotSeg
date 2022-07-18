function [outliers,i_o,reinlier_idx,i_o_all_bin,P_all,t2] = gpca_invSOS_twoStep(x,n,reject,labels,method)

if (nargin<4)
    method='Cos^2';
end

[Kx,Nx] = size(x);
% x = cnormalize(x);


% Apply linear transformation to data for better numerical stability
%[Ux,Sx,Vx] = svd(x,0); % x is mapped to U'x
Ux=eye(Kx);
x = Ux'*x;

%generate veronese map using one less number of clusters
cluster_num = n;
n=n*2;
% [Ln,~] = veronese(x,2);
% Ln_norm = cnormalize(Ln);
% cn = Ln(1,:)./Ln_norm(1,:);
[Ln,~] = veronese_quad(x,cluster_num*2);
% Ln = Ln./(repmat(cn,size(Ln,1),1).^cluster_num);
Ln = conj(Ln');
%% remove outliers

if reject
    [Q,thresh] = findQ_norm(x,x,n);
    
    magic = 0.8;
    t1 = magic*thresh;
    
    figure; plot(Q,'*');hold on;
    plot(t1*ones(size(Q,1)),'r');
    title('Q');hold off;
    %
    % removing the outliers first before picking min Q
    reinlier_idx = (Q<thresh);%1:length(Q);%
    W=Q(reinlier_idx);
    
%     [~,i_o] = max(Q);
% 
%     P_all = findP_old_norm(x,x(:,reinlier_idx),n,i_o);
%     P_all = P_all/max(P_all);
% 
%     t2 = graythreshFast(P_all);
%     figure;plot(P_all,'*');hold on;
%     plot(t2*ones(size(P_all,1)),'r');
%     
%     reinlier_idx = P_all<t2;
else
    reinlier_idx=1:size(Ln,1);
end

reinliers_all = reinlier_idx;
Ln_cleaned = Ln(reinlier_idx,:);
x_o = x(:,reinlier_idx);
% if cluster_num > 1
%% picking outlier class by computing Q on reliable inliers
%compute moment matrix
% [Q,thresh] = findQ(x_o,x_o,n);
[Q,thresh] = findQFast(Ln_cleaned,Ln_cleaned);
[~,i_os] = sort(Q);

% figure;plot(Q,'*');

i_o_all_bin = false;
s_i = 1;
% while length(find(i_o_all_bin))<=3 & s_i<=length(i_os)
i_o = i_os(s_i);%i_o=157
s_i = s_i+1;
cn = nan;
P_all = findP_old_norm(x_o,x_o,(cluster_num-1)*2,i_o,cn);
P_all = P_all/max(P_all);

t2 = graythreshFast(P_all);%
% t2 = findlevels(P_all,3);
% t2 = graythresh(P_all(P_all<t2));
i_o_all_bin = P_all>=t2 ;
% end
% figure;plot(P_all,'*');hold on;
% plot(t2*ones(size(P_all,1)),'r');

outliers = x(:,reinlier_idx);
outliers = outliers(:,i_o_all_bin);
end
