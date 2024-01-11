class Api::SearchesController < ApplicationController
  before_action :set_search, only: %i[show update]

  def index
    @searches = Search.order(created_at: :desc)
    render json: @searches
  end

  def show
    render json: @search
  end

  def create
    @search = Search.new(search_params)

    searches_with_same_ip = Search.where(ip_address: @search.ip_address)

    filtered_searches = filter_non_subsets(searches_with_same_ip.pluck(:query)) + [@search.query]

    searches_with_same_ip.destroy_all

    filtered_searches.each do |filtered_query|
      Search.create(query: filtered_query, ip_address: @search.ip_address)
    end

    updated_searches = Search.order(created_at: :desc)
    render json: updated_searches
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def update
    if @search.update(search_params)
      render json: @search
    else
      render json: @search.errors, status: :unprocessable_entity
    end
  end

  private

  def filter_non_subsets(searches)
    result = []

    searches.each_with_index do |query, i|
      is_subset = false

      searches.each_with_index do |other_query, j|
        next if i == j

        if other_query.include?(query)
          is_subset = true
          break
        end
      end

      result.push(query) unless is_subset
    end

    result
  end

  def set_search
    @search = Search.find(params[:id])
  end

  def search_params
    params.require(:search).permit(:query, :ip_address)
  end 
end
