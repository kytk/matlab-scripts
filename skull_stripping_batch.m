% vbm_skull_stripping_batch.m
% batch script for skull stripping T1WI images
% Requirements: SPM12
% This script does...
% 1. Segment T1WI into grey, white, and CSF using segmentation and save
% bias-corrected T1
% 2. make brain mask by adding GM and WM
% 3. maskout bias-corrected T1WI images with brain mask
% 30/Sep/2017 K.Nemoto

%% Initialize batch
spm_jobman('initcfg');
matlabbatch = {};

%% Select T1 files
imglist = spm_select(Inf,'image','Select T1 volume files');
cwd=fileparts(imglist(1,:));

%% Prepare the SPM window
% interactive window (bottom-left) to show the progress, 
% and graphics window (right) to show the result of coregistration 
 
%spm('CreateMenuWin','on'); %Comment out if you want the top-left window.
spm('CreateIntWin','on');
spm_figure('Create','Graphics','Graphics','on');


%% skull-stripping using segmentation and imcalc
for i=1:size(imglist,1)
    [dir fname ext]=fileparts(imglist(i,:));
    j=3*i-2;
    matlabbatch{j}.spm.spatial.preproc.channel.vols = {deblank(imglist(i,:))};
    matlabbatch{j}.spm.spatial.preproc.channel.biasreg = 0.001;
    matlabbatch{j}.spm.spatial.preproc.channel.biasfwhm = 60;
    matlabbatch{j}.spm.spatial.preproc.channel.write = [0 1];
    matlabbatch{j}.spm.spatial.preproc.tissue(1).tpm = {fullfile(spm('Dir'),'tpm/TPM.nii,1')};
    matlabbatch{j}.spm.spatial.preproc.tissue(1).ngaus = 1;
    matlabbatch{j}.spm.spatial.preproc.tissue(1).native = [1 0];
    matlabbatch{j}.spm.spatial.preproc.tissue(1).warped = [0 0];
    matlabbatch{j}.spm.spatial.preproc.tissue(2).tpm = {fullfile(spm('Dir'),'tpm/TPM.nii,2')};
    matlabbatch{j}.spm.spatial.preproc.tissue(2).ngaus = 1;
    matlabbatch{j}.spm.spatial.preproc.tissue(2).native = [1 0];
    matlabbatch{j}.spm.spatial.preproc.tissue(2).warped = [0 0];
    matlabbatch{j}.spm.spatial.preproc.tissue(3).tpm = {fullfile(spm('Dir'),'tpm/TPM.nii,3')};
    matlabbatch{j}.spm.spatial.preproc.tissue(3).ngaus = 2;
    matlabbatch{j}.spm.spatial.preproc.tissue(3).native = [1 0];
    matlabbatch{j}.spm.spatial.preproc.tissue(3).warped = [0 0];
    matlabbatch{j}.spm.spatial.preproc.tissue(4).tpm = {fullfile(spm('Dir'),'tpm/TPM.nii,4')};
    matlabbatch{j}.spm.spatial.preproc.tissue(4).ngaus = 3;
    matlabbatch{j}.spm.spatial.preproc.tissue(4).native = [0 0];
    matlabbatch{j}.spm.spatial.preproc.tissue(4).warped = [0 0];
    matlabbatch{j}.spm.spatial.preproc.tissue(5).tpm = {fullfile(spm('Dir'),'tpm/TPM.nii,5')};
    matlabbatch{j}.spm.spatial.preproc.tissue(5).ngaus = 4;
    matlabbatch{j}.spm.spatial.preproc.tissue(5).native = [0 0];
    matlabbatch{j}.spm.spatial.preproc.tissue(5).warped = [0 0];
    matlabbatch{j}.spm.spatial.preproc.tissue(6).tpm = {fullfile(spm('Dir'),'tpm/TPM.nii,6')};
    matlabbatch{j}.spm.spatial.preproc.tissue(6).ngaus = 2;
    matlabbatch{j}.spm.spatial.preproc.tissue(6).native = [0 0];
    matlabbatch{j}.spm.spatial.preproc.tissue(6).warped = [0 0];
    matlabbatch{j}.spm.spatial.preproc.warp.mrf = 1;
    matlabbatch{j}.spm.spatial.preproc.warp.cleanup = 1;
    matlabbatch{j}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
    matlabbatch{j}.spm.spatial.preproc.warp.affreg = 'mni';
    matlabbatch{j}.spm.spatial.preproc.warp.fwhm = 0;
    matlabbatch{j}.spm.spatial.preproc.warp.samp = 3;
    matlabbatch{j}.spm.spatial.preproc.warp.write = [0 0];
    matlabbatch{j+1}.spm.util.imcalc.input(1) = cfg_dep('Segment: c1 Images', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','tiss', '()',{1}, '.','c', '()',{':'}));
    matlabbatch{j+1}.spm.util.imcalc.input(2) = cfg_dep('Segment: c2 Images', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','tiss', '()',{2}, '.','c', '()',{':'}));
    matlabbatch{j+1}.spm.util.imcalc.output = ['mask_' fname ext];
    matlabbatch{j+1}.spm.util.imcalc.outdir = {cwd};
    matlabbatch{j+1}.spm.util.imcalc.expression = 'i1+i2>eps';
    matlabbatch{j+1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{j+1}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{j+1}.spm.util.imcalc.options.mask = 0;
    matlabbatch{j+1}.spm.util.imcalc.options.interp = 1;
    matlabbatch{j+1}.spm.util.imcalc.options.dtype = 4;
    matlabbatch{j+2}.spm.util.imcalc.input(1) = cfg_dep('Segment: Bias Corrected (1)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','channel', '()',{1}, '.','biascorr', '()',{':'}));
    matlabbatch{j+2}.spm.util.imcalc.input(2) = cfg_dep('Image Calculator: ImCalc Computed Image: ', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
    matlabbatch{j+2}.spm.util.imcalc.output = ['ss_' fname ext];
    matlabbatch{j+2}.spm.util.imcalc.outdir = {cwd};
    matlabbatch{j+2}.spm.util.imcalc.expression = 'i1.*i2';
    matlabbatch{j+2}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{j+2}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{j+2}.spm.util.imcalc.options.mask = 0;
    matlabbatch{j+2}.spm.util.imcalc.options.interp = 1;
    matlabbatch{j+2}.spm.util.imcalc.options.dtype = 4;
end

%% Run batch
spm_jobman('interactive',matlabbatch);
%spm_jobman('run',matlabbatch);
