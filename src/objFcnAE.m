function [objFcn] = objFcnAE(p, t, inputName)
    objFcn = @valErrorFcn;
    function [valError, cons, fileName] = valErrorFcn(optVars)
        optVarsArr = cell(1, 5);
        optVarsArr(:) = {optVars};
        [stackedAE, features] = stackAE(p, optVarsArr);
        softnet = trainSoftmaxLayer(features, t, 'LossFunction', 'crossentropy');
        deepNet = stack(stackedAE, softnet);
        deepNet = train(deepNet, p, t);
        predicted = int32(deepNet(p));
        plotconfusion(categorical(t), categorical(predicted));
        valError =  1 - mean(predicted == t);
        fileName = num2str(valError) + "_AE_" + inputName + ESPConst.EXTENSION_DATA;
        save(ESPConst.PATH_TRAINED_NNS + fileName, 'deepNet', 'features', 'valError');
        cons = [];
    end
end