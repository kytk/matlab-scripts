%%%% get_spm_all_names.m
%%%% A script to obtain "ALL" region names from the SPM result
%%%% K. Nemoto 06 Nov 2019

% mni coordinates are stored in the xSPM.XYZmm
XYZmm = xSPM.XYZmm;

% obtain cluster ID and convert into table
cluster = spm_clusters(xSPM.XYZ);
cluster_T=table(cluster');
cluster_T.Properties.VariableNames={'cluster'};

% obtain t-value and convert into table
spmT = round(xSPM.Z,2);
spm_T=table(spmT');
spm_T.Properties.VariableNames={'T'};

% enter region names in a cell
region = {};
for i = 1:size(XYZmm,2)
    region{i,1} = spm_atlas('query','neuromorphometrics',XYZmm(:,i));
end

% convert the cell array which includes region names to a table
region_T = cell2table(region);

% generate a table with coordinates
coord=round(XYZmm',0);
x = coord(:,1);
y = coord(:,2);
z = coord(:,3);
coord_T = table(x,y,z);

% combine tables
T = [cluster_T spm_T coord_T region_T];

% generate a filename
timestamp = datestr(now,'yyyy-mm-dd-HHMMSS');
fname = ['region_all_names_' timestamp '.csv'];

% write CSV files
writetable(T,fname)
