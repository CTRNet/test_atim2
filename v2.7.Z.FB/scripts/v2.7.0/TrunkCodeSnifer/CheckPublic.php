<?php
function toCamel($val, $file) {  
	global $i;
	global $j;
	echo($i.": ".$file."\n");
		$j++;
	echo "\t".$val."\n";
	// echo "\t".strlen($val)."\n";
	if (strlen($val)===2){
		$val=strtolower($val);
		$j++;
	}
	die();
    return $val;
}  

function convert($str, $file) {
    echo($file."\n");
    $name = "/<script>[\S\s]*public[\S\s]<\/script>/";
	$str = preg_replace_callback($name, function($matches){
		global $file;
		return toCamel($matches[0], $file);	
	},$str);
    return $str;
}

$path = $argv[1];
$Iterator = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($path));
$i=1; 
$j=0;
foreach($Iterator as $file){
    if(substr($file,-4) !== '.php' && substr($file,-4) !== '.ctp'&& substr($file,-4) !== '.js')
        continue;
    // echo($i.": ".$file."\n");
	$i++;
    $out = convert(file_get_contents($file), $file);
    // file_put_contents($file, $out);
}
echo $j;