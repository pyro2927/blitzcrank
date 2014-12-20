module Blitzcrank
  class Rsync < Copy
    def self.sync(video)
      system("rsync -avz #{ '--bwlimit=' + Blitzcrank.config.bwlimit if Blitzcrank.config.respond_to?(:bwlimit) } --progress --rsh='ssh' \"#{Blitzcrank.config.remote_user}@#{Blitzcrank.config.remote_host}:#{Blitzcrank.config.remote_base_dir}#{video.remote_path.gsub(' ', '\\ ')}\" \"#{video.local_path}\"")
    end
  end
end
