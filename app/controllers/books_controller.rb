class BooksController < ApplicationController

  def index
    books = orchestrate_query(Book.all)
    serializer = Bookland::Serializer.new(data: books,
                                          params: params,
                                          actions: [:fields, :embeds])
    render json: serializer.to_json
  end
end