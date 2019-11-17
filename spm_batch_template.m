%%batchname.m
% Here comes explanation of script
% 
% Author Name Day/Month/Year


%% Run SPM
spm('pet')
%spm('fmri')


%% Prepare the SPM window
%spm('CreateMenuWin','on'); %top-left window (Menu)
%spm('CreateIntWin','on');  %bottom-left window (Interactive)
%spm_figure('Create','Graphics','Graphics','on'); %right window (Graphics)


%% Initialize batch
spm_jobman('initcfg');
matlabbatch = {};


%% Select Image files
filelist = spm_select(Inf,'image','Message...',{},pwd,'.*',1);


%% Select directory
dir = spm_select(1,'dir','Message...');


%% for loop
for i = 1:size(filelist,1)
% "end" comes after batch


%% Batch
% Insert matlabbatch here

%end of for loop
end


%% Run batch
spm_jobman('interactive',matlabbatch);
%spm_jobman('run',matlabbatch);


%%%%% Useful function
% separate path, filename, extension, and frame
% [pth,nam,ext,num] = spm_fileparts(fname)

% generate full path from parts
% f = fullfile(filepart1,...,filepartN)

% SPM path
% spm('dir')

% Create cell array of character vectors
% useful to convert the output of spm_select to cell array
% cellstr(filelist)

