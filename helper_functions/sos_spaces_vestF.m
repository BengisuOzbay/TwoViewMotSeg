function [groupsSOS,X_i_rel] = sos_spaces_vestF(X,ngroups,s,rr,out_rej)
% with cross check using F and Q in the final clustering
merging = [];
merging2 = [];
valids = 0;

validData2_num = 0;
validData3_num = 0;
figOn = false;
reject = false;
time_SOS = 0;

Fonly = true;

%%

X_all = X;
X_i = cell(1,ngroups);
X_i_rel = cell(1,ngroups);
label_i_rel=cell(1,ngroups);
label_i=cell(1,ngroups);
s_rem = s;
clust_rem = 1:ngroups;
F_est = cell(1,ngroups);
indexes = 1:size(X,2);

merged = false;

%% outlier rejection
if out_rej
[Q,thresh] = findQ_norm(X,X,ngroups*2);

magic = .6;
t1 = magic*thresh;

if figOn
    titlePlot =['outlier rejection Q with cluster # ' num2str(ngroups)];
    plotColored(Q,s,titlePlot,t1)
end
%
% removing the outliers first before picking min Q
reinlier_idx = (Q<t1);%1:length(Q);%
while nnz(reinlier_idx)<thresh
    magic = magic+0.1;
    t1 = thresh*magic;
    reinlier_idx = (Q<t1);
    nnz(reinlier_idx);
    if figOn
        titlePlot =['outlier rejection Q with total cluster # ' num2str(ngroups)];
        plotColored(Q,s,titlePlot,t1)
    end
end
W=Q(reinlier_idx);


[~,i_o_grossest] = max(Q);

P_all = findP_old_norm(X,X(:,reinlier_idx),ngroups*2,i_o_grossest);
P_all = P_all/max(P_all);

t2 = 0.001*ngroups;


reinlier_idx = P_all<t2;
while nnz(reinlier_idx)<thresh
    t2 = t2*10;
    reinlier_idx = P_all<t2;
end

if figOn
    titlePlot =['outlier rejection Q with total cluster # ' num2str(ngroups)];
    plotColored(P_all,s,titlePlot,t2)
end
else
    reinlier_idx = 1:length(s);
end
s_rem = s(reinlier_idx);
X = X(:,reinlier_idx);
%%
n_i = ngroups+1;
while n_i > 1
    n_i = n_i-1;
    n_i_inc = false;
    %% trying the SOS_RSC
    if n_i~=1 || length(s_rem)> 9
        %call GPCA
        
        %[X_o,i_o,inlier_idx,cluster_idx,P_all,t2]=gpca_invSOS_remove_pickOutlier_v1_best(X,n_i,reject);
        if n_i~=1
        [X_o,i_o,inlier_idx,cluster_idx,P_all,t2]=gpca_invSOS_twoStep(X,n_i,reject,s_rem);
        else
