require 'shellwords'

module CdExec

  # Command line interface.
  def self.cli(*argv)
    case i = argv.index('-')
    when nil
      dirs, args = argv, Dir['*']
    else
      dirs, args = argv[0...i], argv[i+1..-1]
    end

    help   = dirs.delete('-h') || dirs.delete('--help')
    trace  = dirs.delete('-t') || dirs.delete('--trace')

    display_help if help

    dirs = dirs.select{ |dir| File.directory?(dir) }

    dirs.each_with_index do |dir, idx|
      puts "\n#{idx+1}. #{dir}" if trace
      Dir.chdir dir do
        system command_line(*args)
      end
    end
  end

  # Glue the command line together, adding double quotes if argument
  # contains spaces.
  def self.command_line(*args)
    args.map do |a|
      case a
      when /\s/
        %{"#{a}"}
      else
        a
      end
    end.join(' ')
  end

  # Display help message and exit.
  def self.display_help
    system "man #{man_file}" || puts(File.read(ronn_file))
    exit 0
  end

  # Path to roff man-page file.
  def self.man_file
    File.dirname(__FILE__) + '/../man/cdexe.1'
  end

  # Path to ronn man-page file.
  def self.ronn_file
    File.dirname(__FILE__) + '/../man/cdexe.1.ronn'
  end

end
