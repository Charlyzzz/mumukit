require 'sinatra/base'
require 'yaml'
require 'json'


class Mumukit::Server::App < Sinatra::Base
  configure do
    set :mumuki_url, 'http://mumuki.io'
  end

  configure :development do
    set :config_filename, 'config/development.yml'
  end

  configure :production do
    set :config_filename, 'config/production.yml'
  end

  before do
    content_type 'application/json'
  end

  runtime_config = YAML.load_file(settings.config_filename) rescue nil
  server = Mumukit::Server::TestServer.new(runtime_config)

  before do
    server.start_request!(parse_request)
  end

  helpers do
    def parse_request
      @parsed_request ||= JSON.parse(request.body.read).tap do |it|
        I18n.locale = it['locale'] || :en
      end
    end
  end

  get '/info' do
    JSON.generate(server.info(request.url))
  end

  post '/test' do
    JSON.generate(server.test!(parse_request))
  end

  post '/query' do
    JSON.generate(server.query!(parse_request))
  end

  get '/*' do
    redirect settings.mumuki_url
  end
end
