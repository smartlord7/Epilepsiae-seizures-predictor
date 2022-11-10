function [images] = datasetTimeseriesToImg(height)
    files = dir(ESPConst.PATH_DATASET + "*" + ESPConst.EXTENSION_DATA);
    l = length(files);
    images = cell(1, l);
    for i=(1:l)
        currFile = files(i);
        fileName = currFile.name;
        data = load(ESPConst.PATH_DATASET + fileName);
        fileName = replace(fileName, ESPConst.EXTENSION_DATA, "");
        features = data.(ESPConst.PROP_DATASET_FEATURES);
        rows = size(features, 1);
        dvs = size(features, 1) / height;
        f = floor(dvs);
        d = dvs - f;
        newRows = int32(rows - (1 + d) * height);
        features = features((1:newRows), :);
        features = reshape(features, 29, 29, 1, []);
        data.(ESPConst.PROP_DATASET_FEATURES) = features;
        images = data;
        save(ESPConst.PATH_DATASET_AS_IMAGE + fileName + "-" + height);
    end
end