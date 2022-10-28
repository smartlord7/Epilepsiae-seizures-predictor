function [] = analyseDataset(dataset, title_extra)
    phases = dataset.(ESPConst.PROP_DATASET_CLASSES);
    figure;
    histogram(phases);
    names = {'Interictal'; 'Preictal'; 'Ictal'; 'Postictal'};
    l = length(phases);
    for i=1:length(names)
        count = length(find(phases == i));
        names{i} = sprintf("%s - %d (%.3f%%)", names{i}, count, count / l * 100);
    end
    set(gca,'xtick', 1:length(names), 'xticklabel', names, 'fontsize', 8);
    title_ = "Patient no " + dataset.Id + title_extra;
    title(title_);
    xlabel("Phases");
    ylabel("Points");
    saveas(gcf, ESPConst.PATH_IMAGES + title_ + ESPConst.EXTENSION_IMAGE);
end