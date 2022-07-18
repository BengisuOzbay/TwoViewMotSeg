function [Qeval,thresh] = findQFast(Lno,Lnom)
% [Lnom,powers] = veronese(xm,n);
% Lnom = conj(Lnom');
%compute moment matrix
Np = size(Lnom,1);
Mo = (Lnom'*Lnom)/ Np;
% Mo=Mo+1e-12*eye(size(Mo)) ;
[U,S,~] = svd(Mo,0);

sqrtS=sqrt(diag(S));
smin=min(sqrtS);
Scale=smin./sqrtS; % avoid numerical problems by normalizing with respect
%                    the minimum singular value
c = U*diag(Scale);

% [Lno,powers] = veronese(x,n);
% Lno = conj(Lno');

Qeval=diag(Lno*c*c'*Lno');
% Qeval  = sum((Lno*c).^2,2);
Qeval=Qeval/(smin^2);

thresh = size(Mo,1);
end