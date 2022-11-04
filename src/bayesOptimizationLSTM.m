function [] = bayesOptimizationLSTM(trainInput, valInput, inputName)
    optimVars = [
        optimizableVariable('Solver', {'adam', 'sgdm', 'rmsprop'});
        optimizableVariable('MiniBatchSize', [16 1024], 'Type', 'integer');
        optimizableVariable('MaxEpochs', [100 2000], 'Type', 'integer')
        optimizableVariable('InitialLearnRate', [0.1 1], 'Transform' ,'log')
        optimizableVariable('LearnRateDropFactor', [0.1 1], 'Transform' ,'log')
        optimizableVariable('NumHiddenUnits', [50 200], 'Type', 'integer')
        optimizableVariable('Momentum', [0.1 1])
        optimizableVariable('L2Regularization', [1e-4 1e-2], 'Transform', 'log')
        ];
    
    p = trainInput.(ESPConst.PROP_DATASET_FEATURES);
    t = trainInput.(ESPConst.PROP_DATASET_CLASSES);
    pv = valInput.(ESPConst.PROP_DATASET_FEATURES);
    tv = valInput.(ESPConst.PROP_DATASET_CLASSES);

    objFcn = objFcnLSTM(p, t, p, t, inputName);
    bayesOpt = bayesopt( ...
        objFcn, optimVars, ...
        'MaxTime', ESPConst.MAX_TIME_GRIDSEARCH, ...
        'IsObjectiveDeterministic', false, ...
        'UseParallel', false, ...
        'Verbose', 1);
end

