
%% Trading Set Up: trading parameter and trading portfolio  
lookback = 200;
lookfwd = 20;
portfolio = Portfolio(100);
portfolio.Direction = 0;
tradinglog = cell(0,1);
Strategy = PairTradingStrategy(0,3,50);
Ycol = 2;
Xcol = 5:7;




%% main testing loop
for i = lookback+2:size(Data,1)
    %1. generate market data  
    NewMarketData = MarketData(datenum(Data(i,1)),transpose(Data(1,2:end)), transpose(cell2mat(Data(i,2:end))),transpose(cell2mat(Data(i,2:end))));
    %2. Generate historical training data     
    TrainingData = PairTradingData(datenum(Data(i-lookback:i-1)),...
                                   cell2mat((Data(i-lookback:i-1,Ycol))),... %y bid
                                   cell2mat((Data(i-lookback:i-1,Ycol))),... %y ask
                                   cell2mat((Data(i-lookback:i-1,Xcol))),... %x bid
                                   cell2mat((Data(i-lookback:i-1,Xcol))),... %x ask
                                   Data(1,Ycol),... %y symbol
                                   Data(1,Xcol),... %x symbol
                                   'Historical');
    %3. Feed data into Trading Strategy to generate trading signal 
        %/ feed new market data into strategy obj
        Strategy = Strategy.UpdateMarketData(TrainingData);
        %/ use strategy to generate trading signal 
        Strategy = Strategy.M1(NewMarketData, portfolio);
        
        
        %/ ****************** Display Code *************************/%
        display(strcat('Timer = ',num2str(Strategy.M1Analytics.Timer)));
        %/ ****************** Display Code *************************/%
        
    %4. Check Signal & place orders accordingly
        M1Data.PortfolioRetWeight = Strategy.M1Analytics.PortfolioRetWeight;
        M1Data.Mean = Strategy.M1Analytics.Mean;
        M1Data.Std = Strategy.M1Analytics.Std;
        M1Data.ResIndex = Strategy.M1Analytics.ResIndex;
        M1Data.Intercept = Strategy.M1Analytics.Intercept;
        if Strategy.M1Analytics.M1Signal ~= 0
           % build paramters 
           Symbol =  transpose([Data(1,Ycol); transpose(Data(1,Xcol))]);
           OrderType = cell(1,size(Symbol,2)); 
           OrderType(1,:) = {'MarketOrder'};
           Quantity = [Strategy.M1Analytics.PortfolioYweight Strategy.M1Analytics.PortfolioXWeight];
           YSignal = Strategy.M1Analytics.M1Signal;
           XSignal = zeros(1,size(Strategy.M1Analytics.PortfolioXWeight,2));
           XSignal(1,:) = -Strategy.M1Analytics.M1Signal;
           Direction = [YSignal XSignal] ;
           [YCurrentPrice,~,~] = NewMarketData.FindCurrentPrice(Data(1,Ycol));
           [XCurrentPrice,~,~] = NewMarketData.FindCurrentPrice(Data(1,Xcol));
           OrderPrice = [YCurrentPrice XCurrentPrice];

           %/ create order object(execute the order)
           PairTradingOrder = Order(Symbol,OrderType,Quantity,Direction, OrderPrice, NewMarketData);
           %/ add position to current portfolio 
           
           
           %/ ****************** Display Code *************************/%
           for j = 1:size(Symbol,2)
               if Direction(1,j) == 1 
                  display(strcat(datestr(NewMarketData.TimeStamp),' Buy {', num2str(Quantity(1,j)),'} {',Symbol(1,j), '} @ ', num2str(OrderPrice(1,j))));
                  tradinglog(end + 1,1) = (strcat(datestr(NewMarketData.TimeStamp),' Buy {', num2str(Quantity(1,j)),'} {',Symbol(1,j), '} @ ', num2str(OrderPrice(1,j))));
               elseif Direction(1,j) == -1
                  display(strcat(datestr(NewMarketData.TimeStamp),' Sell {', num2str(Quantity(1,j)),'} {',Symbol(1,j), '} @ ', num2str(OrderPrice(1,j))));
                  tradinglog(end + 1,1) = (strcat(datestr(NewMarketData.TimeStamp),' Sell {', num2str(Quantity(1,j)),'} {',Symbol(1,j), '} @ ', num2str(OrderPrice(1,j))));
               end 
           end
           %/ ****************** Display Code *************************/%
           
           %/ calculate cost
           Cost = PairTradingOrder.ExecuteSetteledPrice .* PairTradingOrder.Quantity;
           %/ add to portfolio
           portfolio = portfolio.AddToPortfolio(PairTradingOrder.Symbol,PairTradingOrder.Quantity,...
                       Cost,NewMarketData,PairTradingOrder.Direction,PairTradingOrder.ExecuteTransactionCost,M1Data);
        else
           %/ if no new signal then just calculate p&l 
           portfolio = portfolio.CalculatePNL(NewMarketData);
        end
        
        plot(portfolio.NAVHistory(2:end));
        pause(0.01)
end
x = 1;
