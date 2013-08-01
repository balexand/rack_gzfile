require 'spec_helper'

describe Rack::GzFile do

  let(:root) { File.expand_path("../../../fixtures", __FILE__) }
  let(:request) { Rack::MockRequest.new(Rack::Lint.new(Rack::GzFile.new(root))) }

  describe "#call" do

    context "non-gzipped file requested" do

      it "renders non-gzipped file" do
        res = request.get('/i_can_has_gzip.html')
        expect(res.status).to eq 200
        expect(res.body).to eq "I can has gzip!\n"
        expect(res.headers.key?('Content-Encoding')).to eq false
        expect(res.headers['Vary']).to eq 'Accept-Encoding'
        expect(res.headers['Content-Length']).to eq "I can has gzip!\n".size.to_s
      end

    end

    context "gzipped file requested" do

      it "renders gzipped file if it exists" do
        res = request.get('/i_can_has_gzip.html', 'HTTP_ACCEPT_ENCODING' => 'gzip')
        expect(res.status).to eq 200
        expect(Zlib::GzipReader.new(StringIO.new(res.body)).read).to eq "I can has gzip!\n"
        expect(res.headers['Content-Encoding']).to eq 'gzip'
        expect(res.headers['Vary']).to eq 'Accept-Encoding'
        expect(res.headers['Content-Length']).to eq File.size(File.join(root, "i_can_has_gzip.html.gz")).to_s
      end

      it "renders non-gzipped file if gzipped file not present" do
        res = request.get('/foo.html', 'HTTP_ACCEPT_ENCODING' => 'gzip')
        expect(res.status).to eq 200
        expect(res.body).to eq "I can't has gzip!\n"
        expect(res.headers.key?('Content-Encoding')).to eq false
        expect(res.headers['Vary']).to eq 'Accept-Encoding'
        expect(res.headers['Content-Length']).to eq "I can't has gzip!\n".size.to_s
      end

      it "renders passes 304 response for gzipped file without updating headers" do
        date = Time.new(2012,12,25)
        File.utime date, date, File.join(root, "i_can_has_gzip.html.gz")
        res = request.get('/i_can_has_gzip.html', 'HTTP_ACCEPT_ENCODING' => 'gzip', 'HTTP_IF_MODIFIED_SINCE' => date.httpdate)

        expect(res.status).to eq 304
        expect(res.body).to eq ""
        expect(res.headers.key?('Content-Encoding')).to eq false
        expect(res.headers['Vary']).to eq 'Accept-Encoding'
        expect(res.headers.key?('Content-Length')).to eq false
      end

      it "renders normal file if arbitrary status is returned for gzipped file" do
        Rack::File.any_instance.stub(:call) do |env|
          case env['PATH_INFO']
          when "/i_can_has_gzip.html.gz"
            [500, {}, ["Something went wrong"]]
          else
            [200, {"Content-Type" => "text/plain"}, ["Got the non-gzipped version"]]
          end
        end

        res = request.get('/i_can_has_gzip.html', 'HTTP_ACCEPT_ENCODING' => 'gzip')
        expect(res.status).to eq 200
        expect(res.body).to eq "Got the non-gzipped version"
        expect(res.headers.key?('Content-Encoding')).to eq false
        expect(res.headers['Vary']).to eq 'Accept-Encoding'
        expect(res.headers['Content-Length']).to eq "Got the non-gzipped version".size.to_s
      end

    end

  end

end
