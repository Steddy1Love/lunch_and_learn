require 'rails_helper'

RSpec.describe 'Learning Resources API', type: :request do
  describe 'GET /api/v1/learning_resources' do
    context 'when resources are found' do
      it 'returns learning resources for the given country' do
        allow_any_instance_of(YouTubeService).to receive(:searches).and_return({
          title: 'A Super Quick History of Laos',
          youtube_video_id: 'uw8hjVqxMXw'
        })

        allow_any_instance_of(PexelService).to receive(:searches).and_return([
          {
            alt_tag: 'standing statue and temples landmark during daytime',
            url: 'https://www.pexel.com/photo-1528181304800-259b08848526?ixid=MnwzNzg2NzV8MHwxfHNlYXJjaHwxfHx0aGFpbGFuZHxlbnwwfHx8fDE2Njc4Njk1NTA&ixlib=rb-4.0.3'
          },
          {
            alt_tag: 'five brown wooden boats',
            url: 'https://www.pexel.com/photo-1552465011-b4e21bf6e79a?ixid=MnwzNzg2NzV8MHwxfHNlYXJjaHwyfHx0aGFpbGFuZHxlbnwwfHx8fDE2Njc4Njk1NTA&ixlib=rb-4.0.3'
          }
        ])

        get '/api/v1/learning_resources', params: { country: 'laos' }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data][:attributes][:country]).to eq('laos')
        expect(json[:data][:attributes][:video][:title]).to eq('A Super Quick History of Laos')
        expect(json[:data][:attributes][:images].length).to eq(2)
      end
    end

    context 'when no resources are found' do
      it 'returns empty video and images' do
        allow_any_instance_of(YouTubeService).to receive(:searches).and_return(nil)
        allow_any_instance_of(PexelService).to receive(:searches).and_return([])

        get '/api/v1/learning_resources', params: { country: 'unknown' }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data][:attributes][:country]).to eq('unknown')
        expect(json[:data][:attributes][:video]).to eq({})
        expect(json[:data][:attributes][:images]).to eq([])
      end
    end
  end
end