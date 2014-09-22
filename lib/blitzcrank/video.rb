require "imdb"
class Video

  TV_SHOW_REGEX = /(.*)\.s?(\d{1,2})[ex](\d{2})/i # Supports s01e01, 1x03
  MOVIE_REGEX = /^(.*).(\d{4}|dvdrip)/i

  def initialize(file_name)
    @file_name = file_name
  end

  def file_name
    @file_name
  end

  def original_path
  end

  def local_path
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
    TV_SHOW_REGEX.match(@file_name).nil? == false
  end

  # pulls the season number froma  file
  def season
    TV_SHOW_REGEX.match(@file_name)
    $2.gsub(/\A0+/, '')
  end

  # movie methods
  def is_movie?
    if is_tv_show?
      return false
    elsif MOVIE_REGEX.match(@file_name).nil? == false
      movie_name = $1
      nice_movie_name = movie_name.gsub('.', ' ').downcase
      i = Imdb::Search.new(nice_movie_name)
      i.movies.size > 0
    else
      false
    end
  end

end
