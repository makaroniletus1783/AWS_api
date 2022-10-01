class StocksController < ApplicationController
  before_action :stocks_params, only: %i[create]
  before_action :check_value, only: [:create]
  def new
    @stock = Stock.new
  end
  def create
    if Stock.find_by(name: params[:name]).present? #在庫があるとき
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
    items = {}
    stocks.each do |stock|
      if stock.amount != 0
        items.store(stock.name, stock.amount)
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

  def check_value
    if params[:amount].present?
      if !params[:amount].is_a? Integer || params[:amount].to_i <= 0 #正の整数であるか確認
        render json: {"message" => "ERROR"}
      end
    else
      params[:amount] = 1 #amountがなければ、1にする
    end
  end

  private

  def stocks_params
    params.require(:stock).permit(:name, :amount)
  end
end
