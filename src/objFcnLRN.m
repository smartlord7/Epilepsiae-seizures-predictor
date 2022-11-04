function [objFcn] = objFcnLRN(p, t, pv, tv, inputName)
    objFcn = @valErrorFcn;
    function [valError, cons, fileName] = valErrorFcn(optVars)
        lrn =  layrecnet(optVars.LayerDelays, optVars.HiddenSize, 'trainscg');
        lrn.trainParam.epochs = optVars.MaxEpochs;
        lrn.trainParam.lr = optVars.InitialLearnRate;
        [Xs,Xi,Ai,Ts] = preparets(lrn, transpose(p), con2seq(t));
        [lrn, info] = train(lrn, Xs, Ts, Xi, Ai);
        valError = info.best_perf;
        fileName = num2str(valError) + "_LRN_" + inputName;
        save(ESPConst.PATH_LRNS + fileName, 'valError');
        cons = [];
    end
end

