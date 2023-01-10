function [trainInput, valInput] = prepareInput(fileName, features, classes, tRatio, vRatio, isTimeSeries)
    tstRatio = ESPConst.RATIO_TEST;
    dataset = struct;
    if fileName ~= ""
        dataset = load(fileName).data;
        features = dataset.(ESPConst.PROP_DATASET_FEATURES);
        classes = dataset.(ESPConst.PROP_DATASET_CLASSES);
    end
    
    [p, pv, ~] = dividerand(transpose(features), tRatio, vRatio, tstRatio);
    [t, tv, ~] = dividerand(transpose(classes), tRatio, vRatio, tstRatio);
    p = transpose(p);
    pv = transpose(pv);
    dataset.(ESPConst.PROP_DATASET_CLASSES) = categorical(t);
    dataset.(ESPConst.PROP_DATASET_FEATURES) = con2seq(p');
    trainInput = dataset;
    dataset.(ESPConst.PROP_DATASET_CLASSES) = categorical(tv);
    if vRatio == 0.0
        dataset.(ESPConst.PROP_DATASET_FEATURES) = con2seq(pv);
    else
        dataset.(ESPConst.PROP_DATASET_FEATURES) = con2seq(pv');
    end
    valInput = dataset;
end

