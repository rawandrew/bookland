class AuthorsController < ApplicationController

  def index
    authors = orchestrate_query(Author.all)
    render serialize(authors)
  end
end