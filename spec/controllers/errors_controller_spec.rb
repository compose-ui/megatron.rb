require 'spec_helper'

class Megatron::Forbidden < StandardError
end

class Megatron::Unauthorized < StandardError
end

describe Megatron::ErrorsController do
  describe '#show' do
    let(:request) { test_request }
    let(:env) do
      request.env.merge({
        'action_dispatch.exception' => exception,
        'HTTP_ACCEPT' => 'application/json'
      })
    end
    let(:status) { response.first }
    let(:body) { response.last.body }

    let(:response) do
      Gaffe.errors_controller_for_request(env).action(:show).call(env)
    end

    context 'with internal_server_error' do
      let(:exception) { StandardError.new }
      it { expect(status).to eql 500 }
      it { expect(body).to match(/an unexpected error occurred/) }
    end

    context 'with bad_request' do
      let(:exception) { ActionController::BadRequest.new }
      it { expect(status).to eql 400 }
      it { expect(body).to match(/bad request/) }
    end

    context 'with forbidden' do
      let(:exception) { Megatron::Forbidden.new }
      it { expect(status).to eql 403 }
      it { expect(body).to match(/forbidden/) }
    end

    context 'with method_not_allowed' do
      let(:exception) { ActionController::MethodNotAllowed.new(:foo) }
      it { expect(status).to eql 405 }
      it { expect(body).to match(/method not supported/) }
    end

    context 'with not_acceptable' do
      let(:exception) { ActionController::UnknownFormat.new }
      it { expect(status).to eql 406 }
      it { expect(body).to match(/not acceptable/) }
    end

    context 'with not_found' do
      let(:exception) { ActionController::RoutingError.new('blah') }
      it { expect(status).to eql 404 }
      it { expect(body).to match(/not found/) }
    end

    context 'with not_implemented' do
      let(:exception) { ActionController::NotImplemented.new }
      it { expect(status).to eql 501 }
      it { expect(body).to match(/not implemented/) }
    end

    context 'with unauthorized' do
      let(:exception) { Megatron::Unauthorized.new }
      it { expect(status).to eql 401 }
      it { expect(body).to match(/unauthorized/) }
    end

    context 'with unprocessable_entity' do
      let(:exception) { ActionController::InvalidAuthenticityToken.new }
      it { expect(status).to eql 422 }
      it { expect(body).to match(/we couldn't process your input/) }
    end
  end
end
