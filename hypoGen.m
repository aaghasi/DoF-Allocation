function Pi = hypoGen(profileTrain, nV)
% function Pi = hypoGen(profileTrain, nV)
%
% This function generates the binary matrix Pi from a train of knolls. For
% the problem of interest in the paper, the profileTrain is a 3D array of
% size nK-by-nD-by-maxAge, where nK represents the number of knolls, PAR is
% the nnumber of grids along the depth axis, and AGE is the number of ages
% on the age axis
%
% Function Inputs:
% profileTrain: a 3D array containing the DoF profile values as a function
% of age and depth
% nV: the DoF profiles are functions with values between zero and one. To
% generate the Pi matrix, this range is discretized into nV equispaced
% grids.
% IMPORTANT: this function automatically scales profileTrain so that the
% maximum value is 1.
%
% Function Output:
% Pi: is a binary matrix with nV*nD*maxAge rows and nK columns. The i-th
% column of Pi represents a vectorized version of the hypograph associated
% with the i-th knoll in profileTrain
%
% Created by: Alireza Aghasi, Georgia State School of Business
% Email: aaghasi@gsu.edu
% Created: October, 2020

% scaling profileTrain so that the maximum value is 1
profileTrain = profileTrain/max(profileTrain(:));

nK = size(profileTrain,1);
nD = size(profileTrain,2);
maxAge = size(profileTrain,3);

Pi = zeros(maxAge*nD*nV,nK);


for n = 1:nK
    mask = zeros(nD,maxAge,nV);
    for age = 1:maxAge
        for d = 1:nD
            mask(d,age,1:round(profileTrain(n,d,age)*nV)) = 1;
        end
    end
    Pi(:,n) = mask(:);
end