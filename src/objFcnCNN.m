function [objFcn] = objFcnCNN(p, t, pv, tv, inputName)
    objFcn = @valErrorFcn;
    function [valError, cons, fileName] = valErrorFcn(optVars)

        p = datasetTimeseriesToImg(p, t, inputName, optVars.ImageHeight);
        pv = datasetTimeseriesToImg(pv, tv, inputName, optVars.ImageHeight);

        layers = [
               imageInputLayer([ESPConst.N_INPUT_FEATURES, optVars.ImageHeight, 1])
               convolution2dLayer([optVars.FilterSizeX optVars.FilterSizeY], optVars.NumFilters)
               maxPooling2dLayer(optVars.PoolSize)
               batchNormalizationLayer
               flattenLayer
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
            'LearnRateDropPeriod', round(optVars.MaxEpochs / 3), ...
            'LearnRateDropFactor', optVars.LearnRateDropFactor, ...
            'MiniBatchSize', optVars.MiniBatchSize, ...
            'L2Regularization', optVars.L2Regularization, ...
            'ExecutionEnvironment', "cpu", ...
            'Verbose', true, ...
            'Plots', 'training-progress', ...
            'ValidationData', {pv, tv}, ...
            'ValidationFrequency', validationFrequency);

        if optVars.Solver == "sgdm"
            options.Momentum = optVars.Momentum;
        end

        tNN = trainNetwork(p, t, layers, options);
        predicted = classify(tNN, pv);
        valError =  1 - mean(predicted == transpose(tv));
        fileName = num2str(valError) + "_CNN_" + inputName;
        save(ESPConst.PATH_CNNS + fileName, 'tNN','valError','options');
        cons = [];
    end
end