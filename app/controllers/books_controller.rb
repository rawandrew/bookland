class BooksController < ApplicationController

  def index
    books = orchestrate_query(Book.all)
    render serialize(books)
  end
end