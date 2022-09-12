class StocksController < ApplicationController
  before_action :stocks_params, only: %i[create]
  def new
    @stock = Stock.new
  end
  def create
    if Stock.find_by(name: params[:name]).present?
      stock = Stock.find_by(name: params[:name])
      stock.amount += params[:amount]
    else
      stock = Stock.new(stocks_params)
    end

    if stock.save
      redirect_to stock_path(stock.name)
    else
      render json: stock.errors, status: 422
    end
  end

  def index
    stocks = Stock.all.order(:name)
    items = []
    stocks.each do |stock|
      if stock[:amount] != 0
        items << {stock[:name] => stock[:amount]}
      end
    end
    render json: items
    
  end

  def show
    @stock = Stock.find_by(name: params[:name])
    item = {@stock.name => @stock.amount}
    render json: item
  end

  def delete
    Stock.destroy_all
    Sale.destroy_all
  end

  private

  def stocks_params
    params.require(:stock).permit(:name, :amount)
  end
end
