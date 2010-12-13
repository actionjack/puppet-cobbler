Class: puppet-cobbler
Author: ActionJack <martin at uncommonsense-uk com>
Twitter: @ActionJack

Class: cobbler

This class manages the cobbler build server

Parameters:
  None

Actions:
  Installs the cobbler build server

Requires:
  - Package["apache","xinetd"]
  - R.I. Pienaar's puppet-concat module

Sample Usage:
node cobblerserver {
       include cobbler
       cobbler::setting{"build_reporting_email": value => "[ 'sysop@192.168.1.x' ]" }
       cobbler::setting{"build_reporting_smtp_server": value => "\"192.168.1.x\"" }
       cobbler::setting{"default_password_crypted": value => "\"$MD5SUM_PASSWORD\"" }
       cobbler::setting{"server": value => "192.168.1.x" }
       cobbler::setting{"next_server": value => "192.168.1.x" }
}

