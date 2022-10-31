function [] = clusterByAEFeatures(aeName, nClasses)
    aeData = load(ESPConst.PATH_AES + aeName);
    features = transpose(aeData.features);
    rng(1); % For reproducibility
    idx = kmeans(features, nClasses, 'Display','final');
    figure;
    scatter3(features(:,1), features(:,2), features(:,3), 15, idx, 'filled');
    title(replace(aeName, "_", "-"));
    saveas(gcf, ESPConst.PATH_IMAGES + aeName + ESPConst.EXTENSION_IMAGE)
end