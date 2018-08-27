<?php
function addPublic($val) {  
	global $j;
	global $k;
	global $output;
	$val1=$val;
    $val = str_replace('function', 'public function', $val);  
    $val = str_replace('static public function', 'public static function', $val);  
	$temp=preg_replace('/^\s*function/','function',$val1);
	$temp=preg_replace('/^\s*static function/','static function',$temp);

	echo ' '.$k.') '.$temp."\n";
	$output.=' '.$k.') '.$temp."\r\n";

	$j++;
	$k++;
    return $val;
}  

function convert($str, $file=null) {
	global $k;
	global $i;
	global $output;

    echo($i.'- '.$file."\n");
	$output.=$i."- ".$file."\r\n";

    $name = '/'.
		'\n\s+function\s&?[a-zA-Z_]+[a-zA-Z0-9_]*\('. '|'.
		'\n\s+static\s+function\s&?[a-zA-Z_]+[a-zA-Z0-9_]*\('.
		'/';
	$i++;
	$k=1;

	$str = preg_replace_callback($name, function($matches){
		return addPublic($matches[0]);	
	},$str);

    $pattern = 
		'/'.
		'<script>'.
		'/';
	
	$m="";
	preg_match($pattern, $str, $m, PREG_OFFSET_CAPTURE);
	if (!empty($m) && $k!=1){
		echo " ******** Pay attention to this file that contain Javascript code. ********** \n";
		$output.=" ******** Pay attention to this file that contain Javascript code. ********** "."\r\n";
	}
	
	
	echo "\n";
	$output.="\r\n";

    return $str;
}

$path = $argv[1];
if(!is_dir($path)) die("\nWrong path [$path]\n");
$Iterator = new RecursiveIteratorIterator(new RecursiveDirectoryIterator($path));
$i=1;
$j=1;
$k=1;
$output="";
foreach($Iterator as $file){
    if(substr($file,-4) == '.php' && (preg_match('/.*Plugin.+((Controller)|(Model)|(View)).+Hook.*/', $file) || preg_match('/.*Plugin.+((Controller)|(Model)|(View)).+Custom.*/', $file))) {
        $out = convert(file_get_contents($file), $file);
        if (isset($argv[2]) && strtolower($argv[2])=='--commit'){
    		file_put_contents($file, $out);
        }
	}
}
$i--;
$j--;
echo "Total files: ".$i."\n";
$output.= "Total files: ".$i."\r\n";
echo "Number of changing: ".$j."\n\n";
$output.= "Number of changing: ".$j."\r\n";
file_put_contents('addPublic'.time().'.txt', $output);