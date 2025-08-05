function mat_2_table(folderPath)
       % Get the list of files .mat in the folder
    fileList = dir(fullfile(folderPath, '*.mat*')); % Get all files
    fileList = fileList(~[fileList.isdir]); % Excludes subdirectories
    prefix = 'Coh_vs_lag';
    fileList = fileList(~startsWith({fileList.name}, prefix));
    
    % Process each file
    for i = 1:length(fileList)
        % Get the full file name
        fileName = fileList(i).name;
        filePath = fullfile(folderPath, fileName);
        matData = load(filePath);
    coherencias
        variableNames = fieldnames(matData);
    
        % Dynamically access a specific variable (example: the first one)
        if ~isempty(variableNames)
            varName = variableNames{1}; % Change here if you are looking for another variable
            varData = matData.(varName); % Access the contents of the variable
            l_varData = length(size(varData));
            if l_varData==2
                format short
                if length(varData) == 16
                    matrix = round(varData,3);
                else
                    matrix = round(varData{1,2},3);
                end
    
                % Convert the matrix to a table (optional if you need a table format)
                tabla = array2table(matrix);
                
                % Define a vector of names for the table variables
                nuevos_nombres = ["FP1","FP2","F7","Fz","F8","F3","FC1","Cz","FC2","F4","P3","Pz","P4", "O1","Oz","O2"]; % Reemplaza con tus nombres
                
                % Verify that the number of names matches the number of columns
                if length(nuevos_nombres) == width(tabla)
                    % Assign new names to table variables
                    tabla.Properties.VariableNames = nuevos_nombres;
                else
                    error('The number of names does not match the number of columns in the table');
                end
                
                if size(tabla,1) == 1
                    continue
                else
                    tabla = addvars(tabla,nuevos_nombres','Before',1);
                end
                
                % Save the table to an Excel file
                name = string(extractBetween(fileName, "_", "."));
                table_path = string(folderPath)+'\'+varName;
                writetable(tabla,table_path,"FileType","spreadsheet"); 
    
            else
                for j = 1:2
                    format short
                    
                    matrix = round(varData{2,1,j},3);
                    
                    % Convert the matrix to a table (optional if you need a table format)
                    tabla = array2table(matrix);
                    
                    % Define a vector of names for the table variables
                    nuevos_nombres = ["FP1","FP2","F7","Fz","F8","F3","FC1","Cz","FC2","F4","P3","Pz","P4", "O1","Oz","O2"]; % Reemplaza con tus nombres
                    
                    % Verify that the number of names matches the number of columns
                    if length(nuevos_nombres) == width(tabla)
                        % Assign new names to table variables
                        tabla.Properties.VariableNames = nuevos_nombres;
                    else
                        error('The number of names does not match the number of columns in the table');
                    end
                    
                    tabla = addvars(tabla,nuevos_nombres','Before',1);
                    
                    % Save the table to an Excel file
                    name = varName;
                    writetable(tabla,(name+"_f"+j),"FileType","spreadsheet"); 
                end
            end
        else
            fprintf('The file %s does not contain any variables.\n', fileName);
        end
    end




 