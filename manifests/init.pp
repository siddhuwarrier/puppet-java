# Public: installs java jre-7u51 and JCE unlimited key size policy files
#
# Examples
#
#    include java
class java (
  $update_version = '51',
  $base_download_url = 'https://s3-eu-west-1.amazonaws.com/siddhuwarrier-boxen-downloads/java/'
) {
  include boxen::config

  $jdk_url = "${base_download_url}/jdk-8u${update_version}-macosx-x64.dmg"
  $wrapper = "${boxen::config::bindir}/java"
  $jdk_dir = "/Library/Java/JavaVirtualMachines/jdk1.8.0_${update_version}.jdk"
  $sec_dir = "${jdk_dir}/Contents/Home/jre/lib/security"

  file { $wrapper:
    source  => 'puppet:///modules/java/java.sh',
    mode    => '0755'
  }

  package {
    "jdk-8u${update_version}.dmg":
      ensure   => present,
      alias    => 'java',
      provider => pkgdmg,
      source   => $jdk_url ;
  }

  # Allow 'large' keys locally.
  # http://www.ngs.ac.uk/tools/jcepolicyfiles
  file { $sec_dir:
    ensure  => 'directory',
    owner   => 'root',
    group   => 'wheel',
    mode    => '0775',
    require => Package['java']
  }

  file { "${sec_dir}/local_policy.jar":
    source  => 'puppet:///modules/java/local_policy.jar',
    owner   => 'root',
    group   => 'wheel',
    mode    => '0664',
    require => File[$sec_dir]
  }

  file { "${sec_dir}/US_export_policy.jar":
    source  => 'puppet:///modules/java/US_export_policy.jar',
    owner   => 'root',
    group   => 'wheel',
    mode    => '0664',
    require => File[$sec_dir]
  }
}
