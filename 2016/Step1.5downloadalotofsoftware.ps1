Set-Location c:\downloads

#Only allow downloads that use TLS 1.2 and TLS 1.3
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls13

Invoke-WebRequest https://nmap.org/dist/nmap-7.94-setup.exe -Outfile nmap.exe
Invoke-WebRequest https://download.sysinternals.com/files/Autoruns.zip -Outfile Autoruns.zip
Invoke-WebRequest https://sourceforge.net/projects/processhacker/files/processhacker2/processhacker-2.39-setup.exe/download -OutFile processhacker-2.39-setup.exe
Invoke-WebRequest https://2.na.dl.wireshark.org/win64/Wireshark-4.2.2-x64.exe -OutFile Wireshark-4.2.2-x64.exe
