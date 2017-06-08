# matlabscripts
Matlab Scripts (mainly for SPM)

These are the SPM-batch based scripts.
Someone's life might be easier with these files.

## vbm_acpc_coreg_batch.m
This script reorients (T1) images automatically.
The script moves the origin to the center of images first, then coregister the images to icbm152.nii.

## vbm_preproc_create_dartel_template_batch.m
This script is a batch which goes through ...

* Segmentation
* DARTEL (creating Templates)
* Normalize to MNI space
* Calculate Tissue Volumes

## vbm_preproc_existing_dartel_batch.m
This script is a batch which goes through ...

* Segmentation
* DARTEL (existing Templates)
* Normalize to MNI space
* Calculate Tissue Volumes

You need to select Template_1 beside T1 images.
Other templates will be specified automatically.



