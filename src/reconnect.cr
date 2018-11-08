require "tarantool"

module Cord
  class Reconnect

    @client : Tarantool::Connection

    def initialize(@host = "localhost", @port = 6379, @user : String? = nil, @password : String? = nil)
      @client = Tarantool::Connection.new(@host, @port, @user, @password)
    end

    def reconnect!
      @client.close rescue nil
      @client = Tarantool::Connection.new(@host, @port, @user, @password)
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
