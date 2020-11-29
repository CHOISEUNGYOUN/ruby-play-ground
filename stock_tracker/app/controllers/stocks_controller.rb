class StocksController < ApplicationController
  before_action :set_keyword
  before_action :blank?

  def search
    @stock = Stock.new_lookup(params[:stock])
    if @stock.present?
      respond_to do |format|
        format.js { render partial: "users/result" }
      end
    else
      respond_to do |format|
        flash.now[:alert] = "Please enter a valid symbol to search"
        format.js { render partial: "users/result" }
      end
    end
  end

  private

  def set_keyword
    @keyword = params[:stock].presence || nil
  end

  def blank?
    if @keyword.blank?
      respond_to do |format|
        flash.now[:alert] = "Please enter a symbol to search"
        format.js { render partial: "users/result" }
      end
    end
  end
end
