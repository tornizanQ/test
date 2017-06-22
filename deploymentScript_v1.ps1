Write-Host "Start of config script"


$version_name=Get-ChildItem Env:quali_version
$version_name=$version_name.Value
Write-Host $version_name

#can be Server,Portal,ES
$product_name=Get-ChildItem Env:quali_product
$product_name=$product_name.Value
Write-Host $product_name

$server_ip=Get-ChildItem Env:server
$server_ip=$server_ip.Value
Write-Host $server_ip

$qs_setup_path = '"' +"\\qsnas1\Shared\Tor\"+ $version_name +"\CloudShell\Data\QsSetup.exe"+'"'

Write-Host $qs_setup_path

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


#Silent install the requested file
$args ="/unattended /answers:" + $answer_file
Write-Host ----->args:
Write-Host $args

Start-Process -FilePath $qs_setup_path -ArgumentList  $args
