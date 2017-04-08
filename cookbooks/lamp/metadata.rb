name 'lamp'
maintainer 'Alex S'
maintainer_email 'jalexspringer@gmail.com'
license 'All Rights Reserved'
description 'Installs/Configures lamp'
long_description 'Installs/Configures lamp'
version '0.2.1'
chef_version '>= 12.1' if respond_to?(:chef_version)

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
issues_url 'https://github.com/jalexspringer/lamp/issues'

# The `source_url` points to the development reposiory for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
source_url 'https://github.com/jalexspringer/lamp'

depends 'httpd', '~> 0.4'
depends 'mysql', '~> 8.0'
depends 'mysql2_chef_gem', '~> 1.1'
depends 'database', '~> 6.1'
