%%fMRI_realign.m
% batch script for realignment
% This script realigns fMRI volumes to the (AC-PC realigned) first volume.
% 
% K. Nemoto 1/Apr/2018

%% Initialize batch
spm_jobman('initcfg');
matlabbatch = {};

%% Select Image files
imglist=spm_select(Inf,'image','Choose images you want to realign');

%% First, set the origin of the first volume to the center of the image
% This part is written by Fumio Yamashita.
for i=1:size(imglist,1)
    file = deblank(imglist(i,:));
    st.vol = spm_vol(file);
    vs = st.vol.mat\eye(4);
    vs(1:3,4) = (st.vol.dim+1)/2;
    spm_get_space(st.vol.fname,inv(vs));
end

%% Prepare the SPM window
% interactive window (bottom-left) to show the progress, 
% and graphics window (right) to show the result of coregistration 

%spm('CreateMenuWin','on'); %Comment out if you want the top-left window.
spm('CreateIntWin','on');
spm_figure('Create','Graphics','Graphics','on');

for i=1:size(imglist,1)
	l=3*i-2;
	m=3*i-1;
	n=3*i;
	%% Coregister with EPI.nii under spm12/toolbox/OldNrom
    matlabbatch{l}.spm.spatial.coreg.estimate.ref = {fullfile(spm('dir'),'toolbox','OldNorm','EPI.nii,1')};
    matlabbatch{l}.spm.spatial.coreg.estimate.source = {deblank(imglist(i,:))};
    matlabbatch{l}.spm.spatial.coreg.estimate.other = {''};
    matlabbatch{l}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
    matlabbatch{l}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
    matlabbatch{l}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{l}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
%% realign: estimate and reslice
	matlabbatch{m}.spm.util.exp_frames.files = {deblank(imglist(i,:))};
	matlabbatch{m}.spm.util.exp_frames.frames = Inf;
	matlabbatch{n}.spm.spatial.realign.estwrite.data{1}(1) = cfg_dep('Expand image frames: Expanded filename list.', substruct('.','val', '{}',{m}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
	matlabbatch{n}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
	matlabbatch{n}.spm.spatial.realign.estwrite.eoptions.sep = 4;
	matlabbatch{n}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
	matlabbatch{n}.spm.spatial.realign.estwrite.eoptions.rtm = 0;
	matlabbatch{n}.spm.spatial.realign.estwrite.eoptions.interp = 2;
	matlabbatch{n}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
	matlabbatch{n}.spm.spatial.realign.estwrite.eoptions.weight = '';
	matlabbatch{n}.spm.spatial.realign.estwrite.roptions.which = [2 1];
	matlabbatch{n}.spm.spatial.realign.estwrite.roptions.interp = 4;
	matlabbatch{n}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
	matlabbatch{n}.spm.spatial.realign.estwrite.roptions.mask = 1;
	matlabbatch{n}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
end

%% Run batch
spm_jobman('interactive',matlabbatch);
%spm_jobman('run',matlabbatch);

