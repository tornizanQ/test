$version_name=Get-ChildItem Env:quali_version

#can be Server,Portal,ES
$product_name=Get-ChildItem Env:quali_product
$qs_setup_path = '"' +"\\builds\Builds\Suites\" + $version_name +"\CloudShell\Data\QsSetup.exe"+'"'

$answer_file=""
$server_answer_file = '"'+"\\builds\Builds\Suites\"+$version_name+"\CloudShell\Utilities\AnswerFiles\CloudShellServerOnlyAnswersFile.xml"+ '"'
$portal_answer_file = "the portal ans file"
$es_answer_file     = "the es ans file"

if ( $product_name -eq"server"){
	$answer_file=$server_answer_file
} 

if ( $product_name -eq "portal"){
	$answer_file=$portal_answer_file
}

if ( $product_name -eq "es"){
	$answer_file=$es_answer_file
}

#Silent install the requested file
$args ="/unattended /answers:" + $answer_file

Start-Process -FilePath $qs_setup_path -ArgumentList  $args
