classdef PairTradingStrategy

    %/ Trading Strategy/Trading Signal generator
    %/ M1 : mean reverting 1 srategy 
    
    
    %/ strategy properties
    properties
        LimitLevel;
        StopLossLevel;
        Data;
        Signal;
        PortfolioActWeight;
        PortfolioRetWeight;
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
        %/ V1
        function [M1Signal, PortfolioYweight,PortfolioXWeight, PortfolioRetWeight, Mean, Std,ResIndex]...
                  = M1(obj, MarketData, CurrentPortfolio)
        % ****************************************************************
        % M1 strategy: 
        % 
        % ****************************************************************
             %/ ret from x & y
              %/ XCurrentPrice ~ 1 x N
              [YCurrentPrice,~,~] = MarketData.FindCurrentPrice(obj.Data.YSymbols);
              [XCurrentPrice,~,~] = MarketData.FindCurrentPrice(obj.Data.XSymbols);
              
              %/ if current portfolio does not have any position then
              %/ calculate weight from scratch
              if CurrentPortfolio.Direction == 0 
                 YRetVec = obj.Data.YRetVec;
                 XRetVec = obj.Data.XRetVec;
                 %/ if size of X > 2 then use PCs to aviod co-linearity
                 %in the following linear regression
                 if size(XRetVec,2) > 1
                    pccoef = princomp(XRetVec);
                    pccomponent = XRetVec * pccoef;
                 else
                    pccoef = 1;
                    pccomponent = XRetVec;
                 end      
                 %/ linear regression on ret
                 RegSt = regstats(YRetVec,pccomponent,'linear',{'beta','r'});
                 %/ construct residual return index
                 ResIndex = zeros(size(RegSt.r,1)+1,1);
                 ResIndex(1,:) = 1;
                 for j = 1:size(RegSt.r)
                     ResIndex(j+ 1,:) = ResIndex(j,:) * (1 + RegSt.r(j,1));
                 end
                 StdResIndex = (ResIndex - mean(ResIndex))/std(ResIndex);
              
                 %/ calculate portfolio weight 
                 obj.PortfolioRetWeight = (pccoef * RegSt.beta(2:end,1))';
                 obj.PortfolioActWeight = ((pccoef * RegSt.beta(2:end,1)) .* transpose(YCurrentPrice./XCurrentPrice))';
                 
                 Mean = mean(StdResIndex);
                 Std = std(StdResIndex);
                 
                 %/ check stationarity 
                 stationarity = adftest(StdResIndex,'model','AR','lags',0);
                 %/ if stationary then generate trading signal
                 
              else %/ if current portfolio have existing position 
                 obj.PortfolioRetWeight = CurrentPortfolio.StrategyData.PortfolioRetWeight;
                 obj.PortfolioActWeight = abs(CurrentPortfolio.Quantity(1,2:end));
                 Mean = CurrentPortfolio.StrategyData.Mean;
                 Std = CurrentPortfolio.StrategyData.Std;
                 ResIndex = CurrentPortfolio.StrategyData.ResIndex;
                 stationarity = 1;
              end
              

              
              if stationarity == 1 
                  %/Calculate current Return
                  YPreviousPrice = obj.Data.YMidPrice(end,1);
                  %/ XPreviousPrice ~ 1 X N
                  XPreviousPrice = transpose(obj.Data.XMidPrice(end,:));
                  Yret = (YCurrentPrice - YPreviousPrice)./YPreviousPrice;
                  %/ Xret ~ 1 X N
                  Xret = (XCurrentPrice - XPreviousPrice')./XPreviousPrice';
                  %/ new portfolio index
                  NewPortfolioIndex = Yret - Xret*obj.PortfolioRetWeight';
                  %/ add to previous ResIndex to find current resindex
                  NewPortfolioIndex = ResIndex(end,:) + NewPortfolioIndex;
                  %/ generating trading signal
                  StdNewResIndex = (NewPortfolioIndex - mean(ResIndex))/std(ResIndex);
                  
                  %/ buy or sell order :
                  %/ Signal = 
                  %/ 1: Buy 
                  %/ 2: Sell
                  %/ 3: Do nothing
                  
                  if strcmp(datestr(MarketData.TimeStamp),'19-Feb-2008')
                     xxx = 1;
                  end
                  
                  if StdNewResIndex > 0  && CurrentPortfolio.Direction(1,1) == 0
                    obj.Signal = -1;  
                  elseif StdNewResIndex <  0  && CurrentPortfolio.Direction(1,1) == 0
                    obj.Signal = 1; 
                  elseif StdNewResIndex < 0 && CurrentPortfolio.Direction(1,1) == -1   
                    obj.Signal = 1;  
                  elseif StdNewResIndex > 0 && CurrentPortfolio.Direction(1,1) == 1      
                    obj.Signal = -1; 
                  else
                    obj.Signal = 0; 
                  end
              else    
                 obj.Signal = 0; 
              end
              
              
         
              M1Signal = obj.Signal;
              
              if obj.Signal == 1
                 PortfolioXWeight = -obj.PortfolioActWeight;
                 PortfolioYweight = 1;
              elseif obj.Signal == -1   
                 PortfolioXWeight = obj.PortfolioActWeight;
                 PortfolioYweight = -1;  
              else
                 PortfolioXWeight = 0;
                 PortfolioYweight = 0;                    
              end
              PortfolioRetWeight = obj.PortfolioRetWeight;
        end
        
        
        %/ trading strategy **M2**
        %/ V1
        %/ Description
        function [M1Signal, PortfolioYweight,PortfolioXWeight, PortfolioRetWeight, Mean, Std,ResIndex]...
                  = M2(obj, MarketData, CurrentPortfolio)
              
                  
              
        end
        
    end
    
    
 
    %/ private methods(only used within the object)
    methods (Access = private)
        %/ calculate portfolio weight give pc weight of pc factors and pc
        %/ regression weight
        function  PortfolioWeight = WeightCalculation(obj, Symbols,PCweights,RegWeights)
            Weights = transpose(RegWeights * PCweights);
            PortfolioWeight = {Symbols Weights};
        end       
    end
    
end
