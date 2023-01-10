function [r] = getClassifierPerformance(path, data, type, min, mx)
    typeClass = 0;
    if type == "detection"
        typeClass = ESPConst.CODE_CLASS_ALL_ICTAL;
    elseif type == "prediction"
        typeClass = ESPConst.CODE_CLASS_ALL_PREICTAL;
    else
        disp("Wrong type. Choose 'detection' or 'prediction'");
    end 

    if min < 0 || mx < 0 || mod(min, 1) ~= 0 || mod(mx, 1) ~= 0
        disp("Insert only positive integers");
    end
    if mx < min
        disp("(min) can not be greater than (mx)");
    end

    struc = load(path);
    nn = struc.tNN;
    dataset = load(data).data;
    l = length(ESPConst.CODES_CLASSES);
    
    features = dataset.(ESPConst.PROP_DATASET_FEATURES);
    classes = dataset.(ESPConst.PROP_DATASET_CLASSES);
    classes = categorical(classes);

    c = class(nn);
    if c == "network"
        view(nn);
        predicted = nn(transpose(features));
        [~, c] = size(predicted);
        m = max(predicted, [], 1);
        idx = (predicted == m);
        [row, ~] = find(idx, c, 'first');
        predicted = categorical(row);
    else
        analyzeNetwork(nn);

        if (class(nn.Layers(2)) == "nnet.cnn.layer.Convolution2DLayer")
            [startIdx, endIdx] = regexp(path, "Height[0-9]+");
            slen = strlength("Height");
            height = str2double(extractBetween(path, startIdx + slen, endIdx));
            images = splitTimeseries(features, height);
            sz = size(images);
            images = reshape(images, sz(1), sz(2), 1, sz(3));
            aux = classify(nn, images);
            predicted = zeros(1, size(features, 1));
            l2 = size(aux, 1);

            j = 0;
            for i=(1:l2)
                base = j * height + 1;
                predicted((base:base + height)) = aux(j + 1);

                j = j + 1;
            end

            predicted = categorical(predicted');
        else
            features = mat2cell(features.', size(features,2), ones(size(features,1),1)).';
            predicted = classify(nn, features);
        end
    end
  
    TP = zeros(1, l);
    TN = zeros(1, l);
    FP = zeros(1, l);
    FN = zeros(1, l);

    for i=1:size(predicted)-mx
        temp = predicted(i:i+mx);
        mostOccured = mode(temp);
        timesOccured = sum(temp==mostOccured);  
        
        if timesOccured >= min
            predicted(i) = mostOccured;
        end
    end

    confusionM = confusionmat(classes, predicted);
    plotconfusion(classes, predicted);

    for j=1:l
        i = ESPConst.CODES_CLASSES(j);
        TP(i) = confusionM(i, i);
        FN(i) = sum(confusionM(i, :)) - confusionM(i, i);
        FP(i) = sum(confusionM(:, i)) - confusionM(i, i);
        TN(i) = sum(confusionM(:)) - TP(i) - FN(i) - FP(i);
    end
    
    accuracy = sum(predicted == classes) / numel(classes);
    SE = TP(typeClass) / (TP(typeClass) + FN(typeClass));
    SP = TN(typeClass) / (TN(typeClass) + FP(typeClass));

    valError = struc.valError;
    r = struct("accuracy", accuracy, ...
        "SE", SE, ...
        "SP", SP, ...
        "valError", valError);

    disp("Value Error: " + valError)
    disp("Accuracy: " + accuracy);
    disp("SE: " + SE);
    disp("SP: " + SP);
end
