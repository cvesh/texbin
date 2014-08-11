class DocumentPdfProcessor < DocumentProcessor

  def process_document!(dir, input_filename)
    basename = File.basename input_filename, ".tex"
    log_file = basename.chomp(File.extname(basename)) + ".log"

    # Convert the document directly to .pdf
    cmd = ["pdflatex"] + Rails.configuration.latex_default_options + [input_filename]
    run_command dir, cmd, log_file

    # Return the input filename with .pdf extension
    basename + ".pdf"
  end
end
