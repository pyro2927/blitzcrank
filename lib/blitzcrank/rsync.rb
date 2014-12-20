require "rsync"
module Blitzcrank
  class Rsync < Copy
    def self.sync(video)
      options = ["--rsh='ssh'"]
      options << '--bwlimit=' + Blitzcrank.config.bwlimit if Blitzcrank.config.respond_to?(:bwlimit)
      Rsync.run("#{Blitzcrank.config.remote_user}@#{Blitzcrank.config.remote_host}:#{Blitzcrank.config.remote_base_dir}#{video.remote_path}", video.local_path, options) do |result|
        if result.success?
          puts "File successfully transfered"
        else
          puts result.error
        end
      end
    end
  end
end
