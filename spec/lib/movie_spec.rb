require './lib/blitzcrank.rb'

module Blitzcrank
  describe Movie do
    let(:movie_file_names) {['Minority.Report.2002.720p.BluRay.DTS.x264-HiDt.mkv',
                             'Army.Of.Darkness.1992.Bluray.1080p.DTSMA.x264.mkv']}
    let(:movies) { movie_file_names.map {|f| Movie.new f } }

    before(:all) do
      Blitzcrank.config.update(base_movie_dir: 'Movies/')
    end

    it "correctly detects movies" do
      movies.each do |video|
        expect(video.is_movie?).to eq(true)
        expect(video.is_tv_show?).to eq(false)
      end
    end

    it "correctly gets the local path for a movie" do
      movies.each_with_index do |video, i|
        expect(video.local_path).to eql("Movies/#{movie_file_names[i]}")
      end
    end

  end
end
