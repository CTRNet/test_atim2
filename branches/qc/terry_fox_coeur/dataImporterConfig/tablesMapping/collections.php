<?php
$pkey = "Patient Biobank Number (required)";

$fields = array(
	"bank_id" 						=> "#bank_id",
	"collection_datetime" 			=> "Date of Specimen Collection Date",
	"collection_datetime_accuracy"	=> array("Date of Specimen Collection Accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	"collection_notes"				=> "notes"
);

function postCollectionRead(Model $m){
	excelDateFix($m);
		
	if(array_key_exists($m->values['Bank'], Config::$banks)) {
		$m->values['bank_id'] = Config::$banks[$m->values['Bank']]['id'];
	} else {
		die ("ERROR: Bank '".$m->values['Bank']."' is unknown [".$m->file."] at line [". $m->line."]\n");
	}

	return true;
}

function postCollectionWrite(Model $m){
	$created = array(
		"created"		=> "NOW()", 
		"created_by"	=> Config::$db_created_id, 
		"modified"		=> "NOW()",
		"modified_by"	=> Config::$db_created_id
		);
	
	$collection_type = '';
	
	//===================================================================================
	//	TISSUE
	//===================================================================================
	
	if($m->values['Collected Specimen Type'] == 'tissue'){
		$collection_type = 'Tissue';
		
		$insert = array(
			"sample_code" 					=> "'tmp_tissue'", 
			"sample_control_id"				=> Config::$sample_aliquot_controls['tissue']['sample_control_id'], 
			"initial_specimen_sample_id"	=> "NULL", 
			"initial_specimen_sample_type"	=> "'tissue'", 
			"collection_id"					=> "'".$m->last_id."'", 
			"parent_id"						=> "NULL" 
		);
		$insert = array_merge($insert, $created);
		$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
		$sample_master_id = mysqli_insert_id(Config::$db_connection);
		$query = "UPDATE sample_masters SET sample_code=CONCAT('T - ', id), initial_specimen_sample_id=id WHERE id=".$sample_master_id;
		mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
		Database::insertRev('sample_masters', $sample_master_id);
		
		$lat_domain = Config::$value_domains['tissue_laterality'];
		$m->values['Tissue Precision Tissue Laterality'] = trim($m->values['Tissue Precision Tissue Laterality']);
		$lat_value = $lat_domain->isValidValue($m->values['Tissue Precision Tissue Laterality']);
		if($lat_value === null){
			echo "WARNING: Unmatched laterality value [",$m->values['Tissue Precision Tissue Laterality'],"] at line [".$m->line."]\n";
			$m->values['Tissue Precision Tissue Laterality'] = '';
		}	

		if(!in_array($m->values['Tissue Precision Tissue Source'],Config::$tissue_source)) {
			echo "WARNING: Unmatched tissue source [",$m->values['Tissue Precision Tissue Source'],"] at line [".$m->line."]\n";
			$m->values['Tissue Precision Tissue Source'] = '';
		}
		
		$tissue_type_domain = Config::$value_domains['qc_tf_tissue_type'];
		$tissue_type_value = $tissue_type_domain->isValidValue($m->values['Tissue Precision Tissue Type']);
		if($tissue_type_value === null){
			echo "WARNING: Unmatched tissue type value [",$m->values['Tissue Precision Tissue Type'],"] at line [".$m->line."]\n";
			$m->values['Tissue Precision Tissue Type'] = '';
		}
		
		$insert = array(
			"sample_master_id"	=> $sample_master_id,
			"tissue_source"		=> "'".$m->values['Tissue Precision Tissue Source']."'",
			"qc_tf_tissue_type"	=> "'".$m->values['Tissue Precision Tissue Type']."'",
			"tissue_laterality"	=> "'".$m->values['Tissue Precision Tissue Laterality']."'"
		);
		//$insert = array_merge($insert, $created);
		$query = "INSERT INTO sd_spe_tissues (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
		Database::insertRev('sd_spe_tissues', $sample_master_id);
		
		$insert = array("sample_master_id" => $sample_master_id);
		$insert = array_merge($insert, $created);
		$query = "INSERT INTO specimen_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
		Database::insertRev('specimen_details', $sample_master_id);
		
		//	*** TISSUE : flash frozen tube ***
	
		if(strlen($m->values['Tissue Precision Flash Frozen Tissues  Volume']) > 0){
			$volume = is_numeric($m->values['Tissue Precision Flash Frozen Tissues  Volume']) ? $m->values['Tissue Precision Flash Frozen Tissues  Volume'] : "NULL";
			if($volume == "NULL"){
				echo "WARNING: Wrong numeric value for [Tissue Precision Flash Frozen Tissues  Volume] -> [",$m->values['Tissue Precision Flash Frozen Tissues  Volume'],"] at line [".$m->line."]\n";
			}
			
			$tubes_nbr = 1;
			$master_insert = array(
				"aliquot_control_id"	=> Config::$sample_aliquot_controls['tissue']['aliquots']['tube']['aliquot_control_id'],
				"collection_id"			=> $m->last_id,
				"sample_master_id"		=> $sample_master_id,
				"in_stock"				=> "'yes - available'"
			);	

			$detail_insert = array(
				"aliquot_master_id"			=> 0,
				"qc_tf_storage_method"	=> "'flash frozen'"
			);
			
			switch($m->values['Tissue Precision Flash Frozen Tissues  Volume Unit']) {
				case 'tube':
					if($volume != "NULL") {
						preg_match("/^[0-9]+$/" ,$volume, $matches);
						if(!empty($matches) && sizeof($matches) == 1 & $matches[0] == $volume) { 
							$tubes_nbr = $volume;
						} else {
							echo "WARNING: Unmatched nbr of flash frozen tissue tubes at line [".$m->line."]\n";
						}
					}
					break;
				case 'ml':
					$master_insert["initial_volume"] = $volume;
					$master_insert["current_volume"] = $volume;
					break;
				case 'mm3':
					$detail_insert['qc_tf_size_mm3'] = $volume;
					break;
				case 'gr':
					$detail_insert['qc_tf_weight_mg'] = $volume*1000;
					break;
				default:	
					echo "WARNING: Unmatched unit value [",$m->values['Tissue Precision Flash Frozen Tissues  Volume Unit'],"] at line [".$m->line."]\n";
			}
			
			while($tubes_nbr) {
				$insert = array_merge($master_insert, $created);
				$query = "INSERT INTO aliquot_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
				$aliquot_master_id = mysqli_insert_id(Config::$db_connection);
				Database::insertRev('aliquot_masters', $aliquot_master_id);
		
				$detail_insert["aliquot_master_id"] = $aliquot_master_id;
				$query = "INSERT INTO ad_tubes (".implode(", ", array_keys($detail_insert)).") VALUES (".implode(", ", array_values($detail_insert)).")";
				$insert = array_merge($insert, $created);
				mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
				Database::insertRev('ad_tubes', $aliquot_master_id);
		
				$tubes_nbr--;
			}
		}
			
		//	*** TISSUE : tube OCT ***
	
		if(strlen($m->values['Tissue Precision OCT Frozen Tissues Volume (mm3)']) > 0){
			$volume = is_numeric($m->values['Tissue Precision OCT Frozen Tissues Volume (mm3)']) ? $m->values['Tissue Precision OCT Frozen Tissues Volume (mm3)'] : "NULL";
			$matches = array();
			if(preg_match('#([\d]+)x([\d]+)x([\d]+)#', $m->values['Tissue Precision OCT Frozen Tissues Volume (mm3)'], $matches)){
				$volume = $matches[1] * $matches[2] * $matches[3];
				echo "WARNING: Provided volume for [Tissue Precision OCT Frozen Tissues Volume (mm3)] was [".$m->values['Tissue Precision OCT Frozen Tissues Volume (mm3)']."] Replacing with [".$volume."] at line [".$m->line."]\n";
			}
			if($volume == "NULL") echo "WARNING: Wrong numeric value for volume [",$m->values['Tissue Precision OCT Frozen Tissues Volume (mm3)'],"] at line [".$m->line."]\n";
			
			$insert = array(
				"aliquot_control_id"	=> Config::$sample_aliquot_controls['tissue']['aliquots']['tube']['aliquot_control_id'],
				"collection_id"			=> $m->last_id,
				"sample_master_id"		=> $sample_master_id,
				"in_stock"				=> "'yes - available'"
			);
			$insert = array_merge($insert, $created);
			$query = "INSERT INTO aliquot_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
			mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
			$aliquot_master_id = mysqli_insert_id(Config::$db_connection);
			Database::insertRev('aliquot_masters', $aliquot_master_id);
		
			$insert = array(
				"aliquot_master_id"	=> $aliquot_master_id,
				"qc_tf_storage_solution"		=> "'OCT'",
				"qc_tf_size_mm3"		=> $volume
			);
			$query = "INSERT INTO ad_tubes (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
			$insert = array_merge($insert, $created);
			mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
			Database::insertRev('ad_tubes', $aliquot_master_id);
		}
		
		//	*** TISSUE : Paraffin block ***
	
		if(strlen($m->values["Tissue Precision Formalin Fixed Paraffin\nEmbedded Tissues Volume (nbr blocks)"]) > 0) {
			$matches = array();
			if(preg_match('#([\d]+)x([\d]+)x([\d]+)mm#', $m->values["Tissue Precision Formalin Fixed Paraffin\nEmbedded Tissues Volume (nbr blocks)"], $matches)){
				echo 'WARNING: [Tissue Precision Formalin Fixed Paraffin Embedded Tissues Volume (nbr blocks)] was a volume. Replacing with value 1 at line ['.$m->line."]\n";
				$m->values["Tissue Precision Formalin Fixed Paraffin\nEmbedded Tissues Volume (nbr blocks)"] = 1;
			}
			if(is_numeric($m->values["Tissue Precision Formalin Fixed Paraffin\nEmbedded Tissues Volume (nbr blocks)"])){
				for($i = $m->values["Tissue Precision Formalin Fixed Paraffin\nEmbedded Tissues Volume (nbr blocks)"]; $i > 0; -- $i){
					$insert = array(
						"aliquot_control_id"	=> Config::$sample_aliquot_controls['tissue']['aliquots']['block']['aliquot_control_id'],
						"collection_id"			=> $m->last_id,
						"sample_master_id"		=> $sample_master_id,
						"in_stock"				=> "'yes - available'"
					);
					$insert = array_merge($insert, $created);
					$query = "INSERT INTO aliquot_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
					mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
					$aliquot_master_id = mysqli_insert_id(Config::$db_connection);
					Database::insertRev('aliquot_masters', $aliquot_master_id);
		
					$insert = array(
						"aliquot_master_id"	=> $aliquot_master_id,
						"block_type"		=> "'paraffin'"
					);
					$query = "INSERT INTO ad_blocks (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
					$insert = array_merge($insert, $created);
					mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
					Database::insertRev('ad_blocks', $aliquot_master_id);
				}
			} else {
				echo "WARNING: Wrong numeric value for volume [",$m->values["Tissue Precision Formalin Fixed Paraffin\nEmbedded Tissues Volume (nbr blocks)"],"] at line [".$m->line."]\n";
			}
		}
	
	//===================================================================================
	//	ASCITE
	//===================================================================================
	
	}else if($m->values['Collected Specimen Type'] == 'ascite'){
		$collection_type = 'Ascite';
		
		$insert = array(
			"sample_code" 					=> "'tmp_ascite'", 
			"sample_control_id"				=> Config::$sample_aliquot_controls['ascite']['sample_control_id'], 
			"initial_specimen_sample_id"	=> "NULL", 
			"initial_specimen_sample_type"	=> "'ascite'", 
			"collection_id"					=> "'".$m->last_id."'", 
			"parent_id"						=> "NULL" 
		);
		$insert = array_merge($insert, $created);
		$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
		$sample_master_id = mysqli_insert_id(Config::$db_connection);
		$query = "UPDATE sample_masters SET sample_code=CONCAT('A - ', id), initial_specimen_sample_id=id WHERE id=".$sample_master_id;
		mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
		Database::insertRev('sample_masters', $sample_master_id);
		
		$insert = array(
			"sample_master_id"	=> $sample_master_id
		);
		$query = "INSERT INTO sd_spe_ascites (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
		Database::insertRev('sd_spe_ascites', $sample_master_id);
		
		$insert = array_merge($insert, $created);
		$query = "INSERT INTO specimen_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
		Database::insertRev('specimen_details', $sample_master_id);
		
		//	*** ASCITE : tube ***
		
		if(strlen($m->values['Ascite Precision Ascites Fluids Volume (ml)']) > 0){		
			if(is_numeric($m->values['Ascite Precision Ascites Fluids Volume (ml)'])){
				$insert = array(
					"aliquot_control_id"	=> Config::$sample_aliquot_controls['ascite']['aliquots']['tube']['aliquot_control_id'],
					"collection_id"			=> $m->last_id,
					"sample_master_id"		=> $sample_master_id,
					"in_stock"				=> "'yes - available'",
					"initial_volume"		=> "'".$m->values['Ascite Precision Ascites Fluids Volume (ml)']."'",
					"current_volume"		=> "'".$m->values['Ascite Precision Ascites Fluids Volume (ml)']."'"
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO aliquot_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
				$aliquot_master_id = mysqli_insert_id(Config::$db_connection);
				Database::insertRev('aliquot_masters', $aliquot_master_id);
				
				$insert = array(
					"aliquot_master_id"		=> $aliquot_master_id,
				);
				$query = "INSERT INTO ad_tubes (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
				Database::insertRev('ad_tubes', $aliquot_master_id);
			} else {
				echo "WARNING: Wrong numeric value for volume [",$m->values['Ascite Precision Ascites Fluids Volume (ml)'],"] at line [".$m->line."]\n";
			}
		}
	
	//===================================================================================
	//	BLOOD
	//===================================================================================
	
	}else if($m->values['Collected Specimen Type'] == 'blood'){
		$collection_type = 'Blood';
		
		$insert = array(
			"sample_code" 					=> "'tmp_blood'", 
			"sample_control_id"				=> Config::$sample_aliquot_controls['blood']['sample_control_id'], 
			"initial_specimen_sample_id"	=> "NULL", 
			"initial_specimen_sample_type"	=> "'blood'", 
			"collection_id"					=> "'".$m->last_id."'", 
			"parent_id"						=> "NULL", 
		);
		$insert = array_merge($insert, $created);
		$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
		$sample_master_id = mysqli_insert_id(Config::$db_connection);
		$query = "UPDATE sample_masters SET sample_code=CONCAT('B - ', id), initial_specimen_sample_id=id WHERE id=".$sample_master_id;
		mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
		Database::insertRev('sample_masters', $sample_master_id);
		
		$insert = array(
			"sample_master_id"	=> $sample_master_id
		);
		$query = "INSERT INTO sd_spe_bloods (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
		Database::insertRev('sd_spe_bloods', $sample_master_id);
		
		$insert = array_merge($insert, $created);
		$query = "INSERT INTO specimen_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
		Database::insertRev('specimen_details', $sample_master_id);

		//	*** SERUM : tube ***
	
		if(strlen($m->values['Blood Precision Frozen Serum Volume (ml)']) > 0){	
			if(is_numeric($m->values['Blood Precision Frozen Serum Volume (ml)'])){
				$insert = array(
					"sample_code" 					=> "'tmp_serum'", 
					"sample_control_id"				=> Config::$sample_aliquot_controls['serum']['sample_control_id'], 
					"initial_specimen_sample_id"	=> $sample_master_id, 
					"initial_specimen_sample_type"	=> "'blood'", 
					"collection_id"					=> "'".$m->last_id."'", 
					"parent_id"						=> $sample_master_id,
					"parent_sample_type"			=>  "'blood'"
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
				$serum_sample_master_id = mysqli_insert_id(Config::$db_connection);
				$query = "UPDATE sample_masters SET sample_code=CONCAT('SER - ', id) WHERE id=".$serum_sample_master_id;
				mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
				Database::insertRev('sample_masters', $serum_sample_master_id);
				
				$insert = array(
					"sample_master_id"	=> $serum_sample_master_id
				);
				$query = "INSERT INTO sd_der_serums (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
				Database::insertRev('sd_der_serums', $serum_sample_master_id);
				
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO derivative_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
				Database::insertRev('derivative_details', $serum_sample_master_id);
				
				$insert = array(
					"aliquot_control_id"	=> Config::$sample_aliquot_controls['serum']['aliquots']['tube']['aliquot_control_id'],
					"collection_id"			=> $m->last_id,
					"sample_master_id"		=> $serum_sample_master_id,
					"in_stock"				=> "'yes - available'",
					"initial_volume"		=> "'".$m->values['Blood Precision Frozen Serum Volume (ml)']."'",
					"current_volume"		=> "'".$m->values['Blood Precision Frozen Serum Volume (ml)']."'"
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO aliquot_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
				$aliquot_master_id = mysqli_insert_id(Config::$db_connection);
				Database::insertRev('aliquot_masters', $aliquot_master_id);
		
				$insert = array(
					"aliquot_master_id"		=> $aliquot_master_id,
				);
				$query = "INSERT INTO ad_tubes (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
				Database::insertRev('ad_tubes', $aliquot_master_id);
			}  else {
				echo "WARNING: Wrong numeric value for volume [",$m->values['Blood Precision Frozen Serum Volume (ml)'],"] at line [".$m->line."]\n";
			}
		}
		
		//	*** PLASMA : tube ***
	
		if(strlen($m->values['Blood Precision Frozen Plasma Volume (ml)']) > 0){	
			if(is_numeric($m->values['Blood Precision Frozen Plasma Volume (ml)'])){
				$insert = array(
					"sample_code" 					=> "'tmp_plasma'", 
					"sample_control_id"				=> Config::$sample_aliquot_controls['plasma']['sample_control_id'], 
					"initial_specimen_sample_id"	=> $sample_master_id, 
					"initial_specimen_sample_type"	=> "'blood'", 
					"collection_id"					=> "'".$m->last_id."'", 
					"parent_id"						=> $sample_master_id,
					"parent_sample_type"			=>  "'blood'" 
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
				$plasma_sample_master_id = mysqli_insert_id(Config::$db_connection);
				$query = "UPDATE sample_masters SET sample_code=CONCAT('PLS - ', id) WHERE id=".$plasma_sample_master_id;
				mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
				Database::insertRev('sample_masters', $plasma_sample_master_id);
				
				$insert = array(
					"sample_master_id"	=> $plasma_sample_master_id
				);
				$query = "INSERT INTO sd_der_plasmas (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
				Database::insertRev('sd_der_plasmas', $plasma_sample_master_id);
				
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO derivative_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
				Database::insertRev('derivative_details', $plasma_sample_master_id);
				
				$insert = array(
					"aliquot_control_id"	=> Config::$sample_aliquot_controls['plasma']['aliquots']['tube']['aliquot_control_id'],
					"collection_id"			=> $m->last_id,
					"sample_master_id"		=> $plasma_sample_master_id,
					"in_stock"				=> "'yes - available'",
					"initial_volume"		=> "'".$m->values['Blood Precision Frozen Plasma Volume (ml)']."'",
					"current_volume"		=> "'".$m->values['Blood Precision Frozen Plasma Volume (ml)']."'"
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO aliquot_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
				$aliquot_master_id = mysqli_insert_id(Config::$db_connection);
				Database::insertRev('aliquot_masters', $aliquot_master_id);
		
				$insert = array(
					"aliquot_master_id"		=> $aliquot_master_id,
				);
				$query = "INSERT INTO ad_tubes (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
				Database::insertRev('ad_tubes', $aliquot_master_id);
			}  else {
				echo "WARNING: Wrong numeric value for volume [",$m->values['Blood Precision Frozen Plasma Volume (ml)'],"] at line [".$m->line."]\n";
			}
		}
					
		//	*** DNA : tube ***
	
		if(strlen($m->values['Blood Precision Blood DNA Volume (ug)']) > 0){
			if(is_numeric($m->values['Blood Precision Blood DNA Volume (ug)'])){
				$insert = array(
					"sample_code" 					=> "'tmp_dna'", 
					"sample_control_id"				=> Config::$sample_aliquot_controls['dna']['sample_control_id'], 
					"initial_specimen_sample_id"	=> $sample_master_id, 
					"initial_specimen_sample_type"	=> "'blood'", 
					"collection_id"					=> "'".$m->last_id."'", 
					"parent_id"						=> $sample_master_id,
					"parent_sample_type"			=>  "'blood'" 
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
				$dna_sample_master_id = mysqli_insert_id(Config::$db_connection);
				$query = "UPDATE sample_masters SET sample_code=CONCAT('DNA - ', id) WHERE id=".$dna_sample_master_id;
				mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
				Database::insertRev('sample_masters', $dna_sample_master_id);
				
				$insert = array(
					"sample_master_id"	=> $dna_sample_master_id
				);
				$query = "INSERT INTO sd_der_dnas (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
				Database::insertRev('sd_der_dnas', $dna_sample_master_id);
				
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO derivative_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
				Database::insertRev('derivative_details', $dna_sample_master_id);
				
				$insert = array(
					"aliquot_control_id"	=> Config::$sample_aliquot_controls['dna']['aliquots']['tube']['aliquot_control_id'],
					"collection_id"			=> $m->last_id,
					"sample_master_id"		=> $dna_sample_master_id,
					"in_stock"				=> "'yes - available'"
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO aliquot_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
				$aliquot_master_id = mysqli_insert_id(Config::$db_connection);
				Database::insertRev('aliquot_masters', $aliquot_master_id);
		
				$insert = array(
					"aliquot_master_id"		=> $aliquot_master_id,
					"qc_tf_weight_ug"		=> $m->values['Blood Precision Blood DNA Volume (ug)']
				);
				$query = "INSERT INTO ad_tubes (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
				Database::insertRev('ad_tubes', $aliquot_master_id);
			} else {
				echo "WARNING: Wrong numeric value for volume [",$m->values['Blood Precision Blood DNA Volume (ug)'],"] at line [".$m->line."]\n";
			}
		}
		
		//	*** BUFFY COAT : tube ***
	
		if(strlen($m->values['Blood Precision Buffy coat (ul)']) > 0){		
			if(is_numeric($m->values['Blood Precision Buffy coat (ul)'])){
				$insert = array(
					"sample_code" 					=> "'tmp_blood_cells'", 
					"sample_control_id"				=> Config::$sample_aliquot_controls['blood cell']['sample_control_id'], 
					"initial_specimen_sample_id"	=> $sample_master_id, 
					"initial_specimen_sample_type"	=> "'blood'", 
					"collection_id"					=> "'".$m->last_id."'", 
					"parent_id"						=> $sample_master_id,
					"parent_sample_type"			=>  "'blood'" 
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
				$bc_sample_master_id = mysqli_insert_id(Config::$db_connection);
				$query = "UPDATE sample_masters SET sample_code=CONCAT('BLD-C - ', id) WHERE id=".$bc_sample_master_id;
				mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
				Database::insertRev('sample_masters', $bc_sample_master_id);
				
				$insert = array(
					"sample_master_id"	=> $bc_sample_master_id
				);
				$query = "INSERT INTO sd_der_blood_cells (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
				Database::insertRev('sd_der_blood_cells', $bc_sample_master_id);
				
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO derivative_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
				Database::insertRev('derivative_details', $bc_sample_master_id);
				
				$insert = array(
					"aliquot_control_id"	=> Config::$sample_aliquot_controls['blood cell']['aliquots']['tube']['aliquot_control_id'],
					"collection_id"			=> $m->last_id,
					"sample_master_id"		=> $bc_sample_master_id,
					"in_stock"				=> "'yes - available'",
					"initial_volume"		=> "'".($m->values['Blood Precision Buffy coat (ul)']/1000)."'",
					"current_volume"		=> "'".($m->values['Blood Precision Buffy coat (ul)']/1000)."'"
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO aliquot_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
				$aliquot_master_id = mysqli_insert_id(Config::$db_connection);
				Database::insertRev('aliquot_masters', $aliquot_master_id);
	
				$insert = array(
					"aliquot_master_id"		=> $aliquot_master_id,
				);
				$query = "INSERT INTO ad_tubes (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
				Database::insertRev('ad_tubes', $aliquot_master_id);	
			} else {
				echo "WARNING: Wrong numeric value for volume [",$m->values['Blood Precision Buffy coat (ul)'],"] at line [".$m->line."]\n";
			}
		}
		
	}else{
		die("Invalid collected specimen type [".$m->values['Collected Specimen Type']."] at line [".$m->line."]");
	}
	
	// Update acquisition_label
	
	$label = $collection_type.' ('.$m->last_id.')';
	$query = "UPDATE collections SET acquisition_label = '$label' WHERE id = ".$m->last_id;
	mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
				
	if(Config::$insert_revs){
		$query = "UPDATE collections_revs SET acquisition_label = '$label' WHERE id = ".$m->last_id;
		mysqli_query(Config::$db_connection, $query) or die("update 1 in addonFunctionEnd failed (revs table)");
	}	
}

$model = new Model(5, $pkey, array(), true, NULL, NULL, 'collections', $fields);
$model->custom_data = array("date_fields" => array(
	$fields["collection_datetime"] => current(array_keys($fields["collection_datetime_accuracy"]))
)); 
$model->post_read_function = 'postCollectionRead';
$model->post_write_function = 'postCollectionWrite';

Config::$models['collections'] = $model;