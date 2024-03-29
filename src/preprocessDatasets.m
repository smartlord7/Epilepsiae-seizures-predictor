function datasets = preprocessDatasets(verbose, classBalanceMode)
    files = dir(ESPConst.PATH_DATASET + "*" + ESPConst.EXTENSION_DATA);
    l = length(files);
    datasets = cell(l, 1);
    for i=(1:l)
        curr_file = files(i);
        data = load(ESPConst.PATH_DATASET + curr_file.name);
        trg = data.(ESPConst.PROP_DATASET_CLASSES);
        normal_idx = (trg == ESPConst.CODE_CLASS_NON_ICTAL);
        seizures_idx = (trg == ESPConst.CODE_CLASS_ICTAL);
        trg_shift = circshift(trg, - 1);
        diff = trg_shift - trg;
        start_seizures_idx = find(diff == 1);
        end_seizures_idx = find(diff == -1);
        trg(normal_idx) = ESPConst.CODE_CLASS_ALL_INTERICTAL;
        trg(seizures_idx) = ESPConst.CODE_CLASS_ALL_ICTAL;
    
        for j=(1:length(start_seizures_idx))
            idx = start_seizures_idx(j);
            trg(idx - ESPConst.BEFORE_INTERVAL_POINTS_PREICTAL : idx) = ESPConst.CODE_CLASS_ALL_PREICTAL;
        end
    
        for j=(1:length(end_seizures_idx))
            idx = end_seizures_idx(j);
            trg(idx : idx + ESPConst.AFTER_INTERVAL_POINTS_POSICTAL) = ESPConst.CODE_CLASS_ALL_POSICTAL;
        end
        
        patient_id = strrep(curr_file.name, ESPConst.EXTENSION_DATA, "");
        data.(ESPConst.PROP_DATASET_CLASSES) = trg;
        data.Id = patient_id;

        if verbose == true
            analyseDataset(data, " - Not balanced");
            pause(2);
        end

        if classBalanceMode ~= ESPConst.BALANCE_MODE_NONE
            [f, ...
                trg] = ...
                classBalance(data.(ESPConst.PROP_DATASET_FEATURES), ...
                trg, ...
            classBalanceMode);

            data.(ESPConst.PROP_DATASET_FEATURES) = f;
            data.(ESPConst.PROP_DATASET_CLASSES) = trg;

            if verbose == true
                analyseDataset(data, " - Balanced (" + classBalanceMode + ")");
                pause(2);
            end
        end

        datasets{i} = data;
        save(ESPConst.PATH_DATASET_PREPROCESSED + patient_id + ...
            "-" + classBalanceMode + ESPConst.EXTENSION_DATA, "data", "-mat");
    end
end

