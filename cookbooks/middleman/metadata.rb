name 'middleman'
maintainer 'Alex S'
maintainer_email 'you@example.com'
license 'All Rights Reserved'
description 'Installs/Configures middleman'
long_description 'Installs/Configures middleman'
version '0.1.0'
chef_version '>= 12.1' if respond_to?(:chef_version)

depends 'httpd'
depends 'poise-ruby'
depends 'runit'
depends 'git'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/middleman/issues'

# The `source_url` points to the development reposiory for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/middleman'
