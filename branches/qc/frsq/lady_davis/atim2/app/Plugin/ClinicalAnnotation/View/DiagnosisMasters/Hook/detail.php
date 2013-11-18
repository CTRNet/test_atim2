<?php 
	$final_options['settings']['actions'] = true;
	$tmp_dir = str_replace('Hook', '', dirname(__FILE__));
	if(!$is_ajax) require("$tmp_dir/add_popup.php");
	$is_ajax = true;
	