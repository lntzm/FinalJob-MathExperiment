filename = "data.xlsx";
[trainData, testData] = dataPreprocess(filename);   % 得到训练集与测试集

% 划分输入数据与输出数据，并转置，用于归一化
trainInput = trainData(:, 1: 9)';
trainOutput = trainData(:, 10: 12)';
testInput = testData(:, 1: 9)';
testOutput = testData(:, 10: 12)';

% 数据归一化
[input, inputPS] = mapminmax(trainInput);
[output, outputPS] = mapminmax(trainOutput);
trainInput = mapminmax('apply', trainInput, inputPS);
trainOutput = mapminmax('apply', trainOutput, outputPS);
testInput = mapminmax('apply', testInput, inputPS);
testOutput = mapminmax('apply', testOutput, outputPS);
