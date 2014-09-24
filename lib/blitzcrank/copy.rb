module Blitzcrank
  class Copy
    def self.sync(video)
      system("cp #{video.remote_path} #{video.local_path}")
    end
  end
end
