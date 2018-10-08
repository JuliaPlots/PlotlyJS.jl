using PlotlyJS

function ohlc1()
    t = ohlc(open=[33.0, 33.3, 33.5, 33.0, 34.1],
             high=[33.1, 33.3, 33.6, 33.2, 34.8],
             low=[32.7, 32.7, 32.8, 32.6, 32.8],
             close=[33.0, 32.9, 33.3, 33.1, 33.1])
    plot(t)
end

function ohlc2()
    # uses Quandl.jl

    function get_ohlc(ticker; kwargs...)
        df = quandlget("WIKI/$(ticker)", format="DataFrame")
        ohlc(df, x=:Date, open=:Open, high=:High, low=:Low, close=:Close; kwargs...)
    end

    p1 = plot(get_ohlc("AAPL", name="Apple"), Layout(title="Apple"))
    p2 = plot(get_ohlc("GOOG", name="Google"), Layout(title="Google"))

    [p1 p2]
end

function candlestick1()
    t = candlestick(open=[33.0, 33.3, 33.5, 33.0, 34.1],
                    high=[33.1, 33.3, 33.6, 33.2, 34.8],
                    low=[32.7, 32.7, 32.8, 32.6, 32.8],
                    close=[33.0, 32.9, 33.3, 33.1, 33.1])
    plot(t)
end

function candlestick2()
    # uses Quandl.jl

    function get_candlestick(ticker; kwargs...)
        df = quandlget("WIKI/$(ticker)", format="DataFrame")
        candlestick(df, x=:Date, open=:Open, high=:High, low=:Low, close=:Close; kwargs...)
    end

    p1 = plot(get_candlestick("AAPL", name="Apple"), Layout(title="Apple"))
    p2 = plot(get_candlestick("GOOG", name="Google"), Layout(title="Google"))

    [p1 p2]
end
