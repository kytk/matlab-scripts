%inverse_atlas.m
%A script to inverse atlas to subject space
%2 July 2017 K. Nemoto

%% Initialize batch
spm_jobman('initcfg');
matlabbatch = {};

%% Select Image files
fflist = spm_select(Inf,'image','Choose flow field images you want to warp the atlas to',{},pwd,'^u_rc1.*',1);
atlasimg = spm_select(1,'image','Choose an Atlas image (e.g. AAL, neuromorphometrics,...)');
template6 = spm_select(1,'image','Select Template_6.nii',{},pwd,'.*Template_6.nii',1);

%% Batch
for i=1:size(fflist,1)
[path fname ext] = fileparts(fflist(i,:));
matlabbatch{i}.spm.util.defs.comp{1}.inv.comp{1}.dartel.flowfield = {fflist(i,1:end-2)};
matlabbatch{i}.spm.util.defs.comp{1}.inv.comp{1}.dartel.times = [1 0];
matlabbatch{i}.spm.util.defs.comp{1}.inv.comp{1}.dartel.K = 6;
matlabbatch{i}.spm.util.defs.comp{1}.inv.comp{1}.dartel.template = {template6(1:end-2)};
matlabbatch{i}.spm.util.defs.comp{1}.inv.space = {atlasimg(1:end-2)};
matlabbatch{i}.spm.util.defs.out{1}.pull.fnames = {atlasimg(1:end-2)};
matlabbatch{i}.spm.util.defs.out{1}.pull.savedir.savepwd = 1;
matlabbatch{i}.spm.util.defs.out{1}.pull.interp = 0;
matlabbatch{i}.spm.util.defs.out{1}.pull.mask = 1;
matlabbatch{i}.spm.util.defs.out{1}.pull.fwhm = [0 0 0];
matlabbatch{i}.spm.util.defs.out{1}.pull.prefix = [fname(6:end) '_'];
end

%% Run batch
spm_jobman('interactive',matlabbatch);
%spm_jobman('run',matlabbatch);
