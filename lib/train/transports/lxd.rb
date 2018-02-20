require 'train'
require 'train/plugins/transport'
require 'nexussw/lxd/transport/local'
require 'nexussw/lxd/driver/cli'
require 'nexussw/lxd/driver/rest'
require 'shellwords'

module Train::Transports
  class Lxd < Train.plugin(1)
    option :config, default: {}
    option :container_name, required: true
    option :username

    name 'lxd'

    def connection(moreoptions = {})
      @connection ||= Connection.new(options.merge(moreoptions))
    end

    class Connection < BaseConnection
      include_options Lxd

      def initialize(options)
        super options
        @lxd = nx_driver.transport_for(options[:container_name]).tap do |transport|
          transport.user options[:username] if options[:username]
        end
      end

      private

      attr_reader :lxd

      def nx_driver
        return ::NexusSW::LXD::Driver::CLI.new(::NexusSW::LXD::Transport::Local.new) unless can_rest?
        ::NexusSW::LXD::Driver::Rest.new(host_address, options[:config][:rest_options])
      end

      def can_rest?
        options[:config][:server] && !options[:config][:server].empty?
      end

      def host_address
        "https://#{options[:config][:server]}:#{options[:config][:port] || 8443}"
      end

      # Execute a command using this connection.
      #
      # @param command [String] command string to execute
      # @return [CommandResult] contains the result of running the command
      def run_command_via_connection(command)
        command = command.shelljoin if command.is_a? Array
        command = ['sh', '-c', command]
        res = lxd.execute(command)
        CommandResult.new res.stdout, res.stderr, res.exitstatus
      end

      # Interact with files on the target. Read, write, and get metadata
      # from files via the transport.
      #
      # @param [String] path which is being inspected
      # @return [FileCommon] file object that allows for interaction
      def file_via_connection(path)
        # TODO: can I replace this with a class that will work more efficiently with lxd api calls?
        Train::File::Remote::Linux.new(self, path)
      end

      # Builds a LoginCommand which can be used to open an interactive
      # session on the remote host.
      #
      # @return [LoginCommand] array of command line tokens
      def login_command
        # TODO: implement
        raise NotImplementedError, "#{self.class} does not implement #login_command()"
      end
    end
  end
end
