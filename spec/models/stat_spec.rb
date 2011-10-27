require 'spec_helper'

describe Stat do

  describe ".convert_incs_to_json" do
    let(:second) { 12345678 }
    before(:each) { @json = Stat.convert_incs_to_json(incs, second) }

    context "load event with 2 video loaded" do
      let(:incs) { {
        site: { t: 'site1234', inc: { "pv.m" => 1, "bp.saf-osx" => 1, "md.h.d" => 1, "md.f.d" => 1 } },
        videos: [
          { st: 'site1234', u: 'abcd1234', inc: { "vl.m" => 1, "bp.saf-osx" => 1, "md.h.d" => 1 } },
          { st: 'site1234', u: 'efgh5678', inc: { "vl.m" => 1, "bp.saf-osx" => 1, "md.f.d" => 1 } }
        ]
      } }

      specify { @json.should eql(
        site: { id: 12345678, pv: 1, bp: { 'saf-osx' => 1 }, md: { 'h' => { 'd' => 1 }, 'f' => { 'd' => 1 } } },
        videos: [
          { id: 12345678, u: 'abcd1234', vl: 1, bp: { 'saf-osx' => 1 }, md: { 'h' => { 'd' => 1 } } },
          { id: 12345678, u: 'efgh5678', vl: 1, bp: { 'saf-osx' => 1 }, md: { 'f' => { 'd' => 1 } } }
        ]
      ) }
    end

    context "load event with empty video loaded" do
      let(:incs) { {
        site: { t: 'site1234', inc: { "pv.e" => 1, "bp.saf-osx" => 1, "md.h.d" => 1 } },
        videos: []
      } }

      specify { @json.should eql(
        site: { id: 12345678, pv: 1, bp: { 'saf-osx' => 1 }, md: { 'h' => { 'd' => 1 } } },
        videos: []
      ) }
    end

    context "view event" do
      let(:incs) { {
        site: { t: 'site1234', inc: { "vv.m" => 1 } },
        videos: [
          { st: 'site1234', u: 'abcd1234', n: 'My Video', inc: { "vv.m" => 1, "vs.source12" => 1 } }
        ]
      } }

      specify { @json.should eql(
        site: { id: 12345678, vv: 1 },
        videos: [
          { id: 12345678, u: 'abcd1234', n: 'My Video', vv: 1, vs: { 'source12' => 1 } },
        ]
      ) }
    end
  end

end
