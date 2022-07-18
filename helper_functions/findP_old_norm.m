function [P_all] = findP_old_norm(x,xm,n,i_o,cn,cnm)
%Input:
%   x: entire data
%   xm:reliable data
%
cn = nan;
cnm = nan;
[Lnom,~] = veronese_quad(xm,n);
[Lno,~] = veronese_quad(x,n);
if (nargin<5)
%     if false%n == 2
%         Lno = cnormalize(Lno);cn=nan;
%         Lnom = cnormalize(Lnom);cnm=nan;
%     end
elseif (nargin<6)
    cnm = cn;
end

if ~isnan(cnm)
    Lnom = Lnom./(repmat(cnm,size(Lnom,1),1).^(n/2));
end
Lnom = conj(Lnom');
%compute moment matrix
Np = size(Lnom,1);
Mo = (Lnom'*Lnom)/ Np;

[U,S,V] = svd(Mo,0);

sqrtS=sqrt(diag(S));
smin=min(sqrtS);
Scale=smin./sqrtS; % avoid numerical problems by normalizing with respect
%                    the minimum singular value
c = U*diag(Scale);

if ~isnan(cn)
    Lno = Lno./(repmat(cn,size(Lno,1),1).^(n/2));
end
Lno = conj(Lno');

% Qeval  = sum((c'*Lno.').^2,1);
% Qeval=Qeval/(smin^2);  %don't forget to scale back

Lbar = Lno(i_o,:);%+10^(-8);
scale=norm(Lbar*c,2)^2;
coeff=c*c'*Lbar'/scale;  %  coefficients of the polynomial p
P_all = abs([Lno] * coeff);
end