#
# Copyright:: Copyright 2012-2019, Chef Software Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

class Chef
  class DataCollector

    # This is for shared code between the run_start_message and run_end_message modules.
    #
    # No external code should call this module directly
    #
    # @api private
    #
    module MessageHelpers
      private

      # Fully-qualified domain name of the Chef Server configured in Chef::Config
      # If the chef_server_url cannot be parsed as a URI, the node["fqdn"] attribute
      # will be returned, or "localhost" if the run_status is unavailable to us.
      #
      # @return [String] FQDN of the configured Chef Server, or node/localhost if not found.
      #
      def chef_server_fqdn
        if !Chef::Config[:chef_server_url].nil?
          URI(Chef::Config[:chef_server_url]).host
        elsif !Chef::Config[:node_name].nil?
          Chef::Config[:node_name]
        else
          "localhost"
        end
      end

      # The organization name the node is associated with. For Chef Solo runs the default
      # is "chef_solo" which can be overridden by the user.
      #
      # @return [String] Chef organization associated with the node
      #
      def organization
        if solo_run?
          # configurable fake organization name for chef-solo users
          Chef::Config[:data_collector][:organization]
        else
          if Chef::Config[:chef_server_url]
            Chef::Config[:chef_server_url].match(%r{/+organizations/+([a-z0-9][a-z0-9_-]{0,254})}).nil? ? "unknown_organization" : $1
          else
            "unknown_organization"
          end
        end
      end

      # The source of the data collecting during this run, used by the
      # DataCollector endpoint to determine if Chef was in Solo mode or not.
      #
      # @return [String] "chef_solo" if in Solo mode, "chef_client" if in Client mode
      #
      def collector_source
        solo_run? ? "chef_solo" : "chef_client"
      end

      # @return [Boolean] True if we're in a chef-solo/chef-zero or legacy chef-solo run
      def solo_run?
        Chef::Config[:solo] || Chef::Config[:local_mode]
      end
    end
  end
end
