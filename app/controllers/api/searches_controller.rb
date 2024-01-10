# app/controllers/searches_controller.rb
class Api::SearchesController < ApplicationController
  before_action :set_search, only: %i[show edit update destroy]

  def index
    @searches = Search.all
    render json: @searches
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def show
    render json: @search
  end

  def create
    @search = Search.new(search_params)

    if @search.save
      render json: @search, status: :created
    else
      render json: @search.errors, status: :unprocessable_entity
    end
  end

  private

  def set_search
    @search = Search.find(params[:id])
  end

  def search_params
    params.require(:search).permit(:query, :ip_address)
  end
end
