class PagesController < ApplicationController
  before_filter :authorize_admin, only: [:new, :create, :index, :edit, :update, :destroy]

  def index
    @pages = Page.all
  end

  def show
    @page = Page.find_by_param(params[:id])
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, tables: true)
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(page_params)
    if @page.save
      flash[:success] = "Du opprettet en ny side."
      @page.update_attribute(:user_id, current_user.id)
      redirect_to @page
    else
      render "new"
    end
  end

  def edit
    @page = Page.find_by_param(params[:id])
  end

  def update
    @page = Page.find_by_param(params[:id])
    if @page.update_attributes(page_params)
      flash[:success] = "Du endret artikkelen."
      redirect_to @page
    else
      render 'new'
    end
  end

  def destroy
    @page = Page.find(params[:id])
    if @page.destroy
      flash[:success] = "Du slettet en artikkel"
    else
      flash[:warning] = "Noe gikk galt."
    end
    redirect_to pages_path
  end

  private
  def page_params
    params.require(:page).permit(:title, :content, :main_menu, :user_id, :front_page, :position)
  end
end
