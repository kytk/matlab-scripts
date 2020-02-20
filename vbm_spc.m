%%vbm_spc.m
% script to calculate symmetrized percent change
% 21 Feb 2020 K.Nemoto


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
tp1list = spm_select(Inf,'image','Select time point 1...',{},pwd,'.*',1);
tp2list = spm_select(Inf,'image','Select time point 2...',{},pwd,'.*',1);


%% Select directory
%dir = spm_select(1,'dir','Message...');


%% for loop
for j = 1:size(tp1list,1)

    %% Batch
    matlabbatch{j}.spm.util.imcalc.input = {
        tp1list(j,:)
        tp2list(j,:)
        };
    matlabbatch{j}.spm.util.imcalc.output = '';
    matlabbatch{j}.spm.util.imcalc.outdir = {''};
    matlabbatch{j}.spm.util.imcalc.expression = '(i2-i1)./(i1+i2)*100.*(i1>0.15)';
    matlabbatch{j}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{j}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{j}.spm.util.imcalc.options.mask = 0;
    matlabbatch{j}.spm.util.imcalc.options.interp = 1;
    matlabbatch{j}.spm.util.imcalc.options.dtype = 4;
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

