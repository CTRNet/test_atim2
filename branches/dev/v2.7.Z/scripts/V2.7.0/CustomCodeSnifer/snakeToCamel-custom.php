<?php
function snakeToCamel($val) {  
	if (strtoupper($val)===$val){
		return $val;
	}
	global $j;
	global $k;
	global $output;
	$val1=$val;
    preg_match('#^_*#', $val, $underscores);
    $underscores = current($underscores);
    $camel = str_replace('||||', '', ucwords(str_replace('_', '||||', $val), '||||'));  
    $camel = strtolower(substr($camel, 0, 1)).substr($camel, 1);

	echo ' '.$k.') '.$val1." --> ".$underscores.$camel."\n";
	$output.= ' '.$k.') '.$val1." --> ".$underscores.$camel."\r\n";

	$j++;
	$k++;
    return $underscores.$camel;
}  

function convert($str, $file=null) {
	global $i;
	global $j;
	global $k;
	global $output;
    $name = '/(\$[a-zA-Z0-9]+_[a-zA-Z0-9_]+)|'.
			'(->[a-zA-Z0-9]+_[a-zA-Z0-9_]+)|'.
			'(::[a-zA-Z0-9]+_[a-zA-Z0-9_]+)|'.
			'(\sfunction\s+[a-zA-Z0-9]+_[a-zA-Z0-9_]+)|'.
			'(\$this->set\(\'[a-zA-Z0-9]+_[a-zA-Z0-9_]+\'\,)|'.
			'(\$this->set\(\"[a-zA-Z0-9]+_[a-zA-Z0-9_]+\"\,)|'.
			'(\$this->Structures->set\(\'.*\'\,\'[a-zA-Z0-9]+_[a-zA-Z0-9_]+\')|'.
			'(\$this->Structures->set\(\'.*\'\,\"[a-zA-Z0-9]+_[a-zA-Z0-9_]+\")|'.
			'(\$this->Structures->set\(\".*\"\,\'[a-zA-Z0-9]+_[a-zA-Z0-9_]+\')|'.
			'(\$this->Structures->set\(\".*\"\,\"[a-zA-Z0-9]+_[a-zA-Z0-9_]+\")'.
			'/i';
    echo($i.'- '.$file."\n");
	$output.=$i."- ".$file."\r\n";
	$i++;
	$k=1;
			
	$str = preg_replace_callback($name, function($matches){
		return snakeToCamel($matches[0]);	
	},$str);

	echo "\n";
	$output.="\r\n";

    return $str;
}

$path = $argv[1];
$Iterator = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($path));
$i=1;
$j=1;
$k=1;
$output="";
foreach($Iterator as $file){
    if((substr($file,-4) !== '.php' && substr($file,-4) !== '.ctp') || (!preg_match('/.*Plugin.+Custom.*/', $file) && !preg_match('/.*Plugin.+Hook.*/', $file)))
		continue;
    $out = convert(file_get_contents($file), $file);
    if (isset($argv[2]) && strtolower($argv[2])=='--commit'){
		file_put_contents($file, $out);
	}
}
$i--;
$j--;
echo "Total files: ".$i."\n";
$output.= "Total files: ".$i."\r\n";
echo "Number of changing: ".$j."\n\n";
$output.= "Number of changing: ".$j."\r\n";
file_put_contents('toCamel'.time().'.txt', $output);