%         [X_o,i_o,inlier_idx,cluster_idx,P_all,t2]=gpca_invSOS_twoStep_single(X,1,reject,s_rem);
        [X_o,i_o,inlier_idx,cluster_idx,P_all,t2]=gpca_invSOS_twoStep(X,2,reject,s_rem);
        end
        while nnz(cluster_idx)<9
            t2 = t2-t2*0.1;
            cluster_idx = P_all>=t2 ;
            X_o = X(:,cluster_idx);
        end
        reinliers = find(inlier_idx);
        outliers = find(cluster_idx);
        s_rem_rel = s_rem(inlier_idx');
        cluster_id = s_rem_rel(i_o);
        
        clust_rem = clust_rem(clust_rem ~= cluster_id);
        outliers=find(inlier_idx(:)&cluster_idx(:));%reinliers(outliers);
        
        if figOn
            titlePlot =['P^2 and threshold with ' num2str(n_i)...
                ' clusters, picked cluster ' num2str(n_i)];
            plotColored(P_all,s_rem,titlePlot,t2)
        end
    else
        reinliers = 1:length(s_rem);
        outliers = 1:length(s_rem);
        X_o = X(:,outliers);
    end
        X1=X(:,(outliers));
        s_curr = s_rem(outliers);
        %% only Fundamental matrix estimation 
        %this part never used
        if length(outliers)<9 && n_i==1
            [Qeval1,thresh] = findQ_norm(X,X,1*2);
            t = thresh*1.2;
            rel_o = Qeval1<t;
            
            while nnz(rel_o)<9
                t = t*2;
                rel_o = Qeval1<t;
            end
%             if nnz(rel_o)<9
%                 rel_o = 1:size(X,2);
%             end
            X_o = X(:,rel_o);
            X1=X(:,(rel_o));
            s_curr = s_rem(rel_o);
            if figOn
                plotColored(Qeval1,s_rem,'found reliables based on which F will be calculated',t)
            end
        end
        
        if Fonly
            [Qeval1,thresh] = findQ_norm(X_o,X_o,1*2);
            t = thresh*1.2;
            rel_o = Qeval1<t;
            while nnz(rel_o)<8
                t = t*2;
                rel_o = Qeval1<t;
            end
            if figOn
                plotColored(Qeval1,s_curr,'found reliables based on which F will be calculated',t)
            end
            
            fNorm8Point = estimateFundamentalMatrix(X_o(1:2,rel_o)',X_o(3:4,rel_o)','Method','Norm8Point');
            xFx = diag([X(3:4,:)' ones(length(s_rem),1)]*fNorm8Point*[X(1:2,:)' ones(length(s_rem),1)]');
            xFx = abs(xFx);
            % grow the currently identified cluster
            xFx_norm = xFx;%/max(xFx);
            t1 = 5e-2;%graythresh(xFx_norm);
%             outlier_growns_idx = xFx_norm<t1;
            outlier_growns_idx = xFx_norm<t1;
            if figOn
                titlePlot =['for F estimte of cluster',num2str(n_i)];
                plotColored(xFx_norm,s_rem,titlePlot,t1)
            end
            while nnz(outlier_growns_idx)<9
                t1 = t1*2;
                outlier_growns_idx = xFx_norm<t1;
            end
                
            X1 = X(:,(outlier_growns_idx));
            s_curr = s_rem(outlier_growns_idx);
        end
        % no check for merging
        merged=false;
        % no growing
    
        
    %% finding the reliable data for each cluster
    if ~merged
        fi = n_i;
    else
        merged = false;
        fi = merging2(end);
    end
    
    if Fonly
        Fest_curr = fNorm8Point;
%     else%to be implemented
    end
    X_i{fi} = X1;
    label_i{fi} = s_curr;
    F_est{fi} = Fest_curr;
    % pick reliables among identified
    [Qeval1,thresh] = findQ_norm(X1,X1,1*2);
%     thresh = findlevels(Qeval1,3)
    i_o_all_bin =Qeval1<thresh*1.4 ;%Qeval1<thresh ;%
    while nnz(i_o_all_bin)<9
        thresh = 1.2*thresh;
        i_o_all_bin =Qeval1<thresh ;
    end
    if figOn
        titlePlot =['Q to identify reliable set for cluster' num2str(n_i)];
        plotColored(Qeval1,label_i{fi},titlePlot,thresh)
    end
%     X1_rel = X1(:,(Qeval1 <= thresh));
%     P_all = findP_old_norm([X1 X_all(:,i_o_grossest)],X1_rel,2,size(X1,2)+1);
%     P_all = P_all/max(P_all);
%     
%     t2 = graythreshFast(P_all);%
%     % t2 = graythresh(P_all(P_all<t2));
%     i_o_all_bin = P_all(1:end-1)<t2 ;
%     % end
%     if figOn
%         titlePlot =['P to identifiy reliable set for cluster' num2str(n_i)];
%         plotColored(P_all,[label_i{fi} 0],titlePlot,t2)
%     end

    X1_rel =  X1(:,i_o_all_bin);
    s_rel = s_curr(i_o_all_bin);
    
    X_i_rel{fi} = X1_rel;
    label_i_rel{fi} = s_rel;
    
    if n_i_inc
        n_i = n_i+1;
    end
    
    if n_i>1
        clust_i = setdiff(reinliers,find(outlier_growns_idx));
        if length(clust_i)<9
            clust_i = setdiff(reinliers,find(outliers));
            X = X(:,clust_i);
            s_rem = s_rem(clust_i);
        else
        X = X(:,clust_i);
        s_rem = s_rem(clust_i);clust_i = setdiff(reinliers,find(outlier_growns_idx));
        end
    end
    
    
end

%% rejecting outliers based on found inliers -removed


%% using original outlier detection for final outliers
% for ng_i = 1:ngroups
%     groups_curr = find(groups==ng_i);
% X1 = X_i_rel{ng_i};
% X_curr = X_all(:,groups_curr);
% [Q,thresh] = findQ_norm(X_curr,X1,1*2);
% %     thresh = findlevels(Q,3);
%     reinlier_idx =Q<thresh*1.2 ;Q<thresh ;
%     
%     fits_curr = use2clust(ng_i,groups_curr);
%     if figOn
%         titlePlot =['Q to identify reliable set for cluster' num2str(n_i)];
%         plotColored(Q,s(groups_curr),titlePlot,thresh)
%     end
%     [~,i_o_grossest] = max(Q);
% 
% P_all = findP_old_norm(X_curr,X_curr(:,reinlier_idx),2,i_o_grossest);
% P_all = P_all/max(P_all);
% t2 = findlevels(P_all,3);
% if figOn
%     titlePlot =['outlier rejection Q with total cluster # ' num2str(ngroups)];
%     plotColored(P_all,s(groups_curr),titlePlot,t2)
% end
% outlier_idx = P_all>t2;
% groups(groups_curr(outlier_idx)) = 0;
% 
% end

%% 
%% rejecting outliers based on found inliers
X_rels = [];
for irel = 1:ngroups
    X_rels = [X_rels X_i_rel{irel}];
end
[Q_out,thresh] = findQ_norm(X_all,X_rels,ngroups*2);

magic = 1;
t1 = findlevels(Q_out,3);magic*thresh;

if figOn
    titlePlot =['outlier rejection Q with cluster # ' num2str(ngroups)];
    plotColored(Q_out,s,titlePlot,t1)
end

%% clustering data with found regressor estimates
magicc = 1.2;
use2clust = [];
X = X_all;
for iiii = 1:ngroups
    X1=X_i_rel{iiii};
    [Qeval,thresh] = findQ_norm(X_all,X1,2);

    Qeval = cnormalize(Qeval);
    use2clust = [use2clust; Qeval'];
end
if out_rej
use2clust = [cnormalize(1./Q_out)';use2clust];
end
[~,groups] =min(use2clust);
if out_rej
groupsSOS1 = groups-1;
end
%% cross check using F to find final outliers
if out_rej
out_id = find(groupsSOS1==0);
X_outliers = X_all(:,out_id);
N = length(out_id);
fits =[];
for ng_i = 1:ngroups
    X_o = X_i_rel{ng_i};
    F_i = estimateFundamentalMatrix(X_o(1:2,:)',X_o(3:4,:)','Method','Norm8Point');
    fit_i = diag([X_outliers(3:4,:)' ones(N,1)]*F_i*[X_outliers(1:2,:)' ones(N,1)]');
    fit_i = (abs(fit_i));
%     figure;plot(fit_i)
    thresh =2e-2;%graythresh(fits_curr);
    if figOn
    plotColored(fit_i,s(groupsSOS1==0),['clustering for ',num2str(ng_i)],thresh)
    end
    fits = [fits; fit_i'];
%     (out_id(fit_i<thresh)) = ng_i;
    
end
[fits_min fits_min_label] = min(fits,[],1);
groupsSOS1(out_id(fits_min<thresh)) = fits_min_label(fits_min<thresh);
groups = groupsSOS1;
end
%% clustering data with found F estimates
% magicc = 1.2;
% use2clust = [];
% X = X_all;
% N = size(X,2);
% for ng_i = 1:ngroups
% %     F_i = F_est{ng_i};
%     X_o = X_i_rel{ng_i};
%     F_i = estimateFundamentalMatrix(X_o(1:2,:)',X_o(3:4,:)','Method','Norm8Point');
%     fit_i = diag([X(3:4,:)' ones(N,1)]*F_i*[X(1:2,:)' ones(N,1)]');
%     fit_i = (abs(fit_i));
% %     figure;plot(fit_i)
%     use2clust = [use2clust; fit_i'];
% end
% use2clust2 = cnormalize(use2clust')';
% [~,groups] =min(use2clust2,[],1);
% %% using F to find final outliers
% for ng_i = 1:ngroups
%     groups_curr = find(groups==ng_i);
%     fits_curr = use2clust(ng_i,groups_curr);
% %     fits_curr = fits_curr/max(fits_curr);
%     thresh =5e-2;%graythresh(fits_curr);
%     if true
%     plotColored(fits_curr',s(groups_curr),['clustering for ',num2str(ng_i)],thresh)
%     end
%     groups(groups_curr(fits_curr>thresh)) = 0;
% 
% end
%% visualizing final outliers
if figOn
plotColored(groups,groups,'clustering')
end
groupsSOS = groups;
end
