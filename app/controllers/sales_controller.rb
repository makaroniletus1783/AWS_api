class SalesController < ApplicationController
  #require 'bigdecimal'
  before_action :check_value_sales, only: [:create]

  @@total = 0.000


  def create
    sale = Sale.new(sales_params)

    @@total += params[:price] * params[:amount] #合計金額に加算

    stock = Stock.find_by(name: params[:name])
    stock.amount += -params[:amount]

    if sale.save && stock.save
      redirect_to sale_path(sale.name)
    else
      render json: sale.errors, status: 422
    end
  end

  def show
    sales = Sale.where(name: params[:name]) #価格の変動を考慮
    items = []
    sales.each do |sale|
      items << {"name" => sale.name, "amount" => sale.amount, "price" => sale.price}
    end
    render json: items
  end

  def index
    total = @@total.ceil(2)
    total = sprintf("%0.2f", total)

    sum = {"sales" => total}

    render json: sum
  end

  def check_value_sales
    if params[:amount].present?
      if (params[:amount].to_i <= 0) || (!params[:amount].is_a? Integer) #正の整数であるか確認
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
