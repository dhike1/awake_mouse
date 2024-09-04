awake-mice-pupil-fMRI-analysis

Software（Windows system): MATLAB R2023a; AFNI_23.0.02 

Example file:
Pupillometry recording

Codes:

AFNI: 

  n_command: main script that can call different fMRI preprocessions
  
  n_mysetting: set up the datasets (raw, processed, atlas) address
  
  o_corr_X: the GLM analysis 
  
  r_command: for group analysis
  
  readParam_X: read paremeters for to3d function
  
MATLAB: 

  pupil-MATLAB:
  
  mypupildetection2023.m: pupil detection;first select the pupil area and then the background area (whole image or area close to the pupil)
    
  pupil_anal.m: pupil feature extraction
    
  pupilout_trail: export the PLR feature for PLR-fMRI analysis 
    
  network-MATLAB:
  
  connect3d.m: correlation network analysis using the ROIs detected from the PLR-fMRI analysis

  allnet.m:correlation network analysis using the ROIs based on Allen brain atlas

