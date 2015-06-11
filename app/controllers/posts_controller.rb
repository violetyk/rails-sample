class PostsController < ApplicationController
  def index
    @posts = Post.limit(7).order(created_at: :desc)
  end

  def show
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to root_path
    else
      flash[:alert] = @post.errors.full_messages
      render 'new'
    end
  end

  private
  def post_params
    params.require(:post).permit(:title, :body)
  end


end
