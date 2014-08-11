require 'fileutils'

class DocumentProcessor

  def process!(input_filename, &block)
    content = nil

    Dir.mktmpdir { |dir|

      # The caller uses a block to add all required files to the
      # temporary directory before it can be processed
      block.call(dir) if block_given?

      # Delegates the building logic to a template method
      output_file = process_document! dir, input_filename

      # Moves output file to the final location
      FileUtils.mv "#{dir}/#{output_file}", input_filename
    }

    content
  end

  def run_command(chdir, cmd, log_file=nil)

    # Do not leak TeX stdout to our app
    _, pipe_out = IO.pipe

    pid = spawn({}, *cmd, chdir: chdir, out: pipe_out)

    begin
      Timeout.timeout(Rails.configuration.process_timeout) {
        Process.waitpid2(pid)
        pipe_out.close

        log = log_file ? File.new("#{chdir}/#{log_file}", "r").read : "TeX error"
        raise Error.new(log) if $?.exitstatus != 0
      }
    rescue Timeout::Error
      Process.kill("KILL", pid)
      raise Timeout::Error.new("Process timeout")
    end
  end

  def process_document!(dir)
    # Should be implemented by the subclasses
  end

  class Error < StandardError;end
end
