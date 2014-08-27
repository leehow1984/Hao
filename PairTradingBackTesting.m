
%% Trading Set Up: trading parameter and trading portfolio  
lookback = 250;
lookfwd = 20;
portfolio = Portfolio(10000);
portfolio.Direction = 0;

%% main testing loop
for i = lookback+2:size(Data,1)
    %1. generate market data  
    NewMarketData = MarketData(datenum(Data(i,1)),transpose(Data(1,2:end)), transpose(cell2mat(Data(i,2:end))),transpose(cell2mat(Data(i,2:end))));
    %2. Generate historical training data     
    TrainingData = PairTradingData(datenum(Data(i-lookback:i-1)),...
                                   cell2mat((Data(i-lookback:i-1,3))),... %y bid
                                   cell2mat((Data(i-lookback:i-1,3))),... %y ask
                                   cell2mat((Data(i-lookback:i-1,4))),... %x bid
                                   cell2mat((Data(i-lookback:i-1,4))),... %x ask
                                   Data(1,3),... %y symbol
                                   Data(1,4),... %x symbol
                                   'Historical');
    %3. Feed data into Trading Strategy to generate trading signal 
        %/ construct strategy obj
        Strategy = PairTradingStrategy(TrainingData,0,3);
        %/ use strategy to generate trading signal 
        [Signal,YWeight,XWeight] = Strategy.M1MACD(NewMarketData, portfolio);
    %4. Check Signal & place orders accordingly

         if Signal ~= 0
           % build paramters 
           Symbol =  transpose([Data(1,3); transpose(Data(1,4))]);
           OrderType = cell(1,size(Symbol,2)); 
           OrderType(1,:) = {'MarketOrder'};
           Quantity = [YWeight XWeight];
           YSignal = Signal;
           XSignal = zeros(1,size(XWeight,2));
           XSignal(1,:) = -Signal;
           Direction = [YSignal XSignal] ;
           [YCurrentPrice,~,~] = NewMarketData.FindCurrentPrice(Data(1,3));
           [XCurrentPrice,~,~] = NewMarketData.FindCurrentPrice(Data(1,4));
           OrderPrice = [YCurrentPrice XCurrentPrice];

           %/ create order object(execute the order)
           PairTradingOrder = Order(Symbol,OrderType,Quantity,Direction, OrderPrice, NewMarketData);
           %/ add position to current portfolio 
           portfolio = portfolio.AddToPortfolio(PairTradingOrder.Symbol,PairTradingOrder.Quantity,...
                       PairTradingOrder.ExecuteSetteledPrice,NewMarketData,PairTradingOrder.Direction(1,1));
        else
           %/ if no new signal then just calculate p&l 
           portfolio = portfolio.CalculatePNL(NewMarketData);
        end
        
        
        
        
        
        
end