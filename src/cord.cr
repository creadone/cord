require "pool/connection"
require "./reconnect.cr"

module Сord
  VERSION = "0.0.1"

  class Connection
    @cp : ConnectionPool(Сord::Reconnect)

    def initialize(@host : String = "localhost",
                   @port : Int32 = 6379,
                   @user : String? = nil,
                   @password : String? = nil,
                   @timeout : Time::Span = 1.second,
                   @pool : Int32 = 10)
      @cp = ConnectionPool(Сord::Reconnect).new(capacity: @pool) do
        Сord::Reconnect.new(host: @host, port: @port, user: @user, password: @password)
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
