module CarrierWave
  module TexProcessor
    extend ActiveSupport::Concern

    module ClassMethods
      def convert(format)
        process convert: format
      end
    end

    def convert(format)
      processors = {
        pdf: DocumentPdfProcessor.new
      }

      processors[format].process!(current_path) { |tmpdir|
        model.upload.file.copy_to tmpdir
        prepare_bundle!(tmpdir) if model.bundle?
      }

      @format = format
    end

    private

    def prepare_bundle!(dir)
      zip = Zip::File.open current_path

      zip.find_all.each { |f|
        f.extract "#{dir}/#{f.name}"
      }
    end
  end
end
