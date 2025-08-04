# Hyper_Attention_v2

This repository contains the complete pipeline for significant directed coherence analysis and functional connectivity graph construction in EEG, focusing on the **figurative attention** condition. The analysis is performed using preprocessed EEG signals and compares attention conditions (MLV and MRV) against a baseline condition without attention (MI).

## Requirements

- MATLAB (tested on R2022b or higher)
- Signal Processing Toolbox
- Parallel Computing Toolbox (for `parfor`)
- `.mat` files organized by subject in the `First_matrices` and `Results` folders
- Data processed with [Brainstorm](https://neuroimage.usc.edu/brainstorm)
  
## Structure

- `Hyper_Attention_v2.m`: Main script that launches the entire pipeline.
- `run_pipeline.m`: Runs analysis for one or more subjects.
- `setup_paths.m`: Add the necessary paths. Make sure you have **Brainstorm** installed in the specified path, or modify this feature according to your local setup. It also can include **BrainNet Viewer** to create the brain figure graphs (optional).
- `preprocess_subjects.m`: This feature automates the preparation and segmentation of raw data in Brainstorm for each experimental subject. It is the first step in the pipeline and should be performed before connectivity analyses.
- `script_new.m`: Automatically executes all preprocessing steps for a subject in Brainstorm, from importing the raw file to generating power spectra.
- `calculate_directed_coherence_significant.m`: Calculates directed coherence by offset with permutation testing.
- `normalized_connectivity.m`: Calculates dissimilarities (MLV-MI, MRV-MI), creates directed graphs, and saves results.
- `AttentionGraphMetrics.m`: Calculates centrality metrics (degree, closeness, eigenvector) and connected components.
- `plot_matrix`: Graph connectivity matrices with title, subtitle and auto-save.
- `save_results_and_figures.m`: Saves the results and the `.mat` matrices (coherence, τ), the graphs as `.jpg` and the `.edge` file for BrainNet Viewer.

## Usage

```matlab
% Open MATLAB and run the main script:
% Hyper_Attention_v2

subjects = [2]; % Vector of subjects
condition = 'MRV'; % The condition of the experiment we are evaluating. (MI_1, MI_2, MLV, MRV)
epochtime = 'MRV'; % This variable is used for certain characteristics to save and give titles. (MI,  MLV, MRV)
interval = 'One_I'; % We can choose between one interval or two intervals (f1, f2). (One_I, Two_f1, Two_f2)

run_pipeline(subjects, condition, epochtime, interval); % Run analysis.
