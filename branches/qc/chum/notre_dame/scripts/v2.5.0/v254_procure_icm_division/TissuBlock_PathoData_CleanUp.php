<?php

	/*
	 * STEP 1 OF PROCURE ICM DIVISION
	 * 
	 * To RUN after custom_post254_for_division.sql
	 * 
	 * Will clean up tissu block fields :
	 *   - Clean up sample_position_code
	 *  -  Add data to new field procure_origin_of_slice
	 *   - Search all tissu blocks having note like #patho: 0000000000 - 00
	 *   - Add 0000000000 to sample_position_code AND patho_dpt_block_code
	 */
	
	//-- DB PARAMETERS ---------------------------------------------------------------------------------------------------------------------------
	
	$db_ip			= "127.0.0.1";
	$db_port 		= "3306";
	$db_user 		= "root";
	$db_pwd			= "";
	$db_schema		= "icm";
	$db_charset		= "utf8";
	
	//-- DB CONNECTION ---------------------------------------------------------------------------------------------------------------------------
	
	$db_connection = @mysqli_connect(
			$db_ip.":".$db_port,
			$db_user,
			$db_pwd
	) or die("Could not connect to MySQL");
	if(!mysqli_set_charset($db_connection, $db_charset)){
		die("Invalid charset");
	}
	@mysqli_select_db($db_connection, $db_schema) or die("db selection failed");
	mysqli_autocommit($db_connection, true);	
	
	$queries_to_update = array();
	
	//-- Clean up sample_position_code ---------------------------------------------------------------------------------------------------------------------------
	
	$step = "****** Step 1: Clean up existing Position Code ******";
	echo "$step<br>";
	
	$query = "SELECT am.id, am.aliquot_label, bl.sample_position_code, am.notes FROM aliquot_masters am INNER JOIN ad_blocks bl ON bl.aliquot_master_id = am.id
		 WHERE bl.sample_position_code != '' AND bl.sample_position_code IS NOT NULL AND am.deleted != 1;";
	$new_block_res = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
	while($new_block = mysqli_fetch_assoc($new_block_res)) {
		$aliquot_master_id = $new_block['id'];
		$aliquot_label = $new_block['aliquot_label'];
		$sample_position_code = $new_block['sample_position_code'];
		$notes = $new_block['notes'];
		
		$studied_data_key = "sample_position_code = [<b>$sample_position_code</b>]";
		
		if(preg_match('/^[0-9]+$/', $sample_position_code)) continue;
		
		if(preg_match('/^\ {0,1}([0-9]+)\ {0,1}-\ {0,1}([LR][AP])\ {0,1}$/', $sample_position_code, $matches)) {
			$new_sample_position_code = $matches[1];
			$new_procure_origin_of_slice = $matches[2];
			$queries_to_update[$step][$studied_data_key][] = "UPDATE ad_blocks SET sample_position_code = '$new_sample_position_code', procure_origin_of_slice = '$new_procure_origin_of_slice' WHERE aliquot_master_id = $aliquot_master_id;";
		} else if(preg_match('/^\ {0,1}([0-9]+)\ {0,1}-{0,1}\ {0,1}(.+)$/', $sample_position_code, $matches)) {
			$new_sample_position_code = $matches[1];
			$new_note = ' Sample Position Precision : '.$matches[2].'.';
			if($notes) {
				$queries_to_update[$step][$studied_data_key][] = "UPDATE aliquot_masters SET notes = CONCAT(notes, '$new_note') WHERE id = $aliquot_master_id;";
			} else {
				$queries_to_update[$step][$studied_data_key][] = "UPDATE aliquot_masters SET notes = '$new_note' WHERE id = $aliquot_master_id;";
			}
			$queries_to_update[$step][$studied_data_key][] = "UPDATE view_aliquots SET has_notes = 'y' WHERE aliquot_master_id = $aliquot_master_id;";
			$queries_to_update[$step][$studied_data_key][] = "UPDATE ad_blocks SET sample_position_code = '$new_sample_position_code' WHERE aliquot_master_id = $aliquot_master_id;";
			pr_msg('message',"Added new note [$new_note] from block Position Code  ($sample_position_code). See aliquot $aliquot_label (syst. code : $aliquot_master_id)");
		} else {
			die("Unable to work on block Position Code ($sample_position_code). See aliquot $aliquot_label (syst. code : $aliquot_master_id)");
		}
	}
		
	foreach($queries_to_update[$step] as $query_set) {
		foreach($query_set as $query) mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
	}
	
	//-- Clean up patho_dpt_block_code ---------------------------------------------------------------------------------------------------------------------------
	
	$step = "****** Step 2: Clean up existing Patho Code ******";
	echo "<br><br><br>$step<br>";
	
	$query = "SELECT am.id, am.aliquot_label, bl.patho_dpt_block_code, bl.sample_position_code FROM aliquot_masters am INNER JOIN ad_blocks bl ON bl.aliquot_master_id = am.id
		 WHERE bl.patho_dpt_block_code != '' AND bl.patho_dpt_block_code IS NOT NULL AND am.deleted != 1;";
	$new_block_res = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
	while($new_block = mysqli_fetch_assoc($new_block_res)) {
		$aliquot_master_id = $new_block['id'];
		$aliquot_label = $new_block['aliquot_label'];
		$patho_dpt_block_code = $new_block['patho_dpt_block_code'];
		$sample_position_code = $new_block['sample_position_code'];
	
		$studied_data_key = "patho_dpt_block_code = [<b>$patho_dpt_block_code</b>] / sample_position_code = [<b>$sample_position_code</b>]";
		
		if(preg_match('/^\ {0,1}([0-9]+)\ {0,1}$/', $patho_dpt_block_code, $matches)) {
			if(strlen($matches[1]) != 10) {
				if(preg_match('/^(0)(07|08)([0-9]{8})$/', $patho_dpt_block_code, $matches_2)) {
					$queries_to_update[$step][$studied_data_key][] = "UPDATE ad_blocks SET patho_dpt_block_code = '".$matches_2[2].$matches_2[3]."' WHERE aliquot_master_id = $aliquot_master_id;";
					pr_msg('message',"The current defined Block Code begins with '007' or '008' ($patho_dpt_block_code). Changed to '".$matches_2[2].$matches_2[3]."'. See aliquot $aliquot_label (syst. code : $aliquot_master_id)");
				} else if(preg_match('/^(83102)([0-9]{4})$/', $patho_dpt_block_code, $matches_2)) {
					$queries_to_update[$step][$studied_data_key][] = "UPDATE ad_blocks SET patho_dpt_block_code = '0$patho_dpt_block_code' WHERE aliquot_master_id = $aliquot_master_id;";
					pr_msg('message', "The current defined Block Code begins with '83102' ($patho_dpt_block_code). Changed to '0$patho_dpt_block_code'. See aliquot $aliquot_label (syst. code : $aliquot_master_id)");
				} else {
					pr_msg('warning',"The current defined Block Code size is different than 10 digits ($patho_dpt_block_code). See aliquot $aliquot_label (syst. code : $aliquot_master_id)");
				}
			}
				continue;
			} else if(preg_match('/^[0-9]{10}[A-W]$/', $patho_dpt_block_code, $matches)) {
				pr_msg('message', "The current defined Block Code format is ok ($patho_dpt_block_code). See aliquot $aliquot_label (syst. code : $aliquot_master_id)");
				continue;
			}
	
			if(preg_match('/^\ {0,1}([0-9]+)\ {0,1}-\ {0,1}([0-9]{1,2})\ {0,1}$/', $patho_dpt_block_code, $matches)) {
				$new_patho_dpt_block_code = $matches[1];
				$new_sample_position_code = $matches[2];
					
				if(strlen($new_patho_dpt_block_code) != 10) {
					pr_msg('warning',"The new Block Code size extracted from previous one ($patho_dpt_block_code) is different than 10 digits ($new_patho_dpt_block_code). See aliquot $aliquot_label (syst. code : $aliquot_master_id)");
				}
				if($sample_position_code && $sample_position_code != $new_sample_position_code) {
					pr_msg('error', "Sample Position Code extracted from previous Block Code ($patho_dpt_block_code) is different than the current defined ($sample_position_code). See aliquot $aliquot_label (syst. code : $aliquot_master_id)");
					$new_sample_position_code = '';
				} else if(!preg_match('/^[0-9]{0,2}$/', $new_sample_position_code, $matches)) {
					pr_msg('warning', "Sample Position Code format extracted from previous Block Code ($patho_dpt_block_code) is wrong ($new_sample_position_code). See aliquot $aliquot_label (syst. code : $aliquot_master_id)");
				}
				if($new_sample_position_code) {
					$queries_to_update[$step][$studied_data_key][] = "UPDATE ad_blocks SET patho_dpt_block_code = '$new_patho_dpt_block_code', sample_position_code = '$new_sample_position_code' WHERE aliquot_master_id = $aliquot_master_id;";
				} else {
					$queries_to_update[$step][$studied_data_key][] = "UPDATE ad_blocks SET patho_dpt_block_code = '$new_patho_dpt_block_code' WHERE aliquot_master_id = $aliquot_master_id;";
				}
			} else {
				pr_msg('error',"The current Block Code format is wrong ($patho_dpt_block_code). See aliquot $aliquot_label (syst. code : $aliquot_master_id)");
			}
	}
	
	foreach($queries_to_update[$step] as $query_set) {
		foreach($query_set as $query) mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
	}	
		
	//-- Extract patho_dpt_block_code and sample_position_code from notes ---------------------------------------------------------------------------------------------------------------------------
	
	$step = "****** Step 3: Extract Patho Code & Position Code from notes ******";
	echo "<br><br><br>$step<br>";
	
	$query = "SELECT am.id, am.aliquot_label, am.notes, bl.patho_dpt_block_code, bl.sample_position_code FROM aliquot_masters am INNER JOIN ad_blocks bl ON bl.aliquot_master_id = am.id
		 WHERE am.notes LIKE '%patho%:%' AND am.deleted != 1;";
	$new_block_res = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
	while($new_block = mysqli_fetch_assoc($new_block_res)) {
		$aliquot_master_id = $new_block['id'];
		$aliquot_label = $new_block['aliquot_label'];
		$notes = $new_block['notes'];
		$patho_dpt_block_code = $new_block['patho_dpt_block_code'];
		$sample_position_code = $new_block['sample_position_code'];
		
		$studied_data_key = "notes = [<b>$notes</b>]/ patho_dpt_block_code = [<b>$patho_dpt_block_code</b>] / sample_position_code = [<b>$sample_position_code</b>]";
		
		$parsed_patho_dpt_block_code = '';
		$parsed_sample_position_code = '';
		$matched_note_to_erase = '';
		if(preg_match('/^.*(#\ {0,1}[pP]atho\ {0,1}:\ {0,1}([0-9]{10,11})\ {0,1}[-:]\ {0,1}([0-9]{2})\ ).*$/', $notes, $matches)) {
			$matched_note_to_erase = $matches[1];
			$parsed_patho_dpt_block_code = $matches[2];
			$parsed_sample_position_code = $matches[3];
		} else if(preg_match('/^.*(#\ {0,1}[pP]atho\ {0,1}:\ {0,1}([0-9]{10,11})\ {0,1}[-:]\ {0,1}([0-9]{2})).*$/', $notes, $matches)) {
			$matched_note_to_erase = $matches[1];
			$parsed_patho_dpt_block_code = $matches[2];
			$parsed_sample_position_code = $matches[3];	
		} else if(preg_match('/^.*(#\ {0,1}[pP]atho\ {0,1}:\ {0,1}([0-9]{10,11})\ ).*$/', $notes, $matches)) {
			$matched_note_to_erase = $matches[1];
			$parsed_patho_dpt_block_code = $matches[2];		
		} else if(preg_match('/^.*(#\ {0,1}[pP]atho\ {0,1}:\ {0,1}([0-9]{10,11})).*$/', $notes, $matches)) {
			$matched_note_to_erase = $matches[1];
			$parsed_patho_dpt_block_code = $matches[2];		
		} else if(preg_match('/^([pP]atho\ {0,1}:\ {0,1}([0-9]{10,11})\ {0,1}[-:]\ {0,1}([0-9]{2})\ ).*$/', $notes, $matches)) {
			$matched_note_to_erase = $matches[1];
			$parsed_patho_dpt_block_code = $matches[2];	
			$parsed_sample_position_code = $matches[3];	
		} else if(preg_match('/^([pP]atho\ {0,1}:\ {0,1}([0-9]{10,11})\ {0,1}[-:]\ {0,1}([0-9]{2})).*$/', $notes, $matches)) {
			$matched_note_to_erase = $matches[1];
			$parsed_patho_dpt_block_code = $matches[2];	
			$parsed_sample_position_code = $matches[3];	
		} else if(preg_match('/^(#patho:\ ([0-9]{10,11})-([0-9]{2}).*[\\r\\n]).*$/', $notes, $matches)) {
			$matched_note_to_erase = $matches[1];
			$parsed_patho_dpt_block_code = $matches[2];
			$parsed_sample_position_code = $matches[3];
		} else {
			pr_msg('message', "No Block Code & Sample Position Code are defined into following note [$notes]. See aliquot $aliquot_label (syst. code : $aliquot_master_id)");
		}
		$new_note = str_replace($matched_note_to_erase, '', $notes);
		if(preg_match('/^[:\ -]+$/', $new_note, $matches)) {
			$new_note = '';	
		}
		
		// UPDATE patho_dpt_block_code sample_position_code
		$ad_blocks_query = '';
		$update_note = true;
		if($patho_dpt_block_code) {
			if($parsed_patho_dpt_block_code && $patho_dpt_block_code != $parsed_patho_dpt_block_code) {
				$update_note = false;
				pr_msg('error', "Block Code extracted from notes ($notes) is different than the current defined ($patho_dpt_block_code). See aliquot $aliquot_label (syst. code : $aliquot_master_id)");
			}
		} else if($parsed_patho_dpt_block_code) {
			if(strlen($parsed_patho_dpt_block_code) != 10) pr_msg('warning',"The Block Code size extracted from notes ($notes) is different than 10 digits ($parsed_patho_dpt_block_code). See aliquot $aliquot_label (syst. code : $aliquot_master_id)");
			$ad_blocks_query = "patho_dpt_block_code = '$parsed_patho_dpt_block_code'";
		}
		if($sample_position_code) {
			if($parsed_sample_position_code && $sample_position_code != $parsed_sample_position_code) {
				$update_note = false;
				pr_msg('error',"Sample Position Code extracted from notes ($notes) is different than the current defined ($sample_position_code). See aliquot $aliquot_label (syst. code : $aliquot_master_id)");
			}
		} else if($parsed_sample_position_code) {		
			$ad_blocks_query = ($ad_blocks_query? $ad_blocks_query.', ': '')."sample_position_code = '$parsed_sample_position_code'";
		}
		if($ad_blocks_query) {
			$queries_to_update[$step][$studied_data_key][] = "UPDATE ad_blocks SET $ad_blocks_query WHERE aliquot_master_id = $aliquot_master_id;";
		}
		// UPDATE notes
		if($update_note && $new_note != $notes) {
			//$queries_to_update[$step][$studied_data_key][] = "UPDATE aliquot_masters SET notes = '$new_note' WHERE id = $aliquot_master_id;";
		}
	}
		
	foreach($queries_to_update[$step] as $query_set) {
		foreach($query_set as $query) mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
	}
	
	echo "****************** PROCESS DONE ******************************<br><br><br>";
	
	echo "--------------------------------------------------------------------------------------------------------------------------<br><br><br>";
	
	echo "****************** QUERIES SUMMARY ******************************<br>";
	
	foreach($queries_to_update as $new_step => $query_set_sorted_per_data) {
		pr("<br><FONT color='blue'><b>****************$new_step****************</b></FONT><br><br>");
		foreach($query_set_sorted_per_data as $studied_data_key => $query_set) {
			pr("<FONT color='green'>$studied_data_key</FONT>");
			foreach($query_set as $query) pr(" ....... $query");
		}
	}
	
	
	//====================================================================================================================================================
	
function pr_msg($type, $msg) {
	$font = 'black';
	switch($type) {
		case 'error':
			$font = 'red';
			break;
		case 'warning':
			$font = '#E56717';
			break;
		case 'message':
			$font = 'green';
			break;
	}
	pr("<FONT color='$font'>$msg</FONT>");
}
	
function pr($var) {
	echo '<pre>';
	print_r($var);
	echo '</pre>';
}	

?>