function [r] = getClassifierPerformance(net, data, type, min, max)
    nn = load(net);
    dataset = load(data).data;
    
    features = dataset.(ESPConst.PROP_DATASET_FEATURES);
    features = mat2cell(features.', size(features,2), ones(size(features,1),1)).';
    classes = dataset.(ESPConst.PROP_DATASET_CLASSES);
    classes = categorical(classes);

    predicted = classify(nn.tNN, features);

    TP = zeros(1,4);
    TN = zeros(1,4);
    FP = zeros(1,4);
    FN = zeros(1,4);

    typeClass = 0;
    if type == "detection"
        typeClass = 3;
    elseif type == "prediction"
        typeClass = 2;
    else
        disp("Wrong type. Choose 'detection' or 'prediction'");
    end 

    if min < 0 || max < 0 || mod(min,1) ~= 0 || mod(max,1) ~= 0
        disp("Insert only positive integers");
    end
    if max < min
        disp("(min) can not be greater than (max)");
    end

    for i=1:size(predicted)-max
        temp = predicted(i:i+max);
        mostOccured = mode(temp);
        timesOccured = sum(temp==mostOccured);  
        
        if timesOccured >= min
            predicted(i) = mostOccured;
        end
    end

    confusionM = confusionmat(classes, predicted);
    plotconfusion(classes, predicted);

    for i=1:4
        TP(i) = confusionM(i,i);
        FN(i) = sum(confusionM(i,:)) - confusionM(i,i);
        FP(i) = sum(confusionM(:,i)) - confusionM(i,i);
        TN(i) = sum(confusionM(:)) - TP(i) - FN(i) - FP(i);
    end
    
    accuracy = sum(predicted == classes)/numel(classes);
    SE = TP(typeClass)/(TP(typeClass) + FN(typeClass));
    SP = TN(typeClass)/(TN(typeClass) + FP(typeClass));
    valError = nn.valError;
    options = nn.options;
    r = struct("accuracy",accuracy, "SE", SE, "SP", SP, "valError", valError, "options", options);

    disp("Value Error: " + valError)
    disp("Accuracy: " + accuracy);
    disp("SE: " + SE);
    disp("SP: " + SP);
end
