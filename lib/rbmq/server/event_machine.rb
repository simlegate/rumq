module Rbmq
  module Server
    module EventMachine
      def post_init
        puts "-- someone connected to the echo server!"
        Rbmq.logger.info "A client has connected..."
      end

      def receive_data data
        # TODO: why
        Rbmq.logger.info 'receive request from client'
        Rbmq.logger.info "\n"+data
        dispatcher = Rbmq::Dispatcher.new(Rbmq::FrameFactory.produce_by_str(data))
        dispatcher.connection = self
        response_frame = dispatcher.run
        Rbmq.logger.info 'send response form server'
        Rbmq.logger.info "\n"+response_frame.to_str
        send_data response_frame.to_str
        # => close_connection if data =~ /quit/i
      end

      def unbind
        puts "-- someone disconnected from the echo server!"
        Rbmq.logger.info "client has left"
      end
    end
  end
end
