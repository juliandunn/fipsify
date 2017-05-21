#
# Cookbook:: fipsify
# Recipe:: default
#
# Copyright:: 2017 Chef Software Inc.

case node['platform']
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
