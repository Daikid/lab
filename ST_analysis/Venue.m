classdef Venue
    %会場をまとめて管理するクラス
    
    properties
        fs  % サンプリングレート
        t   % プロット用の時間ラベル (0:1/fs:2-1/fs)
        mPointList  %   ["S01", ... , "S08"]　など
        measurementPoints   %   mPointListの各測定点に対応する...
                            %   MeasurementPointクラスのインスタンス
        
    end
    
    methods

        %コンストラクタ
        function obj = Venue(mPointList)

            %   mPointList :   ["S01", ... , "S08"]　など

            obj.fs = 48000;
            obj.t = (0 : 1/obj.fs : 2-1/obj.fs);
            obj.measurementPoints = containers.Map();
            obj.mPointList = mPointList;
        end

        function showWaves(obj, direction, timeSpan)
            %   波形を表示して反射音構造を観察する
            %   8点または9点のみに対応…

            %   obj :   Venueクラスのインスタンス
            %   direction   :   "omni", "front"など
            %   timeSpan    :   表示したい範囲[0, 0.10]

            figure
            tl = tiledlayout(3,3,'TileSpacing','Compact');
            title(tl, direction);
            for mPoint = obj.mPointList
                measurementPoint = obj.measurementPoints(mPoint);
                IR = measurementPoint.sixIRs(direction);

                %タイルレイアウト用の変数kを設定
                %{
                for j = 1:9
                    if 1<= j && j <= 3
                        k = j + 6;
                    end
    
                    if 4<= j && j <= 6
                        k = j;
                    end
                    
                    if 7<= j && j <= 9
                        k = j - 6;
                    end
                end
                %}
        
                nexttile

                risePos = riseFind(IR, 30);
                tmpIR = IR(risePos:risePos+obj.fs*2-1);
                plot(obj.t, tmpIR);
                title(mPoint)
                xlim(timeSpan)
                xlabel("time[s]")
            end
        end
    end
end
