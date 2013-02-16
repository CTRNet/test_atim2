<?php
	/*
	 * GENERATE DATA FOR NEW FIELDS:
	 *   -> Collectiom.acquisition_label = 01, 02, 03....
	 * 
	 * 
	 * NOTE:
	 *   custom_post253.sql should be executed first
	 */
	
	//-- DB PARAMETERS ---------------------------------------------------------------------------------------------------------------------------
	
	$db_ip			= "127.0.0.1";
	$db_port 		= "3306";
	$db_user 		= "root";
	$db_pwd			= "";
	$db_schema		= "jghgastro";
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
	
	//-- UPDATE Collectiom.acquisition_label ---------------------------------------------------------------------------------------------------------------------------
	
	$query = "SELECT participant_id, created, id FROM collections WHERE deleted != 1 ORDER BY participant_id ASC, created ASC;";
	$collections = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
	$previous_participant_id = null;
	$collection_counter = null;
	while($new_collection = mysqli_fetch_assoc($collections)) {
		$participant_id = $new_collection['participant_id'];
		$collection_id = $new_collection['id']; 
		if($previous_participant_id != $participant_id) {
			$collection_counter = 0;
			$previous_participant_id = $participant_id;			
		}
		$collection_counter++;
		$new_acquisition_label = (strlen($collection_counter) == 1)? '0'.$collection_counter : $collection_counter;

		$query = "UPDATE collections SET acquisition_label = '$new_acquisition_label' WHERE id = $collection_id";
		mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
		$query = str_replace("collections", "collections_revs", $query);
		mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
		

	}
	
	$result = mysql_query("UPDATE versions SET permissions_regenerated = 0");
	
	echo "****** PROCESS DONE ******<br>";
	
	//====================================================================================================================================================
	
function pr($var) {
	echo '<pre>';
	print_r($var);
	echo '</pre>';
}	

?>