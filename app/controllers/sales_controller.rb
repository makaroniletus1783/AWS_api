class SalesController < ApplicationController
  #require 'bigdecimal'
  before_action :check_value_sales, only: [:create]


  def create
    sale = Sale.new(sales_params)

    stock = Stock.find_by(name: params[:name])
    stock.amount += -params[:amount]

    if sale.save && stock.save
      redirect_to sale_path(sale.name)
    else
      render json: sale.errors, status: 422
    end
  end

  def show
    sale = Sale.find_by(name: params[:name])
    render json: sale.to_json(only: [:name, :amount, :price])
  end

  def index
    sales = Sale.all
    total = 0.000
    sales.each do |sale|
      if sale.price != nil
      total += sale.price * sale.amount
      end
    end

    total = total.ceil(2)
    total = sprintf("%0.2f", total)

    sum = {"sales" => total}

    render json: sum
  end

  def check_value_sales
    if params[:amount].present?
      if !params[:amount].is_a? Integer || params[:amount].to_i <= 0 #正の整数であるか確認
        render json: {"message" => "ERROR"}
      end
    else
      params[:amount] = 1 #amountがなければ、1にする
    end

    if !Stock.find_by(name: params[:name]).present? #在庫に商品が登録されていないとき
      render json: {"message" => "ERROR"}
    elsif  params[:amount] > Stock.find_by(name: params[:name]).amount #在庫に商品がないとき
      render json: {"message" => "ERROR"}
    end

  end

  private

  def sales_params
    params.require(:sale).permit(:name, :amount, :price)
  end
end
