# frozen_string_literal: true

describe Provet::Client do
  let(:response) { JSON.parse(load_fixture('clients', 'show')) }
  let(:body) { spy }

  describe '#list' do
    let(:response) { JSON.parse(load_fixture('clients', 'index')) }

    before do
      stub_request(:get, File.join(Provet::Base.base_uri, 'client', '/'))
        .with(headers: headers)
        .to_return(
          status: 200,
          headers: { content_type: 'application/json' },
          body: response.to_json
        )
    end

    it 'sends a GET request to fetch the client list' do
      expect(described_class)
        .to receive(:get)
        .once
        .with('/client/', headers: headers, query: {})
        .and_return(response)
      expect(described_class.new.list).to eq(response)
    end
  end

  describe '#all' do
    let(:response) { JSON.parse(load_fixture('clients', 'index')) }

    it 'sends a GET request to fetch client for each page' do
      (1..2).each do |page|
        stub_request(:get, File.join(Provet::Base.base_uri, 'client', "/?page=#{page}"))
          .with(headers: headers)
          .to_return(
            status: 200,
            headers: { content_type: 'application/json' },
            body: response.to_json
          )

        expect(described_class)
          .to receive(:get)
          .once
          .with('/client/', headers: headers, query: { page: page })
          .and_return(response)
      end

      described_class.new.all
    end
  end

  describe '#find' do
    before do
      stub_request(:get, File.join(Provet::Base.base_uri, 'client', '123', '/'))
        .with(headers: headers)
        .to_return(
          status: 200,
          headers: { content_type: 'application/json' },
          body: response.to_json
        )
    end

    it 'sends a GET request to fetch the client' do
      expect(described_class)
        .to receive(:get)
        .once
        .with('/client/123/', headers: headers, query: {}).and_return(response)
      expect(described_class.new.find('123')).to eq(response)
    end
  end

  describe '#create' do
    before do
      stub_request(:post, File.join(Provet::Base.base_uri, 'client', '/'))
        .with(
          headers: headers,
          body: body.to_json
        ).to_return(
          status: 200,
          headers: { content_type: 'application/json' },
          body: response.to_json
        )
    end

    it 'sends a POST request to create an client' do
      expect(described_class)
        .to receive(:post)
        .once
        .with('/client/', headers: headers, body: body)
        .and_return(response)
      expect(described_class.new.create(body)).to eq(response)
    end
  end

  describe '#update' do
    before do
      stub_request(:put, File.join(Provet::Base.base_uri, 'client', '123', '/'))
        .with(
          headers: headers,
          body: body.to_json
        )
        .to_return(
          status: 200,
          headers: { content_type: 'application/json' },
          body: response.to_json
        )
    end

    it 'sends a PUT request to update the client' do
      expect(described_class)
        .to receive(:put)
        .once
        .with('/client/123/', headers: headers, body: body)
        .and_return(response)
      expect(described_class.new.update('123', body)).to eq(response)
    end
  end

  describe '#destroy' do
    let(:body) { { archived: 1 } }

    before do
      stub_request(:patch, File.join(Provet::Base.base_uri, 'client', '123', '/'))
        .with(
          headers: headers,
          body: body.to_json
        ).to_return(
          status: 200,
          headers: { content_type: 'application/json' },
          body: response.to_json
        )
    end

    it 'sends a PATCH request to mark the client as inactive' do
      expect(described_class)
        .to receive(:patch)
        .once
        .with('/client/123/', headers: headers, body: body.to_json)
        .and_return(response)
      expect(described_class.new.destroy('123')).to eq(response)
    end
  end

  describe '#really_destroy!' do
    before do
      stub_request(:delete, File.join(Provet::Base.base_uri, 'client', '123', '/'))
        .with(headers: headers)
        .to_return(status: 204)
    end

    it 'sends a DELETE request to erase the client' do
      expect(described_class)
        .to receive(:delete)
        .once
        .with('/client/123/', headers: headers)
      described_class.new.really_destroy!('123')
    end
  end

  describe '#restore' do
    let(:body) { { archived: 0 } }

    before do
      stub_request(:patch, File.join(Provet::Base.base_uri, 'client', '123', '/'))
        .with(
          headers: headers,
          body: body.to_json
        ).to_return(
          status: 200,
          headers: { content_type: 'application/json' },
          body: response.to_json
        )
    end

    it 'sends a PATCH request to mark the client as active' do
      expect(described_class)
        .to receive(:patch)
        .once
        .with('/client/123/', headers: headers, body: body.to_json)
        .and_return(response)
      expect(described_class.new.restore('123')).to eq(response)
    end
  end
end
