function [upperbound, center,lowerbound] = findlevels(a,p)
madfactor = -1 /(sqrt(2)*erfcinv(3/2));  %~1.4826
center = median(a,1,'omitnan');
amad = madfactor*median(abs(a - center), 1, 'omitnan');

lowerbound = center - p*amad;
upperbound = center + p*amad;
