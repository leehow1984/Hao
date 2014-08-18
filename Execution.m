classdef Execution
    
    %
    % Excution object excute trading signals and calculate trading return
    %

    %/ object property 
    properties
        SignalType;
        LimitLevel;
        StopLossLevel;
        Data;
    end
    
    %/ object methods
    methods
        %/ constructor
        function obj = Excution(Data,SignalType,LimitLevel,StopLossLevel)
            obj.SignalType = SignalType;
            obj.Data = Data;
            obj.LimitLevel = LimitLevel;
            obj.StopLossLevel= StopLossLevel;
        end
        
        
        %/ excution function
        function [Return] = Execute(obj)
            
            
            
        end
    end
    
end

