require 'spec_helper'

describe SiteStat do

  describe ".inc_and_json" do
    before(:each) { @inc, @json = SiteStat.inc_and_json(params, user_agent) }

    let(:user_agent) { "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_1) AppleWebKit/534.48.3 (KHTML, like Gecko) Version/5.1 Safari/534.48.3" }

    context "with load event / main hostname" do
      let(:params) { { t: 'ibvjcopp', h: 'm', e: 'l', vn: 1 } }

      it { @inc.should  eql("pv.m" => 1, "bp.saf-osx" => 1) }
      it { @json.should eql("pv" => 1, "bp" => { "saf-osx" => 1 }) }
    end
    context "with video prepare event / main hostname" do
      let(:params) { { t: 'ibvjcopp', h: 'm', e: 'p', pd: 'd', pm: ['h','f'] } }

      it { @inc.should  eql("md.h.d" => 1, "md.f.d" => 1) }
      it { @json.should eql("md" => { "f" => { "d" => 1 }, "h" => { "d" => 1 }}) }
    end
    context "with video view event / main hostname" do
      let(:params) { { t: 'ibvjcopp', h: 'm', e: 's', pd: 'd', pm: 'f' } }

      it { @inc.should  eql("vv.m" => 1) }
      it { @json.should eql("vv" => 1) }
    end

  end

end