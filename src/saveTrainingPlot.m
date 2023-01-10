function stop = saveTrainingPlot(info, name)
    stop = false;
    if info.State == "done"
        currentfig = findall(groot, 'Tag', 'NNET_CNN_TRAININGPLOT_UIFIGURE');
        savefig(currentfig, name + '.fig')
    end
end