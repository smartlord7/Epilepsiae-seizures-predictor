function [objFcn] = objFcnAE(p, inputName)
    objFcn = @valErrorFcn;
    function [valError, cons, fileName] = valErrorFcn(optVars)
        optVarsArr = cell(1, optVars.NumLayers);
        optVarsArr(:) = {optVars};
        [aes, stackedAE, features] = stackAE(p, optVarsArr);
        l = length(aes);
        code = features;

        for i=l:-1:1
            ae = aes{i};
            code = decode(ae, code);
        end

        valError = mse(p - code);
        fileName = "Err" + num2str(valError) + ...
            "AE" + ...
            "NLayers" + num2str(optVars.NumLayers) + ...
            "MinFeatures" + num2str(optVars.MinFeatures) + ...
            "Patient" + inputName;
        save(ESPConst.PATH_AES + fileName, ...
            'stackedAE', ...
            'features', ...
            'valError');
        cons = [];
    end
end