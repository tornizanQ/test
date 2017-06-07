$version_name=Get-ChildItem Env:quali_version
#can be Server,Portal,ES
$product_name=Get-ChildItem Env:quali_product
$server_ip=Get-ChildItem Env:server

$qs_setup_path = '"' +"H:\+ $version_name +\CloudShell\Data"+'"'

$answer_file=""
$server_answer_file = '"'+"H:\"+ $version_name +"\CloudShell\Utilities\AnswerFiles\CloudShellServerOnlyAnswersFile.xml"+ '"'
$portal_answer_file = '"'+"H:\"+ $version_name +"\CloudShell\Utilities\AnswerFiles\CloudShellPortalOnlyAnswersFile.xml"+ '"'
$es_answer_file     = '"'+"H:\"+ $version_name +"\CloudShell\Utilities\AnswerFiles\CloudShellESOnlyAnswersFile.xml"+ '"'
$portal_customer_config = '"'+"H:\"+ $version_name +"\CloudShell\Utilities\AnswerFiles\Portal\customer.config"+ '"'
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

Start-Process -FilePath $qs_setup_path -ArgumentList  $args
