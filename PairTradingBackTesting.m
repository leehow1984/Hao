
%% Trading Set Up: trading parameter and trading portfolio  
lookback = 250;
lookfwd = 20;
portfolio = Portfolio(100);
portfolio.Direction = 0;
tradinglog = cell(0,1);



%% main testing loop
for i = lookback+2:size(Data,1)
    %1. generate market data  
    NewMarketData = MarketData(datenum(Data(i,1)),transpose(Data(1,2:end)), transpose(cell2mat(Data(i,2:end))),transpose(cell2mat(Data(i,2:end))));
    %2. Generate historical training data     
    TrainingData = PairTradingData(datenum(Data(i-lookback:i-1)),...
                                   cell2mat((Data(i-lookback:i-1,2))),... %y bid
                                   cell2mat((Data(i-lookback:i-1,2))),... %y ask
                                   cell2mat((Data(i-lookback:i-1,5:6))),... %x bid
                                   cell2mat((Data(i-lookback:i-1,5:6))),... %x ask
                                   Data(1,2),... %y symbol
                                   Data(1,5:6),... %x symbol
                                   'Historical');
    %3. Feed data into Trading Strategy to generate trading signal 
        %/ construct strategy obj
        Strategy = PairTradingStrategy(TrainingData,0,3);
        %/ use strategy to generate trading signal 
        [Signal,YWeight,XWeight,PortfolioRetWeight, Mean, Std,ResIndex] = Strategy.M1(NewMarketData, portfolio);
    %4. Check Signal & place orders accordingly
        M1Data.PortfolioRetWeight = PortfolioRetWeight;
        M1Data.Mean = Mean;
        M1Data.Std = Std;
        M1Data.ResIndex = ResIndex;
         if Signal ~= 0
           % build paramters 
           Symbol =  transpose([Data(1,2); transpose(Data(1,5:6))]);
           OrderType = cell(1,size(Symbol,2)); 
           OrderType(1,:) = {'MarketOrder'};
           Quantity = [YWeight XWeight];
           YSignal = Signal;
           XSignal = zeros(1,size(XWeight,2));
           XSignal(1,:) = -Signal;
           Direction = [YSignal XSignal] ;
           [YCurrentPrice,~,~] = NewMarketData.FindCurrentPrice(Data(1,2));
           [XCurrentPrice,~,~] = NewMarketData.FindCurrentPrice(Data(1,5:6));
           OrderPrice = [YCurrentPrice XCurrentPrice];

           %/ create order object(execute the order)
           PairTradingOrder = Order(Symbol,OrderType,Quantity,Direction, OrderPrice, NewMarketData);
           %/ add position to current portfolio 
           
           %/ display order on screen
           for j = 1:size(Symbol,2)
               if Direction(1,j) == 1 
                  display(strcat(datestr(NewMarketData.TimeStamp),' Buy {', num2str(Quantity(1,j)),'} {',Symbol(1,j), '} @ ', num2str(OrderPrice(1,j))));
                  tradinglog(end + 1,1) = (strcat(datestr(NewMarketData.TimeStamp),' Buy {', num2str(Quantity(1,j)),'} {',Symbol(1,j), '} @ ', num2str(OrderPrice(1,j))));
               elseif Direction(1,j) == -1
                  display(strcat(datestr(NewMarketData.TimeStamp),' Sell {', num2str(Quantity(1,j)),'} {',Symbol(1,j), '} @ ', num2str(OrderPrice(1,j))));
                  tradinglog(end + 1,1) = (strcat(datestr(NewMarketData.TimeStamp),' Sell {', num2str(Quantity(1,j)),'} {',Symbol(1,j), '} @ ', num2str(OrderPrice(1,j))));
               end 
           end
           %/ calculate cost
           Cost = PairTradingOrder.ExecuteSetteledPrice .* PairTradingOrder.Quantity;
           %/ add to portfolio
           portfolio = portfolio.AddToPortfolio(PairTradingOrder.Symbol,PairTradingOrder.Quantity,...
                       Cost,NewMarketData,PairTradingOrder.Direction,M1Data);
        else
           %/ if no new signal then just calculate p&l 
           portfolio = portfolio.CalculatePNL(NewMarketData);
        end
        
        
        
end
x = 1;
