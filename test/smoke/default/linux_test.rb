# # encoding: utf-8

# Basic verification test for FIPS on Linux

describe file('/proc/sys/crypto/fips_enabled') do
  its('content') { should match(/^1/) }
end
