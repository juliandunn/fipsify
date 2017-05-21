registry_key 'HKLM\System\CurrentControlSet\Control\Lsa\FIPSAlgorithmPolicy' do
    values [{
    :name => 'Enabled'
    :type => :dword
    :data => '1'
  }]
  action :create
  notifies :request_reboot, 'reboot[fips-mode-reboot]'
end
