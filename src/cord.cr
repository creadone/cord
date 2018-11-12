require "pool/connection"
require "./reconnect.cr"

module Cord
  VERSION = "0.0.2"

  class Connection
    @cp : ConnectionPool(Cord::Reconnect)

    def initialize(@host : String = "localhost",
                   @port : Int32 = 6379,
                   @user : String? = nil,
                   @password : String? = nil,
                   @timeout : Time::Span = 1.second,
                   @pool : Int32 = 10,
                   @logger : Logger = nil
                   )
      @cp = ConnectionPool(Cord::Reconnect).new(capacity: @pool) do
        Cord::Reconnect.new(host: @host, port: @port, user: @user, password: @password, logger: @logger)
      end
    end

    macro method_missing(call)
      @cp.connection do |cn|
        return cn.{{call}}
      end
    end

    def pool_size
      @cp.size
    end

    def pool_pending
      @cp.pending
    end

    def stats
      {capacity: @pool, available: pool_pending, used: pool_size}
    end

  end
end
