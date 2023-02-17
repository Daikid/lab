classdef MeasurementPoint
    %一つの測定点でのデータを管理する

    properties
        fs; %サンプリング周波数
        
        AIRs; %Aフォーマット（元データ）のインパルス応答波形
        sixIRs; %6chに分解した状態のインパルス応答波形
        
        directionalFreqSTearly; %周波数バンドごとの方向別STearly
        directionalFreqSTlate; %周波数バンドごとの方向別STlate
        directionalSTearly; %周波数バンド平均後の方向別STearly
        directionalSTlate; %周波数バンド平均後の方向別STlate
    end
    
    methods
        
        %コンストラクタ インスタンスを初期化
        %インパルス応答波形をそのまま保持
        function obj = MeasurementPoint(measure4wav)

            obj.fs = 48000;

            obj.directionalFreqSTearly = containers.Map();
            obj.directionalFreqSTlate = containers.Map();
            
            obj.directionalSTearly = containers.Map();
            obj.directionalSTlate = containers.Map();
            
            % A formatのデータ
            A_form_key = {'ch1', 'ch2', 'ch3', 'ch4'};
            A = cell(1,4);
            for i = 1:4
                A{1,i} = measure4wav(:,i);
            end
            obj.AIRs = containers.Map(A_form_key, A);
            
            % B formatへの変換を経由
            B = AtoB(A);
            
            
            % 6ch + 無指向性のデータ
            six_key = {'omni','front', 'back', 'left', 'right', 'up', 'down'};
            six_IRs = Bto6(B);
            obj.sixIRs = containers.Map(six_key, six_IRs);
            
        end

        function obj = setDirST(obj, divTime, directionKey, BPFs)
            %方向別ST（無指向性含む）を計算してメンバ変数に格納

            %   obj :   MeasurementPointクラスのインスタンス
            %   divTime :   [0.010, 0.010]　[直接音終了時刻, 初期反射音開始時刻]
            %   directionKey    :   "omni", "front", "back", "left",...
            %                       "right", "up", "down"のいずれか
            %   BPFs    :   バンドパスフィルタ

            directEndTime = divTime(1); %直接音の終了時刻[s]
            earlyStartTime = divTime(2); %初期反射音の開始時刻[s]

            %無指向性の直接音（分母側）を時間切り出し
            omniIR = obj.sixIRs("omni");

            omniStartNum = riseFind(omniIR, 30);
            omniIR = omniIR(omniStartNum : omniStartNum + obj.fs*2 - 1); %2秒間切り出し
            omniDirect = omniIR(1:obj.fs*directEndTime); %直接音を切り出し
            
            %この方向の反射音を時間切り出し
            directionIR = obj.sixIRs(directionKey);

            refStartNum = riseFind(directionIR, 30);
            directionIR = directionIR(refStartNum : refStartNum + obj.fs*2 - 1); %2秒間切り出し

            directionalEarlyRef = directionIR(obj.fs * earlyStartTime : obj.fs*0.100 - 1); %初期反射音切り出し
            directionalLateRef = directionIR(obj.fs*0.100 : obj.fs*1.00 - 1); %後期反射音切り出し

            %バンドパスフィルタをかけてバンドごとのSTを計算

            dirFreqSTearly = zeros(4,1);
            dirFreqSTlate = zeros(4,1);
            for i = 1:4
                %BPFをかける
                BPF = BPFs{i,1};
                BPFedOmniDirect = conv(omniDirect, BPF);
                BPFedDirEarly = conv(directionalEarlyRef, BPF);
                BPFedDirLate = conv(directionalLateRef, BPF);

                %このバンドでのSTを計算
                dirFreqSTearly(i) = 10*log10(sum(BPFedDirEarly.^2)/...
                    sum(BPFedOmniDirect.^2));
                dirFreqSTlate(i) = 10*log10(sum(BPFedDirLate.^2)/...
                    sum(BPFedOmniDirect.^2));
            end

            %バンドごとのSTをメンバ変数に値を保持
            obj.directionalFreqSTearly(directionKey) = dirFreqSTearly;
            obj.directionalFreqSTlate(directionKey) = dirFreqSTlate;


            %方向別バンドごとのSTの平均をメンバ変数に保持
            
            dirSTearly = mean(dirFreqSTearly);
            dirSTlate = mean(dirFreqSTlate);
            
            obj.directionalSTearly(directionKey) = dirSTearly;
            obj.directionalSTlate(directionKey) = dirSTlate;

        end

    end
end