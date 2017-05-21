#
# Cookbook:: fipsify
# Recipe:: el7
# Author:: Julian Dunn (<jdunn@chef.io>)
#
# Copyright:: Copyright (C) 2017 Chef Software Inc.
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

package 'prelink' do
  action :remove
end

package 'dracut-fips' do
  action :install
  notifies :run, 'execute[regenerate-initramfs]', :immediately
end

package 'dracut-fips-aesni' do
  action :install
  only_if { node['cpu']['0']['flags'].include?('aes') }
end

execute 'regenerate-initramfs' do
  command 'dracut -f'
  action :nothing
end

add_to_list 'enable-fips-in-kernel' do
  path '/etc/default/grub'
  pattern 'GRUB_CMDLINE_LINUX="'
  delim [' ']
  ends_with '"'
  entry 'fips=1'
  action :edit
  notifies :run, 'execute[grub-mkconfig]'
end

add_to_list 'add-boot-param' do
  path '/etc/default/grub'
  pattern 'GRUB_CMDLINE_LINUX="'
  delim [' ']
  ends_with '"'
  # lazy eval, otherwise if there's no /boot partition, resource
  # compilation will fail - so only eval this if guard is true
  entry lazy { "boot=UUID=#{node['filesystem']['by_mountpoint']['/boot']['uuid']}" }
  action :edit
  notifies :run, 'execute[grub-mkconfig]'
  only_if { node['filesystem']['by_mountpoint']['/boot'] }
end

execute 'grub-mkconfig' do
  command 'grub2-mkconfig -o /boot/grub2/grub.cfg'
  action :nothing
  notifies :request_reboot, 'reboot[fips-mode-reboot]'
end
