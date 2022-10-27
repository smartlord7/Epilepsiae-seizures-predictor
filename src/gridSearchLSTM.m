function [] = gridSearchLSTM(trainInput, valInput)
    optimVars = [
        optimizableVariable('SectionDepth', [1 10], 'Type', 'integer')
        optimizableVariable('InitialLearnRate', [0.1 1], 'Transform' ,'log')
        optimizableVariable('Momentum', [0.01 1])
        optimizableVariable('L2Regularization', [1e-10 1e-2], 'Transform', 'log')
        ];
    p = trainInput.(ESPConst.PROP_DATASET_FEATURES);
    t = trainInput.(ESPConst.PROP_DATASET_CLASSES);
    pv = valInput.(ESPConst.PROP_DATASET_FEATURES);
    tv = valInput.(ESPConst.PROP_DATASET_CLASSES);

    objFcn = objFcnLSTM(p, t, pv, tv);
    bayesOpt = bayesopt( ...
        objFcn, optimVars, ...
        'MaxTime', 14 * 60 * 60, ...
        'IsObjectiveDeterministic', false, ...
        'UseParallel', false, ...
        'Verbose', 1);
end

