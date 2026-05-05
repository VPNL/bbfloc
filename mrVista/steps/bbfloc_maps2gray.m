function bbfloc_maps2gray(session_path)
% bbfloc_maps2gray(session_path);
% 
% Transforms the time series from the inplane to volume anatomy and
% averages the time series. Transforms generated contrast maps into Gray.
%
% Inputs
% session_path: path to subject's session folder, ex. '/share/kalanit/biac2/kgs/projects/DynamicCategories/data/bbfloc/subj-01/short_length/'
%
% CT april 25 

%% Default inputs
if notDefined('session_path')
    fprintf(1,'Error, you need to define a session_path \n');
    return
end

%% Checks
% Check and validate inputs and path to vistasoft
if isempty(which('mrVista'))
    vista_path = 'https://github.com/vistalab/vistasoft';
    error(['Add vistasoft to your matlab path: ', vista_path]);
end

cd(session_path);

%% Transform time series

% Open hidden inplane
hi = initHiddenInplane('MotionComp_RefScan1', 1);
% Open hidden gray
hg = initHiddenGray('MotionComp_RefScan1', 1);

% Xform time series from inplane to gray using trilinear interpolation
%hg = ip2volTSeries(hi,hg,0,'linear');

%% Transform all contrast maps to gray
hi = initHiddenInplane('GLMs',1);
hg = initHiddenGray('GLMs',1);
ip2volAllParMaps(hi, hg, 'linear');

