#
# Cookbook:: fipsify
# Recipe:: el7
#
# Copyright:: Copyright (C) 2017 Chef Software Inc.

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
  delim [" "]
  ends_with '"'
  entry 'fips=1'
  action :edit
  notifies :run, 'execute[grub-mkconfig]'
end

# TODO: Need to handle situation where /boot is on a separate partition.
# Can do this by testing for existence of node['filesystem']['by_mountpoint']['/boot']
# and if this is true, need to append_if_no_line the UUID of this partition to 
# GRUB_CMDLINE_LINUX as above

execute 'grub-mkconfig' do
  command 'grub2-mkconfig -o /boot/grub2/grub.cfg'
  action :nothing
  notifies :request_reboot, 'reboot[fips-mode-reboot]'
end
