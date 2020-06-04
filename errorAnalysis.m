%性能评价
function error = errorAnalysis(predict,output)
%相对误差error
predict = predict';
output = output';
number = size(output,1);
error = abs((predict - output)./output)
%平均误差
error_ = mean(mean(error)')

%决定系数R^2,R^2越接近1表示拟合越好,number为样本数量
R2 = (number*sum(predict.*output) - sum(predict).*sum(output)).^2;
R2 = R2/((number*sum((predict).^2) - (sum(predict)).^2).*(number*sum((output).^2) - (sum(output)).^2));
R2.^2

%结果对比
result = [output;predict;error]
%  绘图
% for i = 1:3
%     figure
%     stem(1:number,Output(i,:))
%     hold on
%     stem(1:number,predict(i,:))
% end
legend('真实值','预测值')
xlabel('预测样本')
ylabel('出水COD')
string = {'测试集出水COD含量预测结果对比';['R^2=' num2str(R2)]};
title(string)