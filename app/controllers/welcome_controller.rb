class WelcomeController < ApplicationController

  def index
    id = flash[:created]
    @doc_url = document_url(id: id) if id
  end
end
