%%%% get_names.m
%%%% A script to obtain region names from the SPM result
%%%% K. Nemoto 06 Sep 2019

% mni coordinates are stored the 12th column of TabDat.dat
mmXYZ = cell2mat(TabDat.dat(:,12)');

% enter region names in a cell
region = {};
for i = 1:size(mmXYZ,2)
    region{i,1} = spm_atlas('query','neuromorphometrics',mmXYZ(:,i));
end

% convert the cell which includes region name to a table
region_T = cell2table(region);

% generate a table with coordinates
coord=mmXYZ';
x = coord(:,1);
y = coord(:,2);
z = coord(:,3);
coord_T = table(x,y,z);

% combine tables
T = [coord_T region_T];

% generate a filename
timestamp = datestr(now,'yyyy-mm-dd');
fname = ['region_name_' timestamp '.csv'];

% write CSV files
writetable(T,fname)
