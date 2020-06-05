clc;clear all;
%% 数据导入及预处理
filename = "data.xlsx";
[trainData, testData] = dataPreprocess(filename);   % 得到训练集与测试集

% 划分输入数据与输出数据，并转置，用于归一化
trainInput = trainData(:, 1: 9)';
trainOutput = trainData(:, 10: 11)';
testInput = testData(:, 1: 9)';
testOutput = testData(:, 10: 11)';

% 数据归一化
[input, inputPS] = mapminmax(trainInput);
[output, outputPS] = mapminmax(trainOutput);
trainInputNorm = mapminmax('apply', trainInput, inputPS);
trainOutputNorm = mapminmax('apply', trainOutput, outputPS);
testInputNorm = mapminmax('apply', testInput, inputPS);
testOutputNorm = mapminmax('apply', testOutput, outputPS);

%% 神经网络训练
%定义BP前馈神经网络
net_predict = newff(trainInputNorm,trainOutputNorm,5,{'tansig','tansig'},'traingd');
%网络参数的设置
net_predict.trainParam.epochs = 20000;  %训练次数设置
net_predict.trainParam.goal = 0.01;  %训练目标设置
net_predict.trainParam.lr = 0.05;  %学习率设置
net_predict.trainParam.mc = 0.9;  %动量因子的设置

%<--------------------------------开始训练-------------------------------->%

net_predict = train(net_predict,trainInputNorm,trainOutputNorm);
%导入预测数据Datapredict
trainPredictNorm = sim(net_predict,trainInputNorm);

%对预测数据反归一化，是否正确？存疑
trainPredict = mapminmax('reverse',trainPredictNorm,outputPS);

% 对训练集预测结果进行性能评价
%%% lzh: 增加返回值
[errorTrain, R2Train] = errorAnalysis(trainPredict,trainOutput);
%%% lzh: END

%% 测试集测试
%测试集的预测输出
testPredictNorm = sim(net_predict,testInput);

%对预测数据反归一化，是否正确？存疑
testPredict = mapminmax('reverse',testPredictNorm,outputPS);

% 对测试集预测结果进行性能评价
%%% lzh: 增加返回值
[errorTest, R2Test] = errorAnalysis(testPredict,testOutput);
%%% lzh: END
