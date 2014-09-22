require "./video"
module Blitzcrank
  class Copy
    def initialize(config)
      @config = config
    end

    def sync(video)
      system("cp #{video.original_path} #{video.local_path}")
    end
  end
end
