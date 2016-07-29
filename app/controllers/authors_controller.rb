class AuthorsController < ApplicationController

  def index
    authors = orchestrate_query(Author.all)
    render serialize(authors)
  end

  def show
    render serialize(author)
  end

  private

  def author
    @author ||= params[:id] ? Author.find_by!(id: params[:id]) : Author.new(author_params)
  end

  alias_method :resource, :author

  def author_params
    params.require(:data).permit(:given_name, :family_name)
  end
end