function [error, R] = errorAnalysis(predict, output)
% 用于计算预测数据与真实数据的误差
% params predict 预测值
% params output 实际值
% return errorAvg 平均误差，越小越准确
% return R2 相关系数，越大越准确

CODPredict = predict(1, :);
VFAPredict = predict(2, :);
CODOutput = output(1, :);
VFAOutput = output(2, :);

columns = size(output,2);
error1 = abs((CODPredict - CODOutput)./CODOutput);
error1 = mean(error1);
error2 = abs((VFAPredict - VFAOutput)./VFAOutput);
error2 = mean(error2);
error = [error1, error2];
%平均误差

%决定系数R^2,R^2越接近1表示拟合越好,number为样本数量
R1 = solveR(CODPredict, CODOutput, columns);
R2 = solveR(VFAPredict, VFAOutput, columns);
R = [R1, R2];


%  绘图
figure()
subplot(121)
plot(CODOutput ,'x')
hold on
plot( CODPredict, 'o')
axis([0 columns 0 100])
legend('真实值','预测值')
xlabel('样本')
ylabel('COD去除率')
string = ['测试集出水COD去除率预测结果对比\n', 'R^2=', num2str(R1)];
title(string)

subplot(122)
plot(VFAOutput ,'x')
hold on
plot( VFAPredict, 'o')
axis([0 columns 0 100])
legend('真实值','预测值')
xlabel('样本')
ylabel('VFA去除率')
string = ['测试集出水VFA去除率预测结果对比\n', 'R^2=', num2str(R2)];
title(string)

function R = solveR(predict, output, number)
R = (number * sum(predict .* output) - sum(predict) * sum(output))^2 / ...
((number * sum(predict.^2) - (sum(predict))^2) * ...
(number * sum(output.^2) - (sum(output))^2));




