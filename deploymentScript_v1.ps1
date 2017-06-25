Write-Host "Start of config script"

$version_name=Get-ChildItem Env:quali_version
$version_name=$version_name.Value
Write-Host "version_name:" $version_name

#can be Server,Portal,ES
$product_name=Get-ChildItem Env:quali_product
$product_name=$product_name.Value
Write-Host "product_name: " $product_name

$server_ip=Get-ChildItem Env:server
$server_ip=$server_ip.Value
Write-Host $server_ip
$cmdkey = "cmdkey /add:qsnas1 /user:qualisystems\qauser /pass:qa1234"
$qs_setup_path = "\\qsnas1\Shared\Tor\"+ $version_name +"\CloudShell\Data\QsSetup.exe"

Write-Host "qs_setup_path: " $qs_setup_path

$answer_file=""
$server_answer_file = '"'+"\\qsnas1\Shared\Tor\"+ $version_name +"\CloudShell\Utilities\AnswerFiles\CloudShellServerOnlyAnswersFile.xml"+ '"'
$portal_answer_file = '"'+"\\qsnas1\Shared\Tor\"+ $version_name+"\CloudShell\Utilities\AnswerFiles\CloudShellPortalOnlyAnswersFile.xml"+ '"'
$es_answer_file     = '"'+"\\qsnas1\Shared\Tor\"+ $version_name +"\CloudShell\Utilities\AnswerFiles\CloudShellESOnlyAnswersFile.xml"+ '"'
$portal_customer_config = '"'+"\\qsnas1\Shared\Tor\"+ $version_name +"\CloudShell\Utilities\AnswerFiles\Portal\customer.config"+ '"'

if ( $product_name -eq"server"){
	$answer_file=$server_answer_file
	
} 

if ( $product_name -eq "portal"){
	$answer_file=$portal_answer_file
	Get-Item $portal_customer_config | Replace-FileString
	-Pattern 'localhost'
	-Replacement $server_ip
}

if ( $product_name -eq "es"){
	$answer_file=$es_answer_file
}

write-host "answer_file: " $answer_file
##$batContent =  """$qs_setup_path"" /silent /answers:""$answer_file"" >> c:\results.txt"
#$batContent =  "$qs_setup_path /silent /answers:$answer_file"
$batContent =  """$qs_setup_path"" /silent /answers:$answer_file"
Add-Content "C:\InstallSuite.bat" $batContent
$psexec = "cmd.exe /c 'c:\InstallSuite.bat'"
Invoke-Expression -Command:$psexec
Get-Content c:\results.txt

$lastLogFile = (Get-ChildItem "c:\ProgramData\QualiSystems\QsSetup\Logs" | sort LastWriteTime | select -last 1).FullName
Write-host "Reading the file: $lastLogFile"
Get-Content $lastLogFile


