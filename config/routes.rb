Texbin::Application.routes.draw do

  scope "/docs" do

    # Processes a document given its id
    get "/:id" => "documents#index", as: "document"

    # Adds a new document
    put "/" => "documents#save", as: "put_document"
  end

  # Help
  get "/help" => "welcome#help", as: "help"

  # Home page
  root "welcome#index"
end
