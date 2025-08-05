function run_pipeline(subjects, condition, epochtime, interval)
    % Load dependencies and setup paths
    setup_paths();

    % Load and preprocess raw data
    [SubjectNames, RawFiles, RawEventFiles, name_mkr] = load_raw_data(subjects, condition);

    % Preprocess and import epochs
    preprocess_subjects(subjects, SubjectNames, RawFiles, name_mkr, epochtime, condition);

    % Compute connectivity metrics
    for i = 1:length(subjects)
        subj = subjects(i);
        compute_connectivity(subj, condition, epochtime, interval);

        % Normalized Coherences and difference. Grapgs and graphs metrics
        normalized_connectivity(subj,interval)

        % Directories Results
        base_path = 'C:/Users/natty/OneDrive/Documentos/Neurociencias/Proyectos/Hypergraph_Attention/';
        result_path = fullfile(base_path, 'Results', interval, ['Sujeto_', num2str(subj)]);
    
        % Obtain xls from .mat
        mat_2_table(result_path)
    end
end
