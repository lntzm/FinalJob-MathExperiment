%% 数据预处理
filename = "data.xlsx";
data = xlsread(filename);
[nanRows, ~] = find(isnan(data));           % 找到存在NaN的行
data(nanRows, :) = [];                      % 删除存在NaN的行
[zeroRows, ~] = find(data == 0);
data(zeroRows, :) = [];

% 得到异常与正常样本的标签
labels = ones(size(data, 1), 1);
[BadRows, ~] = find(data(:, 11)<80 | data(:, 10)<50);
for i = 1: length(BadRows)
    labels(BadRows(i)) = 0;
end
data(:, [10, 11]) = [];

[trainData, testData, trainLabel, testLabel] = getTrainTest(data, labels);

%% BP神经网络训练
while (1)
    % 如果目录中有已保存的网络，不进行训练，加载此网络
    if exist('classification.mat', 'file')
        load classification net
        break;
    end
    % 否则，定义BP前馈神经网络
    net = newff(trainData,trainLabel',9,{'tansig','purelin'},'trainlm');
    %网络参数的设置
    net.trainParam.epochs = 200;  %训练次数设置
    net.trainParam.goal = 0.01;  %训练目标设置
    net.trainParam.lr = 0.005;  %学习率设置
    net.trainParam.mc = 0.9;  %动量因子的设置
    net.trainParam.max_fail = 20;  % 最大确认失败次数
    % 开始训练
    net = train(net,trainData,trainLabel');
    trainPredict = sim(net,trainData);
    warning = find(trainPredict < 0.5);
    
    if length(warning) > 20     % 异常样本数足够，停止训练
        break;
    end
    % 如果异常样本数过少，训练结果可能不准确，重新划分训练集并训练
    [trainData, testData, trainLabel, testLabel] = getTrainTest(data, labels);
end

save classification net         % 保存训练的网络

trainPredict = fixPredict(trainPredict);
trainAccuracy = countDiff(trainPredict, trainLabel);    % 计算预测精确度

%% 测试集测试
%测试集的预测输出
testPredict = sim(net,testData);
testPredict = fixPredict(testPredict);
testAccuracy = countDiff(testPredict, testLabel);       % 计算预测准确度

% 画图查看分类情况
figure()
plot(testLabel, 'r-*')
hold on
plot(testPredict, 'b:o')
legend('真实值', '预测值')
title('测试集预测结果比较')

%% classification中用到的一些小函数
function [trainData, testData, trainLabel, testLabel] = getTrainTest(data, labels)
% 划分训练集、测试集数据与标签并进行归一化
trainIndex = crossvalind('HoldOut', size(data,1), 0.25);    % 训练集索引
testIndex = ~trainIndex;                            % 测试集索引
trainData = data(trainIndex, :);                    % 训练集数据
testData = data(testIndex, :);                      % 测试集数据
trainLabel = labels(trainIndex);                    % 训练集标签
testLabel = labels(testIndex);                      % 测试集标签
% 数据归一化，需要转置
[~, PS] = mapminmax(trainData');
trainData = mapminmax('apply', trainData', PS);
testData = mapminmax('apply', testData', PS);
end

function predict = fixPredict(predict)
% 得到预测分类结果，大于等于0.5为正常，小于0.5为异常
predict(predict >= 0.5) = 1;
predict(predict < 0.5) = 0;
predict = predict';
end

function accuracy = countDiff(predict, true)
% 计算分类准确度
count = 0;
for i = 1: length(true)     % 预测值与真实值不相等，count++
    if (predict(i) ~= true(i))
        count = count + 1;
    end
end
accuracy = 1 - (count / length(true));
end


