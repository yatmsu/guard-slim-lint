# frozen_string_literal: true

require 'guard/compat/plugin'
require 'shellwords'

module Guard
  # This class is Guard plugin
  class SlimLint < Plugin
    DEFAULT_OPTIONS = {
      all_on_start: true,
      cli: nil
    }

    attr_reader :options

    # Initializes a Guard plugin.
    # Don't do any work here,
    # especially as Guard plugins get initialized even if they are not in an active group!
    #
    # @param [Hash] options the custom Guard plugin options
    # @option options [Array<Guard::Watcher>] watchers the Guard plugin file watchers
    # @option options [Symbol] group the group this Guard plugin belongs to
    # @option options [Boolean] any_return allow any object to be returned from a watcher
    #
    def initialize(options = {})
      super
      default_options = DEFAULT_OPTIONS.dup
      @options = default_options.merge!(slim_dires: default_slim_dirs).merge!(options)
    end

    # Called once when Guard starts. Please override initialize method to init stuff.
    #
    # @raise [:task_has_failed] when start has failed
    # @return [Object] the task result
    #
    def start
      run if @options[:all_on_start]
    end

    # Called when `reload|r|z + enter` is pressed.
    # This method should be mainly used for "reload" (really!)
    # actions like reloading passenger/spork/bundler/...
    #
    # @return [nil]
    #
    def reload; end

    # Called when just `enter` is pressed
    # This method should be principally used for long action like running all specs/tests/...
    #
    # @raise [:task_has_failed] when run_all has failed
    # @return [Object] the task result
    #
    def run_all
      run
    end

    # Called on file(s) additions that the Guard plugin watches.
    #
    # @param [Array<String>] paths the changes files or paths
    # @raise [:task_has_failed] when run_on_additions has failed
    # @return [Object] the task result
    #
    def run_on_additions(paths)
      run(paths)
    end

    # Called on file(s) modifications that the Guard plugin watches.
    #
    # @param [Array<String>] paths the changes files or paths
    # @raise [:task_has_failed] when run_on_modifications has failed
    # @return [Object] the task result
    #
    def run_on_modifications(paths)
      run(paths)
    end

    # Called on file(s) removals that the Guard plugin watches.
    #
    # @return [nil]
    #
    def run_on_removals(paths); end

    private

    # @param [Array<String>] paths the changes files or paths
    # @raise [:task_has_failed] when run_on_additions has failed
    # @return [Object] the task result
    #
    def run(paths = [])
      command = ['slim-lint']
      command.concat build_cli_command(@options[:cli])

      if paths.empty?
        Guard::Compat::UI.info 'Running Slim-Lint for all slim files'
        command.concat @options[:slim_dires]
      else
        Guard::Compat::UI.info "Running Slim-Lint for some of the slim files: #{paths.join('\n')}"
        command.concat paths
      end

      throw :task_has_failed unless system(*command)
    end

    # @param [String] commands
    #
    def build_cli_command(commands)
      case commands
      when String then commands.shellsplit
      when NilClass then []
      else raise ArgumentError, 'Please specify only String for :cli option'
      end
    end

    # @return [Array<String>] slim directory paths
    #
    def default_slim_dirs
      File.exist?('app/views') ? ['app/views'] : ['.']
    end
  end
end
