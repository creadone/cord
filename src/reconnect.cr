require "tarantool"

module Cord
  class Reconnect

    @client : Tarantool::Connection

    def initialize(@host = "localhost", @port = 6379, @user : String? = nil, @password : String? = nil, @logger : Logger? = nil)
      @client = Tarantool::Connection.new(host: @host, port: @port, user: @user, password: @password, logger: @logger)
    end

    def reconnect!
      @client.close rescue nil
      @client = Tarantool::Connection.new(host: @host, port: @port, user: @user, password: @password, logger: @logger)
    end

    macro method_missing(call)
      safe_call { @client.{{call}} }
    end

    private def safe_call
      yield
    rescue
      reconnect!
      yield
    end

  end
end
