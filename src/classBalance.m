function [features, classifications] = classBalance(features, classifications, mode)
    [counts, classes] = histcounts(classifications);
    classes(end) = [];
    classes = round(classes);

    if mode == 0
        [minCount, idx] = min(counts);
        minClass = classes(idx);

        for i=find(classes ~= minClass)
            class = classes(i);
            classCount = counts(i);
            diffCount = classCount - minCount;
            [features, classifications] = randomSubsample(features, classifications, class, diffCount);
        end   
    else
        [maxCount, idx] = max(counts);
        maxClass = classes(idx);
        remainingCount = length(find(classifications ~= maxClass));

        if maxCount > remainingCount
            diffCount = maxCount - remainingCount;
            [features, classifications] = randomSubsample(features, classifications, maxClass, diffCount);
        end
    end
end

