require 'spec_helper'

describe Rack::Static do

  let(:root) { File.expand_path("../../../fixtures", __FILE__) }
  let(:request) { Rack::MockRequest.new(Rack::Lint.new(Rack::Static.new(nil, urls: ['/'], root: root))) }

  it "renders gzipped content" do
    res = request.get('/i_can_has_gzip.html', 'HTTP_ACCEPT_ENCODING' => 'gzip')
    expect(res.status).to eq 200
    expect(Zlib::GzipReader.new(StringIO.new(res.body)).read).to eq "I can has gzip!\n"
    expect(res.headers['Content-Encoding']).to eq 'gzip'
    expect(res.headers['Vary']).to eq 'Accept-Encoding'
    expect(res.headers['Content-Length']).to eq File.size(File.join(root, "i_can_has_gzip.html.gz")).to_s
  end

end
