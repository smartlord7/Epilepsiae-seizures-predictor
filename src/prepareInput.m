function [trainInput, valInput] = prepareInput()
    datasets = dir(ESPConst.PATH_DATASET_PREPROCESSED + "*" + ESPConst.EXTENSION_DATA);
    l = length(datasets);
    tRatio = ESPConst.RATIO_TRAIN;
    vRatio = ESPConst.RATIO_VAL;
    tstRatio = ESPConst.RATIO_TEST;
    trainInput = cell(l, 1);
    valInput = cell(l, 1);

    for i=1:length(datasets)
        dataset = load(ESPConst.PATH_DATASET_PREPROCESSED + datasets(i).name).data;
        features = dataset.(ESPConst.PROP_DATASET_FEATURES);
        classes = dataset.(ESPConst.PROP_DATASET_CLASSES);
        [p, pv, ~] = divideblock(transpose(features), tRatio, vRatio, tstRatio);
        [t, tv, ~] = divideblock(transpose(classes), tRatio, vRatio, tstRatio);
        p = transpose(p);
        pv = transpose(pv);
        dataset.(ESPConst.PROP_DATASET_CLASSES) = categorical(t);
        dataset.(ESPConst.PROP_DATASET_FEATURES) = mat2cell(p.', size(p,2), ones(size(p,1),1)).';
        trainInput{i} = dataset;
        dataset.(ESPConst.PROP_DATASET_CLASSES) = categorical(tv);
        dataset.(ESPConst.PROP_DATASET_FEATURES) = mat2cell(pv.', size(pv,2), ones(size(pv,1),1)).';
        valInput{i} = dataset;
    end
end

