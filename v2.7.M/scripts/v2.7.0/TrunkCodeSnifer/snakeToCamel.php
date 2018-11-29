<?php
function snakeToCamel($val) {  
	if (strtoupper($val)===$val){
		return $val;
	}
    preg_match('#^_*#', $val, $underscores);
    $underscores = current($underscores);
    $camel = str_replace('||||', '', ucwords(str_replace('_', '||||', $val), '||||'));  
    $camel = strtolower(substr($camel, 0, 1)).substr($camel, 1);

    return $underscores.$camel;  
}  

function convert($str) {
	global $j;
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
	$str = preg_replace_callback($name, function($matches){
		return snakeToCamel($matches[0]);	
	},$str);
    return $str;
}

$path = $argv[1];
$Iterator = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($path));
$i=1;
foreach($Iterator as $file){
    if(substr($file,-4) !== '.php' && substr($file,-4) !== '.ctp')
        continue;
    echo($i.": ".$file."\n");
	$i++;
    $out = convert(file_get_contents($file));
    file_put_contents($file, $out);
}