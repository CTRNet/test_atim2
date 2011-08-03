<?php
$pkey = "Patient Biobank Number
(required)";

$fields = array(
	"bank_id" 						=> "#bank_id",
	"collection_datetime" 			=> "Date of Specimen Collection Date",
	"collection_datetime_accuracy"	=> array("Date of Specimen Collection Accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => ""))
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
	global $connection;
	$created = array(
		"created"		=> "NOW()", 
		"created_by"	=> Config::$db_created_id, 
		"modified"		=> "NOW()",
		"modified_by"	=> Config::$db_created_id
		);
	if($m->values['Collected Specimen Type'] == 'tissue'){
		$insert = array(
			"sample_code" 					=> "'tmp_tissue'", 
			"sample_category"				=> "'specimen'", 
			"sample_control_id"				=> "3", 
			"sample_type"					=> "'tissue'", 
			"initial_specimen_sample_id"	=> "NULL", 
			"initial_specimen_sample_type"	=> "'tissue'", 
			"collection_id"					=> "'".$m->last_id."'", 
			"parent_id"						=> "NULL" 
		);
		$insert = array_merge($insert, $created);
		$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		$sample_master_id = mysqli_insert_id($connection);
		$query = "UPDATE sample_masters SET sample_code=CONCAT('T - ', id), initial_specimen_sample_id=id WHERE id=".$sample_master_id;
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
		$lat_domain = Config::$value_domains['tissue_laterality'];
		$lat_value = $lat_domain->isValidValue($m->values['Tissue Precision Tissue Laterality']);
		if($lat_value === null){
			echo "WARNING: Unmatched laterality value [",$m->values['Tissue Precision Tissue Laterality'],"] at line [".$m->line."]\n";
			$m->values['Tissue Precision Tissue Laterality'] = '';
		}	

		if(!in_array($m->values['Tissue Precision Tissue Type'],Config::$tissue_source)) {
			echo "WARNING: Unmatched tissue type [",$m->values['Tissue Precision Tissue Type'],"] at line [".$m->line."]\n";
			$m->values['Tissue Precision Tissue Type'] = '';
		}

		$insert = array(
			"sample_master_id"	=> $sample_master_id,
			"tissue_source"		=> "'".$m->values['Tissue Precision Tissue Type']."'",
			"tissue_laterality"	=> "'".$m->values['Tissue Precision Tissue Laterality']."'"
		);
		$insert = array_merge($insert, $created);
		$query = "INSERT INTO sd_spe_tissues (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
		$insert = array("sample_master_id" => $sample_master_id);
		$insert = array_merge($insert, $created);
		$query = "INSERT INTO specimen_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
		if(strlen($m->values['Tissue Precision Flash Frozen Tissues  Volume']) > 0){
			$volume = is_numeric($m->values['Tissue Precision Flash Frozen Tissues  Volume']) ? $m->values['Tissue Precision Flash Frozen Tissues  Volume'] : "NULL";
			if($volume == "NULL") echo "WARNING: Wrong numeric value for volume [",$m->values['Tissue Precision Flash Frozen Tissues  Volume'],"] at line [".$m->line."]\n";
			
			$unit_domain = Config::$value_domains['qc_tf_flash_frozen_volume_unit'];
			$unit_value = $unit_domain->isValidValue($m->values['Tissue Precision Flash Frozen Tissues  Volume Unit']);
			if($unit_value === null){
				echo "WARNING: Unmatched unit value [",$m->values['Tissue Precision Flash Frozen Tissues  Volume Unit'],"] at line [".$m->line."]\n";
				$m->values['Tissue Precision Flash Frozen Tissues  Volume Unit'] = '';
			}	
			
			$insert = array(
				"aliquot_type"			=> "'block'",
				"aliquot_control_id"	=> "4",
				"collection_id"			=> $m->last_id,
				"sample_master_id"		=> $sample_master_id,
				"initial_volume"		=> $volume,
				"current_volume"		=> $volume,
				"aliquot_volume_unit"	=> "'".$m->values['Tissue Precision Flash Frozen Tissues  Volume Unit']."'"
			);			
			
			$insert = array_merge($insert, $created);
			$query = "INSERT INTO aliquot_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
			mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
			$aliquot_master_id = mysqli_insert_id($connection);
			
			$insert = array(
				"aliquot_master_id"	=> $aliquot_master_id,
				"block_type"		=> "'frozen'"
			);
			$query = "INSERT INTO ad_blocks (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
			$insert = array_merge($insert, $created);
			mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		}
		if(strlen($m->values['Tissue Precision OCT Frozen Tissues Volume (mm3)']) > 0){
			$volume = is_numeric($m->values['Tissue Precision OCT Frozen Tissues Volume (mm3)']) ? $m->values['Tissue Precision OCT Frozen Tissues Volume (mm3)'] : "NULL";
			if($volume == "NULL") echo "WARNING: Wrong numeric value for volume [",$m->values['Tissue Precision OCT Frozen Tissues Volume (mm3)'],"] at line [".$m->line."]\n";
			$insert = array(
				"aliquot_type"			=> "'block'",
				"aliquot_control_id"	=> "4",
				"collection_id"			=> $m->last_id,
				"sample_master_id"		=> $sample_master_id,
				"initial_volume"		=> $volume,
				"current_volume"		=> $volume,
				"aliquot_volume_unit"	=> "'mm3'"
			);
			$insert = array_merge($insert, $created);
			$query = "INSERT INTO aliquot_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
			mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
			$aliquot_master_id = mysqli_insert_id($connection);
			
			$insert = array(
				"aliquot_master_id"	=> $aliquot_master_id,
				"block_type"		=> "'oct'"
			);
			$query = "INSERT INTO ad_blocks (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
			$insert = array_merge($insert, $created);
			mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		}
		if(strlen($m->values["Tissue Precision Formalin Fixed Paraffin\nEmbedded Tissues Volume (nbr blocks)"]) > 0) {
			if(is_numeric($m->values["Tissue Precision Formalin Fixed Paraffin\nEmbedded Tissues Volume (nbr blocks)"])){
				for($i = $m->values["Tissue Precision Formalin Fixed Paraffin\nEmbedded Tissues Volume (nbr blocks)"]; $i > 0; -- $i){
					$insert = array(
						"aliquot_type"			=> "'block'",
						"aliquot_control_id"	=> "4",
						"collection_id"			=> $m->last_id,
						"sample_master_id"		=> $sample_master_id,
					);
					$insert = array_merge($insert, $created);
					$query = "INSERT INTO aliquot_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
					mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
					$aliquot_master_id = mysqli_insert_id($connection);
					
					$insert = array(
						"aliquot_master_id"	=> $aliquot_master_id,
						"block_type"		=> "'paraffin'"
					);
					$query = "INSERT INTO ad_blocks (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
					$insert = array_merge($insert, $created);
					mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				}
			} else {
				echo "WARNING: Wrong numeric value for volume [",$m->values["Tissue Precision Formalin Fixed Paraffin\nEmbedded Tissues Volume (nbr blocks)"],"] at line [".$m->line."]\n";
			}
		}
	}else if($m->values['Collected Specimen Type'] == 'ascite'){
		$insert = array(
			"sample_code" 					=> "'tmp_ascite'", 
			"sample_category"				=> "'specimen'", 
			"sample_control_id"				=> "1", 
			"sample_type"					=> "'ascite'", 
			"initial_specimen_sample_id"	=> "NULL", 
			"initial_specimen_sample_type"	=> "'ascite'", 
			"collection_id"					=> "'".$m->last_id."'", 
			"parent_id"						=> "NULL" 
		);
		$insert = array_merge($insert, $created);
		$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		$sample_master_id = mysqli_insert_id($connection);
		$query = "UPDATE sample_masters SET sample_code=CONCAT('A - ', id), initial_specimen_sample_id=id WHERE id=".$sample_master_id;
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
		$insert = array(
			"sample_master_id"	=> $sample_master_id
		);
		$insert = array_merge($insert, $created);
		$query = "INSERT INTO sd_spe_ascites (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		$query = "INSERT INTO specimen_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
		
		$insert = array(
			"aliquot_type"			=> "'tube'",
			"aliquot_control_id"	=> "2",
			"collection_id"			=> $m->last_id,
			"sample_master_id"		=> $sample_master_id,
			"initial_volume"		=> "'".$m->values['Ascite Precision Ascites Fluids Volume (ml)']."'",
			"current_volume"		=> "'".$m->values['Ascite Precision Ascites Fluids Volume (ml)']."'",
			"aliquot_volume_unit"	=> "'ml'"
		);
		$insert = array_merge($insert, $created);
		$query = "INSERT INTO aliquot_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		$aliquot_master_id = mysqli_insert_id($connection);
		$query = "UPDATE aliquot_masters SET barcode=id WHERE id=".$aliquot_master_id;
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
		$insert = array(
			"aliquot_master_id"		=> $aliquot_master_id,
		);
		$insert = array_merge($insert, $created);
		$query = "INSERT INTO ad_tubes (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
	}else if($m->values['Collected Specimen Type'] == 'blood'){
		//blood
		$insert = array(
			"sample_code" 					=> "'tmp_blood'", 
			"sample_category"				=> "'specimen'", 
			"sample_control_id"				=> "2", 
			"sample_type"					=> "'blood'", 
			"initial_specimen_sample_id"	=> "NULL", 
			"initial_specimen_sample_type"	=> "'blood'", 
			"collection_id"					=> "'".$m->last_id."'", 
			"parent_id"						=> "NULL", 
		);
		$insert = array_merge($insert, $created);
		$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		$sample_master_id = mysqli_insert_id($connection);
		$query = "UPDATE sample_masters SET sample_code=CONCAT('B - ', id), initial_specimen_sample_id=id WHERE id=".$sample_master_id;
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
		$insert = array(
			"sample_master_id"	=> $sample_master_id
		);
		$insert = array_merge($insert, $created);
		$query = "INSERT INTO sd_spe_ascites (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		$query = "INSERT INTO specimen_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

		if(strlen($m->values['Blood Precision Frozen Serum Volume (ml)']) > 0){	
			if(is_numeric($m->values['Blood Precision Frozen Serum Volume (ml)'])){
				$insert = array(
					"sample_code" 					=> "'tmp_serum'", 
					"sample_category"				=> "'derivative'", 
					"sample_control_id"				=> "10", 
					"sample_type"					=> "'serum'", 
					"initial_specimen_sample_id"	=> $sample_master_id, 
					"initial_specimen_sample_type"	=> "'blood'", 
					"collection_id"					=> "'".$m->last_id."'", 
					"parent_id"						=> $sample_master_id, 
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				$serum_sample_master_id = mysqli_insert_id($connection);
				$query = "UPDATE sample_masters SET sample_code=CONCAT('SER - ', id) WHERE id=".$serum_sample_master_id;
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				
				$insert = array(
					"sample_master_id"	=> $serum_sample_master_id
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO sd_der_serums (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				$query = "INSERT INTO derivative_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				
				$insert = array(
					"aliquot_type"			=> "'tube'",
					"aliquot_control_id"	=> "8",
					"collection_id"			=> $m->last_id,
					"sample_master_id"		=> $serum_sample_master_id,
					"initial_volume"		=> "'".$m->values['Blood Precision Frozen Serum Volume (ml)']."'",
					"current_volume"		=> "'".$m->values['Blood Precision Frozen Serum Volume (ml)']."'",
					"aliquot_volume_unit"	=> "'ml'"
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO aliquot_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				$aliquot_master_id = mysqli_insert_id($connection);
				$query = "UPDATE aliquot_masters SET barcode=id WHERE id=".$aliquot_master_id;
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				
				$insert = array(
					"aliquot_master_id"		=> $aliquot_master_id,
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO ad_tubes (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
			}  else {
				echo "WARNING: Wrong numeric value for volume [",$m->values['Blood Precision Frozen Serum Volume (ml)'],"] at line [".$m->line."]\n";
			}
		}
		
		if(strlen($m->values['Blood Precision Frozen Plasma Volume (ml)']) > 0){	
			if(is_numeric($m->values['Blood Precision Frozen Plasma Volume (ml)'])){
				$insert = array(
					"sample_code" 					=> "'tmp_plasma'", 
					"sample_category"				=> "'derivative'", 
					"sample_control_id"				=> "9", 
					"sample_type"					=> "'plasma'", 
					"initial_specimen_sample_id"	=> $sample_master_id, 
					"initial_specimen_sample_type"	=> "'blood'", 
					"collection_id"					=> "'".$m->last_id."'", 
					"parent_id"						=> $sample_master_id, 
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				$plasma_sample_master_id = mysqli_insert_id($connection);
				$query = "UPDATE sample_masters SET sample_code=CONCAT('PLS - ', id) WHERE id=".$plasma_sample_master_id;
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				
				$insert = array(
					"sample_master_id"	=> $plasma_sample_master_id
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO sd_der_plasmas (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				$query = "INSERT INTO derivative_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				
				$insert = array(
					"aliquot_type"			=> "'tube'",
					"aliquot_control_id"	=> "8",
					"collection_id"			=> $m->last_id,
					"sample_master_id"		=> $plasma_sample_master_id,
					"initial_volume"		=> "'".$m->values['Blood Precision Frozen Plasma Volume (ml)']."'",
					"current_volume"		=> "'".$m->values['Blood Precision Frozen Plasma Volume (ml)']."'",
					"aliquot_volume_unit"	=> "'ml'"
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO aliquot_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				$aliquot_master_id = mysqli_insert_id($connection);
				$query = "UPDATE aliquot_masters SET barcode=id WHERE id=".$aliquot_master_id;
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				
				$insert = array(
					"aliquot_master_id"		=> $aliquot_master_id,
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO ad_tubes (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
			}  else {
				echo "WARNING: Wrong numeric value for volume [",$m->values['Blood Precision Frozen Plasma Volume (ml)'],"] at line [".$m->line."]\n";
			}
		}
			
		if(strlen($m->values['Blood Precision Blood DNA Volume (ug)']) > 0){
			if(is_numeric($m->values['Blood Precision Blood DNA Volume (ug)'])){
				$insert = array(
					"sample_code" 					=> "'tmp_dna'", 
					"sample_category"				=> "'derivative'", 
					"sample_control_id"				=> "12", 
					"sample_type"					=> "'dna'", 
					"initial_specimen_sample_id"	=> $sample_master_id, 
					"initial_specimen_sample_type"	=> "'blood'", 
					"collection_id"					=> "'".$m->last_id."'", 
					"parent_id"						=> $sample_master_id, 
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				$dna_sample_master_id = mysqli_insert_id($connection);
				$query = "UPDATE sample_masters SET sample_code=CONCAT('DNA - ', id) WHERE id=".$dna_sample_master_id;
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				
				$insert = array(
					"sample_master_id"	=> $dna_sample_master_id
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO sd_der_dnas (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				$query = "INSERT INTO derivative_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				
				$insert = array(
					"aliquot_type"			=> "'tube'",
					"aliquot_control_id"	=> "8",
					"collection_id"			=> $m->last_id,
					"sample_master_id"		=> $dna_sample_master_id,
					"initial_volume"		=> "'".$m->values['Blood Precision Blood DNA Volume (ug)']."'",
					"current_volume"		=> "'".$m->values['Blood Precision Blood DNA Volume (ug)']."'",
					"aliquot_volume_unit"	=> "'ug'"
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO aliquot_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				$aliquot_master_id = mysqli_insert_id($connection);
				$query = "UPDATE aliquot_masters SET barcode=id WHERE id=".$aliquot_master_id;
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				
				$insert = array(
					"aliquot_master_id"		=> $aliquot_master_id,
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO ad_tubes (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
			} else {
				echo "WARNING: Wrong numeric value for volume [",$m->values['Blood Precision Blood DNA Volume (ug)'],"] at line [".$m->line."]\n";
			}
		}
		
		if(strlen($m->values['Blood Precision Buffy coat (ul)']) > 0){		
			if(is_numeric($m->values['Blood Precision Buffy coat (ul)'])){
					$insert = array(
						"sample_code" 					=> "'tmp_blood_cells'", 
						"sample_category"				=> "'derivative'", 
						"sample_control_id"				=> "7", 
						"sample_type"					=> "'blood cell'", 
						"initial_specimen_sample_id"	=> $sample_master_id, 
						"initial_specimen_sample_type"	=> "'blood'", 
						"collection_id"					=> "'".$m->last_id."'", 
						"parent_id"						=> $sample_master_id, 
					);
					$insert = array_merge($insert, $created);
					$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
					mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
					$bc_sample_master_id = mysqli_insert_id($connection);
					$query = "UPDATE sample_masters SET sample_code=CONCAT('BLD-C - ', id) WHERE id=".$bc_sample_master_id;
					mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
					
					$insert = array(
						"sample_master_id"	=> $bc_sample_master_id
					);
					$insert = array_merge($insert, $created);
					$query = "INSERT INTO sd_der_blood_cells (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
					mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
					$query = "INSERT INTO derivative_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
					mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
					
					$insert = array(
						"aliquot_type"			=> "'tube'",
						"aliquot_control_id"	=> "8",
						"collection_id"			=> $m->last_id,
						"sample_master_id"		=> $bc_sample_master_id,
						"initial_volume"		=> "'".$m->values['Blood Precision Buffy coat (ul)']."'",
						"current_volume"		=> "'".$m->values['Blood Precision Buffy coat (ul)']."'",
						"aliquot_volume_unit"	=> "'ug'"
					);
					$insert = array_merge($insert, $created);
					$query = "INSERT INTO aliquot_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
					mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
					$aliquot_master_id = mysqli_insert_id($connection);
					$query = "UPDATE aliquot_masters SET barcode=id WHERE id=".$aliquot_master_id;
					mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
					
					$insert = array(
						"aliquot_master_id"		=> $aliquot_master_id,
					);
					$insert = array_merge($insert, $created);
					$query = "INSERT INTO ad_tubes (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
					mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				} else {
				echo "WARNING: Wrong numeric value for volume [",$m->values['Blood Precision Buffy coat (ul)'],"] at line [".$m->line."]\n";
			}
		}
		
		
	}else{
		die("Invalid collected specimen type");
	}
}


$model = new Model(5, $pkey, array(), true, NULL, NULL, 'collections', $fields);
$model->custom_data = array("date_fields" => array(
	$fields["collection_datetime"] => current(array_keys($fields["collection_datetime_accuracy"]))
)); 
$model->post_read_function = 'postCollectionRead';
$model->post_write_function = 'postCollectionWrite';

Config::$models['collections'] = $model;