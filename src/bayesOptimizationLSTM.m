function [] = bayesOptimizationLSTM(trainInput, valInput, inputName)
    optimVars = [
        optimizableVariable('SectionDepth', [20 30], 'Type', 'integer')
        optimizableVariable('InitialLearnRate', [0.1 1], 'Transform' ,'log')
        optimizableVariable('NumHiddenUnits', [100 5000], 'Type', 'integer')
        optimizableVariable('Momentum', [0.8 0.98])
        optimizableVariable('L2Regularization', [1e-4 1e-2], 'Transform', 'log')
        ];
    p = trainInput.(ESPConst.PROP_DATASET_FEATURES);
    t = trainInput.(ESPConst.PROP_DATASET_CLASSES);
    pv = valInput.(ESPConst.PROP_DATASET_FEATURES);
    tv = valInput.(ESPConst.PROP_DATASET_CLASSES);

    objFcn = objFcnLSTM(p, t, pv, tv, inputName);
    bayesOpt = bayesopt( ...
        objFcn, optimVars, ...
        'MaxTime', ESPConst.MAX_TIME_GRIDSEARCH, ...
        'IsObjectiveDeterministic', false, ...
        'UseParallel', true, ...
        'Verbose', 1);
end

