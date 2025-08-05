function preprocess_subjects(subjects, SubjectNames, RawFiles, name_mkr, condition_epochtime, condition)
    ProtocolName = 'Attention';
    reports_dir = 'C:/Users/natty/OneDrive/Documentos/Neurociencias/Proyectos/Hypergraph_Attention/Results/attention/';
    
    if ~brainstorm('status')
        brainstorm nogui
    end

    for iSubj = subjects
        [sSubject, iSubject] = bst_get('Subject', SubjectNames{iSubj});
        if ~isempty(sSubject)
            db_delete_subjects(iSubject);
        end

        bst_report('Start', []);
        sFiles = script_new(SubjectNames, RawFiles, iSubj, name_mkr, condition_epochtime);
        ReportFile = bst_report('Save', sFiles);

        if ~isempty(reports_dir) && ~isempty(ReportFile)
            bst_report('Export', ReportFile, bst_fullfile(reports_dir, ...
                ['report_' ProtocolName '_' SubjectNames{iSubj} '.html']));
        end
    end
end

