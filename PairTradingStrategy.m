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
        Timer;
        HoldingPeriod;
        M1Analytics;
    end
     
    %/ strategy constructor and strategies
    methods
        %/ constructor
        function obj = PairTradingStrategy(LimitLevel,StopLossLevel,HoldingPeriod)
                obj.HoldingPeriod = HoldingPeriod;
                obj.LimitLevel = LimitLevel;
                obj.StopLossLevel = StopLossLevel;
                obj.M1Analytics.Timer = 0;
        end
        
        %/ update market data
        function obj = UpdateMarketData(obj,NewDataObj)
                 obj.Data = [];
                 obj.Data = NewDataObj;
        end
        
        
        
        %%/ trading strategy **M1**
        %/ V1 / Description / 
        %/ This trading strategy is based on simple linear regression
        %/ It regress return of Y with return of X and sum up the residual return of the regression
        %/ If the relationship is significant then the sum of the residual
        %/ should be stationary(e.g  if e~n(0,sigma) then sum(e) ~
        %/ N(0,n* Sigma ^2)
        %/ holding period: 20 days 
        
        function obj = M1(obj, MarketData, CurrentPortfolio)
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
                 RegSt = regstats(YRetVec,pccomponent,'linear',{'beta','r','adjrsquare'});
                 
                 
                 %/ ****************** Display Code *************************/%
                 display(strcat(datestr(MarketData.TimeStamp),' Linear Regression R^2 =  ', num2str(RegSt.adjrsquare)));
                 %/ ****************** ************ *************************/%
                 
                 
                 %/ construct residual return index
                 obj.M1Analytics.ResIndex = zeros(size(RegSt.r,1)+1,1);
                 obj.M1Analytics.ResIndex(1,:) = 1;
                 for j = 1:size(RegSt.r)
                     obj.M1Analytics.ResIndex(j+ 1,:) = obj.M1Analytics.ResIndex(j,:) * (1 + RegSt.r(j,1));
                 end
                 StdResIndex = (obj.M1Analytics.ResIndex - mean(obj.M1Analytics.ResIndex))/std(obj.M1Analytics.ResIndex);
              
                 %/ calculate portfolio weight 
                 obj.PortfolioRetWeight = (pccoef * RegSt.beta(2:end,1))';
                 obj.PortfolioActWeight = ((pccoef * RegSt.beta(2:end,1)) .* transpose(YCurrentPrice./XCurrentPrice))';
                 
                 
                 obj.M1Analytics.Intercept = RegSt.beta(1,1);
                 obj.M1Analytics.Mean = mean(StdResIndex);
                 obj.M1Analytics.Std = std(StdResIndex);
                 
                 %/ check stationarity 
                 [stationarity, Pval] = adftest(StdResIndex,'model','AR','lags',0,'alpha',0.05);
                 
                 %/ ****************** Display Code *************************/%
                 display(strcat(datestr(MarketData.TimeStamp),' ADF Test Stationary = ', num2str(stationarity), '  PVAL = ', num2str(Pval)));
                 %/ ****************** ************ *************************/%
                 
                 %/ if stationary then generate trading signal
                 
              else %/ if current portfolio have existing position 
                 obj.PortfolioRetWeight = CurrentPortfolio.StrategyData.PortfolioRetWeight;
                 obj.PortfolioActWeight = abs(CurrentPortfolio.Quantity(1,2:end));
                 obj.M1Analytics.Mean = CurrentPortfolio.StrategyData.Mean;
                 obj.M1Analytics.Std = CurrentPortfolio.StrategyData.Std;
                 obj.M1Analytics.ResIndex = CurrentPortfolio.StrategyData.ResIndex;
                 obj.M1Analytics.Intercept = CurrentPortfolio.StrategyData.Intercept ;
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
                  NewPortfolioIndex = Yret - Xret*obj.PortfolioRetWeight' - obj.M1Analytics.Intercept;
                  %/ add to previous ResIndex to find current resindex
                  NewPortfolioIndex = obj.M1Analytics.ResIndex(end,:) + NewPortfolioIndex;
                  %/ generating trading signal
                  StdNewResIndex = (NewPortfolioIndex - mean(obj.M1Analytics.ResIndex))/std(obj.M1Analytics.ResIndex);
                  
                  %/ ****************** Display Code *************************/%
                  display(strcat('StdNewResIndex = ', num2str(StdNewResIndex )));
                  %/ ****************** Display Code *************************/%
                  
                  %/ buy or sell order :
                  %/ Signal = 
                  %/ 1: Buy 
                  %/ 2: Sell
                  %/ 3: Do nothing       
                  
                  %/ Trading Signal Generation
                  %/ if position does not converge within holding period
                  %/ then close the position
                  if obj.M1Analytics.Timer > obj.HoldingPeriod && CurrentPortfolio.Direction(1,1) ~= 0
                     if CurrentPortfolio.Direction(1,1) == -1 
                        obj.Signal = 1;
                        obj.M1Analytics.Timer =0;
                     elseif CurrentPortfolio.Direction(1,1) == 1
                        obj.Signal = -1;
                        obj.M1Analytics.Timer =0;
                     end 
                     
                  %/ generate entry signal    
                  elseif StdNewResIndex > 2 && StdNewResIndex < 5  && CurrentPortfolio.Direction(1,1) == 0
                    obj.Signal = -1; 
                    obj.M1Analytics.Timer =1;
                  elseif StdNewResIndex <  - 2 && StdNewResIndex > -5 && CurrentPortfolio.Direction(1,1) == 0
                    obj.Signal = 1; 
                    obj.M1Analytics.Timer =1;
                    
                  %/ generate limit exit signal when position exist  
                  elseif StdNewResIndex < 0 && CurrentPortfolio.Direction(1,1) == -1   
                    obj.Signal = 1;  
                    obj.M1Analytics.Timer =0;
                  elseif StdNewResIndex > -0 && CurrentPortfolio.Direction(1,1) == 1      
                    obj.Signal = -1;
                    obj.M1Analytics.Timer =0;
                    
                    
                  %/ generate stop loss exit signal when position exist  
                  elseif StdNewResIndex > 4 && CurrentPortfolio.Direction(1,1) == -1   
                    obj.Signal = 1;  
                    obj.M1Analytics.Timer =0;
                  elseif StdNewResIndex < - 4 && CurrentPortfolio.Direction(1,1) == 1      
                    obj.Signal = -1;
                    obj.M1Analytics.Timer =0;                  
                  
                  %/ if none of the above threadholds are met then do nothing 
                  else
                    obj.Signal = 0; 
                    if CurrentPortfolio.Direction(1,1) ~= 0
                       obj.M1Analytics.Timer = obj.M1Analytics.Timer + 1;
                    else   
                       obj.M1Analytics.Timer = 0;
                    end    
                  end
              else
                 obj.Signal = 0;
                 obj.M1Analytics.Timer =0;
              end
              
              
         
              obj.M1Analytics.M1Signal = obj.Signal;
              
              if obj.Signal == 1
                 obj.M1Analytics.PortfolioXWeight = -obj.PortfolioActWeight;
                 obj.M1Analytics.PortfolioYweight = 1;
              elseif obj.Signal == -1   
                 obj.M1Analytics.PortfolioXWeight = obj.PortfolioActWeight;
                 obj.M1Analytics.PortfolioYweight = -1;  
              else
                 obj.M1Analytics.PortfolioXWeight = 0;
                 obj.M1Analytics.PortfolioYweight = 0;                    
              end
              obj.M1Analytics.PortfolioRetWeight = obj.PortfolioRetWeight;
        end
        
        
        %/ trading strategy **M2**
        %/ V1
        %/ Description
        function [M1Signal, PortfolioYweight,PortfolioXWeight, PortfolioRetWeight, Mean, Std,ResIndex]...
                  = M2(obj, MarketData, CurrentPortfolio)
              
                  
              
        end
        
    end
    
    
 

end
