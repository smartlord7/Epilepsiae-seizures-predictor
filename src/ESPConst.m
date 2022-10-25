classdef ESPConst
    %ESPCONST Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
        PATH_INPUT_DATA = "../in/";
        EXTENSION_DATA = ".mat";
        PATH_DATASET = ESPConst.PATH_INPUT_DATA + "dataset/";
        PROP_DATASET_FEATURES = "FeatVectSel";
        PROP_DATASET_CLASSES = "Trg";
        CODE_CLASS_NON_ICTAL = 0;
        CODE_CLASS_ICTAL = 1;
        CODE_CLASS_ALL_INTERICTAL = 1;
        CODE_CLASS_ALL_PREICTAL = 2;
        CODE_CLASS_ALL_ICTAL = 3;
        CODE_CLASS_ALL_POSTICTAL = 4;
        BEFORE_INTERVAL_POINTS_PREICTAL = 900; % 15 minutes
        AFTER_INTERVAL_POINTS_POSTICTAL = 300; % 5 minutes
    end
end

