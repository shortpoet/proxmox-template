[CmdletBinding()]
param (
  [Parameter()]
  [String]
  $Distro = "Ubuntu"
)

$uris = [PSCustomObject]@{
  Ubuntu = [PSCustomObject]@{
    2104 = 'https://cloud-images.ubuntu.com/hirsute/current/hirsute-server-cloudimg-amd64.img'
    2004 = 'https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img'
    1804 = 'https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img'
  }
  Debian = [PSCustomObject]@{
    10 = "http://cdimage.debian.org/cdimage/openstack/current-10/debian-10-openstack-amd64.qcow2"
    9  = "http://cdimage.debian.org/cdimage/openstack/current-9/debian-9-openstack-amd64.qcow2"
  }
  CentOs = [PSCustomObject]@{
    8 = "https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-GenericCloud-8.4.2105-20210603.0.x86_64.qcow2"
    7 = "https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-2111.qcow2"
  }
}

function Get-Uri {
  switch ($Distro) {
    "Ubuntu" { 
      return $uris.$Distro.2104
    }
    "Debian" { 
      return $uris.$Distro.10
    }
    "CentOs" { 
      return $uris.$Distro.8
    }
  }
}

function Get-Iso {
  $uri = $(Get-Uri)
  # https://stackoverflow.com/questions/14473180/regex-to-get-a-filename-from-a-url/14475897
  $regex = "[^/\\&\?#]+\.\w{3,4}(?=([\?&#].*$|$))"
  $uri -match $regex
  $filename = $Matches.0
  echo "uri is -> $uri"
  echo "file is -> $filename"
  Invoke-WebRequest -Uri $uri -OutFile "${PWD}\$filename"
  # Invoke-RestMethod -Uri $uri -OutFile ${PWD}
}

Get-Iso