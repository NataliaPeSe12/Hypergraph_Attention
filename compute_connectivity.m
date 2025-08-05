function compute_connectivity(iSubj, condition, condition_epochtime, interval)

    % Here will be the implementation of the coherence calculation
    fprintf('Procesando sujeto %d en condición %s...', iSubj, condition);
    root_path = 'C:/Users/natty/OneDrive/Documentos/Neurociencias/Proyectos/Hypergraph_Attention/Attention/data/';
    subj_name = sprintf('sub%02d', iSubj);
    subj_dir = fullfile(root_path, subj_name);

    % Significance test parameters by permutation
    numPermutations = 500;
    alpha = 0.05;
    
    Fs = 500;  % Hz
    if interval == "One_I"
        f_range = [6.1, 8.7];  % Hz
    elseif interval == "Two_I_f1"
        f_range = [6.15, 6.75];  % Hz
    else
        f_range = [8.05, 8.65];
    end

    folders = dir(subj_dir);
    valid_folders = folders([folders.isdir] & ~startsWith({folders.name}, '@') ...
        & contains({folders.name}, condition) & ~ismember({folders.name}, {'.', '..'}));

    if isempty(valid_folders)
        fprintf('Condition "%s" was not found for subject %s\\n', condition, subj_name);
        return;
    end

    for j = 1:length(valid_folders)
        data_folder = fullfile(subj_dir, valid_folders(j).name);
        trial_file = dir(fullfile(data_folder, '*_trial001.mat'));
        if isempty(trial_file), continue; end
        load(fullfile(trial_file(1).folder, trial_file(1).name));  % Loads 'F'

        [coherences, tauMatrix_lag, coh_vs_lag_matrix, pMatrix] = calculate_directed_coherence(F, Fs, f_range, numPermutations, alpha);

        save_results_and_figures(iSubj, condition, condition_epochtime, interval, ...
            coherences, tauMatrix_lag, f_range, coh_vs_lag_matrix, pMatrix);
    end
end
