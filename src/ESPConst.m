classdef ESPConst
    %ESPCONST Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
        PATH_INPUT_DATA = "../in/";
        PATH_IMAGES = "../img/";
        EXTENSION_DATA = ".mat";
        EXTENSION_IMAGE = ".png";
        PATH_DATASET = ESPConst.PATH_INPUT_DATA + "original_dataset/";
        PATH_DATASET_PREPROCESSED =  ESPConst.PATH_INPUT_DATA + "preprocessed_dataset/";
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
        N_INPUT_FEATURES = 29;
        N_OUTPUT_CLASSES_ALL = 4;

        MAX_TIME_GRIDSEARCH = 14 * 60 * 60;

        BALANCE_MODE_NONE = 0;
        BALANCE_MODE_EQUAL = 1;
        BALANCE_MODE_LARGEST_SUM = 2;

        BALANCE_MODES = [ESPConst.BALANCE_MODE_NONE
            ESPConst.BALANCE_MODE_EQUAL
            ESPConst.BALANCE_MODE_LARGEST_SUM
        ];

        RATIO_TRAIN = 0.75;
        RATIO_VAL = 0.25;
        RATIO_TEST = 0.0;
    end
end

