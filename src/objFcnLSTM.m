function [objFcn] = objFcnLSTM(p, t, pv, tv, inputName)
    objFcn = @valErrorFcn;
    function [valError, cons, fileName] = valErrorFcn(optVars)
        layers = [
               sequenceInputLayer(ESPConst.N_INPUT_FEATURES)
               lstmLayer(optVars.NumHiddenUnits, OutputMode="last")
               fullyConnectedLayer(ESPConst.N_OUTPUT_CLASSES_ALL)
               softmaxLayer
               classificationLayer
                 ];
        miniBatchSize = 64;
        validationFrequency = floor(numel(t) / miniBatchSize);

        options = trainingOptions('sgdm', ...
            'InitialLearnRate', optVars.InitialLearnRate, ...
            'Momentum',optVars.Momentum, ...
            'MaxEpochs', 60, ... 
            'LearnRateSchedule', 'piecewise', ...
            'LearnRateDropPeriod', 40, ...
            'LearnRateDropFactor', 0.1, ...
            'MiniBatchSize', miniBatchSize, ...
            'L2Regularization', optVars.L2Regularization, ...
            'ExecutionEnvironment', "cpu", ...
            'Verbose', true, ...
            'Plots', 'training-progress', ...
            'ValidationFrequency', validationFrequency);

        hasValData = true;
        if length(unique(tv)) == ESPConst.N_OUTPUT_CLASSES_ALL
            options.ValidationData = {pv, tv};
            hasValData = false;
        end

        tNN = trainNetwork(p, t, layers, options);

        if hasValData == true
            valError = inf;
        else
            predicted = classify(tNN, pv);
            valError =  1 - mean(predicted == transpose(tv));
        end

        fileName = num2str(valError) + "_LSTM_" + inputName;
        save(ESPConst.PATH_TRAINED_NNS + fileName, 'tNN','valError','options');
        cons = [];
    end
end