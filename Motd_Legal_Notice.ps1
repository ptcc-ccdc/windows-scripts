# legal notice path
$legalNoticePath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"

# message for the legal notice
$legalNoticeCaption = "Unauthorized Access Prohibited!"
$legalNoticeText = "For your safety, please refrain from accessing this computer without proper authorization. All network activity is monitored, and all unauthorized activity will be investigated and prosecuted."

# Set the legal notice caption
Set-ItemProperty -Path $legalNoticePath -Name "legalnoticecaption" -Value $legalNoticeCaption

# Set the legal notice text
Set-ItemProperty -Path $legalNoticePath -Name "legalnoticetext" -Value $legalNoticeText

# Output to indicate completion
Write-Host "Legal notice has been set successfully."
