classdef Portfolio
    %
    %   Portfolio object
    %   Contents holding information      
    properties
        Symbols;
        SecurityType;
        Quantity;
        Cost;
        MTM;
        PNL;
        Weights;
        NAV;
        Cash;   
        %/ potential component to be added into portfolio object
        %/ RiskManager
        %/ Portfolio Controller
    end
    
    
    methods
        %/ Constructor
        function obj = Portfolio(Symbols,Quantity,Cost,MarketData,Cash)
            obj.Symbols = Symbols;
            obj.Quantity = Quantity;
            obj.Cost = Cost;
            obj.Cash = Cash;
            %/ calculate % weight and NAV
            for i = 1:ize(obj.Symbols,1) 
                obj.MTM(i,1) =  MarketData.MidPrice(find(strcmp(obj.Symbols(i,1),MarketData.Symbols),'first'),1);
            end
            %/ NAV Calculation 
            obj.NAV = sum(obj.MTM + obj.Cash);
            %/ P&L Calculation
            obj.PNL = obj.MTM - obj.Cost;
            %/ Weight Calculation
            obj.Weights = obj.MTM / obj.NAV;
        end
        
        %/ Add element to the object
        function obj = AddToPortfolio(obj,Symbols,Quantity,Cost,MarketData)
            obj.Symbols(end+1,1) = Symbols;
            obj.Quantity(end+1,1) = Quantity;
            obj.Cost(end+1,1) = Cost;
            %/ Cash 
            obj.Cash = obj.Cash - Quantity * Cost;
            %/ calculate % weight and NAV
            for i = 1:ize(obj.Symbols,1)
                obj.MTM(i,1) =  MarketData.MidPrice(find(strcmp(obj.Symbols(i,1),MarketData.Symbols),'first'),1);
            end
            %/ NAV Calculation
            obj.NAV = sum(obj.MTM + obj.Cash);
            %/ P&L Calculation
            obj.PNL = obj.MTM - obj.Cost;
            %/ Weight Calculation
            obj.Weights = obj.MTM / obj.NAV;
        end
        
        %/ Remove element to the object
        function obj = RemoveFromPortfolio(obj,Symbols,Quantity,Cost,MarketData)
            obj.Quantity(find(strcmp(Symbols,obj.Symbols),'first'),1) = obj.Quantity(find(strcmp(Symbols,obj.Symbols),'first'),1) - Quantity;
            obj.Quantity(end+1,1) = Quantity; 
            obj.Cost(end+1,1) = Cost;
            %/ Cash
            obj.Cash = obj.Cash - Quantity * Cost;
            %/ calculate % weight and NAV
            for i = 1:ize(obj.Symbols,1)
                obj.MTM(i,1) =  MarketData.MidPrice(find(strcmp(obj.Symbols(i,1),MarketData.Symbols),'first'),1);
            end
            %/ NAV Calculation
            obj.NAV = sum(obj.MTM + obj.Cash);
            %/ P&L Calculation
            obj.PNL = obj.MTM - obj.Cost;
            %/ Weight Calculation
            obj.Weights = obj.MTM / obj.NAV;          
        end
        
    end
    
end

