module Cord
  class Reconnect
    def initialize(@host = "localhost", @port = 6379, @user : String? = nil, @password : String? = nil, @logger : Logger? = nil)
      @client = Tarantool::Connection.new(host: @host, port: @port, user: @user, password: @password, logger: @logger)
    end

    def reconnect!
      begin
        @client = Tarantool::Connection.new(host: @host, port: @port, user: @user, password: @password, logger: @logger)
      rescue
        @logger.not_nil!.info("Trying reconnect to #{@host}")
        sleep 3
        reconnect!
      end
    end

    macro method_missing(call)
      safe_call { @client.{{call}} }
    end

    private def safe_call
      yield
    rescue
      @logger.not_nil!.fatal("Can't connect to #{@host}")
      reconnect!
      yield
    end
  end
end
