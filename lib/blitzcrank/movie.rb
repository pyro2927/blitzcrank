module Blitzcrank
  class Movie < Video

    def local_path
      Blitzcrank.config.base_movie_dir + nice_name
    end

    def is_movie?
      true
    end

    def is_tv_show?
      false
    end

  end
end
