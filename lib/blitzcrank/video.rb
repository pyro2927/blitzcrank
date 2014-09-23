require "imdb"
module Blitzcrank
  class Video

    TV_SHOW_REGEX = /(.*)[\. ]s?(\d{1,2})[ex](\d{2})/i # Supports s01e01, 1x03
    MOVIE_REGEX = /^(.*).(\d{4}|dvdrip)/i

    def self.with_path(file_path)
      file_name = Video.file_name(file_path)
      if Video.is_tv_show? file_name
        return TVShow.new file_path
      elsif Video.is_movie? file_name
        return Movie.new file_path
      end
      return Video.new file_path
    end

    def self.file_name(file_path)
      file_path.split('/').last
    end

    # returns if this is a TV show or not
    def self.is_tv_show?(file_name)
      TV_SHOW_REGEX.match(file_name).nil? == false
    end

    # movie methods
    def self.is_movie?(file_name)
      if Video.is_tv_show?(file_name)
        return false
      elsif MOVIE_REGEX.match(file_name).nil? == false
        movie_name = $1
        nice_movie_name = movie_name.gsub('.', ' ').downcase
        i = Imdb::Search.new(nice_movie_name)
        i.movies.size > 0
      else
        false
      end
    end

    def initialize(file_path)
      @file_path = file_path
      @file_name = Video.file_name file_path
    end

    def remote_path
      @file_path
    end

    def file_name
      @file_name
    end

    def nice_name
      unless TV_SHOW_REGEX.match(@file_name).nil?
        showName = $1
        wordsInShowName = showName.gsub(/[\._]/, ' ').downcase.split(" ") # strip . and _
        wordsInShowName.each do |word|
          if wordsInShowName.index(word) == 0 || /^(in|a|the|and|on)$/i.match(word).nil?
            word.capitalize!
          end
        end
        wordsInShowName.join(" ").gsub(/\b(us|uk|\d{4})$/i, '(\1)') # adding parens around US/UK marked shows, or shows with years
      else
        @file_name
      end
    end

    # returns if this is a TV show or not
    def is_tv_show?
      Video.is_tv_show?(@file_name)
    end

    # movie methods
    def is_movie?
      Video.is_movie?(@file_name)
    end

  end
end
