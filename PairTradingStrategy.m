classdef PairTradingStrategy

    %/ Strategy Code:
    %/ M1 : mean reverting srategy 1 (PCA Based);
    
    %% / construct pair trading strategy parameter
    properties
        LimitLevel;
        StopLossLevel;
        TrainingDataObj;
        MarketDataObj;
    end
     
    %% / obj methods(including constructor)
    methods
        %/ constructor
        function obj = PairTradingStrategy(TrainingDataObj,MarketDataObj,LimitLevel,StopLossLevel)
                obj.MarketDataObj = MarketDataObj;
                obj.TrainingDataObj = TrainingDataObj;
                obj.LimitLevel = LimitLevel;
                obj.StopLossLevel = StopLossLevel;
        end
        
        %/ trading strategy **M1**
        function M1Signal = M1MACD(obj)
        % ****************************************************************
        % M1 strategy: 
        % mean reverting index: rescaled index difference
        % mean reverting indicator: MACD   
        % ****************************************************************
                 %/ main loop
                 
                     %/ ret from x & y
                     YRetVec = obj.TrainingDataObj.YRetVec;
                     XRetVec = obj.TrainingDataObj.XRetVec;
                     
                     %/ if size of X > 2 then use PCs to aviod co-linearity
                     %in the following linear regression
                     if size(XRetVec,2) > 2
                        pccoef = princomp(XRetVec);
                        pccomponent = XRetVec * pccoef;
                     else
                        pccomponent = XRetVec;
                     end    
                     
                     %/ linear regression on ret
                     RegSt = regstats(YRetVec,pccomponent,'linear');
                     %/ construct residual return index
                     ResIndex = zeros(size(RegSt.r,1)+1,1);
                     ResIndex(1,:) = 1;
                     for j = 1:size(RegSt.r)
                         ResIndex(j+ 1,:) = ResIndex(j,:) * (1 + RegSt.r(j,1));
                     end
                     %/ check stationarity 
                     stationarity = adftest(ResIndex,'model','AR','lags',0);
                     %/ if stationary then trade it 
                     if stationarity == 1
                         %/ generating trading signal
                         StdResIndex = (ResIndex - mean(ResIndex))/std(ResIndex);
                         
                         if StdResIndex(end,1) > 2 
                            M1Signal = -1;  
                         elseif StdResIndex(end,1) < -2
                            M1Signal = 1; 
                         else
                            M1Signal = 0; 
                         end
                     else
                         M1Signal = 0; 
                     end  
        end
        
        
        
    end
end
