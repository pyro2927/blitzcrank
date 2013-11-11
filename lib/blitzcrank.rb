require "blitzcrank/version"
require "colorize"
require "yaml"
require "imdb"

module Blitzcrank

  # Configuration defaults
  @config = {
              :base_tv_dir => "",
              :base_movie_dir => "",
              :season_identifier => "Season ",
              :remote_host => "localhost" ,
              :remote_user => %x[whoami],
              :remote_base_dir => "~/"
            }

  @valid_config_keys = @config.keys

  # Configure through hash
  def self.configure(opts = {})
    opts.each {|k,v| @config[k.to_sym] = v if @valid_config_keys.include? k.to_sym}
  end

  def self.configure_with(yaml_path)
    begin
      config = YAML::load(IO.read(yaml_path))
    rescue Errno::ENOENT
      log(:warning, "YAML configuration file couldn't be found. Using defaults."); return
    rescue Psych::SyntaxError
      log(:warning, "YAML configuration file contains invalid syntax. Using defaults."); return
    end

    configure(config)
  end

  def self.config
    @config
  end

  def self.write_sample_config(yaml_path)
    IO.write(yaml_path, @config.to_yaml)
  end

  def self.transfer_file(remote_path, local_dir)
    system("rsync -avz --bwlimit=2000 --progress --rsh='ssh' \"#{@config[:remote_user]}@#{@config[:remote_host]}:#{@config[:remote_base_dir]}#{remote_path.gsub(' ', '\\ ')}\" \"#{local_dir}\"")
  end

  def self.remote_video_file_list
      %x[ssh -q #{@config[:remote_user]}@#{@config[:remote_host]} "cd #{@config[:remote_base_dir]} && find . -type f \\( -iname \'*.avi\' -or -iname \'*.mkv\' -or -iname \'*.mp4\' -or -iname \'*.m4v\' -or -iname \'*.divx\' \\)"]
  end

  def self.file_menu(search_array = nil)
    #very fancy stuff, get listing of our remote files
    fileArray = Blitzcrank.remote_video_file_list.gsub('./','').split("\n")

    availableFiles = Array.new()
    if search_array.nil?
      fileArray.each do |remoteFile|
        availableFiles.push({:path => remoteFile, :name => remoteFile.split('/').last()})
      end
    else
      fileArray.each do |remoteFile|
        search_array.each do |search_text|
          unless /#{search_text.gsub(' ', '.*')}/i.match(remoteFile).nil?
            # we've found a match, store it as an option
            tempHash = {:path => remoteFile, :name => remoteFile.split('/').last()}
            unless availableFiles.include?(tempHash)
              availableFiles.push(tempHash)
            end
          end
        end
      end
    end
    availableFiles.sort_by! {|h| h[:name].downcase}

    filesToTransfer = Blitzcrank.transfer_menu(availableFiles)

    Blitzcrank.transfer_files(filesToTransfer)
  end

  def self.rsync_all_files
    puts "Downloading all remote videos\n"
    fileArray = Blitzcrank.remote_video_file_list.gsub('./','').split("\n")
    availableFiles = Array.new()
    fileArray.each do |remoteFile|
      availableFiles.push({:path => remoteFile, :name => remoteFile.split('/').last()})
    end
    Blitzcrank.transfer_files(availableFiles)
  end

  # any files (hashes) passed into here will be checked against our local TV folders and IMDB to see if it's a movie
  def self.transfer_files(filesToTransfer)
    Dir.chdir(@config[:base_tv_dir])
    tv_directories = Dir.glob("*/")

    filesToTransfer.each do |dh|
      Dir.chdir(@config[:base_tv_dir])
      full_path = dh[:path]
      file_name = dh[:name]
      nice_name = Blitzcrank.nice_tv_name(file_name)
      if Dir.exists?(nice_name) # see if we already have a directory for this tv show
        season_dir = "#{Dir.pwd}/#{nice_name}/#{@config[:season_identifier]}#{Blitzcrank.season(file_name)}"
        Dir.mkdir(season_dir) unless Dir.exists?(season_dir) # make the folder if it doesn't exist
        Blitzcrank.transfer_file(full_path, season_dir)
      elsif Blitzcrank.is_movie?(file_name)
        Blitzcrank.transfer_file(full_path, @config[:base_movie_dir])
      end
    end
  end

  def self.season(file_name)
    /s(\d{2})e\d{2}/i.match(file_name)
    $1.gsub(/\A0+/, '')
  end

  def self.nice_tv_name(file_name)
    unless /(.*).s(\d*)e(\d*)/i.match(file_name).nil?
      oldShowName = $1
      wordsInShowName = oldShowName.gsub('.', ' ').downcase.split(" ")
      wordsInShowName.each do |word|
        if wordsInShowName.index(word) == 0 || /^(in|a|the|and|on)$/i.match(word).nil?
          word.capitalize!
        end
      end
      wordsInShowName.join(" ")
    else
      file_name
    end
  end

  def self.is_movie?(file_name)
    unless /^(.*).(\d{4}|dvdrip)/i.match(file_name).nil?
      movie_name = $1
      nice_movie_name = movie_name.gsub('.', ' ').downcase
      i = Imdb::Search.new(nice_movie_name)
      i.movies.size > 0
    else
      false
    end
  end

  def self.transfer_menu(files)
    filesToTransfer = Array.new
    begin
      unless filesToTransfer.empty?
        print "Files queued for transfer:\n"
        filesToTransfer.sort_by! {|h| h[:name]}
        filesToTransfer.each do |f|
          print "* #{f[:name]}\n"
        end
        print "------------------------------------------------------------------\n"
      end

      files.each_with_index do |fh, index|
        unless filesToTransfer.include?(fh)
          line = "#{index + 1}: #{fh[:name]}\n"
          print line.light_cyan if index % 2 == 1
          print line.green if index % 2 == 0
        end
      end
      print "Which file would you like to transfer? (enter '0' when finished)\n"
      response = STDIN.gets
      print "\n"
      transfer_index = response.to_i
      if (transfer_index <= files.length && transfer_index > 0)
        filesToTransfer.push(files[transfer_index - 1])
      end
    end while transfer_index > 0 && filesToTransfer.length < files.length
    filesToTransfer
  end

end
