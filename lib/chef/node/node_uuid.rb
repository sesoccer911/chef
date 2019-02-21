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

require "securerandom"

class Chef
  class Node
    module NodeUUID
      class << self
        #
        # Returns a UUID that uniquely identifies this node for reporting reasons.
        #
        # The node is read in from disk if it exists, or it's generated if it does
        # does not exist.
        #
        # @return [String] UUID for the node
        #
        def node_uuid
          unless File.exists?(Chef::Config[:chef_guid_path])
            File.write(Chef::Config[:chef_guid_path], SecureRandom.uuid)
          end

          File.open(Chef::Config[:chef_guid_path]).first.chomp
        end
      end
    end
  end
end
