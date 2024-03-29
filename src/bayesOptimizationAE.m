function [] = bayesOptimizationAE(trainInput, inputName)
    optVars = [
            optimizableVariable('NumLayers', [3 10], 'Type', 'integer')
            optimizableVariable('MinFeatures', [1 5], 'Type', 'integer')
            optimizableVariable('EncoderTransferFunction', {'logsig' 'satlin'}, 'type', 'categorical')
            optimizableVariable('DecoderTransferFunction', {'logsig' 'satlin' 'purelin'}, 'type', 'categorical')
            optimizableVariable('MaxEpochs', [50 500], 'Type', 'integer')
            optimizableVariable('L2WeightRegularization', [0.001 1], 'Transform' ,'log')
            optimizableVariable('SparsityProportion', [0.05 1], 'Transform' ,'log')
            optimizableVariable('SparsityRegularization', [0.05 5], 'Transform' ,'log')
            optimizableVariable('ScaleData', [0 1])
            optimizableVariable('InitialLearnRate', [0.01 1], 'Transform' ,'log')
        ];

    p = transpose(trainInput.(ESPConst.PROP_DATASET_FEATURES));

    objFcn = objFcnAE(p, inputName);
    bayesOpt = bayesopt( ...
        objFcn, optVars, ...
        'MaxTime', ESPConst.MAX_TIME_GRIDSEARCH, ...
        'IsObjectiveDeterministic', false, ...
        'UseParallel', true, ...
        'Verbose', 1);
end

