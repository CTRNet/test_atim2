<?php

	// FILE created to update data directly into DB.
	// Not a file of the dataimporter
	
	//-----------------------------------------------------------------------------------------------------------------------------
	$db_ip			= "127.0.0.1";
	$db_port 		= "3306";
	$db_user 		= "root";
	$db_pwd			= "";
	$db_schema		= "coeur";
	$db_charset		= "utf8";
	//-----------------------------------------------------------------------------------------------------------------------------
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
	//-----------------------------------------------------------------------------------------------------------------------------
	
	pr('Launch process');
	
	// ** Clean-up PARTICIPANTS **

	$query = "select diagnosis_master_id, ca125_progression_time_in_months,progression_time_in_months,follow_up_from_ovarectomy_in_months,survival_from_ovarectomy_in_months from qc_tf_dxd_eocs";
	$all_eoc_float_values = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");	
	while($eoc_float_values = mysqli_fetch_assoc($all_eoc_float_values)) {
		$diagnosis_master_id = $eoc_float_values['diagnosis_master_id'];
		$eoc_data_to_update = array();
		foreach($eoc_float_values as $field => $value) {
			if($field != 'diagnosis_master_id') {
				if(strpos($value,'.')) {
					$eoc_data_to_update[] = "$field = '".substr($value,0,strpos($value,'.'))."'";
				}
			}
		}
		if(!empty($eoc_data_to_update)) {		
			$query = "UPDATE qc_tf_dxd_eocs SET ".implode(',',$eoc_data_to_update)." WHERE diagnosis_master_id = $diagnosis_master_id";	
			mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
			$query = str_replace("qc_tf_dxd_eocs", "qc_tf_dxd_eocs_revs", $query);
			mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
		}
	}
	
	pr('done');
	
//====================================================================================================================================================

function pr($var) {
	echo '<pre>';
	print_r($var);
	echo '</pre>';
}
	
?>