function [errorWeights] = getErrorWeights(t, classWeights)
    errorWeights = zeros(size(t));
    for i=1 : length(classWeights)
        cw = classWeights(i,: );
        idx = (categorical(transpose(t)) == categorical(cw(1)));
        errorWeights(idx) = cw(2);
    end
end

