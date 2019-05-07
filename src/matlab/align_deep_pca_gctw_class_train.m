function align_deep_pca_gctw_class_train(inputFolder, class, outputFolder, ctwFolder , l)
% TODO desc
%
% History
%   create  -  Luca Coviello (luca.coviello@gmail.com), 01-16-2018

disp([' config : ' , inputFolder,  ' ' , class, ' ',  outputFolder,' ', ctwFolder ,' ', l ]);
l=str2num(l);

outfile = strcat(outputFolder, '/', class, '.csv');
outfile_objs = strcat(outputFolder, '/', class, '_objs.csv');
outfile_obj = strcat(outputFolder, '/', class, '_obj.csv');
outfile_objs1 = strcat(outputFolder, '/', class, '_objs1.csv');
outfile_obj1 = strcat(outputFolder, '/', class, '_obj1.csv');
outfile_objs2 = strcat(outputFolder, '/', class, '_objs2.csv');
outfile_obj2 = strcat(outputFolder, '/', class, '_obj2.csv');

if exist(outfile, 'file') == 2
    disp(strcat('Skipping for ', class));
    exit
end

%% add libraries path
footpath = cd;
addpath(genpath([footpath '/' ctwFolder '/ctw/src']));
addpath(genpath([footpath '/' ctwFolder '/ctw/lib']));

%% algorithm parameter
parCca = st('d', 0.95, 'lams', .1); % CCA: reduce dimension to keep at least 0.95 energy
parGN = st('nItMa', 2, 'inp', 'linear'); % Gauss-Newton: 2 iterations to update the weight in GTW,
parGtw = st('nItMa', 100);

%% data
aslData = aslAliDataFeatures(inputFolder);
X0s = aslData.DPs;
Xs = pcas(X0s, st('d', min(cellDim(X0s, 1)), 'cat', 'n'));

%% monotonic basis
ns = cellDim(Xs, 2);
%l = round(max(ns) * 1.1);
bas = baTems(l, ns, 'pol', [5 .5], 'tan', [5 1 1]); % 2 polynomial and 3 tangent functions

%% utw (initialization)
aliUtw = utw(Xs, bas, []);

%% gctw
aliGtw = gtw(Xs, bas, aliUtw, [], parGtw, parCca, parGN);

%% save indexes
P = aliGtw.P;
csvwrite(outfile, P)

%% save obj function
objs = aliGtw.objs;
csvwrite(outfile_objs, objs)
obj  = aliGtw.obj;
csvwrite(outfile_obj, obj)

%% save obj function
objs1 = aliGtw.objs1;
csvwrite(outfile_objs1, objs1)
obj1  = aliGtw.obj1;
csvwrite(outfile_obj1, obj1)

%% save obj function
objs2 = aliGtw.objs2;
csvwrite(outfile_objs2, objs2)
obj2  = aliGtw.obj2;
csvwrite(outfile_obj2, obj2)
