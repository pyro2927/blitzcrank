require "blitzcrank/version.rb"
require "./lib/blitzcrank/video.rb"
Dir['./lib/blitzcrank/*.rb'].each {|f| require f }
require "colorize"
require "configurable"
require "yaml"

module Blitzcrank
  include Configurable

  # Configuration defaults
  configurable_options :base_tv_dir => "",
                       :base_movie_dir => "",
                       :season_identifier => "Season ",
                       :remote_host => "localhost" ,
                       :remote_user => %x[whoami],
                       :remote_base_dir => "~/",
                       :dry_run => false

  def self.configure_with(yaml_path)
    begin
      Blitzcrank.config.update(YAML.load(IO.read(yaml_path)))
    rescue Errno::ENOENT
      log(:warning, "YAML configuration file couldn't be found. Using defaults."); return
    rescue Psych::SyntaxError
      log(:warning, "YAML configuration file contains invalid syntax. Using defaults."); return
    end
  end

  def self.write_sample_config(yaml_path)
    IO.write(yaml_path, Blitzcrank.config.to_yaml)
  end

  def self.transfer_file(remote_path, local_dir)
    puts "Copying #{remote_path} to #{local_dir}"
    if !Blitzcrank.config.dry_run
      system("rsync -avz #{ '--bwlimit=' + Blitzcrank.config.bwlimit unless Blitzcrank.config.bwlimit.nil? } --progress --rsh='ssh' \"#{Blitzcrank.config.remote_user}@#{Blitzcrank.config.remote_host}:#{Blitzcrank.config.remote_base_dir}#{remote_path.gsub(' ', '\\ ')}\" \"#{local_dir}\"")
    end
  end

  # get a listing of all remote files that would be considered "videos"
  def self.remote_video_file_list
    %x[ssh -q #{Blitzcrank.config.remote_user}@#{Blitzcrank.config.remote_host} "cd #{Blitzcrank.config.remote_base_dir} && find . -type f \\( -iname \'*.avi\' -or -iname \'*.mkv\' -or -iname \'*.mp4\' -or -iname \'*.m4v\' -or -iname \'*.divx\' \\)"]
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

  # copies all files if they find a matching local directory
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
    Dir.chdir(Blitzcrank.config.base_tv_dir)

    filesToTransfer.each do |dh|
      Dir.chdir(Blitzcrank.config.base_tv_dir)
      full_path = dh[:path]
      file_name = dh[:name]
      video = Video.with_path file_name
      directories = Dir.glob(video.nice_name, File::FNM_CASEFOLD)
      if directories.count > 0 && video.is_tv_show?
        nice_name = directories.first
        season_dir = "#{Dir.pwd}/#{nice_name}/#{Blitzcrank.config.season_identifier}#{video.season}"
        Dir.mkdir(season_dir) unless Dir.exists?(season_dir) # make the folder if it doesn't exist
        Blitzcrank.transfer_file(full_path, season_dir)
      elsif video.is_movie?
        Blitzcrank.transfer_file(full_path, Blitzcrank.config.base_movie_dir)
      end
    end
  end

  # runs the interactive transfer menu, returns an array of files to download
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
