% Author: Hao Liu
% Email: liuh295@mail2.sysu.edu.cn
% Platform: Ubuntu 18.04
% Toolkit: Matlab R2017a

% 码表
codebook = [-1.3077, 2.7694, -0.0631, 1.4897, -1.2075, 1.0347;
            -0.4336, -1.3499, 0.7147, 1.4090, 0.7172, 0.7269;
            0.3426, 3.0349, -0.2050, 1.4172, 1.6302, -0.3034;
            3.5784, 0.7254, -0.1241, 0.6715, 0.4889, 0.2939];
      
s = size(codebook);

nSize = [1000, 10000, 100000];

% 实验进行次数
% N = 10000;

for N = nSize
    % 保存计算的概率结果（对应于白噪声的方差）
    probability = ones(1, 100);

    for i = 0.1:0.1:10
        % 记录当前成功次数
        count = 0;
        for j = 1:N
            % 随机选择发送信号
            randIndex = randi(s(1));
            curSignalX = codebook(randIndex,:);

            % 产生标准高斯噪声
            gaussSignal = normrnd(0, 1, [1 6]);
            % 接收到的信号
            sendingSignal = curSignalX + i*gaussSignal;

            % 根据最小欧式距离原则推断发送的是哪个信号
            min = Inf;
            index = 1;
            for k = 1:s(1)
                temp = norm(sendingSignal - codebook(k,:));
                if (temp < min)
                    min = temp;
                    index = k;
                end
            end
            % 推断成功则计数加一
            if (index == randIndex)
                count = count + 1;
            end

        end

        pb = count / N;
        probability(int32(i / 0.1)) = pb;
    end

    % 绘制方差与概率的对应关系
    figure;
    plot(0.1:0.1:10, probability, 'r.');
    xlabel("variance");
    ylabel("probability to successful");
    
end