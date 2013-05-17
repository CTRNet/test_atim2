<?php
	/*
	 * GENERATE DATA FOR NEW FIELDS:
	 *   Search all icm storage and check content PROCURE vs NOT PROCURE
	 */
	
	//-- DB PARAMETERS ---------------------------------------------------------------------------------------------------------------------------
	
	$db_ip			= "127.0.0.1";
	$db_port 		= "3306";
	$db_user 		= "root";
	$db_pwd			= "";
	$db_schema		= "jghbreast";
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
	
	$query = "SELECT aliquot_master_id FROM quality_ctrls WHERE aliquot_master_id IS NOT NULL AND aliquot_master_id != '' AND deleted != 1;";
	$qc_aliquot_master_ids_res = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
	while($qc_aliquot_master_id = mysqli_fetch_assoc($qc_aliquot_master_ids_res)) {
		$aliquot_master_id = $qc_aliquot_master_id['aliquot_master_id'];
		$query = "SELECT count(*) AS use_counter FROM view_aliquot_uses WHERE aliquot_master_id = $aliquot_master_id;";
		$qc_res = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
		$new_qc = mysqli_fetch_assoc($qc_res);
		$query = "UPDATE aliquot_masters SET use_counter = '".$new_qc['use_counter']."' WHERE id = $aliquot_master_id AND deleted <> 1";
		mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
	}
	
	
	$query = "UPDATE versions SET permissions_regenerated = 0;";
	mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
	
	echo "****** PROCESS DONE ******<br>";
	
	//====================================================================================================================================================
	
function pr($var) {
	echo '<pre>';
	print_r($var);
	echo '</pre>';
}	

?>