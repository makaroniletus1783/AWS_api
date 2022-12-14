class SalesController < ApplicationController
  #require 'bigdecimal'
  before_action :check_value, only: [:create]


  def create
    if !Stock.find_by(name: params[:name]).present?
      render plain: "在庫に存在しません"
    elsif  params[:amount] > Stock.find_by(name: params[:name]).amount
      render plain: "在庫数が足りません"
    else
      #if Sale.find_by(name: params[:name]).present?
      #sale = Sale.find_by(name: params[:name])
      #sale.amount += params[:amount]
      #sale.price = params[:price]
      #else
      sale = Sale.new(sales_params)
      #end

    stock = Stock.find_by(name: params[:name])
    stock.amount += -params[:amount]

      if sale.save && stock.save
        redirect_to sale_path(sale.name)
      else
        render json: sale.errors, status: 422
      end
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

  def sales_params
    params.require(:sale).permit(:name, :amount, :price)
  end
end
