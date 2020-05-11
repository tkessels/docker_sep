service rtvscand start
echo "Starting Liveupdate"
sav liveupdate -u
echo "Done with Liveupdate"
echo "Changing Config for Manualscan"
key='\Symantec Endpoint Protection\AV\LocalScans\ManualScan'
cmd='/opt/Symantec/symantec_antivirus/symcfg'

${cmd} -r list | tee /root/sep_config.default
#Setting AntivirusAction to NotifyOnly
${cmd} add -k "${key}" -v FirstAction -d 0 -t 'REG_DWORD'
${cmd} add -k "${key}" -v FirstMacroAction -d 0 -t 'REG_DWORD'
${cmd} add -k "${key}" -v Checksum -d 1 -t 'REG_DWORD'
${cmd} -r list | tee /root/sep_config

while ! (sav info -d | grep -Pq '^\d') ; do
  sleep 1
done

#writing DefinitionVersion to file in TAGFORMAT
sav info -d | tr -d '\r\n/' | cut -f1 -d" " | sed -e 's/\(....\)\(..\)/\2\1/' | tee /root/tag
service rtvscand stop
sleep 5
