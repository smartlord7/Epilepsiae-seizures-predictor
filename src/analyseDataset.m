function [] = analyseDataset(dataset)
    phases = dataset.(ESPConst.PROP_DATASET_CLASSES);
    histogram(phases);
    names = {'Interictal'; 'Preictal'; 'Ictal'; 'Postictal'};
    l = length(phases);
    for i=1:length(names)
        count = length(find(phases == i));
        names{i} = sprintf("%s - %d (%.3f%%)", names{i}, count, count / l * 100);
    end
    set(gca,'xtick', 1:length(names), 'xticklabel', names, 'fontsize', 8);
    title("Patient no " + dataset.Id);
    xlabel("Phases");
    ylabel("Occurrences");
end