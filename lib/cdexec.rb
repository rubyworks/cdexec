module CdExec

  #
  def self.cli(*argv)
    case i = argv.index('-')
    when nil
      dirs, args = argv, Dir['*']
    else
      dirs, args = argv[0...i], argv[i+1..-1]
    end

    trace = dirs.delete('-t')

    dirs = dirs.select{ |dir| File.directory?(dir) }

    dirs.each do |dir|
      puts "cd #{dir}" if trace
      Dir.chdir dir do
        system *args
      end
    end
  end

end
