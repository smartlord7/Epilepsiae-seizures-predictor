function [r] = getClassifierPerformance(path, data, type, min, mx)
    struc = load(path);
    nn = struc.tNN;
    dataset = load(data).data;
    
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
        features = mat2cell(features.', size(features,2), ones(size(features,1),1)).';
        predicted = classify(nn, features);
    end

    l = length(ESPConst.CODES_CLASSES);
    TP = zeros(1, l);
    TN = zeros(1, l);
    FP = zeros(1, l);
    FN = zeros(1, l);

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
        TP(i) = confusionM(i,i);
        FN(i) = sum(confusionM(i,:)) - confusionM(i,i);
        FP(i) = sum(confusionM(:,i)) - confusionM(i,i);
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
