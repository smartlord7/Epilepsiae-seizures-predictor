function [images, labels] = datasetTimeseriesToImg(features, classes, name, height)
    images = [];
    labels = [];
    for j=(1:length(ESPConst.CODES_CLASSES))
        class = ESPConst.CODES_CLASSES(j);
        classIdx = (classes == class);
        classFeatures = features(classIdx, :);
        rows = size(classFeatures, 1);
        dvs = size(classFeatures, 1) / height;
        f = floor(dvs);
        d = dvs - f;
        newRows = int32(rows - (1 + d) * height);
        classImages = classFeatures((1:newRows), :);
        classImages = reshape(classImages, size(classFeatures, 2), height, []);
        images = [images classImages];
        label = class * ones(1, size(classImages, 3));
        labels = [labels label];
    end
    
    labels = categorical(labels)
    save(ESPConst.PATH_DATASET_AS_IMAGE + name + "-" + height, "images", "labels");
end