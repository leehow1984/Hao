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
        
        %/ Add/Remove security to the portfolio object
        function obj = AddToPortfolio(obj,Symbols,Quantity,Cost,MarketData)

            
           % update current position
            for i = 1:size(Symbols,1)
                if sum(Strcmp(Symbols(i,1),obj.Symbols)) > 0 %/ same security exist
                   Index = find(Strcmp(Symbols(i,1),obj.Symbols),'first');
                   %/ Calculating the cost of the position
                   %/ If position net off then set cost to zero 
                   %/ Otherwise calculate weighted average of position
                   %/
                   if obj.Quantity(Index,1) == - Quantity %/ close position
                      obj.Cost(Index,1) = 0;
                   elseif (obj.Quantity(Index,1)> 0 && Quantity > 0) || (obj.Quantity(Index,1) < 0 && Quantity < 0)  %/ add position
                      obj.Cost(Index,1) = (obj.Cost(Index,1)*obj.Quantity(Index,1) + Quantity*Cost)/(obj.Quantity(Index,1) + Quantity); 
                   else %/ reduce position
                      obj.Cost(Index,1) = obj.Cost(Index,1) * (obj.Quantity(Index,1) + Quantity(i,1)); 
                   end 
                   obj.Quantity(Index,1) =  obj.Quantity(Index,1) + Quantity(i,1);
                    
                   obj.Cash = obj.Cash + Cost;
                else %/ new security 
                    obj.Symbols(end+1,:) = Symbols(i,1);
                    obj.Quantity(end+1,:) = Quantity(i,1);
                    obj.Cost(end+1,:) = Cost(i,1);
                end
            end
            
           %/ Remove security with zero holdings
              Index = obj.Quantity == 0;
              obj.Symbols(Index,1) = [];
              obj.Quantity(Index,1) = [];
              obj.Cost(Index,1) = [];
              obj.MTM(Index,1) = [];
              obj.PNL(Index,1) = [];
              obj.Weights(Index,1) = [];
              
           %/ Update current portfolio's MTM
            for i = 1:size(obj.Symbols,1)  
                obj.MTM(i,1) = MarketData.MidPrice(find(strcmp(obj.Symbols(i,1),MarketData.Symbols),1))*obj.Quantity(i,1);
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

