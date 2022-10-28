function [features, classifications] = randomSubsample(features, classifications, class, count)
    rng(ESPConst.SEED_RANDOM_SUBSAMPLE);
    classIdx = find(classifications == class);
    rn = randperm(length(classIdx));
    rn = rn(1:count);
    rnClassIdx = classIdx(rn);
    features(rnClassIdx,:) = [];
    classifications(rnClassIdx) = [];
end