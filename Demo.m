
% Demo.m presents an example of DoF allocation. Tthe following code
% regenrates Figure 4(b) of the paper. 

clear all;
% To create the raw profile trains, you would need to run the script
% createDoFTrain.m, for the desired parameters and save the train as
% RawPTrains.mat
load('MAT_Files/RawProfileTrains.mat');

% =========================================================================
%% creating or reading the unweighted Pi matrix

if ~isfile('MAT_Files/PiMatrixUnweighted.mat') % checking if the matrix Pi 
                                               % is already calculated and 
                                               % saved
    disp('creating the Pi matrix ...')
   
    % Generating the Pi matrix associated with the resulting profile train
    Pi = hypoGen(profileTrain, 50);
    
    % Condensing the Pi matrix to Pi_c, as described in the paper's
    % supplementary notes
    disp('conndensing the Pi matrix ...');
    [Pi_c, Ncount] = PiCondenser(Pi);
    save('MAT_Files/PiMatrixUnweighted.mat', 'Pi_c', 'Ncount');
else
    load('MAT_Files/PiMatrixUnweighted.mat');
end

% =========================================================================
%% Running the central optimization for different values of T = 1,...,9
nK = size(Pi_c,2);
% Running the optimal DoF allocation optimization
solution = zeros(nK,9);
disp('Running the optimization');
for T = 1:9
    T
    solution(:,T) = LPMBP(Pi_c,Ncount,T);
end

% =========================================================================
%% plotting the location of the optimal DoF centers 
figure('position',[100 100 1000 250]);
hold on;grid on;title('location of selected DoF planes')
for T = 1:9
    plot(centers(logical(solution(:,T))), T*ones(T,1),'.','MarkerSize', ...
                                               20,'Color',[0 0.647 0.941]);
end
xlabel('depth(cm)');
ylabel('T');
ylim([0,10])

% =========================================================================
% The lines above solve the optimal DoF allocation for the unweighted case 
% (i.e., no weight on the age or depth). In the following we repeat the
% steps above, however, we weight the profiles age by the US population

%% weighting the age axix by the US population
load('MAT_Files/ageProfile.mat'); 

maxAge = size(profileTrain,3);
for age = 1:maxAge
    profileTrain(:,:,age) = ageProfile(age,2)*profileTrain(:,:,age);
end

% =========================================================================
%% creating or reading the unweighted Pi matrix

if ~isfile('MAT_Files/PiMatrixAgeUSWeighted.mat')% checking if the matrix 
                                                 % Pi is already calculated 
                                                 % and saved
    disp('creating the Pi matrix ...')
    % Generating the Pi matrix associated with the resulting profile train
    Pi = hypoGen(profileTrain, 50);
    
    % Condensing the Pi matrix to Pi_c, as described in the paper's
    % supplementary notes
    disp('conndensing the Pi matrix ...');
    [Pi_c, Ncount] = PiCondenser(Pi);
    save('MAT_Files/PiMatrixAgeUSWeighted.mat', 'Pi_c', 'Ncount');
else
    load('MAT_Files/PiMatrixAgeUSWeighted.mat');
end

% =========================================================================
%% Running the central optimization for different values of T = 1,...,9
nK = size(Pi_c,2);
% Running the optimal DoF allocation optimization
solution = zeros(nK,9);
disp('Running the optimization');
for T = 1:9
    T
    solution(:,T) = LPMBP(Pi_c,Ncount,T);
end

% =========================================================================
%% plotting the location of the optimal DoF centers 
hold on;
for T = 1:9
    plot(centers(logical(solution(:,T))), T*ones(T,1),'+','MarkerSize'...
                                             ,15,'Color',[0.941 0.647 0]);
end
grid on;

