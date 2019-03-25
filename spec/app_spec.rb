require File.expand_path('spec_helper.rb', __dir__)
RSpec.describe FileControl do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe '#endpoints' do
    it '#/files/:tags/:page should return ' do
      get '/api/v1/files/+Tag2+Tag3-Tag4/1' do
        expect(last_response).to be_ok
      end
    end
    it '#/file with valid json' do
      post '/api/v1/file', '{"name": "File5", "tags": ["Tag3","Tag4"]}' do
        expect(last_response).to be_ok
      end
    end
    it '#/file with invalid tag character json' do
      post '/api/v1/file', '{"name": "File5", "tags": ["+Tag3","Tag4"]}' do
        expect(last_response.body).to eq('{"message":"Request may not include +, - and whitespaces"}')
      end
    end
    it '#/file with invalid json' do
      post '/api/v1/file', '{"name": "File5", "tskkkwqqwlel": [+Tag3","Tag4"]}' do
        expect(last_response.body).to eq('{"message":"Invalid JSON"}')
      end
    end
  end

  describe "AppHelpers" do
    subject do
      Class.new { include AppHelpers }
    end
    describe '.remove_filter_character' do
      it 'should remove +, - characters from tags' do
        expect(subject.new.remove_filter_character(['+Tag1','-Tag2'])).to eq(%w[Tag1 Tag2])
      end
    end
    describe '.tag_filter' do
      it 'separate tags that allow a tag to be filtered' do
        expect(subject.new.tag_filter('+Tag1-Tag2+Tag3')[:permitted_tags]).to eq(%w[Tag1 Tag3])
      end
      it 'separate tags that denni a tag to be filtered' do
        expect(subject.new.tag_filter('+Tag1-Tag2+Tag3')[:denied_tags]).to eq(%w[Tag2])
      end
    end
    describe '.invalid_tag?' do
      it 'should return true if the post body have a special character in the tag' do
        expect(subject.new.invalid_tag?({'tags' => ['+Tag1']})).to be true
      end
      it 'should return false if the post body dont have a special character in the tag' do
        expect(subject.new.invalid_tag?({'tags' => ['Tag1']})).to be false
      end
    end
  end
end
