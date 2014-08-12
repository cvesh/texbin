# -*- coding: utf-8 -*-

class Document
  include Mongoid::Document

  # Uploaded file added to attr_accessible to avoid mass assignment problems
  mount_uploader  :upload, DocumentUploader

  validates :upload, presence: true
  validate  :upload_file_size, if: :upload?
  validate  :bundle_structure, if: :bundle?

  after_validation :remove_invalid_document_upload

  def article?
    upload.file && !!(File.basename(upload.file.path) =~ /\.tex$/)
  end

  # Bundles are not supported yet. I'll get back to this sometime

  def bundle?
    upload.file && !!(File.basename(upload.file.path) =~ /\.zip$/)
  end

  private

  def upload_file_size
    return unless upload.file

    limit = Rails.configuration.file_size_limit

    errors.add(:upload, "is too big") if
      upload.file.size > limit
  end

  def bundle_structure
    return unless upload.file

    begin
      zip = Zip::File.open upload.file.path

      # Look for the main .tex file
      article = zip.find_entry "article.tex"

      errors.add(:upload, "is not a valid bundle") if
        article == nil
    rescue Zip::ZipError
      errors.add :upload, "is not a valid ZIP file"
    end
  end

  def remove_invalid_document_upload
    remove_upload! if errors.present?
  end
end
