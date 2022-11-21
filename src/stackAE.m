function [aes, stackedAE, features] = stackAE(input, optVarsArr)
    stackedAE = 0;
    first = true;
    nLayers = optVarsArr{1}.NumLayers;
    minFeatures = optVarsArr{1}.MinFeatures;
    step = round(ESPConst.N_INPUT_FEATURES / nLayers);
    hiddenSizes = (ESPConst.N_INPUT_FEATURES - step:-step:minFeatures);
    l = length(hiddenSizes);
    aes = cell(l, 1);

    for i=(1:l)
        optVars = optVarsArr{i};
        ae = trainAutoencoder(input, ...
            'hiddenSize', hiddenSizes(i), ...
            'EncoderTransferFunction', string(optVars.EncoderTransferFunction), ...
            'DecoderTransferFunction', string(optVars.DecoderTransferFunction), ...
            'MaxEpochs', optVars.MaxEpochs, ...
            'L2WeightRegularization', optVars.L2WeightRegularization, ...
            'LossFunction', 'msesparse', ...
            'ShowProgressWindow', true, ...
            'SparsityProportion', optVars.SparsityProportion, ...
            'SparsityRegularization', optVars.SparsityRegularization, ...
            'ScaleData', optVars.ScaleData, ...
            'UseGPU', true);
        
        input = encode(ae, input);
        aes{i} = ae;

        if first == true
            stackedAE = ae;
            first = false;
        else
            stackedAE = stack(stackedAE, ae);
        end

        features = input;
    end
end