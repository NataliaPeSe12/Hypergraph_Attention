function [SubjectNames, RawFiles, RawEventFiles, name_mkr] = load_raw_data(subjects, condition)
    % Paths
    data_dir = 'C:/Users/natty/OneDrive/Documentos/Neurociencias/Proyectos/Hypergraph_Attention/Data/';
    cond_dir = ['/',condition,'/'];
    
    % Initialize output
    SubjectNames = cell(1,28); 
    RawFiles = cell(1,28); 
    RawEventFiles = cell(1,28);

    % Loop through subjects
    for iSubj = subjects
        name = sprintf('sub%02d', iSubj);
        SubjectNames{iSubj} = name;
        direct = [data_dir, name, cond_dir];
        
        fname_raw = dir(fullfile(direct, '*.dat'));
        if isempty(fname_raw)
            fname_raw = dir(fullfile(direct, '*.eeg'));
        end
        fname_event = dir(fullfile(direct, '*.vmrk'));
        
        RawFiles{iSubj} = fullfile(fname_raw.folder, fname_raw.name);
        RawEventFiles{iSubj} = fullfile(fname_event.folder, fname_event.name);
    end

    % Load marker table
    Guide_Table = readtable("EEG_total.xlsx");
    Guide_Table = Guide_Table(1:56,1);
    name_mkr = split(table2array(Guide_Table), " (");
    name_mkr = name_mkr(:,1);
    names_4 = contains(name_mkr, "4");
    names_2 = contains(name_mkr, "2");
    names_2_4 = names_2 + names_4;
    name_mkr = name_mkr(logical(names_2_4));
end


