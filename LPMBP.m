function alpha = LPMBP(Pi,Ncount,T)
% function alpha = LPMBP(Pi,Ncount,T)
%
% Solves the central program associated with the optimal DoF allocation.
% The program first tries to solve the optimaztion using an LP relaxation, 
% if the solution is already binary, the result is delivered, otherwise the 
% program uses the Gurobi integer programming toolbox to solve the original 
% problem.  
%
% Function Inputs:
% Pi is the binary dictionary matrix
% Ncount is the number of pixels within each shapelet (superpixel)
% T is the cardinality of the solution
%
% Function Output:
% alpha: the alpha part of the solution. The beta part is not passed.
% Please see the original paper for ttechnical details.
%
% IMPORTANT: Running the following code requires installing the Gurobi
% software. The license is free for academic use. Please refer to 
% https://www.gurobi.com/ for more details
% 
% Created by: Alireza Aghasi, Georgia State School of Business
% Email: aaghasi@gsu.edu
% Created: October, 2020

nBeta = size(Pi,1);
n = size(Pi,2);


A = [-Pi, eye(nBeta)];
b = zeros(nBeta,1);
A = [A;[ones(1,n),zeros(1,nBeta)]];
b = [b;T];
A = sparse(A);
f = [zeros(n,1);-ones(nBeta,1)];

% first Running the LP
disp('Solving the LP relaxation hoping for the combinatorial solution ...');
lb = [zeros(n,1);-inf(nBeta,1)];
ub = [ones(n,1);Ncount];
varType = repmat('C', [1,n+nBeta]);
[x, ~] = Gurobi_LP_Solver(f, A, b, lb, ub, varType);
alpha = x(1:n);
% checking if the acquired alpha is (very close to being) binary 
if norm( abs(alpha-.5) - .5*ones(n,1) )<1e-6
    disp('Success: LP solved the combinatorial problem!');
else
    disp('LP failed to solve the combinatorial problem, switching to a combinatorial solver!');
    lb = [zeros(n,1);-inf(nBeta,1)];
    ub = [inf(n,1);Ncount];
    varType(1:n) = 'B';
    [x, ~] = Gurobi_LP_Solver(f, A, b, lb, ub, varType);
    alpha = x(1:n);
end