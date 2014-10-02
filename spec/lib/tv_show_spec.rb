require File.join(File.dirname(__FILE__), "../../lib/blitzcrank.rb")

module Blitzcrank
  describe TVShow do
    let(:tv_file_names) {['The.League.S03E03.720p.HDTV.x264-IMMERSE.mkv',
                          'doctor_who_2005.8x05.time_heist.720p_hdtv_x264-fov.mkv',
                          'Doctor Who S04E14 The Next Doctor 720p BluRay DTS5.1 x264-BG.mkv']}
    let(:tv_show_names) {['The League',
                          'Doctor Who (2005)',
                          'Doctor Who']}
    let(:tv_show_seasons) {['3',
                            '8',
                            '4']}
    let(:tv_shows) { tv_file_names.map {|f| TVShow.new f } }

    before(:all) do
      Blitzcrank.config.update(base_tv_dir: 'TV/')
    end

    it "correctly detects TV shows" do
      tv_shows.each do |video|
        expect(video.is_tv_show?).to eq(true)
        expect(video.is_movie?).to eq(false)
      end
    end

    it "correctly parses file names into TV show names" do
      tv_shows.each_with_index do |video, i|
        expect(video.nice_name).to eql(tv_show_names[i])
      end
    end

    it "correctly parses seasons from TV show file names" do
      tv_shows.each_with_index do |video, i|
        expect(video.season).to eql(tv_show_seasons[i])
      end
    end

    it "correctly gets the local path for a TV show" do
      tv_shows.each_with_index do |video, i|
        expect(video.local_path).to eql("TV/#{tv_show_names[i]}/Season #{tv_show_seasons[i]}/#{video.file_name}")
      end
    end

  end
end
