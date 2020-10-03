function [Pi_c, Ncount] = PiCondenser(Pi)
% function [Pi_c, Ncount] = PiCondenser(Pi)
%
% The function follows the process discussed in the supplementary notes to
% condense the matrix Pi and create Pi_c.
%
% Function Input:
% Pi: is the binary matrix containing the hypographs of the knolls train
%
% Function Output:
% Pi_c: is the condennsed matrix
% Ncount: is an integer array of the same size as the number of rows in 
% Pi_c, where its i-th value indicates the number of pixels in the i-th
% supper-pixel (the super-pixels are indexed by the order of the rows in
% Pi_c)
%
% Created by: Alireza Aghasi, Georgia State School of Business
% Email: aaghasi@gsu.edu
% Created: October, 2020

[Pi_c,~,J] = unique(Pi, 'rows', 'first');
Js = sort(J);
Ncount = accumarray(Js,1);
W = spdiags(Ncount,0,length(Ncount),length(Ncount));
Pi_c = W*Pi_c;

