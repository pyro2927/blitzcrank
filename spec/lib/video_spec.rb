require './lib/blitzcrank.rb'

describe Video do
  let(:tv_file_names) {['The.League.S03E03.720p.HDTV.x264-IMMERSE.mkv',
                     'doctor_who_2005.8x05.time_heist.720p_hdtv_x264-fov.mkv']}
  let(:tv_show_names) {['The League',
                     'Doctor Who (2005)']}
  let(:tv_show_seasons) {['3',
                          '8']}
  let(:movie_file_names) {['Minority.Report.2002.720p.BluRay.DTS.x264-HiDt.mkv',
                           'Army.Of.Darkness.1992.Bluray.1080p.DTSMA.x264.mkv']}
  let(:tv_shows) { tv_file_names.map {|f| Video.new f } }
  let(:movies) { movie_file_names.map {|f| Video.new f } }

  it "correctly detects TV shows" do
    tv_shows.each do |video|
      expect(video.is_tv_show?).to eq(true)
      expect(video.is_movie?).to eq(false)
    end
  end

  it "correctly detects movies" do
    movies.each do |video|
      expect(video.is_movie?).to eq(true)
      expect(video.is_tv_show?).to eq(false)
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

end
