clear all;
close all;

P=3; % pupil diamter (mm)
maxAge = 60; % Maximum age to consider, we recommend 60, as after this age
             % the calculated DoF profiles become zero
             
GCR = 10; % GCR is the knoll train resolution. It inncreases the number of
          % knolls by the given factor. For example of GCR = 5, instead of
          % having the knolls by steps of DoFSpacing, we will have them by
          % steps of DoFSpacing/5 
          
nD = 2000; % PAR is the grid size on the depth axis
D_min = 0.5; % The minimum diopter range 

plotSpacing = 10; % Only for visualization purposes. At the end when 
                  % plotting the 3D DoF profiles, which could be large in
                  % number, only a portion of them (by spacing plotSpacing)
                  % will be plotted
                  
outputFileName = 'MAT_Files/RawProfileTrains.mat'; % The file name for 
                                                   % saving the DoF profile 
                                                   % train        

load('MAT_Files/BaseProfile.mat')  % Loading the DoF profile based on the 
                                   % measurements  performed in the 
                                   % following paper:
                                   % Marcos, Susana, Esther Moreno, and 
                                   % Rafael Navarro. "The depth-of-field of 
                                   % the human eye from objective and 
                                   % subjective measurements." Vision 
                                   % research 39.12 (1999): 2039-2049.
figure(1);
plot(dprofile(1,:),dprofile(2,:),'*');
hold;
xx = linspace(-2,2,200);
plot(xx,fitFunc(xx),'linewidth',2);title('Base DoF profile')



DOFSpacing = -0.0825*P + 0.6833; %This is depth of filed and the equation 
                                 % is an estimate of the variation relative 
                                 % to the pupil size based on literature 

D_maxGlobal = 7.083/(1 + exp(0.2031*(1-36.2)-0.6109)); % D_max is the 
            % maximum diopter range or diopter amplitude that is calculated 
            % based  on age and Anderson data with the above given function
            % Please see :
            % "Minus-Lens–Stimulated Accommodative Amplitude Decreases 
            % Sigmoidally with Age: A Study of Objectively Measured 
            % Accommodative Amplitudes from Age 3
            % D_maxGlobal is the maximum of D_max among all ages, which
            % happens at age 1 in the equation above


ArangeGlobal = D_min: DOFSpacing/GCR: D_maxGlobal;

nKMax = length(ArangeGlobal); % the maximum number of knolls

centers = 100./ArangeGlobal; % O is the object distances based on thin lens 
                       % equation 1/D0 is the distance from lens to back of
                       % the eye since that is the focus at infinity
figure(2);
plot(centers(:),1,'+');title('centers of the knolls')

profileTrain = zeros(nKMax,nD,maxAge);

for age = 1:maxAge
    D_max = 7.083/(1 + exp(0.2031*(age-36.2)-0.6109));% see the description
                                                      % above about D_max
    Arange= D_min: DOFSpacing/GCR: D_max;
    % apply the profile
    minOCC = 100/D_max;
    maxOCC = 100/D_min;
    OCC = linspace(minOCC,maxOCC,nD);
    
    for i = 1:length(Arange)
        profileTrain(i,:,age)=fitFunc(100./OCC-Arange(i));
    end
end

minOCC = 100/D_maxGlobal;
maxOCC = 100/D_min;
OCC = linspace(minOCC,maxOCC,nD);
[Dist,Age] = meshgrid(1:maxAge,OCC);
figure;hold on;
for g = 1:plotSpacing: nKMax
    mesh(Age, Dist,squeeze(profileTrain(g,:,:)));
end
view([45 45])    
xlabel('depth (cm)');
ylabel('age (year)')

save(outputFileName, 'profileTrain','centers');

