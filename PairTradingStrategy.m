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
        function M1Result = M1MACD(obj)
        % ****************************************************************
        % M1 strategy: 
        % mean reverting index: rescaled index difference
        % mean reverting indicator: MACD   
        % ****************************************************************
                 
                 %/ main loop
                 for i = obj.LookBack:obj.LookFwd:size(obj.Data.XRetVex,1) 
                     
                     %/ ret from x & y
                     YRetVec = obj.Data.YRetVec(i-obj.LookBack + 1,:);
                     XRetVec = obj.Data.XRetVec(i-obj.LookBack + 1,:);
                     
                     
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
                     
                     
                     %/ if stationary then trade it 
                     
                     
                     
                     
                     
                                  
                 end  
                 
                 %/ result export
                 M1Result = 0;
        
        end
        
        
        
        
        
        
  
    end
    
end

