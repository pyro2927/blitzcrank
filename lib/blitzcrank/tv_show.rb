module Blitzcrank
  class TVShow < Video

    def season_path
      Blitzcrank.config.base_tv_dir + nice_name + "/" + Blitzcrank.config.season_identifier + season
    end

    def local_path
      season_path + "/" + @file_name
    end

    def season
      TV_SHOW_REGEX.match(@file_name)
      $2.gsub(/\A0+/, '')
    end

    def is_movie?
      false
    end

    def is_tv_show?
      true
    end

  end
end
