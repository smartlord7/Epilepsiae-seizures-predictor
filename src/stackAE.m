function [stackedAE, features] = stackAE(input, optVarsArr)
    stackedAE = 0;
    first = true;
    hiddenSizes = (ESPConst.N_INPUT_FEATURES-6:-6:3);
    l = length(hiddenSizes);
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
            'ScaleData', optVars.ScaleData);
        input = encode(ae, input);

        if first == true
            stackedAE = ae;
            first = false;
        else
            stackedAE = stack(stackedAE, ae);
        end

        features = input;
    end
end