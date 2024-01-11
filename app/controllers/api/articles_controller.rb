# app/controllers/api/articles_controller.rb
class Api::ArticlesController < ApplicationController
    def index
        if params[:query].present?
          @articles = Article.where("title ILIKE ? OR content ILIKE ?", "%#{params[:query]}%", "%#{params[:query]}%").order(created_at: :desc)
        else
          @articles = Article.order(created_at: :desc)
        end
        render json: @articles
      end

    def create
      @article = Article.new(article_params)
  
      if @article.save
        render json: @article, status: :created
      else
        render json: @article.errors, status: :unprocessable_entity
      end
    end
  
    private
  
    def article_params
      params.require(:article).permit(:title, :content)
    end
  end
  