require 'spec_helper'

module Chargify2
  describe ProductFamilyResource do
    it "should have a path of 'product_families'" do
      described_class.path.should == 'product_families'
    end

    it "represents with the ProductFamily class" do
      described_class.representation.should == ProductFamily
    end

    context 'without an instance configured with a client' do
      describe '.read' do
        it "performs a GET request to 'https://api.chargify.com/api/v2/product_families/123' (without authentication) when called with '123'" do
          WebMock.stub_request(:get, 'https://api.chargify.com/api/v2/product_families/123')
          described_class.read('123')
          a_request(:get, 'https://api.chargify.com/api/v2/product_families/123').should have_been_made.once
        end

        it "returns a Response object with a ProductFamily representation" do
          WebMock.stub_request(:get, 'https://api.chargify.com/api/v2/product_families/123')
          described_class.read('123').should be_a(Response)
          described_class.read('123').resource.should be_a(ProductFamily)
        end
      end

      describe '.list' do
        it "performs a GET request to 'https://api.chargify.com/api/v2/product_families' (without authentication)" do
          WebMock.stub_request(:get, 'https://api.chargify.com/api/v2/product_families')
          described_class.list
          a_request(:get, 'https://api.chargify.com/api/v2/product_families').should have_been_made.once
        end
      end
    end

    context 'with an instance configured with a client' do
      let(:client) { Client.new(valid_client_credentials) }
      let!(:resource) { described_class.new(client) }

      describe '#read' do
        it "performs a GET request to the authenticated product_families/:id endpoint" do
          WebMock.stub_request(:get, client_authenticated_uri(client, '/product_families/123'))
          resource.read('123')
          a_request(:get, client_authenticated_uri(client, '/product_families/123')).should have_been_made.once
        end

        it "returns a Response with a ProductFamily representation" do
          WebMock.stub_request(:get, client_authenticated_uri(client, '/product_families/123'))
          resource.read('123').should be_a(Response)
          resource.read('123').resource.should be_a(ProductFamily)
        end
      end

      describe '#list' do
        it "performs a GET request to the authenticated product_families endpoint" do
          WebMock.stub_request(:get, client_authenticated_uri(client, '/product_families'))
          resource.list
          a_request(:get, client_authenticated_uri(client, '/product_families')).should have_been_made.once
        end

        it "returns an array of ProductFamily representations" do
          WebMock.stub_request(:get, client_authenticated_uri(client, '/product_families'))
          expect(resource.list.resource).to all(be_a(ProductFamily))
        end
      end
    end

    def client_authenticated_uri(client, path)
      uri = URI(client.base_uri)
      uri.user = client.api_id
      uri.password = client.api_password
      uri.to_s + path
    end
  end
end
