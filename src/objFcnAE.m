function [objFcn] = objFcnAE(p, t, inputName)
    objFcn = @valErrorFcn;
    function [valError, cons, fileName] = valErrorFcn(optVars)
        optVarsArr = cell(1, 5);
        optVarsArr(:) = {optVars};
        [aes, stackedAE, features] = stackAE(p, optVarsArr);
        l = length(aes);
        code = features;
        for i=l:-1:1
            ae = aes{i};
            code = decode(ae, code);
        end
        valError = mse(p - code);
        fileName = num2str(valError) + "_AE_" + inputName;
        save(ESPConst.PATH_AES + fileName, 'stackedAE', 'features', 'valError');
        cons = [];
    end
end