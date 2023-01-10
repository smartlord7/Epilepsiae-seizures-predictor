function [images, labels] = datasetTimeseriesToImg(features, classes, name, height)
    images = [];
    labels = [];
    
    for j=(1:length(ESPConst.CODES_CLASSES))
        class = ESPConst.CODES_CLASSES(j);
        classIdx = (classes == class);
        classFeatures = features(classIdx, :);
        classImages = [];

        if class ~= ESPConst.CODE_CLASS_ALL_INTERICTAL
            step = 1;
            l = size(classFeatures, 1);

            for k = 1 : step : l
                if k + height - 1 > l
                    break;
                end

                img = classFeatures(k : k + height - 1, :)';

                if isempty(classImages)
                    classImages = reshape(img, size(img, 1), size(img, 2), 1);
                else
                    classImages = cat(3, classImages, img);
                end
            end
        else
            rows = size(classFeatures, 1);
            dvs = size(classFeatures, 1) / height;
            f = floor(dvs);
            d = dvs - f;
            newRows = int32(rows - (1 + d) * height);
            classFeatures = classFeatures((1:newRows), :);
            classImages = reshape(classFeatures, size(features, 2), height, []);
        end

        images = cat(3, images, classImages);
        label = class * ones(1, size(classImages, 3));
        labels = [labels label];
    end
    
    sz = size(images);
    images = reshape(images, sz(1), sz(2), 1, sz(3));
    labels = categorical(categorical(labels));
    save(ESPConst.PATH_DATASET_AS_IMAGE + name + "" + height, "images", "labels");
end