<?php
function addPublic($val) {  
    $val = str_replace('function', 'public function', $val);  
    $val = str_replace('static public function', 'public static function', $val);  
	global $j;
	echo "\n\t".$j.': '.$val."\n";
	$j++;
    return $val;  
}  

function convert($str, $file=null) {
	global $j;
	global $i;
    $name = '/'.
		'\n\s+function\s&?[a-zA-Z_]+[a-zA-Z0-9_]*\('. '|'.
		'\n\s+static\s+function\s&?[a-zA-Z_]+[a-zA-Z0-9_]*\('.
		'/';
    echo($i.": ".$file."\n");
	$i++;
	$str = preg_replace_callback($name, function($matches){
		return addPublic($matches[0]);	
	},$str);
    return $str;
}

$path = $argv[1];
$Iterator = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($path));
$i=1;
$j=1;
foreach($Iterator as $file){
    if(substr($file,-4) !== '.php')
        continue;
    $out = convert(file_get_contents($file), $file);
    file_put_contents($file, $out);
}