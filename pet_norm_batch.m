% pet_norm_batch.m
% batch script for normalizing PET
% 04/Dec/2019 K.Nemoto

%% Initialize batch
spm_jobman('initcfg');
matlabbatch = {};

%% Select PET files
imglist = spm_select(Inf,'image','Select PET files');

%% Prepare the SPM window
% interactive window (bottom-left) to show the progress, 
% and graphics window (right) to show the result of coregistration 
 
%spm('CreateMenuWin','on'); %Comment out if you want the top-left window.
spm('CreateIntWin','on');
spm_figure('Create','Graphics','Graphics','on');

%% Normalize based on ECD template
for i=1:size(imglist,1)
    matlabbatch{1}.spm.tools.oldnorm.estwrite.subj(i).source = {deblank(imglist(i,:))};
    matlabbatch{1}.spm.tools.oldnorm.estwrite.subj(i).wtsrc = '';
    matlabbatch{1}.spm.tools.oldnorm.estwrite.subj(i).resample = {deblank(imglist(i,:))};
end
    matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.template = {fullfile(spm('Dir'),'toolbox/OldNorm/PET.nii,1')};
    matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.weight = '';
    matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.smosrc = 8;
    matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.smoref = 0;
    matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.regtype = 'mni';
    matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.cutoff = 25;
    matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.nits = 16;
    matlabbatch{1}.spm.tools.oldnorm.estwrite.eoptions.reg = 1;
    matlabbatch{1}.spm.tools.oldnorm.estwrite.roptions.preserve = 0;
    matlabbatch{1}.spm.tools.oldnorm.estwrite.roptions.bb = [-78 -112 -70
                                                             78 76 85];
    matlabbatch{1}.spm.tools.oldnorm.estwrite.roptions.vox = [2 2 2];
    matlabbatch{1}.spm.tools.oldnorm.estwrite.roptions.interp = 1;
    matlabbatch{1}.spm.tools.oldnorm.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{1}.spm.tools.oldnorm.estwrite.roptions.prefix = 'w';

%% Run batch
spm_jobman('interactive',matlabbatch);
%spm_jobman('run',matlabbatch);
