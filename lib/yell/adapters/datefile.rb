# encoding: utf-8

module Yell #:nodoc:
  module Adapters #:nodoc:

    # The +Datefile+ adapter is similar to the +File+ adapter. However, it
    # rotates the file at midnight.
    class Datefile < Yell::Adapters::File

      # The default date pattern, e.g. "19820114" (14 Jan 1982)
      DefaultDatePattern = "%Y%m%d"

      setup do |options|
        @date_pattern = options[:date_pattern] || DefaultDatePattern

        @file_basename = options[:filename] || default_filename
        options[:filename] = @file_basename

        @date = nil # default; do not override --R
      end

      write do |event|
        close if close?
      end

      close do
        @filename = @file_basename.sub( /(\.\w+)?$/, ".#{@date}\\1" )
      end


      private

      # Determines whether to close the file handle or not.
      #
      # It is based on the `:date_pattern` (can be passed as option upon initialize). 
      # If the current time hits the pattern, it closes the file stream.
      #
      # @return [Boolean] true or false
      def close?
        _date = Time.now.strftime( @date_pattern )
        if !@stream or _date != @date
          @date = _date
          return true
        end

        false
      end

    end

    register( :datefile, Yell::Adapters::Datefile )

  end
end
