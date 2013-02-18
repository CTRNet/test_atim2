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
	
	$query = "UPDATE collections SET acquisition_label = null;";
	mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
	
	$query = "SELECT participant_id, created, id FROM collections WHERE (acquisition_label = NULL OR acquisition_label LIKE '') AND deleted != 1 ORDER BY participant_id ASC, created ASC;";
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
	
	//-- UPDATE SpecimenDetail.qc_gastro_specimen_code ---------------------------------------------------------------------------------------------------------------------------
	
	$query = "UPDATE specimen_details SET qc_gastro_specimen_code = null;";
	mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
	
	$query = "SELECT SampleMaster.id AS id,
		Collection.participant_id AS participant_id,
		SampleControl.sample_type AS sample_type,
		SpecimenDetail.qc_gastro_specimen_code AS qc_gastro_specimen_code,
		SpecimenDetail.specimen_biobank_id AS specimen_biobank_id
		FROM sample_masters SampleMaster
		INNER JOIN specimen_details SpecimenDetail ON SpecimenDetail.sample_master_id = SampleMaster.id
		INNER JOIN sample_controls SampleControl ON SampleControl.id = SampleMaster.sample_control_id
		INNER JOIN collections Collection ON Collection.id = SampleMaster.collection_id
		WHERE SampleControl.sample_category = 'specimen' AND SampleMaster.deleted <> 1 AND SpecimenDetail.qc_gastro_specimen_code IS NULL;";
	$specimens = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
	while($new_specimen = mysqli_fetch_assoc($specimens)) {
		$sample_master_id = $new_specimen['id'];
		if(preg_match('/^([0-9]{3})([NTB])$/', $new_specimen['specimen_biobank_id'], $matches)) {
			switch($new_specimen['sample_type']) {
				case 'tissue':
					if(!in_array($matches[2], array('T','N'))) {
						pr('Wrong specimen biobank id format for tissue '.$new_specimen['specimen_biobank_id'].'. Set T by default. See participant id = '.$new_specimen['participant_id']);
						$matches[2] = 'T';
					}
					break;
				case 'blood':
					if(!in_array($matches[2], array('B'))) {
						pr('Wrong specimen biobank id format for blood '.$new_specimen['specimen_biobank_id'].'. Set B by default. See participant id = '.$new_specimen['participant_id']);
						$matches[2] = 'B';
					}
					break;
				default:
					die('ERR 884309393839');
			}
			$qc_gastro_specimen_code = $matches[2];
			
			$query = "UPDATE specimen_details SET qc_gastro_specimen_code = '$qc_gastro_specimen_code' WHERE sample_master_id = $sample_master_id";
			mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
			$query = str_replace("specimen_details", "specimen_details_revs", $query);
			mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
		} else {
			pr('Wrong specimen biobank id format '.$new_specimen['specimen_biobank_id'].'. See participant id = '.$new_specimen['participant_id']);
		}
	}	
	
	$result = mysql_query("UPDATE versions SET permissions_regenerated = 0;");
	
	echo "****** PROCESS DONE ******<br>";
	
	//====================================================================================================================================================
	
function pr($var) {
	echo '<pre>';
	print_r($var);
	echo '</pre>';
}	

?>