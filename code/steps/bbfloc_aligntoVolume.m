% bbfloc_aligntoVolume.m
%
% Align inplane anatomy to volume anatomy
% First by hand: rxAlign. Then run the other sections, up to fitting
% ellipse. Make sure that the ellipse covers the brain (or most of it) but
% excludes the skull. 
% Keep running the other sections (except for 4d' (OPTIONAL) Automatic
% alignment). Then continue the rest of the sectionss to save.
% see our google doc and youtube video for instructions
disp('=========== Starting Alignment Inplane to Volume ===========');



% rxAlign is an interactive tool that you will use to align to whole brain anatomy
rxAlign; 
% Once you are done with the alignment, pull out the necessary info
rxVista = rxRefresh;
rxClose;
rx = rxVista; clear rxVista;
close all;
cd(session_path)

disp('===========  Alignment Inplane to Volume done ===========');

% document in logfile
lid = fopen(logFileName, 'a');
fprintf(lid, '%s :  Alignment: Inplane to Volume done  \n\n', char(datetime('now')));
fclose(lid)

