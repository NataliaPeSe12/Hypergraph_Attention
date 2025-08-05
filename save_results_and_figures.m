function save_results_and_figures(iSubj, condition, epochtime, interval, ...
    coherences, tauMatrix_coh, f_range, coh_vs_lag_matrix, pMatrix)

    base_path = 'C:/Users/natty/OneDrive/Documentos/Neurociencias/Proyectos/Hypergraph_Attention/';
    result_path = fullfile(base_path, 'Results', interval, ['Sujeto_', num2str(iSubj)]);
    first_matrices_path = fullfile(base_path, 'First_matrices', ['Sub_', num2str(iSubj)], interval);
    mkdir(result_path);
    mkdir(first_matrices_path);

    % Filter empty arrays
    coherences(coherences == 0) = 0;

    % Saving .mat files
        switch epochtime
            case 'MI_1'
            % Save coherences for freq and subject
            coherences(coherences >= 0 & coherences <= 0) = 0;
            MI_Coherences_for_MLV{iSubj,1} = coherences;
            tau_coh_MI_for_MLV = tauMatrix_coh;
            coh_vs_lag_matrix_MI_1 = coh_vs_lag_matrix;
            pMatrix_MI_1 = pMatrix;
            save(fullfile(first_matrices_path, ['C_', epochtime]), "MI_Coherences_for_MLV")
            save(fullfile(result_path, ['tau_Coh_', epochtime]),"tau_coh_MI_for_MLV")
            save(fullfile(result_path, ['Coh_vs_lag_', epochtime]),"coh_vs_lag_matrix_MI_1")
            save(fullfile(result_path, ['P_values_peaks_', epochtime]),"pMatrix_MI_1")

            case 'MI_2'
            % Save coherences for freq and subject
            coherences(coherences >= 0 & coherences <= 0) = 0;
            MI_Coherences_for_MRV{iSubj,1} = coherences;
            tau_coh_MI_for_MRV = tauMatrix_coh;
            coh_vs_lag_matrix_MI_2 = coh_vs_lag_matrix;
            pMatrix_MI_2 = pMatrix;
            save(fullfile(first_matrices_path, ['C_', epochtime]), "MI_Coherences_for_MRV")
            save(fullfile(result_path, ['tau_Coh', epochtime]),"tau_coh_MI_for_MRV")
            save(fullfile(result_path, ['Coh_vs_lag_', epochtime]),"coh_vs_lag_matrix_MI_2")
            save(fullfile(result_path, ['P_values_peaks_', epochtime]),"pMatrix_MI_2")

            case 'MLV'
            % Save coherences for freq and subject
            coherences(coherences >= 0 & coherences <= 0) = 0;
            MLV_Coherences{iSubj,1} = coherences;
            tau_coh_MLV = tauMatrix_coh;
            coh_vs_lag_matrix_MLV = coh_vs_lag_matrix;
            pMatrix_MLV = pMatrix;
            save(fullfile(first_matrices_path, ['C_', epochtime]), "MLV_Coherences")
            save(fullfile(result_path, ['tau_Coh', epochtime]), "tau_coh_MLV")
            save(fullfile(result_path, ['Coh_vs_lag_', epochtime]),"coh_vs_lag_matrix_MLV")
            save(fullfile(result_path, ['P_values_peaks_', epochtime]),"pMatrix_MLV")

            case 'MRV'
            % Save coherences for freq and subject
            coherences(coherences >= 0 & coherences <= 0) = 0;
            MRV_Coherences{iSubj,1} = coherences;
            tau_coh_MRV = tauMatrix_coh;
            coh_vs_lag_matrix_MRV = coh_vs_lag_matrix;
            pMatrix_MRV = pMatrix;
            save(fullfile(first_matrices_path, ['C_', epochtime]), "MRV_Coherences")
            save(fullfile(result_path, ['tau_Coh', epochtime]),"tau_coh_MRV")
            save(fullfile(result_path, ['Coh_vs_lag_', epochtime]),"coh_vs_lag_matrix_MRV")
            save(fullfile(result_path, ['P_values_peaks_', epochtime]),"pMatrix_MRV")

        end
        
    % Saving .edge matrices for BrainNet
    edge_file = sprintf('Coh_%s_sub%d_%.1f_%.1f.edge', condition, iSubj, f_range(1), f_range(2));
    writematrix(coherences, fullfile(result_path, edge_file), 'Delimiter','\t','FileType','text');

    % Graphics
    plot_matrix(coherences, 'Coherence', epochtime, iSubj, f_range, result_path);
end

