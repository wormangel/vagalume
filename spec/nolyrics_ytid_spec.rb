#encoding: utf-8

require "spec_helper"

describe Vagalume do

  it "returns result with no lyrics" do
    result = Vagalume.find(art: "Metallica", mus: "Fuel", nolyrics: true)
    result.song.lyric.should == nil
  end

  it "returns result with youtube id" do
    result = Vagalume.find(art: "Metallica", mus: "Fuel", ytid: true)
    result.song.youtube_id.should == "MDBLhdSy5t4"
  end

  it "returns exact song via id" do
    result = Vagalume.find(musid: "3ade68b6g050deda3")
    result.song.name = "Fuel"
  end

end