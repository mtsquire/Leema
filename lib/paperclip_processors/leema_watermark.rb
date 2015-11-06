module Paperclip
  class LeemaWatermark < Processor
    def make
      src = @file
      basename = File.basename(file.path, File.extname(file.path))
      dst_format = options[:format] ? ".\#{options[:format]}" : ''

      dst = Tempfile.new([basename, dst_format])
      dst.binmode
      parameters = '-geometry +650+580 -compose "Over" :watermark :source :dest'
      begin
        success = Paperclip.run("composite", parameters,
                    :watermark => File.expand_path("#{Rails.root}/app/assets/images/leema-ship.png"),
                    :source => File.expand_path(src.path),
                    :dest => File.expand_path(dst.path))

      rescue Cocaine::CommandLineError
        raise PaperclipError, "There was an command line error with imagemagick's composite command for #{basename}" if @whiny
      rescue Cocaine::ExitStatusError => e
        raise PaperclipError, "There was an error processing the watermark for #{basename}" if @whiny
      rescue Cocaine::CommandNotFoundError => e
        raise Paperclip::CommandNotFoundError.new("Could not run the `convert` command. Please install imagemagick.")
      end
      dst
    end
  end
end