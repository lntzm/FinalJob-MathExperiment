function error = errorAnalysis(predict, output, status)
% 用于计算预测数据与真实数据的误差
% param predict 预测值    param output 实际值
% return errorAvg 平均误差，越小越准确
CODPredict = predict(1, :);     % COD预测数据
VFAPredict = predict(2, :);     % VFA预测数据
CODOutput = output(1, :);       % COD真实数据
VFAOutput = output(2, :);       % VFA真实数据

% 计算误差
columns = size(output,2);
error1 = abs((CODPredict - CODOutput)./CODOutput);  % COD误差
error1Mean = mean(error1);                          % COD平均误差
error2 = abs((VFAPredict - VFAOutput)./VFAOutput);  % VFA误差
error2Mean = mean(error2);                          % VFA平均误差
error = [error1Mean, error2Mean];

%  绘制COD预测值与真实值
figure()
subplot(121)
plot(CODOutput ,'x')
hold on
plot( CODPredict, 'o')
axis([0 columns 0 100])
legend('真实值','预测值')
xlabel('样本')
ylabel('COD去除率')
string = {[status, '出水COD去除率预测结果对比']; ['R^2=', num2str(R1)]};
title(string)

% 绘制VFA预测值与真实值
subplot(122)
plot(VFAOutput ,'x')
hold on
plot( VFAPredict, 'o')
axis([0 columns 0 100])
legend('真实值','预测值')
xlabel('样本')
ylabel('VFA去除率')
string = {[status, '出水VFA去除率预测结果对比']; ['R^2=', num2str(R2)]};
title(string)

% 绘制COD的error
figure()
subplot(121)
plot(error1, '.')
axis([0 350 0 0.5])
xlabel('样本')
ylabel('相对误差')
string  = [status, 'COD去除率误差'];
title(string)
grid on

% 绘制VFA的error
subplot(122)
plot(error2, '.')
axis([0 350 0 0.5])
xlabel('样本')
ylabel('相对误差')
string  = [status, 'VFA去除率误差'];
title(string)
grid on
