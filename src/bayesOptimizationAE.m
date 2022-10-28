function [] = bayesOptimizationAE(trainInput, inputName)
    optVars = [
            optimizableVariable('EncoderTransferFunction', {'logsig' 'satlin'}, 'type', 'categorical')
            optimizableVariable('DecoderTransferFunction', {'logsig' 'satlin' 'purelin'}, 'type', 'categorical')
            optimizableVariable('MaxEpochs', [50 200], 'Type', 'integer')
            optimizableVariable('L2WeightRegularization', [0.001 1], 'Transform' ,'log')
            optimizableVariable('SparsityProportion', [0.05 1], 'Transform' ,'log')
            optimizableVariable('SparsityRegularization', [0.05 5], 'Transform' ,'log')
            optimizableVariable('ScaleData', [0 1])
            optimizableVariable('InitialLearnRate', [0.1 1], 'Transform' ,'log')
        ];

    p = transpose(trainInput.(ESPConst.PROP_DATASET_FEATURES));
    t = transpose(trainInput.(ESPConst.PROP_DATASET_CLASSES));

    objFcn = objFcnAE(p, t, inputName);
    bayesOpt = bayesopt( ...
        objFcn, optVars, ...
        'MaxTime', ESPConst.MAX_TIME_GRIDSEARCH, ...
        'IsObjectiveDeterministic', false, ...
        'UseParallel', false, ...
        'Verbose', 1);
end

