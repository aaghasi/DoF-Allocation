function [x, fval] = Gurobi_LP_Solver(f, A, b, lb, ub, varType)
% Gurobi_Solver is a linear programming function using the Gurobi MATLAB 
% interface
%

%   x = Gurobi_Solver(f, A, b, lb) solves the problem:
%
%   minimize     f'*x
%   subject to     A*x <= b
%                   lb <= x <= ub
%
%   You can set lb(j) = -inf, if x(j) has no lower bound
%

% The variable varType is an array of characters same size as x which is 
% 'C' for continuous variables and 'B' for binary variables
%
% Please see http://www.gurobi.com/ for instructions on how to download 
% Gurobi and link it to MATLAB. Gurobi is free for academic research

% Created by: Alireza Aghasi, Georgia State University
% Email: aaghasi@gsu.edu
% Created: May 2020

% Gurobi Setting:

model.obj = f;
model.A = A;
model.rhs = b;
model.sense = '<';
model.vtype = varType;
model.lb = lb;
model.ub = ub;
% model.method = -1;
params.outputflag = 0;

result = gurobi(model, params);

if isfield(result, 'x')
    x = result.x;
else
    x = nan(n,1);
end

if isfield(result, 'objval')
    fval = result.objval;
else
    fval = nan;
end