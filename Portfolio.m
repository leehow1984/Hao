
classdef Portfolio
    %
    %   Portfolio object
    %   Contents holding information      
    properties
        Symbols; % 1 x n cell 
        SecurityType;
        Quantity; % 1 x n matrix
        Cost; % 1 x n matrix 
        MTM; % 1 x n matrix
        PNL; % 1 x n matrix
        Weights; % 1 x n matrix
        NAV; % 1 x 1 matrix
        Cash;  % 1 x 1 matrix
        Direction; % 1 x 1 matrix
        StrategyData;
        NAVHistory;
        PNLHistory;
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
            obj.PNL = 0;
            obj.NAVHistory = 0;
            obj.PNLHistory = 0;
            %/ Weight Calculation
            %obj.Weights = obj.MTM / obj.NAV;
        end
        
        %/ Add security to the portfolio object
        function obj = AddToPortfolio(obj,Symbols,Quantity,Cost,MarketData,Direction,StrategyData)
           %/ input check
           if size(Symbols,1) > 1 || ~iscell(Symbols)
              error('Symbols must be a 1 x n cell');
           end
           if size(Quantity,1) > 1 || ~ismatrix(Quantity)
              error('Quantity must be a 1 x n matrix');
           end
           if size(Cost,1) > 1 || ~ismatrix(Cost)
              error('Cost must be a 1 x n matrix');
           end           
           if size(Cost,1) > 1 || ~ismatrix(Cost)
              error('Cost must be a 1 x n matrix');
           end 
           
           
           %/ Update current portfolio's MTM
           if size(obj.Symbols,1) ~= 0
              for i = 1:size(obj.Symbols,2)  
                obj.MTM(1,i) = MarketData.MidPrice(find(strcmp(obj.Symbols(1,i),MarketData.Symbols),1))*obj.Quantity(1,i);
              end
           end
            %/ P&L Calculation
            obj.PNL = sum(obj.MTM - obj.Cost);
            obj.PNLHistory(1,end+1) = obj.PNL; 
           
            
           %/ update current position
            for i = 1:size(Symbols,2)
                if ~isempty(obj.Symbols) %/ if the portfolio is not empty
                    if sum(strcmp(Symbols(1,i),obj.Symbols)) > 0 %/ check if the same security exist
                       Index = find(strcmp(Symbols(1,i),obj.Symbols));
                       %/ Calculating the cost of the position
                       %/ If position net off then set cost to zero 
                       %/ Otherwise calculate weighted average of position
                   
                       if obj.Quantity(1,Index) == - Quantity(1,i)  %/ close position
                          obj.Cost(1,Index) = 0;
                          obj.MTM(1,i)  = 0;
                          
                       elseif obj.Quantity(1,Index)> 0 || obj.Quantity(1,Index) < 0  %/ add position
                          obj.Cost(1,Index) = obj.Cost(1,Index)+ sum(Cost); 
                       else %/ reduce position
                          obj.Cost(1,Index) = obj.Cost(1,Index) + sum(Cost); 
                       end 
                       
                       obj.Cash = obj.Cash - Cost(1, i);
                   else % new security
                       obj.Symbols(1, i) = Symbols(1,i);
                       obj.Cost(1, i) = Cost(1,i);
                       obj.MTM(1,i) =  Cost(1,i);
                       obj.Cash = obj.Cash - Cost(1, i);
                   end
                else %/ if the portfolio is empty
                    obj.Symbols(1, i) = Symbols(1, i);
                    obj.Cost(1, i) = Cost(1, i);
                    obj.MTM(1,i) =  Cost(1,i);
                    obj.Cash = obj.Cash - Cost(1, i);
                end
            end
           
            
            
           %/ add quantity 
           if isempty(obj.Quantity)
              obj.Quantity =  Quantity  ;
           else
              obj.Quantity =  obj.Quantity  + Quantity ;  
           end    
           
           
           %/ Trade Direction
           obj.Direction = obj.Direction + Direction; 
           
            
           %/ NAV Calculation
           if isempty(obj.MTM)
               obj.NAV = obj.Cash;
           else
               obj.NAV = sum(obj.MTM) + obj.Cash;
           end
            %/ P&L Calculation
            
           
            obj.NAVHistory(1,end+1) = obj.NAV;
            %/ Weight Calculation
            obj.Weights = obj.MTM / obj.NAV;
            %/ Strategy Data
            obj.StrategyData = StrategyData;
            
            %/ Remove security with zero holdings
            Index = find(obj.Quantity == 0);
            obj.Symbols(:,Index) = [];
            obj.Quantity(:,Index) = [];
            obj.Cost(:,Index) = [];
            obj.MTM(:,Index) = [];
            obj.Weights(:,Index)  = [];
        end
        
        
        %/ Calculate portfolio PNL
        function obj = CalculatePNL(obj, MarketData)
           %/ Update current portfolio's MTM
            for i = 1:size(obj.Symbols,2)  
                obj.MTM(1,i) = MarketData.MidPrice(find(strcmp(obj.Symbols(1,i),MarketData.Symbols),1))*obj.Quantity(1,i);
            end
           
            %/ NAV Calculation
            if isempty(obj.MTM)
               obj.NAV = obj.Cash;
            else
               obj.NAV = sum(obj.MTM) + obj.Cash;
            end    
            %/ P&L Calculation
            obj.PNL = sum(obj.MTM - obj.Cost);
            obj.PNLHistory(1,end+1) = obj.PNL;
            obj.NAVHistory(1,end+1) = obj.NAV;
            %/ Weight Calculation
            obj.Weights = obj.MTM / obj.NAV;
            
        end    
            
    end
    
end

