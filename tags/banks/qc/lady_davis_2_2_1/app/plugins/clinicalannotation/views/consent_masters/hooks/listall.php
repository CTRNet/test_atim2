<?php
if(sizeof($final_options['links']['bottom']['add']) == 1){
	$use_link = "";
	foreach($final_options['links']['bottom']['add'] as $link){
		$use_link = $link;
	}
	$final_options['links']['bottom']['add'] = $use_link;  
}