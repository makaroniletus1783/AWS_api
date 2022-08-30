class StocksController < ApplicationController
  before_action :stocks_params, only: %i[create]
  def new
    @stock = Stock.new
  end
  def create
    stock = Stock.new(stocks_params)
    if stock.save
      render json: stock
    else
      render json: stock.errors, status: 422
    end
  end

  def show
    @stock = Stock.find_by(name: params[:name])
    render json: @stock
  end

  private

  def stocks_params
    params.require(:stock).permit(:name, :amount)
  end
end
