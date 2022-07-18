function [Qeval,thresh] = findQ_norm(x,xm,n)
[Lnom,powers] = veronese_quad(xm,n);
% r2use = (powers(:,1)+powers(:,2)<=n/2) &( powers(:,3)+powers(:,4)<=n/2);
% Lnom = Lnom(r2use,:);

Lnom = conj(Lnom');
%compute moment matrix
Np = size(Lnom,1);
Mo = (Lnom'*Lnom)/ Np;
% Mo=Mo+1e-10*eye(size(Mo));
[U,S,V] = svd(Mo,0);

sqrtS=sqrt(diag(S));
smin=min(sqrtS);
Scale=smin./sqrtS; % avoid numerical problems by normalizing with respect
%                    the minimum singular value
c = U*diag(Scale);

[Lno,powers] = veronese_quad(x,n);
% r2use = (powers(:,1)+powers(:,2)<=n/2) &( powers(:,3)+powers(:,4)<=n/2);
% Lno = Lno(r2use,:);
if false%n==2
    Lno = cnormalize(Lno);
end
Lno = conj(Lno');

Qeval=diag(Lno*c*c'*Lno');
% Qeval  = sum((Lno*c).^2,2);
Qeval=Qeval/(smin^2);
% figure;plot(Qeval,'*')
thresh = size(Mo,1);
% mean(Qeval)
end