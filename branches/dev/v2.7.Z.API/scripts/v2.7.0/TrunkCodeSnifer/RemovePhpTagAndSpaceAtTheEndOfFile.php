<?php
function checkTag($val, $file) {  
	global $j;
	global $output;
	$j++;
	echo $j."\t".$val."\n";
	$output.=$j."\t".$val."\r\n";
    return '';
}  

function convert($str, $file) {
	global $i;	
	global $output;
	echo($i.": ".$file."\n");
	$output.=$i.": ".$file."\r\n";
    $name = "/".
			"\s*\?>\s*$"."|".
			"\s+$".
			"/";
			
	$str = preg_replace_callback($name, function($matches){
		global $file;
		return checkTag($matches[0], $file);	
	},$str);
    return $str;
}

$path = $argv[1];
$Iterator = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($path));
$i=0; 
$j=0;
$output="";
foreach($Iterator as $file){
    if(substr($file,-4) !== '.php' && substr($file,-4) !== '.ctp')
        continue;
	$i++;
    $out = convert(file_get_contents($file), $file);
    if (isset($argv[2]) && strtolower($argv[2])=='--commit'){
		file_put_contents($file, $out);
	}
}
echo "Total files: ".$i."\n";
$output.= "Total files: ".$i."\r\n";
echo "Number of changing: ".$j."\n\n";
$output.= "Number of changing: ".$j."\r\n";
file_put_contents('phpEndOfFile'.time().'.txt', $output);