function [trainInput, valInput] = prepareInput(fileName, tRatio, vRatio)
    tstRatio = ESPConst.RATIO_TEST;

    dataset = load(fileName).data;
    features = dataset.(ESPConst.PROP_DATASET_FEATURES);
    classes = dataset.(ESPConst.PROP_DATASET_CLASSES);
    [p, pv, ~] = divideblock(transpose(features), tRatio, vRatio, tstRatio);
    [t, tv, ~] = divideblock(transpose(classes), tRatio, vRatio, tstRatio);
    p = transpose(p);
    pv = transpose(pv);
    dataset.(ESPConst.PROP_DATASET_CLASSES) = categorical(t);
    dataset.(ESPConst.PROP_DATASET_FEATURES) = mat2cell(p.', size(p,2), ones(size(p,1),1)).';
    trainInput = dataset;
    dataset.(ESPConst.PROP_DATASET_CLASSES) = categorical(tv);
    dataset.(ESPConst.PROP_DATASET_FEATURES) = mat2cell(pv.', size(pv,2), ones(size(pv,1),1)).';
    valInput = dataset;
end

