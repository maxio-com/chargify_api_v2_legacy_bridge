require 'spec_helper'

module Chargify2
  describe Direct::ResponseParameters do
    let(:client) { Client.new(valid_client_credentials) }

    it "raises an argument error if it could not get an api_id and secret from the passed client" do
      lambda {
        Direct::SecureParameters.new({}, Hashery::OpenCascade.new)
      }.should raise_error(ArgumentError)
    end

    describe "#verified?" do
      before(:each) do
        @api_id = valid_client_credentials[:api_id]
        @timestamp = '1303245326'
        @nonce = @api_id
        @status_code = '200'
        @result_code = '2000'
        @call_id = 'blah'

        # Signature calculation:
        # Message: "00000000-0000-0000-0000-000000000000130324532600000000-0000-0000-0000-0000000000002002000blah"
        # Secret: "notarealsecret"
        @signature = "81146cf88328e5092e4fe577cf795891e77aef41"
      end

      it "returns true when all of the expected params are present and the signature matches the calculated signature" do
        rp = Direct::ResponseParameters.new({
          'api_id' => @api_id,
          'timestamp' => @timestamp,
          'nonce' => @nonce,
          'status_code' => @status_code,
          'result_code' => @result_code,
          'call_id' => @call_id,
          'signature' => @signature
        }, client)

        rp.verified?.should be_truthy
      end

      it "returns false when the calculated signature of the result params is different from the received signature" do
        rp = Direct::ResponseParameters.new({
          'api_id' => @api_id,
          'timestamp' => @timestamp,
          'nonce' => @nonce,
          'status_code' => @status_code,
          'result_code' => @result_code,
          'call_id' => @call_id,
          'signature' => 'foo'
        }, client)

        rp.verified?.should be_falsey
      end

      it "returns false when the calculated signature is correct but the api_id does not match the client's" do
        other_client_credentials = valid_client_credentials.merge(:api_id => '1')
        other_client = Client.new(other_client_credentials)

        rp = Direct::ResponseParameters.new({
          'api_id' => @api_id,
          'timestamp' => @timestamp,
          'nonce' => @nonce,
          'status_code' => @status_code,
          'result_code' => @result_code,
          'call_id' => @call_id,
          'signature' => @signature
        }, other_client)

        rp.verified?.should be_falsey
      end
    end
  end
end
