function [objFcn] = objFcnCNN(p, t, pv, tv, inputName)
    objFcn = @valErrorFcn;
    function [valError, cons, fileName] = valErrorFcn(optVars)
        layers = [
               imageInputLayer(ESPConst.N_INPUT_FEATURES, optVars.ImageHeight)
               bilstmLayer(optVars.NumHiddenUnits,OutputMode="last")
               fullyConnectedLayer(ESPConst.N_OUTPUT_CLASSES_ALL)
               softmaxLayer
               classificationLayer
                 ];
        validationFrequency = floor(numel(t) / optVars.MiniBatchSize);

        options = trainingOptions(string(optVars.Solver), ...
            'InitialLearnRate', optVars.InitialLearnRate, ...
            'MaxEpochs', optVars.MaxEpochs, ...
            'SequencePaddingDirection', "left", ...
            'Shuffle', "every-epoch", ...
            'LearnRateSchedule', 'piecewise', ...
            'LearnRateDropPeriod', optVars.MaxEpochs / 3, ...
            'LearnRateDropFactor', optVars.LearnRateDropFactor, ...
            'MiniBatchSize', optVars.MiniBatchSize, ...
            'L2Regularization', optVars.L2Regularization, ...
            'ExecutionEnvironment', "gpu", ...
            'Verbose', true, ...
            'Plots', 'training-progress', ...
            'ValidationFrequency', validationFrequency);

        if optVars.Solver == "sgdm"
            options.Momentum = optVars.Momentum;
        end

        tNN = trainNetwork(p, t, layers, options);
        predicted = classify(tNN, pv);
        valError =  1 - mean(predicted == transpose(tv));
        fileName = num2str(valError) + "_LSTM_" + inputName;
        save(ESPConst.PATH_LSTMS + fileName, 'tNN','valError','options');
        cons = [];
    end
end