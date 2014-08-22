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
        Direction;
        %/ potential component to be added into portfolio object
        %/ RiskManager
        %/ Portfolio Controller
    end
    
    
    methods
        %/ Constructor
        function obj = Portfolio(Cash)
            obj.Symbols = cell(0,1);
            obj.Quantity = zeros(0,1);
            obj.Cost = zeros(0,1);
            obj.Cash = Cash;
            obj.MTM = zeros(0,1);
            obj.Weights = zeros(0,1);
            %/ calculate % weight and NAV
            %for i = 1:ize(obj.Symbols,1) 
            %    obj.MTM(i,1) =  MarketData.MidPrice(find(strcmp(obj.Symbols(i,1),MarketData.Symbols),'first'),1);
            %end
            %/ NAV Calculation 
            obj.NAV = obj.Cash;
            %/ P&L Calculation
            %obj.PNL = obj.MTM - obj.Cost;
            %/ Weight Calculation
            %obj.Weights = obj.MTM / obj.NAV;
        end
        
        %/ Add/Remove security to the portfolio object
        function obj = AddToPortfolio(obj,Symbols,Quantity,Cost,MarketData,Direction)

            
           % update current position
            for i = 1:size(Symbols,1)
                if size(obj.Symbols,1) ~= 0
                    if sum(strcmp(Symbols(i,1),obj.Symbols)) > 0 %/ same security exist
                       Index = find(strcmp(Symbols(i,1),obj.Symbols));
                   %/ Calculating the cost of the position
                   %/ If position net off then set cost to zero 
                   %/ Otherwise calculate weighted average of position
                   
                       if obj.Quantity(Index,1) == - Quantity %/ close position
                          obj.Cost(Index,1) = 0;
                       elseif (obj.Quantity(Index,1)> 0 && Quantity > 0) || (obj.Quantity(Index,1) < 0 && Quantity < 0)  %/ add position
                          obj.Cost(Index,1) = obj.Cost(Index,1)+ Cost; 
                       else %/ reduce position
                          obj.Cost(Index,1) = obj.Cost(Index,1) + Cost; 
                       end 
                       obj.Quantity(Index,1) =  obj.Quantity(Index,1) + Quantity(i,1);
                    
                       obj.Cash = obj.Cash - Cost;
                   else % new security
                       obj.Symbols(end+1,:) = Symbols(i,1);
                       obj.Quantity(end+1,:) = Quantity(i,1);
                       obj.Cost(end+1,:) = Cost(i,1);
                       obj.Cash = obj.Cash - Cost;
                   end
                else %/ new security 
                    obj.Symbols(end+1,:) = Symbols(i,1);
                    obj.Quantity(end+1,:) = Quantity(i,1);
                    obj.Cost(end+1,:) = Cost(i,1);
                    obj.Cash = obj.Cash - Cost;
                end
            end
            
           %/ Remove security with zero holdings
              Index = find(obj.Quantity == 0);
              obj.Symbols(Index,:) = [];
              obj.Quantity(Index,:) = [];
              obj.Cost(Index,:) = [];
              obj.MTM(Index,:) = [];
              obj.PNL(Index,:) = [];
              obj.Weights(Index,:) = [];
              
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
            
            %/ Trade Direction
            obj.Direction = Direction;
            
            
        end
        

        
    end
    
end

