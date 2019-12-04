% flip_batch.m
% batch script for L-R flipping of images
% 20/Jun/2019 K.Nemoto

%% Initialize batch
spm_jobman('initcfg');
matlabbatch = {};

%% Select images
imglist = spm_select(Inf,'image','Select images you want to flip');
imgfiles = cellstr(imglist);

%% Prepare the SPM window
% interactive window (bottom-left) to show the progress, 
% and graphics window (right) to show the result of coregistration 
 
%spm('CreateMenuWin','on'); %Comment out if you want the top-left window.
spm('CreateIntWin','on');
%spm_figure('Create','Graphics','Graphics','on');

% Flip L-R
matlabbatch{1}.spm.util.reorient.srcfiles = imgfiles;
matlabbatch{1}.spm.util.reorient.transform.transM = [-1 0 0 0
                                                     0 1 0 0
                                                     0 0 1 0
                                                     0 0 0 1];
matlabbatch{1}.spm.util.reorient.prefix = 'f';

%% Run batch
spm_jobman('interactive',matlabbatch);
%spm_jobman('run',matlabbatch);

