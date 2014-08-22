
%% Trading Set Up: trading parameter and trading portfolio  
lookback = 250;
lookfwd = 20;
portfolio = Portfolio(10000);



%% main testing loop
for i = lookback+2:size(Data,1)
    %1. generate market data  
    NewMarketData = MarketData(datenum(Data(i,1)),transpose(Data(1,:)), transpose(cell2mat(Data(i,2:end))),transpose(cell2mat(Data(i,2:end))));
    %2. Generate historical training data     
    TrainingData = PairTradingData(datenum(Data(i-lookback:i-1)), transpose(cell2mat(Data(i,2))),transpose(cell2mat(Data(i,2))),transpose(cell2mat(Data(i,3:end))), transpose(cell2mat(Data(i,3:end))),'Historical');
    %3. Feed data into Trading Strategy to generate trading signal 
    Strategy = PairTradingStrategy(TrainingData,0,3);
    


end