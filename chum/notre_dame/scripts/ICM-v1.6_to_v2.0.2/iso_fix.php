<?php
$f = fopen('aa.sql', 'r');
$w = fopen('bb.sql', 'w');
//echo($r."\n");
$unfinished_line = "";
while($r = fread($f, 1024)){
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