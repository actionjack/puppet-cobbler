# Class: cobbler
#
# This class manages the cobbler build server
#
# Parameters:
#   None
#       
#
# Actions:
#   Install the cobbler build server
#
# Requires:
#   - Package["apache","xinetd"]
#   - R.I. Pienaar's puppet-concat module
#
# Sample Usage:
#
#
# Variables

class cobbler::install {
    $packagelist = ["cobbler","cobbler-web","pykickstart","debmirror","cman"]
    package{ $packagelist: ensure => installed }
}

class cobbler::absent {
    $packagelist = ["cobbler","cobbler-web"]
    package{ $packagelist: ensure => absent }
}
 
class cobbler::config {
    File{
        require => Class["cobbler::install"],
        notify  => Class["cobbler::service"],
        owner   => "root",
        group   => "root",
        mode    => 644
    }
}
 
class cobbler::service {
    service{"cobblerd":
        ensure  => running,
        enable  => true,
        require => Class["cobbler::config"],
    }
}

class cobbler::disableboot {
    service{"cobblerd":
	enable  => false
    }
}

 
class cobbler {
    include cobbler::install, 
	    cobbler::config, 
	    cobbler::service

    include concat::setup

    concat{"/etc/cobbler/settings":
        notify => Service["cobblerd"],
    }

    concat::fragment{"cobbler_settings_file":
       target  => "/etc/cobbler/settings",
       content => template("cobbler/settings.erb"),
       order   => 01,
    }

}

class cobbler::disable {
    include cobbler::install,
            cobbler::config,
	    cobbler::disableboot
}

class cobbler::monitor {
#noop not in use at the moment
}

class cobbler::backup {
#noop not in use at the moment
}

define cobbler::setting($value) {
    concat::fragment{"cobbler_${name}": 
       target => "/etc/cobbler/settings",
       content => "${name}:  ${value}\n",
    }
}

