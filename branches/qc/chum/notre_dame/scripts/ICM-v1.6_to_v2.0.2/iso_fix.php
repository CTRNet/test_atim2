<?php

$f = fopen('ATiM_utf8_tmp.sql', 'r');
if(empty($f)) die('Unable to open file1');
$w = fopen('ATiM_utf8.sql', 'w');
if(empty($w)) die('Unable to open file2');

//echo($r."\n");
$unfinished_line = "";
while($r = fread($f, 300024)){
	$lines = explode("\n", $r);
	$lines[0] = $unfinished_line.$lines[0];
	$unfinished_line = array_pop($lines);
	foreach($lines as $line){
		$line = str_replace("Ã‰", "Ã", $line);
		fwrite($w, utf8_decode($line)."\n");
	}
}
$line = $unfinished_line;
$line = str_replace("Ã‰", "Ã", $line);
fwrite($w, utf8_decode($line));

?>