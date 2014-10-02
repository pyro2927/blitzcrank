require './lib/blitzcrank.rb'

module Blitzcrank
  describe Copy do

    let(:video) { Video.with_path 'The.League.S03E03.720p.HDTV.x264-IMMERSE.mkv' }

    it "copies video files" do
      allow(Copy).to receive(:system).and_return(0)
      Copy.sync(video)
      expect(Copy).to have_received(:system)
    end

  end
end
