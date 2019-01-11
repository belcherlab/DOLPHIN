# DOLPHIN

For the code associated with:\
**"Deep-tissue optical imaging of near cellular-sized features"**\
by Dang, X.; Bardhan, N. M.; Qi, J.; Gu, L.; Eze, N. A.; Lin, C-W.; Kataria, S.; Hammond, P. T.; and Belcher, A. M. ("**The Authors**")

This software and all associated code is provided under:\
**The MIT License**\
**Copyright (C) 2019 "The Authors"**\
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

**Package Contents:**\
The following MATLAB files are provided as part of this code package:
- "CHADNIS.m", which is the main file, with dependencies on the following files
- "Class_based_processing_for_all_files.m" contains instructions for reading all sub-directories containing sequential data folders, for the \<directory\> specified in the argument of obj = CHADNIS(\<directory\>)
- "SpeReader.m", which helps read raw data from the Princeton Instruments 2D OMA-V camera (stored as .spe files) into a MATLAB matrix for subsequent processing.
- "Dual_camera_image_registration_and_overlapping.m" performs registration and overlap functions for the two image acquisition sources, viz., the NIR camera and the visible Si detector camera.
- "FastHSI.m", which performs hyperspectral imaging (HSI) operations on the HSC data.
- "RoiMeasurement.m" is used to determine the region of interest (ROI) for the HSC or HDC data, from the all Results class object matrix.
- "ROI_HSC.m" is used to calculate the mean and standard deviation of the ROI area for HSC mode of analysis
- "ROI_HDC.m" is used to calculate the mean and standard deviation of the ROI area for HDC mode of analysis
- "MCX_result_processing_all.m" is used to plot the results of Monte Carlo eXtreme (MCX) simulations. MCX simulations were performed using the fast photon transport simulation software, Monte Carlo eXtreme (MCX) Version 0.9.7-2, authored by Qianqian Fang (fangq [at] nmr.mgh.harvard.edu), licensed under the GNU General Public License
- "Cell_image_processing.m" is used to analyze emission image of cells loaded with downconversion nanoparticles.
- "HyperSpectralMappingImagingSystem.m" is used to create a montage of the HSC data from the "allResults_ClassObj.mat" data matrix.
- "Movie_generation_and_processing.m" is used to create the Supplementary movies S1-S3.


**System Requirements:**

Hardware Requirements\
The CHADNIS package requires only a standard computer with enough RAM to support the operations defined by a user. For minimal performance, this will be a computer with about 8 GB of RAM. For optimal performance, we recommend a computer with the following specs:\
RAM: 16+ GB\
CPU: 4+ cores, 3.0+ GHz/core

The runtimes below are generated using a desktop computer with the following specs (Core i7-4790K, 32 GB RAM, 4 cores/8 threads@4.2 GHz).\

OS Requirements:\
The code provided was tested to run successfully on the aforementioned computer hardware, running Windows 8.1, and MATLAB Revision 2014a. 



**Installation Guide:**\
MATLAB is a proprietary software provide by the vendor "The MathWorks, Inc." and needs to be purchased and installed on the computer in order to run this code.\
Once MATLAB is running successfully, no additional installation is required.\
In order to run the code, the main file ("CHADNIS.m") and all the associated files, along with the raw data to be processed, need to be downloaded and placed in the same Working Directory in MATLAB, prior to running the code.



**Demo/Instructions for use:**\
In the MATLAB command line: \
obj = CHADNIS(\<directory\>)\
where \<directory\> is the full path to the folder which contains all the raw data collected, which needs to be processed.\
Note: \<directory\> must also contain the background file, which is labeled with "\_bcgnd" in the filename (the blank background, collected under the same conditions of image acquistion, viz. the integration time, number of acquisition frames and normalization) as the data collection procedure.\
For help with troubleshooting or other issues pertaining to Code run errors, please contact:\
Dr. Xiangnan Dang, xiangnan.dang@gmail.com



**Expected Output:**  
3D hyper-spectral or hyper-diffuse data (depending on the mode of analysis used, HSC or HDC), as well as intermediate results stored during computation.

**Data outputs:**
* A text .txt file, "allResults_infofile.txt", which contains details about the experiment type (HSC or HDC), the laser power used, the integration time, scan size (such as 20 mm x 40 mm), the grid size (such as 100 x 200), a vector containing the intermediate datapoints in the wavelength range (850 - 1750 nm), a vector containing the data points in the diffuse range (1 - 205), the measured band, the detector size (256 x 320), the region of interest of the detector (detector ROI).
* A .mat file, "allResults_ClassObj.mat", which contains the class object obj returned by the output of CHADNIS.m
* A .mat file, "allResults_allframes.mat", which contains the data for all frames collected during image acquisition 
* A .mat file, "allResults_Level1Data.mat", which contains the Level 1 data for all frames collected during image acquisition, prior to further processing.
* A .mat file, "allResults_HSC.mat", which contains the data after processing the HSC data
* A .mat file, "allResults_HSC_smooth.mat", which contains the HSC data after applying a smoothing filter
 
**Visualization outputs:**\
Figures are plotted in MATLAB \*.fig format, as well as exported in \*.eps format. Contains:\ 
* "allResults_Level1fig.fig", "allResults_Level1eps.eps" (which contain the Level 1 data, showing the detector pixels (a, b), signal intensity as a function of wavelength, and the real space (x, y) coordinate images) 
* "allResults_Resultsfig.fig", "allResults_Resultseps.eps" (which contain the wavelength spectra, the output of the HSC or HDC analyses - such as the 4 Principal components in HSC, and the relative % contributions of each component)
* "allResults_Montagefig.fig", "allResults_Montageeps.eps" (which contain a montage of the real space scan over the entire wavelength range, from 850-1750 nm) 



**Expected Runtime:**\
For a 100 x 200 raster grid scan, the run time using the computer hardware mentioned above is approximately 5 minutes. 
