classdef Portfolio
    %
    %   Portfolio object
    %
      
    properties
        Symbols;
        Quantity;
        Weights;
        PCweights;
        RegWeights;
        Nav;
        
        %/ potential component to be added into portfolio object
        %/ RiskManager
        %/ 
    end
    
    
    methods
        %/ Constructor
        function obj = Portfolio(Symbols,Quantity,Weights,PCweights,RegWeights)
            obj.Symbols = Symbols;
            obj.Quantity = Quantity;
            obj.Weights = Weights;
            obj.PCweights = PCweights;
            obj.RegWeights = RegWeights;
            %/ calculate % weight from PC weight.
        end
        
        
        
        
        
    end
    
end

