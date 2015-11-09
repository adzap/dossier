require 'erb'
require 'yaml'

module Dossier
  class Configuration

    DB_KEY = 'DATABASE_URL'.freeze

    attr_accessor :config_path, :templates_path, :client, :formats, :multi_report_formats, :share_connection

    def initialize
      @config_path = Rails.root.join('config', 'dossier.yml')
      @templates_path = "dossier/reports"
      @formats = [ :html, :json, :csv, :xls ]
      @multi_report_formats = [ 'html' ]
      @share_connection = true
    end
   
    def connection_options
      return { :share_connection => true } if @share_connection == true
      yaml_config.merge(dburl_config || {}).presence || raise_empty_conn_config
    end

    def yaml_config
      YAML.load(ERB.new(File.read(config_path)).result)[Rails.env].symbolize_keys
    rescue Errno::ENOENT
      {}
    end
   
    def dburl_config
      Dossier::ConnectionUrl.new.to_hash if ENV.has_key? DB_KEY
    end

    def client
      @client ||= setup_client!
    end

    def setup_client!
      @client ||= Dossier::Client.new(connection_options)
    end

    private

    def raise_empty_conn_config
      raise ConfigurationMissingError.new(
        "Your connection options are blank, you are missing both #{config_path} and ENV['#{DB_KEY}']"
      )
    end

  end

  class ConfigurationMissingError < StandardError ; end
end
