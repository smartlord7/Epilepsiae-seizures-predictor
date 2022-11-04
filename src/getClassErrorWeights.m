function [errorWeights] = getClassErrorWeights(t, classWeights)
    errorWeights = zeros(size(t.(ESPConst.PROP_DATASET_CLASSES)));
    for i=1 : length(classWeights)
        cw = classWeights(i,: );
        idx = t.(ESPConst.PROP_DATASET_CLASSES) == categorical(cw(1));
        errorWeights(idx) = cw(2);
    end
end

