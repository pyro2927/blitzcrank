require './lib/blitzcrank.rb'

describe Blitzcrank, 'nice_tv_name' do
  let(:tv_file_names) {['The.League.S03E03.720p.HDTV.x264-IMMERSE.mkv',
                     'doctor_who_2005.8x05.time_heist.720p_hdtv_x264-fov.mkv']}
  let(:tv_show_names) {['The League',
                     'Doctor Who (2005)']}
  it "correctly parses file names into TV show names" do
    tv_file_names.each_with_index do |file_name, i|
      expect(Blitzcrank.nice_tv_name(file_name)).to eql(tv_show_names[i])
    end
  end
end
