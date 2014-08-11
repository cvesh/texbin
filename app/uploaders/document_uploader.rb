# encoding: utf-8

class DocumentUploader < CarrierWave::Uploader::Base
  include CarrierWave::TexProcessor

  storage Rails.configuration.document_storage

  process convert: :pdf
  process :set_content_type

  after :remove, :delete_empty_upstream_dirs

  def cache_dir
    Rails.configuration.document_upload_cache_dir
  end

  def store_dir
    "#{base_store_dir}/#{model.id}"
  end

  def base_store_dir
    "#{Rails.configuration.document_upload_dir}/#{model.id.to_s[0, 2]}"
  end

  def filename
    super.chomp(File.extname(super)) + ".pdf" if original_filename.present?
  end

  def extension_white_list
    %w(tex)
  end

  def delete_empty_upstream_dirs
    Dir.delete ::File.expand_path(store_dir, root)
    Dir.delete ::File.expand_path(base_store_dir, root)
  rescue SystemCallError
    true # don't remove a non empty directory
  end

  def set_content_type(*args)
    self.file.instance_variable_set(:@content_type, "application/pdf")
  end
end
