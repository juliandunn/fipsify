#
# Cookbook:: fipsify
# Recipe:: default
# Author:: Julian Dunn (<jdunn@chef.io>)
#
# Copyright:: 2017 Chef Software Inc.

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

case node['platform_family']
when 'rhel'
  case node['platform_version']
  when /^6/
    include_recipe '::el6'
  when /^7/
    include_recipe '::el7'
  else
    raise 'Unsupported operating system version'
  end
when 'windows'
  include_recipe '::windows'
else
  raise 'Unsupported operating system'
end

reboot 'fips-mode-reboot' do
  reason 'Reboot into new FIPS-enabled kernel'
  action :nothing
  not_if { node['fips']['kernel']['enabled'] } # Never reboot even if signalled if already in FIPS mode
end
