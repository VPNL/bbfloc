% bbfloc_Xform
% transform maps and times series to grat view
% this will generate under Gray 
lid = fopen(logFileName, 'a');
disp('=========== Starting to transfrom contrast maps  and time series to gray  ===========');
bbfloc_maps2gray(session_path)

fprintf(lid, '%s : Finished transforming contrast maps and timeseries to gray  \n\n', char(datetime('now')));
disp('=========== Transfrom contrast maps and timeseries to gray Done ===========');
fclose(lid)