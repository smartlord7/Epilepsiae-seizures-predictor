function [] = bayesOptimizationLRN(trainInput, inputName)
    optVars = [
            optimizableVariable('LayerDelays', [1 10], 'Type','integer')
            optimizableVariable('HiddenSize', [30 50], 'Type','integer')
            optimizableVariable('InitialLearnRate', [0.01 1], 'Transform', 'log')
            optimizableVariable('MaxEpochs', [50 1000], 'Type', 'integer')
            optimizableVariable('ErrorWeightInterictal', [0 0.1])
            optimizableVariable('ErrorWeightPreictal', [0.3 0.4])
            optimizableVariable('ErrorWeightIctal', [0.5 0.6])
            optimizableVariable('ErrorWeightPosictal', [0.2 0.3])
            optimizableVariable('TrainFcn', {'trainbr', 'trainbfg', 'trainrp', ...
            'trainscg', 'traincgb', 'traincgf', ...
            'traincgp', 'trainoss', 'traingdx', ...
            'traingdm', 'traingd'})
        ];
    
    p = trainInput.(ESPConst.PROP_DATASET_FEATURES);
    t = trainInput.(ESPConst.PROP_DATASET_CLASSES);
    t = onehotencode(t, size(t, 1));

    objFcn = objFcnLRN(p, t, inputName);
    bayesOpt = bayesopt( ...
        objFcn, optVars, ...
        'MaxTime', ESPConst.MAX_TIME_GRIDSEARCH, ...
        'IsObjectiveDeterministic', false, ...
        'UseParallel', false, ...
        'Verbose', 1);
end

