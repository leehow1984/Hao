classdef PairTradingStrategy

    %/ Strategy Code:
    %/ M1 : mean reverting 1 srategy: st
    
    %/ construct pair trading strategy parameter
    properties
        LookBack;
        LookFwd;
        LimitLevel;
        StopLossLevel;
        Data;
    end
    
    
    %/ obj methods
    methods
        %/ construct the object
        function obj = PairTradingStrategy(DataObj,LookBack,LookFwd,LimitLevel,StopLossLevel)
                obj.Data = DataObj;
                obj.LookBack = LookBack; 
                obj.LookFwd = LookFwd;
                obj.LimitLevel = LimitLevel;
                obj.StopLossLevel = StopLossLevel;
        end
        
        %/ trading strategy 
        function M1Result = M1(obj, YColumn)
            %     
            
            
                 
               
            
        
        end
        
        
        
        
    end
    
end

