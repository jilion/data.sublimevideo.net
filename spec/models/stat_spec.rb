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

  # describe ".inc_and_json" do
  #   before(:each) { @inc = Stat.inc_and_json(params, user_agent) }
  #
  #   let(:user_agent) { "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_1) AppleWebKit/534.48.3 (KHTML, like Gecko) Version/5.1 Safari/534.48.3" }
  #
  #   context "with load event / main hostname" do
  #     let(:params) { { t: 'ibvjcopp', h: 'm', e: 'l', vn: 1 } }
  #
  #     it { @inc.should  eql("pv.m" => 1, "bp.saf-osx" => 1) }
  #     it { @json.should eql("pv" => 1, "bp" => { "saf-osx" => 1 }) }
  #   end
  #   context "with video prepare event / main hostname" do
  #     let(:params) { { t: 'ibvjcopp', h: 'm', e: 'l', po: 1, d: 'd', pm: ['h','f'] } }
  #
  #     it { @inc.should  eql("md.h.d" => 1, "md.f.d" => 1) }
  #     it { @json.should eql("md" => { "f" => { "d" => 1 }, "h" => { "d" => 1 }}) }
  #   end
  #   context "with video view event / main hostname" do
  #     let(:params) { { t: 'ibvjcopp', h: 'm', e: 's', d: 'd', pm: 'f' } }
  #
  #     it { @inc.should  eql("vv.m" => 1) }
  #     it { @json.should eql("vv" => 1) }
  #   end
  #
  # end

end