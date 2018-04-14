begin
  require "vagrant"
rescue LoadError
  raise "The Vagrant Execute plugin must be run within Vagrant."
end

if Vagrant::VERSION < "2.0.3"
  raise "The Vagrant Execute plugin is only compatible with Vagrant 2.0.3+"
end

module VagrantPlugins
  module Execute
    class Plugin < Vagrant.plugin("2")
      name "execute"
      description "Vagrant plugin to execute commands inside a VM from the host machine."

      command "execute" do
        class Command < Vagrant.plugin("2", :command)
          # see https://github.com/mitchellh/vagrant/blob/master/lib/vagrant/machine.rb
          # see https://github.com/mitchellh/vagrant/blob/master/lib/vagrant/plugin/v2/communicator.rb
          def execute
            options = {}
            options[:sudo] = false
            options[:command] = ""

            opts = OptionParser.new do |o|
              o.banner = "Usage: vagrant execute [vm-name] -c command"
              o.separator ""
              o.on("--sudo", "Execute with sudo") do |v|
                options[:sudo] = v
              end
              o.on("-c", "--command COMMAND", "Command to execute") do |v|
                options[:command] = v
              end
            end

            vms = parse_options(opts)

            with_target_vms(vms) do |machine|
              if options[:sudo]
                machine.communicate.sudo(options[:command], {elevated: true, interactive: false}) do |type, data|
                  handle_comm(machine, type, data)
                end
              else
                machine.communicate.execute(options[:command]) do |type, data|
                  handle_comm(machine, type, data)
                end
              end
            end
          end

          def cleanup
          end

          protected

          # This handles outputting the communication data back to the UI
          def handle_comm(machine, type, data)
            if [:stderr, :stdout].include?(type)
              # Output the data with the proper color based on the stream.
              color = type == :stdout ? :green : :red

              # Clear out the newline since we add one
              data = data.chomp
              return if data.empty?

              options = {}
              options[:color] = color #if !config.keep_color

              machine.ui.info(data.chomp, options)
            end
          end
        end

        Command
      end
    end
  end
end
