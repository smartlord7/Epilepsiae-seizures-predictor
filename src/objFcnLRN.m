function [objFcn] = objFcnLRN(p, t, inputName)
    objFcn = @valErrorFcn;
    function [valError, cons, fileName] = valErrorFcn(optVars)
        lrn =  layrecnet(optVars.LayerDelays, optVars.HiddenSize, 'trainscg');
        lrn.trainParam.epochs = optVars.MaxEpochs;
        lrn.trainParam.lr = optVars.InitialLearnRate;
        classWeights = [ESPConst.CODE_CLASS_ALL_INTERICTAL optVars.ErrorWeightInterictal;
            ESPConst.CODE_CLASS_ALL_PREICTAL optVars.ErrorWeightPreictal;
            ESPConst.CODE_CLASS_ALL_ICTAL optVars.ErrorWeightIctal;
            ESPConst.CODE_CLASS_ALL_POSICTAL optVars.ErrorWeightPosictal];
        errorWeights = getErrorWeights(t, classWeights);
        [xs, xi, ai, ts, ew] = preparets(lrn, transpose(p), con2seq(t), {}, errorWeights);
        [lrn, info] = train(lrn, xs, ts, xi, ai, ew);
        valError = info.best_perf;
        fileName = num2str(valError) + "_LRN_" + inputName;
        save(ESPConst.PATH_LRNS + fileName, 'lrn', 'valError');
        cons = [];
    end
end

