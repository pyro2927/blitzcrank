module Blitzcrank
  class Rsync < Copy
    def self.sync(video)
      command = "rsync -avz #{ '--bwlimit=' + Blitzcrank.config.bwlimit if Blitzcrank.config.respond_to?(:bwlimit) } --progress --rsh='ssh' \"#{Blitzcrank.config.remote_user}@#{Blitzcrank.config.remote_host}:#{Blitzcrank.config.remote_base_dir}#{self.escaped_string(video.remote_path)}\" \"#{video.local_path}\""
      system(command)
    end

    def self.escaped_string(string)
      string.gsub(' ', '\\ ').gsub("'", %q(\\\')).gsub("&"){'\&'}
    end
  end
end
