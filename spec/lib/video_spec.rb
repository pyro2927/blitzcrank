require './lib/blitzcrank.rb'

module Blitzcrank
  describe Video do
    let(:movie_file_names) {['Minority.Report.2002.720p.BluRay.DTS.x264-HiDt.mkv',
                             'Army.Of.Darkness.1992.Bluray.1080p.DTSMA.x264.mkv']}
    let(:movies) { movie_file_names.map {|f| Video.with_path f } }

    it "correctly creates movies" do
      movies.each do |video|
        expect(video.class).to eq(Movie)
      end
    end

  end
end
