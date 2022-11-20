function [accuracy, SE, SP, valError, options] = getClassifierPerformance(net, data, type, method)
    % net - rede a ser usada
    % data - dados da pessoa a ser testada
    % type - detecao ou previsao
    % method - ponto a ponto, 10 pontos consecutivos, 5 dos ultimos 10 pontos

    nn = load(net);
    dataset = load(data).data; % data ja vem com as classes
    
    features = dataset.(ESPConst.PROP_DATASET_FEATURES);
    features = mat2cell(features.', size(features,2), ones(size(features,1),1)).';
    classes = dataset.(ESPConst.PROP_DATASET_CLASSES);
    classes = categorical(classes);

    predicted = classify(nn.tNN, features);

    % Method 1
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
        % parar (error function?)
    end 

    auxMethods = 0;
    if method == "10_consecutive_points"
        auxMethods = 10;
    elseif method == "5_in_10_consecutive_points"
        auxMethods = 5;
    else
        if method ~= "point_by_point"
            disp("Wrong method. Choose 'point_by_point', '10_consecutive_points' or '5_in_10_consecutive_points'");
            % parar (error function?)
        end
    end
    
    if auxMethods ~= 0
        for i=1:size(predicted)-10
            temp = predicted(i:i+10);
            mostOccured = mode(temp);
            timesOccured = sum(temp==mostOccured);  
            
            if timesOccured >= auxMethods
                predicted(i) = mostOccured;
            end
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
    disp("Accuracy: " + accuracy);
    disp("SE: " + SE);
    disp("SP: " + SP);
end
