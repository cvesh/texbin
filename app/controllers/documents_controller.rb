class DocumentsController < ApplicationController
  rescue_from DocumentProcessor::Error, with: :handle_tex_error
  rescue_from Timeout::Error,           with: :handle_timeout_error

  def save
    @new_doc = Document.new upload: params[:file]

    if @new_doc.save
      flash[:created] = @new_doc._id
      redirect_to root_path
    else
      flash[:error] = "#{@new_doc.errors[:upload].first}"
      redirect_to root_path
    end
  end

  def index
    redirect_to document.upload_url, status: :moved_permanently
  end

  private

  def document
    @document ||= Document.find params[:id]
  end

  def handle_timeout_error(err)
    @error = err
    render "errors/timeout", formats: [:html], content_type: "text/html", status: :request_timeout
  end

  def handle_tex_error(err)
    @error = err
    render "errors/tex_process", formats: [:html], content_type: "text/html", status: :unprocessable_entity
  end
end
