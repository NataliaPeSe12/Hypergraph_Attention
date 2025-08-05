function normalized_connectivity(subj, interval)
    % Normalized Coherences and difference
    basePath = 'C:\Users\natty\OneDrive\Documentos\Neurociencias\Proyectos\Hypergraph_Attention';
    resultsPath = fullfile(basePath, 'Results', interval, ['Sujeto_', num2str(subj)]);
    firstMatricesPath = fullfile(basePath, 'First_matrices', ['Sub_', num2str(subj)],interval);
    addpath(firstMatricesPath,resultsPath);

    diff_C_MLV = cell(subj);
    diff_C_MRV = cell(subj);

    regions = struct( ...
        'Frontal_L', [1, 3, 6, 7], ...
        'Frontal_R', [2, 5, 9, 10], ...
        'Central',   [4, 8], ...
        'Parietals', [11, 12, 13], ...
        'Occipitals', [14, 15, 16]);

    if interval == "Una_I"
        f_range = [6.1, 8.7];  % Hz
    elseif interval == "Dos_I_f1"
        f_range = [6.15, 6.75];  % Hz
    else
        f_range = [8.05, 8.65];
    end

    % Load necessary .mat files
    matsToLoad = {'C_MI_1.mat', 'C_MI_2.mat', 'C_MLV.mat', 'C_MRV.mat', 'tau_CohMLV.mat', 'tau_CohMRV.mat'};
    archivos = fullfile(firstMatricesPath, matsToLoad(1:4));

    existen = all(cellfun(@isfile, archivos));

    if existen
        disp('All files exist. Continuing...');
        for matName = matsToLoad
            load(matName{1});
        end

        C_MI_MLV = MI_Coherences_for_MLV{subj,1};
        C_MI_MRV = MI_Coherences_for_MRV{subj,1};
        C_MLV = MLV_Coherences{subj,1};
        C_MRV = MRV_Coherences{subj,1};

        diff_C_MLV{subj} = C_MLV - C_MI_MLV;
        diff_C_MRV{subj} = C_MRV - C_MI_MRV;

        pos = @(x) max(x, 0);
        neg = @(x) min(x, 0);

        matrices = struct( ...
            'Coherence_MLV', pos(diff_C_MLV{subj}), ...
            'Coherence_MRV', pos(diff_C_MRV{subj}), ...
            'Anticoherence_MLV', neg(diff_C_MLV{subj}), ...
            'Anticoherence_MRV', neg(diff_C_MRV{subj}));

        % Determine which tau matrix to use based on the field
        tauMap = struct( ...
            'Coherence_MLV', tau_coh_MLV, ...
            'Coherence_MRV', tau_coh_MRV, ...
            'Anticoherence_MLV', tau_coh_MLV, ...
            'Anticoherence_MRV', tau_coh_MRV);

        % Node coordinates (x, y)
        x = [-0.5 0.5 -1 0 1 -0.7 -0.4 0 0.4 0.7 -0.7 0 -0.7 -0.5 0 0.5];
        y = [4.5 4.5 2 1.5 2 2 0.5 0 0.5 2 -2.1 -2 -2.1 -4.5 -4.8 -4.5];
        nodes = ["FP1","FP2","F7","Fz","F8","F3","FC1","Cz","FC2","F4","P3","Pz","P4","O1","Oz","O2"];
        pathSave = fullfile(resultsPath, "Graphs");
        if ~exist(pathSave, 'dir')
            mkdir(pathSave);
        end

        fields = fieldnames(matrices);
        for k = 1:numel(fields)
            field = fields{k};
            S.(field) = matrices.(field);
            isAnti = contains(field, 'Anticoherence');
            tauMatrix_lag = tauMap.(field);

            G = digraph();
            G = addnode(G, nodes);

            for i = 1:length(nodes)
                for j = 1:length(nodes)
                    value = matrices.(field)(i,j);
                    if i ~= j && ~isnan(tauMatrix_lag(i,j)) && ...
                       ((~isAnti && value > 0) || (isAnti && value < 0))
                        G = addedge(G, nodes{i}, nodes{j}, value);
                    end
                end
            end

            AttentionGraphMetrics(G, nodes, x, y, subj, [field '_' interval], pathSave);
            save(fullfile(resultsPath, ['Diff_', field, '_', num2str(1), '.mat']), '-struct', 'S', field);
            save(fullfile(pathSave, ['Graph_', field, '_subj_', num2str(subj), '.mat']), 'G');
            clear S;
        end

        titles = { ...
            'Coherence difference (MLV-MI)', ...
            'Coherence difference (MRV-MI)', ...
            'Anticoherence difference (MLV-MI)', ...
            'Anticoherence difference (MRV-MI)'};

        suffixes = {'M_Coh_MLV', 'M_Coh_MRV', 'M_AntiCoh_MLV', 'M_AntiCoh_MRV'};

        for k = 1:numel(fields)
            figure;
            imagesc(matrices.(fields{k}));
            colorbar;
            title([titles{k}, sprintf(' (%.1f-%.1f Hz)', f_range(1), f_range(2))]);
            subtitle(['Subject ', num2str(subj)]);
            xlabel('Electrode i');
            ylabel('Electrode j');
            saveas(gcf, fullfile(resultsPath, [suffixes{k}, '_subj_', num2str(subj), '_f', num2str(1), '.jpg']));
            close;
        end

    else
        disp('Missing files to normalize');
    end
end
