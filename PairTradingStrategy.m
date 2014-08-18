classdef PairTradingStrategy

    %/ Strategy Code:
    %/ M1 : mean reverting 1 srategy: st
    
    %% / construct pair trading strategy parameter
    properties
        LookBack;
        LookFwd;
        LimitLevel;
        StopLossLevel;
        Data;
    end
     
    %% / obj methods(including constructor)
    methods
        %/ constructor
        function obj = PairTradingStrategy(DataObj,LookBack,LookFwd,LimitLevel,StopLossLevel)
                obj.Data = DataObj;
                obj.LookBack = LookBack; 
                obj.LookFwd = LookFwd;
                obj.LimitLevel = LimitLevel;
                obj.StopLossLevel = StopLossLevel;
        end
        
        %/ trading strategy **M1**
        function MACD1Result = MACD1(obj)
        % 
        % M1 strategy: 
        % mean reverting index: rescaled index 
        % mean reverting indicator: MACD   
        % 
        
        
        
        
        
        
        end
        
        
        
        
        
        
  
    end
    
end

