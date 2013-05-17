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
	
	$modified = date('Y-m-d').' 00:00:00';
	$modified_by = '1';
	
	$msg_to_display = array('TODO' => array(), 'MESSAGE' => array());
	
	//-----------------------------------------------------------------------------------
	
	$queries = array(
		"UPDATE quality_ctrls SET qc_lady_rin_score = score, modified = '$modified', modified_by = '$modified_by' WHERE unit = 'RIN';",
		"UPDATE quality_ctrls SET qc_lady_260_280_score = score, modified = '$modified', modified_by = '$modified_by' WHERE unit = '260/280';",
		"UPDATE quality_ctrls SET qc_lady_260_230_score = score, modified = '$modified', modified_by = '$modified_by' WHERE unit = '260/230';",
		"UPDATE quality_ctrls SET score = '', unit = '', modified = '$modified', modified_by = '$modified_by' WHERE qc_lady_rin_score IS NOT NULL OR qc_lady_260_230_score IS NOT NULL OR qc_lady_260_280_score IS NOT NULL;"
	);
	foreach($queries as $new_query) {
		mysqli_query($db_connection, $new_query) or die("query failed [".$new_query."]: " . mysqli_error($db_connection)."]");
	}
	
	//-----------------------------------------------------------------------------------
	
	$query = "SELECT col.participant_id, qc.score, qc.unit
		FROM quality_ctrls qc INNER JOIN sample_masters sm ON sm.id = qc.sample_master_id INNER JOIN collections col ON col.id = sm.collection_id
		WHERE qc.unit != '' AND qc.score != '';";
	$qc_res = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
	$errors = array();
	while($new_qc = mysqli_fetch_assoc($qc_res)) {
		$errors[] = 'participant_id='.$new_qc['participant_id'].' score='.$new_qc['score'].' unit='.$new_qc['unit'];
	}
	if($errors) {
//		die('Score not empty. See: '.implode(' | ', $errors));
	}
	
	//-----------------------------------------------------------------------------------
	
	$query = "SELECT id, qc_code, sample_master_id, type, qc_type_precision, run_by, date, date_accuracy, score, unit, conclusion, notes, aliquot_master_id, used_volume, concentration, concentration_unit, qc_lady_260_230_score, qc_lady_260_280_score FROM quality_ctrls WHERE (qc_lady_260_230_score IS NOT NULL OR qc_lady_260_280_score IS NOT NULL) AND deleted <> 1;";
	$qc_res = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
	$qc_to_review = array();
	while($new_qc = mysqli_fetch_assoc($qc_res)) {
		$sample_master_id = $new_qc['sample_master_id'];
		$qc_to_review[$sample_master_id][] = $new_qc;
	}
	$aliquot_master_ids_to_update = array();
	foreach($qc_to_review AS $new_sample_qcs) {
		if(sizeof($new_sample_qcs) == 2) {
			$qc_1 = $new_sample_qcs[0];
			$qc_2 = $new_sample_qcs[1];
			if($qc_1['qc_lady_260_230_score'] && $qc_2['qc_lady_260_230_score']) {
				if($qc_1['date'] == $qc_2['date']) {
					$msg_to_display['TODO'][] = ('Deux valeurs de 260/230 pour deux QC a la meme date. Sample code ['.$qc_1['sample_master_id'].'] QC ['.$qc_1['qc_code'].'] & ['.$qc_2['qc_code'].']. A faire manuellement.');
				} else {
					//nothing done
				}
			} else if($qc_1['qc_lady_260_280_score'] && $qc_2['qc_lady_260_280_score']) {
				if($qc_1['date'] == $qc_2['date']) {
					$msg_to_display['TODO'][] = ('Deux valeurs de 260/280 pour deux QC a la meme date. Sample code ['.$qc_1['sample_master_id'].'] QC ['.$qc_1['qc_code'].'] & ['.$qc_2['qc_code'].']. A faire manuellement.');
				} else {
					//nothing done
				}
			} else {
				if($qc_1['used_volume'] || $qc_2['used_volume']) die('ERR 838839393');
				$dif_keys = array();
				foreach(array('type','qc_type_precision','run_by','date','date_accuracy', 'conclusion', 'notes') as $key) {
					if($qc_1[$key] != $qc_2[$key]) $dif_keys[] = array();
				}
				if($dif_keys) die('ERR 77777');
				if(($qc_1['concentration'].$qc_1['concentration_unit']) != ($qc_2['concentration'].$qc_2['concentration_unit']) && ($qc_1['concentration'].$qc_1['concentration_unit']) && ($qc_2['concentration'].$qc_2['concentration_unit'])) {
					$msg_to_display['TODO'][] = ('Les concentration pour deux QC a la meme date sont différents. Sample code ['.$qc_1['sample_master_id'].'] QC ['.$qc_1['qc_code'].'] & ['.$qc_2['qc_code'].']. A faire manuellement.');
				} else if($qc_1['aliquot_master_id'] != $qc_2['aliquot_master_id'] && $qc_2['aliquot_master_id'] && $qc_1['aliquot_master_id']) {
					$msg_to_display['TODO'][] = ('Les aliquots testés pour deux QC a la meme date sont différents. Sample code ['.$qc_1['sample_master_id'].'] QC ['.$qc_1['qc_code'].'] & ['.$qc_2['qc_code'].']. A faire manuellement.');
				} else {
					if($qc_1['aliquot_master_id'] != $qc_2['aliquot_master_id']) $msg_to_display['MESSAGE'][] = ('Un des deux QC n etait pas lié à un aliquot. Il sera lié automatiquement par le merge. Sample code ['.$qc_1['sample_master_id'].'] QC ['.$qc_1['qc_code'].'] & ['.$qc_2['qc_code'].'].');
					if(($qc_1['concentration'].$qc_1['concentration_unit']) != ($qc_2['concentration'].$qc_2['concentration_unit'])) $msg_to_display['MESSAGE'][] = ('Un des deux QC n avait pas de concentration. Il en aura une automatiquement par le merge. Sample code ['.$qc_1['sample_master_id'].'] QC ['.$qc_1['qc_code'].'] & ['.$qc_2['qc_code'].'].');
					
					$qc_id_to_update = $qc_1['id'];
					$qc_id_to_delete = $qc_2['id'];
					$qc_code = 'QC - '.$qc_1['id'].'/'.$qc_2['id'];
					$qc_lady_260_230_score = $qc_1['qc_lady_260_230_score'].$qc_2['qc_lady_260_230_score'];
					$qc_lady_260_280_score = $qc_1['qc_lady_260_280_score'].$qc_2['qc_lady_260_280_score'];
					$aliquot_master_id = empty($qc_1['aliquot_master_id'])? $qc_2['aliquot_master_id'] : $qc_1['aliquot_master_id'];
					$concentration = empty($qc_1['concentration'])? $qc_2['concentration'] : $qc_1['concentration'];
					
					$concentration_unit = empty($qc_1['concentration_unit'])? $qc_2['concentration_unit'] : $qc_1['concentration_unit'];
					$queries = array(
						"UPDATE quality_ctrls SET qc_code = '$qc_code', qc_lady_260_230_score = '$qc_lady_260_230_score', qc_lady_260_280_score = '$qc_lady_260_280_score', ".(empty($aliquot_master_id)? "aliquot_master_id = null" : "aliquot_master_id = '$aliquot_master_id'").", ".(strlen($concentration)? "concentration = '$concentration'" : "concentration = null").", concentration_unit = '$concentration_unit', modified = '$modified', modified_by = '$modified_by' WHERE id = $qc_id_to_update;",
						"UPDATE quality_ctrls SET deleted = 1, modified = '$modified', modified_by = '$modified_by' WHERE id = $qc_id_to_delete;"
					);
					foreach($queries as $new_query) {
						mysqli_query($db_connection, $new_query) or die("query failed [".$new_query."]: " . mysqli_error($db_connection)."]");
					}
					
					if($aliquot_master_id) $aliquot_master_ids_to_update[$aliquot_master_id] = $aliquot_master_id;
				}
			}	
		} else if(sizeof($new_sample_qcs) > 2) {
			$codes = array();
			foreach($new_sample_qcs as $new_qc) $msgs[] = '['.$new_qc['qc_code'].'('.$new_qc['date'].')]';
			$msg_to_display['TODO'][] = ('Plus de deux qc. Sample code ['.$new_sample_qcs[0]['sample_master_id'].'] QC '.implode(' & ', $msgs).'. A faire manuellement.');
		}		
	}
	
	$query = "INSERT INTO quality_ctrls_revs (id, qc_code, sample_master_id, type, qc_type_precision, tool, run_id, run_by, date, date_accuracy, score, unit, conclusion, notes, aliquot_master_id, used_volume, modified_by, version_created, concentration, concentration_unit, qc_lady_rin_score, qc_lady_260_230_score, qc_lady_260_280_score)
		(SELECT id, qc_code, sample_master_id, type, qc_type_precision, tool, run_id, run_by, date, date_accuracy, score, unit, conclusion, notes, aliquot_master_id, used_volume, modified_by, modified, concentration, concentration_unit, qc_lady_rin_score, qc_lady_260_230_score, qc_lady_260_280_score FROM quality_ctrls WHERE modified = '$modified' AND modified_by = '$modified_by');";
	mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
	
	$query = "UPDATE versions SET permissions_regenerated = 0;";
	mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
	
	pr($msg_to_display);
	
	echo "****** PROCESS DONE ******<br>";
	
	//====================================================================================================================================================
	
function pr($var) {
	echo '<pre>';
	print_r($var);
	echo '</pre>';
}	

?>