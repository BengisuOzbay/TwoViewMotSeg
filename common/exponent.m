function exp_n = exponent(n,K)
% exp = exponent(n,K)
%
% EXPONENT: computes tha matrix of exponents of a homogeneous polynomial of
% degree n in K variables. exp is a nchoosek(n+K-1,n) by K matrix
% For example, if n=2 and K =2, then exp = [2 0; 1 1; 0 2];
%
% Copyright @ Rene Vidal, 2003

id  = eye(K);
exp = id;

%initiation
rd1 = 0;
for j=1:K
    rd1 = rd1 + nchoosek(2+K-j-1,1);
end

rene = zeros(rd1,K);
count =1;

for j=1:K
    sz_exp = size(exp,1);
    
    for k=sz_exp-nchoosek(2+K-j-1,1)+1:sz_exp
        rene(count,:) = id(j,:)+exp(k,:);
        count = count+1;
    end
end
exp_n = rene;

for i=3:n
    rd1 = 0;
    for j=1:K
        rd1 = rd1 + nchoosek(i+K-j-1,i-1);
    end
    
    rene = zeros(rd1,K);
    count =1;
    for j=1:K
        sz_exp = size(exp_n,1);
        for k=sz_exp-nchoosek(i+K-j-1,i-1)+1:sz_exp
            rene(count,:) = id(j,:)+exp_n(k,:);
            count = count+1;
        end
    end
    exp_n = rene;
end

% id  = eye(K);
% exp = id;
% first = true;
% for i=2:n
%   rd1 = 0;
%   for j=1:K
%       rd1 = rd1 + nchoosek(i+K-j-1,i-1);
%   end
%   
%   rene = zeros(rd1,K);
%   count =1;
% 
%   for j=1:K
%     if first
%         sz_exp = size(exp,1);
%     else
%         sz_exp = size(exp_n,1);
%     end
%     
%     for k=sz_exp-nchoosek(i+K-j-1,i-1)+1:sz_exp    
%         if first
%             rene(count,:) = id(j,:)+exp(k,:);
%         else
%             rene(count,:) = id(j,:)+exp_n(k,:);
%         end
%         count = count+1;
%     end
%   end
%   exp_n = rene;
%   first = false;
% end