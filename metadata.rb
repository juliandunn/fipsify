name 'fipsify'
maintainer 'Julian C. Dunn'
maintainer_email 'jdunn@chef.io'
license 'Apache 2.0'
description 'Turn on system settings to force a machine into FIPS 140-2 mode'
long_description 'Turn on system settings to force a machine into FIPS 140-2 mode'
version '0.1.0'
chef_version '>= 13.0' if respond_to?(:chef_version)
supports 'redhat'
supports 'windows'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
issues_url 'https://github.com/juliandunn/fipsify/issues'

# The `source_url` points to the development reposiory for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
source_url 'https://github.com/juliandunn/fipsify'

depends 'line'
