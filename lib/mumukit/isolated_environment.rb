require 'docker'
require 'pathname'

module Mumukit
  class IsolatedEnvironment

    attr_accessor :container

    def configure!(*files)

      filenames = files.map { |it| File.absolute_path(it.path) }
      dirnames = filenames.map { |it| Pathname.new(it).dirname }

      binds = dirnames.map { |it| "#{it}:#{it}" }
      volumes = Hash[[dirnames.map { |it| [it, {}] }]]

      command = yield(*filenames).split

      self.container = Docker::Container.create(
          'Image' => Mumukit.config.docker_image,
          'Cmd' => command,
          'NetworkDisabled' => true,
          'HostConfig' => {
              'Binds' => binds},
          'Volumes' => volumes)
    end

    def run!
      container.start
      container.wait(Mumukit.config.command_time_limit)

      exit = container.json['State']['ExitCode']
      out = container.streaming_logs(stdout: true, stderr: true)

      if exit == 0
        [out, :passed]
      else
        [out, :failed]
      end
    rescue Docker::Error::TimeoutError => e
      [I18n.t('mumukit.time_exceeded', limit: Mumukit.config.command_time_limit), :aborted]
    end

    def destroy!
      if container
        container.stop
        container.delete
      end
    end
  end
end