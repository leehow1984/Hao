classdef PairTradingStrategy

    %/ Trading Strategy/Trading Signal generator
    %/ M1 : mean reverting 1 srategy 
    
    
    %/ strategy properties
    properties
        LimitLevel;
        StopLossLevel;
        Data;
        Signal;
        PortfolioWeight;
    end
     
    %/ strategy constructor and strategies
    methods
        %/ constructor
        function obj = PairTradingStrategy(DataObj,LimitLevel,StopLossLevel)
                obj.Data = DataObj;
                obj.LimitLevel = LimitLevel;
                obj.StopLossLevel = StopLossLevel;
        end
        
        %/ trading strategy **M1**
        function obj = M1MACD(obj, MarketData, CurrentPortfolio)
        % ****************************************************************
        % M1 strategy: 
        % mean reverting index: rescaled index difference
        % mean reverting indicator: MACD   
        % ****************************************************************
        
             %/ ret from x & y
             YRetVec = obj.Data.YRetVec;
             XRetVec = obj.Data.XRetVec;
                     
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
              
              %/ calculate portfolio weight 
              obj.PortfolioWeight = WeightCalculation(Symbols,pccoef, RegSt.beta(2:end,1));
              
              
              %/ check stationarity 
              stationarity = adftest(ResIndex,'model','AR','lags',0);
              %/ if stationary then generate trading signal
              if stationarity == 1
                  
                  %/Calculate current Return
                  YCurrentPrice = 
                  
                  
                  
                  
                  
                  
                  
                 %/ generating trading signal
                 StdResIndex = (ResIndex - mean(ResIndex))/std(ResIndex);
                 if StdResIndex(end,1) > 2 
                    obj.M1Signal = -1;  
                 elseif StdResIndex(end,1) < -2
                    obj.M1Signal = 1; 
                 else
                    obj.M1Signal = 0; 
                 end
              end
        end
        
        
        
        
    
    end
    
    %/ private methods(only used within the object)
    methods (Access = private)
        
        %/ calculate portfolio weight give pc weight of pc factors and pc
        %/ regression weight
        function  PortfolioWeight = WeightCalculation(Symbols,PCweights,RegWeights)
            Weights = transpose(RegWeights * PCweights);
            PortfolioWeight = [Symbols Weights];
        end       
    end
    
end
