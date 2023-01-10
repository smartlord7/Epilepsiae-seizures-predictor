function [splitted] = splitTimeseries(timeseries, length)
    rows = size(timeseries, 1);
    dvs = size(timeseries, 1) / length;
    f = floor(dvs);
    d = dvs - f;
    newRows = int32(rows - (1 + d) * length);
    splitted = timeseries((1:newRows), :);
    splitted = reshape(splitted, size(timeseries, 2), length, []);
end
