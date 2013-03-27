<?php
	/*
	 * COMPLETE tissu block fields:
	 *   Search all tissu blocks having note like #patho: 0000000000 - 00
	 *   Add 0000000000 to sample_position_code AND patho_dpt_block_code
	 *   
	 *   To run on icm database v2.5.4
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
	
	//-- UPDATE .... ---------------------------------------------------------------------------------------------------------------------------
	
	$query = "SELECT am.id, am.aliquot_label, am.notes, bl.patho_dpt_block_code, bl.sample_position_code FROM aliquot_masters am INNER JOIN ad_blocks bl ON bl.aliquot_master_id = am.id
		 WHERE am.notes LIKE '%patho%:%' AND am.deleted != 1;";
	$new_block_res = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
	while($new_block = mysqli_fetch_assoc($new_block_res)) {
		$aliquot_master_id = $new_block['id'];
		$notes = $new_block['notes'];
		$patho_dpt_block_code = $new_block['patho_dpt_block_code'];
		$sample_position_code = $new_block['sample_position_code'];
pr('--------------------------------------------------------------------------------------------------------------------------------------------');	
pr("patho_dpt_block_code [$patho_dpt_block_code], sample_position_code [$sample_position_code], notes [$notes]");	
pr('==================================================================================');	
		$parsed_patho_dpt_block_code = '';
		$parsed_sample_position_code = '';
		$note_matched = '';
		if(preg_match('/^.*(#\ {0,1}[pP]atho\ {0,1}:\ {0,1}([0-9]{10,11})\ {0,1}[-:]\ {0,1}([0-9]{2})\ ).*$/', $notes, $matches)) {
			$note_matched = $matches[1];
			$parsed_patho_dpt_block_code = $matches[2];
			$parsed_sample_position_code = $matches[3];
		} else if(preg_match('/^.*(#\ {0,1}[pP]atho\ {0,1}:\ {0,1}([0-9]{10,11})\ {0,1}[-:]\ {0,1}([0-9]{2})).*$/', $notes, $matches)) {
			$note_matched = $matches[1];
			$parsed_patho_dpt_block_code = $matches[2];
			$parsed_sample_position_code = $matches[3];	
					
		} else if(preg_match('/^.*(#\ {0,1}[pP]atho\ {0,1}:\ {0,1}([0-9]{10,11})\ ).*$/', $notes, $matches)) {
			$note_matched = $matches[1];
			$parsed_patho_dpt_block_code = $matches[2];		
		} else if(preg_match('/^.*(#\ {0,1}[pP]atho\ {0,1}:\ {0,1}([0-9]{10,11})).*$/', $notes, $matches)) {
			$note_matched = $matches[1];
			$parsed_patho_dpt_block_code = $matches[2];		
			
		} else if(preg_match('/^([pP]atho\ {0,1}:\ {0,1}([0-9]{10,11})\ {0,1}[-:]\ {0,1}([0-9]{2})\ ).*$/', $notes, $matches)) {
			$note_matched = $matches[1];
			$parsed_patho_dpt_block_code = $matches[2];	
			$parsed_sample_position_code = $matches[3];	
			//
		} else if(preg_match('/^([pP]atho\ {0,1}:\ {0,1}([0-9]{10,11})\ {0,1}[-:]\ {0,1}([0-9]{2})).*$/', $notes, $matches)) {
			$note_matched = $matches[1];
			$parsed_patho_dpt_block_code = $matches[2];	
			$parsed_sample_position_code = $matches[3];	
			
		} else if(preg_match('/^(#patho:\ ([0-9]{10,11})-([0-9]{2}).*[\\r\\n]).*$/', $notes, $matches)) {
				$note_matched = $matches[1];
				$parsed_patho_dpt_block_code = $matches[2];
				$parsed_sample_position_code = $matches[3];
		} else {
			pr("No pathologie codes into following note [$notes]");
		}
		$new_note = str_replace($note_matched, '', $notes);
		if(preg_match('/^[:\ -]+$/', $new_note, $matches)) {
			$new_note = '';	
		}

		// UPDATE notes
		if($new_note != $notes) { 
			$query = "UPDATE aliquot_masters SET notes = '$new_note' WHERE id = $aliquot_master_id;";
pr($query);			
//			mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
			$query = "UPDATE aliquot_masters_revs SET notes = '$new_note' WHERE id = $aliquot_master_id;";
//			mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
		}
		// UPDATE patho_dpt_block_code sample_position_code
		$ad_blocks_query = '';
		if($patho_dpt_block_code) {
			if($parsed_patho_dpt_block_code && $patho_dpt_block_code != $parsed_patho_dpt_block_code) pr("WARNING : Note and existing data are different ($patho_dpt_block_code != $parsed_patho_dpt_block_code). See $aliquot_master_id");
		} else if($parsed_patho_dpt_block_code) {
			$ad_blocks_query = "patho_dpt_block_code = '$parsed_patho_dpt_block_code'";
		}
		if($sample_position_code) {
			if($parsed_sample_position_code && $sample_position_code != $parsed_sample_position_code) pr("WARNING : Note and existing data are different ($sample_position_code != $parsed_sample_position_code). See $aliquot_master_id");
		} else if($parsed_sample_position_code) {
			$ad_blocks_query = ($ad_blocks_query? $ad_blocks_query.', ': '')."sample_position_code = '$parsed_sample_position_code'";
		}
		if($ad_blocks_query) {
			$query = "UPDATE ad_blocks SET $ad_blocks_query WHERE aliquot_master_id = $aliquot_master_id;";
pr($query);			
//			mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
			$query = "UPDATE ad_blocks_revs SET $ad_blocks_query WHERE aliquot_master_id = $aliquot_master_id;";
//			mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
		}
pr('--------------------------------------------------------------------------------------------------------------------------------------------');		
	}
	
	echo "****** PROCESS DONE ******<br>";
	
	//====================================================================================================================================================
	
function pr($var) {
	echo '<pre>';
	print_r($var);
	echo '</pre>';
}	





<select tabindex="12" class="" name="data[AliquotDetail][procure_origin_of_slice]">
<option value=""></option>
<option value="LA">LA</option>
<option value="LP">LP</option>
<option selected="selected" value="RA">RA</option>
<option value="RP">RP</option>

?>