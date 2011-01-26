<?php
$pkey = "Patient Biobank Number
(required)";

$fields = array(
	"bank_id" 						=> "bank_id",
	"collection_datetime" 			=> "Date of Specimen Collection Date",
	"collection_datetime_accuracy"	=> "Date of Specimen Collection Accuracy"
);


function postCollectionWrite(Model $m, $collection_id){
	global $connection;
	$created = array(
		"created"		=> "NOW()", 
		"created_by"	=> "1", 
		"modified"		=> "NOW()",
		"modified_by"	=> "1"
		);
	if($m->values['Collected Specimen Type'] == 'tissue'){
		$insert = array(
			"sample_code" 					=> "'tmp_tissue'", 
			"sample_category"				=> "'specimen'", 
			"sample_control_id"				=> "3", 
			"sample_type"					=> "'tissue'", 
			"initial_specimen_sample_id"	=> "NULL", 
			"initial_specimen_sample_type"	=> "'tissue'", 
			"collection_id"					=> "'".$collection_id."'", 
			"parent_id"						=> "NULL" 
		);
		$insert = array_merge($insert, $created);
		$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		$sample_master_id = mysqli_insert_id($connection);
		$query = "UPDATE sample_masters SET sample_code=CONCAT('T - ', id), initial_specimen_sample_id=id WHERE id=".$sample_master_id;
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
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
			$insert = array(
				"aliquot_type"			=> "'block'",
				"aliquot_control_id"	=> "4",
				"collection_id"			=> $collection_id,
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
			$insert = array(
				"aliquot_type"			=> "'block'",
				"aliquot_control_id"	=> "4",
				"collection_id"			=> $collection_id,
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
		if(is_numeric($m->values['Tissue Precision Formalin Fixed Paraffin\nEmbedded Tissues Volume (nbr blocks)'])){
			for($i = $m->values['Tissue Precision Formalin Fixed Paraffin\nEmbedded Tissues Volume (nbr blocks)']; $i > 0; ++ $i){
				$insert = array(
					"aliquot_type"			=> "'block'",
					"aliquot_control_id"	=> "4",
					"collection_id"			=> $collection_id,
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
		}
	}else if($m->values['Collected Specimen Type'] == 'ascite'){
		$insert = array(
			"sample_code" 					=> "'tmp_ascite'", 
			"sample_category"				=> "'specimen'", 
			"sample_control_id"				=> "1", 
			"sample_type"					=> "'ascite'", 
			"initial_specimen_sample_id"	=> "NULL", 
			"initial_specimen_sample_type"	=> "'ascite'", 
			"collection_id"					=> "'".$collection_id."'", 
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
			"collection_id"			=> $collection_id,
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
			"collection_id"					=> "'".$collection_id."'", 
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
		
		if(is_numeric($m->values['Blood Precision Frozen Serum Volume (ml)'])){
			$insert = array(
				"sample_code" 					=> "'tmp_serum'", 
				"sample_category"				=> "'derivative'", 
				"sample_control_id"				=> "10", 
				"sample_type"					=> "'serum'", 
				"initial_specimen_sample_id"	=> $sample_master_id, 
				"initial_specimen_sample_type"	=> "'blood'", 
				"collection_id"					=> "'".$collection_id."'", 
				"parent_id"						=> $sample_master_id, 
			);
			$insert = array_merge($insert, $created);
			$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
			mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
			$serum_sample_master_id = mysqli_insert_id($connection);
			$query = "UPDATE sample_masters SET sample_code=CONCAT('SER - ', id) WHERE id=".$sample_master_id;
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
				"collection_id"			=> $collection_id,
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
		}
		
		if(is_numeric($m->values['Blood Precision Frozen Plasma Volume (ml)'])){
			$insert = array(
				"sample_code" 					=> "'tmp_plasma'", 
				"sample_category"				=> "'derivative'", 
				"sample_control_id"				=> "9", 
				"sample_type"					=> "'plasma'", 
				"initial_specimen_sample_id"	=> $sample_master_id, 
				"initial_specimen_sample_type"	=> "'blood'", 
				"collection_id"					=> "'".$collection_id."'", 
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
				"collection_id"			=> $collection_id,
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
		}
		
		if(is_numeric($m->values['Blood Precision Blood DNA Volume (ug)'])){
			$insert = array(
				"sample_code" 					=> "'tmp_dna'", 
				"sample_category"				=> "'derivative'", 
				"sample_control_id"				=> "12", 
				"sample_type"					=> "'dna'", 
				"initial_specimen_sample_id"	=> $sample_master_id, 
				"initial_specimen_sample_type"	=> "'blood'", 
				"collection_id"					=> "'".$collection_id."'", 
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
				"collection_id"			=> $collection_id,
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
		}
		
		
	if(is_numeric($m->values['Blood Precision Buffy coat (ul)'])){
			$insert = array(
				"sample_code" 					=> "'tmp_blood_cells'", 
				"sample_category"				=> "'derivative'", 
				"sample_control_id"				=> "7", 
				"sample_type"					=> "'blood cell'", 
				"initial_specimen_sample_id"	=> $sample_master_id, 
				"initial_specimen_sample_type"	=> "'blood'", 
				"collection_id"					=> "'".$collection_id."'", 
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
				"collection_id"			=> $collection_id,
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
		}
		
		
	}else{
		die("Invalid collected specimen type");
	}
}


$tables['collections'] = new Model(5, $pkey, array(), true, NULL, 'collections', $fields);
$tables['collections']->custom_data = array("date_fields" => array(
	$fields["collection_datetime"] => $fields["collection_datetime_accuracy"]
)); 
$tables['collections']->post_read_function = 'postRead';
$tables['collections']->post_write_function = 'postCollectionWrite';

