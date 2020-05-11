#!/bin/bash
function config() {
  echo "Changing Config for Manualscan"
  key='\Symantec Endpoint Protection\AV\LocalScans\ManualScan'
  cmd='/opt/Symantec/symantec_antivirus/symcfg'
  #Setting AntivirusAction to NotifyOnly
  ${cmd} add -k "${key}" -v FirstAction -d 0 -t 'REG_DWORD'
  ${cmd} add -k "${key}" -v FirstMacroAction -d 0 -t 'REG_DWORD'
  ${cmd} add -k "${key}" -v Checksum -d 1 -t 'REG_DWORD'
}

case "${1}" in
  shell )
    echo "stage: ${1}"
    service rtvscand start
    (sleep 5 ; config)&
    echo "Usage:"
    echo "sav manualscan -c <file>"
    /bin/bash
    ;;
  version )
    echo "stage: ${1}"
    service rtvscand start
    sleep 5
    sep_dev=$(sav info -d | tr -d '\r\n')
    sep_vers=$(sav info -p | tr -d '\r\n' )
    docker_tag=$(echo -n "${sep_dev}" | sed -e 's/rev./_/' -e 's/ //g' -e 's|/|.|g' -e 's/\([0-9]\{2\}\).\([0-9]\{2\}\).\([0-9]\{2\}\)/\2.\1.\3/g' )
    kernel_vers=$(uname -r)
    os_vers=$(head /etc/issue)
    echo "OS version: ${os_vers}"
    echo "Kernelversion: ${kernel_vers}"
    echo "Virusdefinition: ${sep_dev}"
    echo "Productversion: ${sep_vers}"
    echo "Dockertag: ${docker_tag}"
    echo "Java Version:"
    java -version
    ;;
  scan )
    echo "stage: ${1}"
    service rtvscand start
    sleep 5
    config
    sav manualscan -c /data
    ;;
  tag )
    cat /root/tag
    ;;
  config )
    cat /root/sep_config
    ;;
  debug )
    echo "stage: ${1}"
    /bin/bash
    ;;
esac
