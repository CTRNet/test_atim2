<?php
$pkey = "NS";

$child = array('ConsentMaster','DiagnosisMaster','PathoMiscIdentfier','DosMiscIdentfier','MdeieMiscIdentfier');
$fields = array(
	"participant_identifier" => "NS", 
	"date_of_birth" => "DN",
	"vital_status" => array("CT" => 
		array(
			"" => "",
			"O" => "alive",
			"*DCD" => "deceased",
			"DCD" => "deceased",
			"*O" => "alive",
			"N" => "",
			"O*" => "alive",
			"O                       O" => "alive")));

//see the Model class definition for more info
$model = new Model(0, $pkey, $child, false, NULL, NULL, 'participants', $fields);

//we can then attach post read/write functions
$model->post_read_function = 'postParticipantRead';
$model->post_write_function = 'createParticipantCollections';

$model->custom_data = array(
	"date_fields" => array(
		$fields["date_of_birth"] => null
	) 
);

//adding this model to the config
Config::$models['Participant'] = $model;

function postParticipantRead(Model $m){
	$set_1448_date = false;	
	if(($m->values['NS'] == '1448') && ($m->values['DN'] == '1944')) {
		$set_1448_date = true;	
		echo "<br><FONT COLOR=\"green\" >WARNING: Line ".$m->line." [DN][WARNING]: DN has been hard-coded to '1905-04-27' check date into atim for NS = 1448!</FONT><br>";						
		$m->values['DN'] = '';
	}

	excelDateFix($m);
	
	if($set_1448_date) $m->values['DN'] = '1905-04-27';
	
	return true;
}

function createParticipantCollections(Model $m){
	$participant_id = $m->last_id;
	$line =  $m->line;
	$inventory_data_from_file =  $m->values;
	$ns = $inventory_data_from_file['NS'];
	
	$collections = array();
	$warning_messages = array('high'=>array(), 'medium'=>array(), 'low'=>array());
	
	//Get Spent Time
	
	$spent_time = array('default' => null, 'details' => array());
	$spent_time_data = $inventory_data_from_file[utf8_decode('Délais chir.')];
	if(!empty($spent_time_data)) {
		$times = explode('/', strtoupper(str_replace(' ', '', $spent_time_data)));
		foreach($times as $new) {
			$value = '';
			$unit = '';
			$tissue = '';
			
			$new = str_replace('-','', $new);
			$new = str_replace('JOURS','JOUR', $new);
			
			preg_match('/([0-9]+JOUR)/', $new, $matches_day);	
			preg_match('/([0-9]+H)/', $new, $matches_hour);	
			preg_match('/([0-9]+MIN\.)/', $new, $matches_mn);	
			
			if(!empty($matches_day)) {
				if(sizeof($matches_day) != 2) { pr($matches_day);die('spent_time_data_a1'); }
				$value = str_replace('JOUR', '', $matches_day[0]);
				$unit = 'd';
				$tissue = str_replace($matches_day[0], '', $new);
				
			} else if(!empty($matches_hour)) {
				if(sizeof($matches_hour) != 2)  {  pr($matches_hour);die('spent_time_data_a2'); }
				$value = str_replace('H', '', $matches_hour[0]);
				$unit = 'h';
				$tissue = str_replace($matches_hour[0], '', $new);
				
			} else if(!empty($matches_mn)) {
				if(sizeof($matches_mn) != 2) {  pr($matches_mn);die('spent_time_data_a3'); }
				$value = str_replace('MIN.', '', $matches_mn[0]);
				$unit = 'mn';
				$tissue = str_replace($matches_mn[0], '', $new);
			
			} else {
				echo"<pre>$new";
				print_r($times);
				die('spent_time_data_98466733');
			} 
		
			if(empty($tissue)) {
				if(!empty($spent_time['default'])) { die('spent_time_data_3131313'); }
				$spent_time['default'] = array('value' => $value, 'unit' => $unit);
			} else {
				if(!empty($spent_time['default'])) { die('spent_time_data_3131313'); }
				if(isset($spent_time['details'][$tissue])) {
					$warning_messages['medium'][] = "Spent time defined twice for tissue ($tissue)!";
				} else {
					$spent_time['details'][$tissue] = array('value' => $value, 'unit' => $unit);
				}
			}
		}	
	}

	// ------------------------------------------------------------------------------
	// [TISSUS] : sample => tissue --------------------------------------------------
	
	$tissu_cell_data = $inventory_data_from_file['TISSUS'];
	if(!empty($tissu_cell_data)) {
		$tissues = explode(',', strtoupper(str_replace(' ', '', $tissu_cell_data)));
		foreach($tissues as $new_tissue) {
			preg_match('/^([0-9]+)/',  $new_tissue, $matches);
			$nbr_of_tissues_to_create = isset($matches[1])?  $matches[1] : 1;
			$new_tissue = str_replace($nbr_of_tissues_to_create,'', $new_tissue);
			
			while($nbr_of_tissues_to_create) {
				if(!empty($new_tissue)) {
					if(array_key_exists($new_tissue, Config::$tissueCodeSynonimous)) $new_tissue = Config::$tissueCodeSynonimous[$new_tissue];
					if(array_key_exists($new_tissue, Config::$tissueCode2Details)) {
						$suffix = '';
						
						if(array_key_exists($new_tissue, $collections)) {
							$suffix_counter = 1;
							while(array_key_exists($new_tissue.$suffix, $collections)) {
								$suffix = '###'.$suffix_counter.'###';
								$suffix_counter++;
							}	
							$warning_messages['low'][] = "Tissue code {$new_tissue} is created at least twice (see column TISSUS).";						
						}
						$collections[$new_tissue.$suffix] = array('type' => 'tissue', 'details' => Config::$tissueCode2Details[$new_tissue], 'aliquots' => array(), 'derivatives' => array());
						
					}else {
						$warning_messages['high'][] = "Tissue code {$new_tissue} is unknown (see column TISSUS & tissueCode2Details).";
					}
				}
				$nbr_of_tissues_to_create--;
			}
		}
	} 
	
	//--- End of TISSUS
	
	// --------------------------------------------------------------------------
	// [OCT] + [N0 BOÎTE OCT] : sample => tissue , aliquot => oct block ---------
	$aliquot_type = 'oct block';
	
	$oct_cell_data = $inventory_data_from_file['OCT'];
	if(!empty($oct_cell_data)) {
		//Get all different types of source
		$oct_cell_data = str_replace( array(" ", "OCT/", "/"), array("", "", ","), strtoupper($oct_cell_data));
		$oct_cell_data = preg_replace('/^(.+)\,$/', '$1', $oct_cell_data);
		$oct_sources = explode(',', $oct_cell_data);

		// Set boxes array per source types
		$boxes = explode(',', str_replace(array(" ", "/", "."), array("", ",", ","), $inventory_data_from_file[utf8_decode('N0 BOÎTE OCT')]));
		$boxes =(empty($boxes))? array('') : $boxes;
		if(sizeof($boxes) == 1) { for($i = 1; $i < sizeof($oct_sources); $i++) { $boxes[] = $boxes[0]; } }	
		if(sizeof($boxes) != sizeof($oct_sources)) die("<br><FONT COLOR=\"red\" >Line ".$m->line." / NS = $ns [OCT][ERROR] 1: The box definitions [".$inventory_data_from_file[utf8_decode('N0 BOÎTE OCT')]."] does not match the oct defintion [".$inventory_data_from_file['OCT']."] (check wrong coma, etc).</FONT><br>"); 
		
		// Set product
		foreach($oct_sources as $new_source) {
			preg_match('/^([0-9]+)/',  $new_source, $matches);
			$nbr_of_aliquots_to_create = isset($matches[1])? $matches[1] : 1;
			$new_source = str_replace($nbr_of_aliquots_to_create,'', $new_source);
			
			if(array_key_exists($new_source, Config::$tissueCodeSynonimous)) $new_source = Config::$tissueCodeSynonimous[$new_source];
			if(!array_key_exists($new_source, Config::$tissueCode2Details)) {
				$warning_messages['high'][] = "Parent type '$new_source' of an oct tube is not supported. (see column OCT & tissueCode2Details). Defined tissue code as 'AP' for the block to temporary solve the issue.";
				$new_source = 'AP';	
			}
				
			if(!array_key_exists($new_source, $collections)) {
				//Create parent
				$warning_messages['low'][] = "Created parent '$new_source' for an 'OCT tube' value (see OCT column) because this one does not exist into 'TISSUS' column.";
				$collections[$new_source] = array('type' => 'tissue', 'details' => Config::$tissueCode2Details[$new_source], 'aliquots' => array(), 'derivatives' => array());
			}

			$box = array_shift($boxes);
			if(is_null($box)) die('ERR0098373');
			preg_match('/^([0-9]+)$/', $box, $matches);
			if(!empty($box) && !isset($matches[1]) && $box != 'WRONG_BOX') $warning_messages['medium'][] = "OCT box value [$box] looks like wrong (not numeric - see 'N0 BOÎTE OCT' column).";
			while($nbr_of_aliquots_to_create) { 
				$collections[$new_source]['aliquots'][] = array('type' =>$aliquot_type, 'storage' => $box); 
				$nbr_of_aliquots_to_create--;
			}
		}
	}
	
	//--- End of OCT
	
	// --------------------------------------------------------------------------
	// [TISSU] + [N0 BOÎTE TISSU] : sample => tissue , aliquot => frozen tube ---------
	$aliquot_type = 'frozen tube';
	
	$tissu_cell_data = $inventory_data_from_file['TISSU'];
	if(!empty($tissu_cell_data)) {
		//Get all different types of source
		$tissu_cell_data = str_replace( array(" ", "T/", "/"), array("", "", ","), strtoupper($tissu_cell_data));
		$tissu_cell_data = preg_replace('/^(.+)\,$/', '$1', $tissu_cell_data);
		$tissue_sources = explode(',', $tissu_cell_data);

		// Set boxes array per source types
		$boxes = explode(',', str_replace(array(" ", "/", ".", "-"), array("", ",", ",", ","), $inventory_data_from_file[utf8_decode('N0 BOÎTE TISSU')]));
		$boxes =(empty($boxes))? array('') : $boxes;
		if(sizeof($boxes) == 1) { for($i = 1; $i < sizeof($tissue_sources); $i++) { $boxes[] = $boxes[0]; } }	
		if(sizeof($boxes) != sizeof($tissue_sources)) {
			$warning_messages['high'][] = "The box definitions [".$inventory_data_from_file[utf8_decode('N0 BOÎTE TISSU')]."] (from 'N0 BOÎTE TISSU' column) does not match the tissue data [".$inventory_data_from_file['TISSU']."] (defined into 'TISSU' column) : Check wrong coma, '/', '.', etc. Created box with label 'WRONG_BOX' to temporary solve the issue.";
			$boxes = array('WRONG_BOX');
			for($i = 1; $i < sizeof($tissue_sources); $i++) { $boxes[] = $boxes[0];	}		
		}
		
		// Set product
		foreach($tissue_sources as $new_source) {
			preg_match('/^([0-9]+)/',  $new_source, $matches);
			$nbr_of_aliquots_to_create = isset($matches[1])? $matches[1] : 1;
			$new_source = str_replace($nbr_of_aliquots_to_create,'', $new_source);
			
			if(array_key_exists($new_source, Config::$tissueCodeSynonimous)) $new_source = Config::$tissueCodeSynonimous[$new_source];
			if(!array_key_exists($new_source, Config::$tissueCode2Details)) {
				$warning_messages['high'][] = "Tissue code {$new_source} is unknown for a tissue tube (see column TISSU & tissueCode2Details). Defined tissue code as 'AP' for the tube to temporary solve the issue.";
				$new_source = 'AP';			
			}	
			if(!array_key_exists($new_source, $collections)) {
				//Create parent
				$warning_messages['low'][] = "Created parent '$new_source' for a tissue tube value (see TISSU column) because this one is not already defined by the content of the 'OCT' or 'TISSUS' columns.";
				$collections[$new_source] = array('type' => 'tissue', 'details' => Config::$tissueCode2Details[$new_source], 'aliquots' => array(), 'derivatives' => array());
			}

			$box = array_shift($boxes);
			if(is_null($box)) die('ERR0098374');
			preg_match('/^([0-9]+)$/', $box, $matches);
			if(!empty($box) && !isset($matches[1]) && $box != 'WRONG_BOX') $warning_messages['medium'][] = "Tissue box value [$box] looks like wrong (not numeric - see 'N0 BOÎTE TISSU' column).";
			while($nbr_of_aliquots_to_create) { 
				$collections[$new_source]['aliquots'][] = array('type' =>$aliquot_type, 'storage' => $box); 
				$nbr_of_aliquots_to_create--;
			}
		}
	}	
	
	//--- End of TISSU	
	
	// --------------------------------------------------------------------------
	// [FFPE] + [N0 BOÎTE FFPE] : sample => tissue , aliquot => paraffin block --
	$aliquot_type = 'paraffin block';
	
	$ffpe_cell_data = $inventory_data_from_file['FFPE'];
	if(!empty($ffpe_cell_data)) {
		//Get all different types of source
		$ffpe_cell_data = str_replace( array(" ", "P/,", "P/", "/"), array("", "", "", ","), strtoupper($ffpe_cell_data));
		$ffpe_cell_data = preg_replace('/^(.+)\,$/', '$1', $ffpe_cell_data);
		$ffpe_sources = explode(',', $ffpe_cell_data);

		// Set boxes array per source types
		$boxes = explode(',', str_replace(array(" ", "/", "."), array("", ",", ","), $inventory_data_from_file[utf8_decode('N0 BOÎTE FFPE')]));
		$boxes =(empty($boxes))? array('') : $boxes;
		if(sizeof($boxes) == 1) { for($i = 1; $i < sizeof($ffpe_sources); $i++) { $boxes[] = $boxes[0]; } }	
		if(sizeof($boxes) != sizeof($ffpe_sources)) die("<br><FONT COLOR=\"red\" >Line ".$m->line." / NS = $ns [FFPE][ERROR] 1: The box definitions [".$inventory_data_from_file[utf8_decode('N0 BOÎTE FFPE')]."] does not match the ffpe defintion [".$inventory_data_from_file['FFPE']."] (check wrong coma, etc).</FONT><br>"); 
		
		// Set product
		foreach($ffpe_sources as $new_source) {
			preg_match('/^([0-9]+)/',  $new_source, $matches);
			$nbr_of_aliquots_to_create = isset($matches[1])? $matches[1] : 1;
			$new_source = str_replace($nbr_of_aliquots_to_create,'', $new_source);
			
			if(array_key_exists($new_source, Config::$tissueCodeSynonimous)) $new_source = Config::$tissueCodeSynonimous[$new_source];
			if(!array_key_exists($new_source, Config::$tissueCode2Details)) die("<br><FONT COLOR=\"red\" >Line ".$m->line." / NS = $ns [FFPE][ERROR]: Parent type '$new_source' of an ffpe tube is not supported.</FONT><br>");
				
			if(!array_key_exists($new_source, $collections)) {
				//Create parent
				$warning_messages['low'][] = "Created parent '$new_source' for a ffpe tube value (see TISSU column) because this one is not already defined by the content of the previous columns like OCT', 'TISSUS', etc.";
				$collections[$new_source] = array('type' => 'tissue', 'details' => Config::$tissueCode2Details[$new_source], 'aliquots' => array(), 'derivatives' => array());
			}

			$box = array_shift($boxes);
			if(is_null($box)) die('ERR0098376');
			preg_match('/^([0-9]+)$/', $box, $matches);
			if(!empty($box) && !isset($matches[1]) && $box != 'WRONG_BOX') $warning_messages['medium'][] = "FFPE box value [$box] looks like wrong (not numeric - see 'N0 BOÎTE FFPE' column).";
			while($nbr_of_aliquots_to_create) { 
				$collections[$new_source]['aliquots'][] = array('type' =>$aliquot_type, 'storage' => $box); 
				$nbr_of_aliquots_to_create--;
			}
		}
	}
	
	//--- End of FFPE	
	
	// -----------------------------------------------------------------------------------------------------------------
	// [SANG-PLASMA-SÉRUM- CULOT ENRICHI ] + blood_file_data : sample => blood,etc , aliquot => tube (+/- description) -
	$aliquot_type = 'paraffin block';
	
	$merged_blood_data = array_key_exists($ns, Config::$bloodBoxesData)? Config::$bloodBoxesData[$ns] : array();
	unset(Config::$bloodBoxesData[$ns]);

	$blood_cell_data = $inventory_data_from_file[utf8_decode('SANG-PLASMA-SÉRUM- CULOT ENRICHI ')];
	if(!empty($blood_cell_data) || !empty($merged_blood_data)) {

		if(!empty($blood_cell_data)) {
			// Merge data from box worksheet witht data of main worksheet
			$blood_cell_data = str_replace(array(" ", 'sang', 'RNAlater'), array("", 'Sang', 'RL'), $blood_cell_data);
			$blood_cell_data = preg_replace('/^(.+)\,$/', '$1', $blood_cell_data);
			$blood_data_from_all_file = explode(',', $blood_cell_data);		

			foreach($blood_data_from_all_file as $new_blood_type) {
				preg_match('/^([0-9]+)/',  $new_blood_type, $matches);
				$nbr_of_aliquots_to_create = isset($matches[1])? $matches[1] : 1;
				$new_blood_type = str_replace($nbr_of_aliquots_to_create,'', $new_blood_type);
				if(!in_array($new_blood_type, array('Sang', 'P', 'CE', 'S', 'RL', 'ARLT'))) die("<br><FONT COLOR=\"red\" >Line ".$m->line." / NS = $ns [SANG][ERROR]: Blood type '$new_blood_type' is not supported.</FONT><br>");
				
				if(isset($merged_blood_data[$new_blood_type]) && sizeof($merged_blood_data[$new_blood_type]) == $nbr_of_aliquots_to_create) {
					// Same data into the 2 worksheets.... nothing to do
				} else if(isset($merged_blood_data[$new_blood_type]) && sizeof($merged_blood_data[$new_blood_type]) != $nbr_of_aliquots_to_create) {
 					$nbr_to_add = $nbr_of_aliquots_to_create - sizeof($merged_blood_data[$new_blood_type]);
					$nbr_to_add = ($nbr_to_add < 0)? 0 : $nbr_to_add;
					$warning_messages['medium'][] = "Nbr of [$new_blood_type] is not the same into the 2 sent worksheets (blood boxes worksheet and main file column 'SANG-PLASMA-SÉRUM- CULOT ENRICHI ' : ".sizeof($merged_blood_data[$new_blood_type])." != $nbr_of_aliquots_to_create). Will add $nbr_to_add tubes in no box.";
						
					while($nbr_to_add) {
						$merged_blood_data[$new_blood_type][] = array('box' => '');
						$nbr_to_add--;
					}		
				} else {
					$nbr_to_add = $nbr_of_aliquots_to_create;
					while($nbr_to_add) {
						$merged_blood_data[$new_blood_type][] = array('box' => '');
						$nbr_to_add--;
					}
				}
			}
		}		
		
		//Set Product
		foreach($merged_blood_data as $product_type => $aliquots) {
			// Build aliquot array
			$aliquot_type = ($product_type == 'RL')? 'RNALater tube': 'tube';
			$aliquots_array = array();
			foreach ($aliquots as $new_aliquot) {
				$aliquots_array[] = array('type' =>$aliquot_type,'storage' => $new_aliquot['box']);
			}
			
			// Add blood
			if(!isset($collections['blood'])) $collections['blood'] = array('type' => 'blood', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
			
			switch($product_type) {
				case 'Sang':
				case 'RL':
					$collections['blood']['aliquots'] = array_merge($collections['blood']['aliquots'], $aliquots_array);
					break;
				case 'P':
					if(!isset($collections['blood']['derivatives']['plasma'])) $collections['blood']['derivatives']['plasma'] = array('type' => 'plasma', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
					$collections['blood']['derivatives']['plasma']['aliquots'] = array_merge($collections['blood']['derivatives']['plasma']['aliquots'], $aliquots_array);						
					break;
				case 'S':
					if(!isset($collections['blood']['derivatives']['serum'])) $collections['blood']['derivatives']['serum'] = array('type' => 'serum', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
					$collections['blood']['derivatives']['serum']['aliquots'] = array_merge($collections['blood']['derivatives']['serum']['aliquots'], $aliquots_array);						
					break;
				case 'CE':
					if(!isset($collections['blood']['derivatives']['blood cell'])) $collections['blood']['derivatives']['blood cell'] = array('type' => 'blood cell', 'details' => null, 'aliquots' => array(), 'derivatives' => array());						
					$collections['blood']['derivatives']['blood cell']['aliquots'] = array_merge($collections['blood']['derivatives']['blood cell']['aliquots'], $aliquots_array);						
					break;
				case 'ARLT':
//TODO see 4
					if(!isset($collections['blood']['derivatives']['blood cell (arlt)'])) $collections['blood']['derivatives']['blood cell (arlt)'] = array('type' => 'blood cell (arlt)', 'details' => null, 'aliquots' => array(), 'derivatives' => array());						
					$collections['blood']['derivatives']['blood cell (arlt)']['aliquots'] = array_merge($collections['blood']['derivatives']['blood cell (arlt)']['aliquots'], $aliquots_array);						
					break;							
				default:
					die("<br><FONT COLOR=\"red\" >Line ".$m->line." [blood_file][ERROR]: blood sample '$product_type' is not supported. </FONT><br>");		
			}			
		}
	}
	
	//--- End of SANG		
	
	// ---------------------------------------------------------------------------------------------------------
	// [ASCITE] + [NO BÔITE ASC,S, RNALATER] + [NO BÔTE ASCITE (NC)] : sample => ascite,LP , aliquot => tube --
	
//TODO see 5

	$ascite_cell_data = $inventory_data_from_file['ASCITE'];
	$ascite_boxes_cell_data = $inventory_data_from_file[utf8_decode('NO BÔITE ASC,S, RNALATER')];
	$nc_boxes_cell_data = $inventory_data_from_file[utf8_decode('NO BÔTE ASCITE (NC)')];
	
	if(!empty($ascite_cell_data)) {
		$ascite_cell_data = str_replace(' ', '', $ascite_cell_data);
		
		// MANAGE NC
		$nc_tubes_nbrs = 0;
		$ncs_string = '';
		preg_match('/([0-9]*NC)+/',  $ascite_cell_data, $matches);
		if(isset($matches[1]))  {
			$ncs_string = $matches[1];
			preg_match('/^([0-9]+)/',  $ncs_string, $matches);
			$nc_tubes_nbrs = isset($matches[1])? $matches[1] : 1;
		}
		$ascite_cell_data_without_nc =  str_replace(array($ncs_string, ',,'), array('', ','), $ascite_cell_data);
		if($nc_tubes_nbrs) {
			preg_match('/^([0-9]+)$/',  $nc_boxes_cell_data, $matches);
			if(!empty($nc_boxes_cell_data) && !isset($matches[1]) && $nc_boxes_cell_data != 'WRONG_BOX') $warning_messages['medium'][] = "NC box value [$nc_boxes_cell_data] looks like wrong (not numeric - see 'NO BÔTE ASCITE (NC)' column).";
			$nc_box = $nc_boxes_cell_data;

			if(!isset($collections['ascite'])) $collections['ascite'] = array('type' => 'ascite', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
			if(!isset($collections['ascite']['derivatives']['ascite cell'])) $collections['ascite']['derivatives']['ascite cell'] = array('type' => 'ascite cell', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
			
			while($nc_tubes_nbrs) { 
				$collections['ascite']['derivatives']['ascite cell']['aliquots'][] = array('type' =>'tube', 'storage' => $nc_box); 
				$nc_tubes_nbrs--;
			}
		}
		
		// MANAGE ASCITE WITHOUT NC
		$ascite_cell_data_without_nc = preg_replace('/^(.+)\,$/', '$1', $ascite_cell_data_without_nc);
		if(!empty($ascite_cell_data_without_nc)) {

			$ascite_without_ncs = explode(',', $ascite_cell_data_without_nc);
			
			// Set boxes array
			$boxes = explode(',', str_replace(array(" ", "/", "."), array("", ",", ","), $ascite_boxes_cell_data));
			$boxes =(empty($boxes))? array('') : $boxes;
			if(sizeof($boxes) == 1) { for($i = 1; $i < sizeof($ascite_without_ncs); $i++) { $boxes[] = $boxes[0]; } }	
			if(sizeof($boxes) != sizeof($ascite_without_ncs)) 
			{
				$warning_messages['high'][] = "The box definitions [".$inventory_data_from_file[utf8_decode('NO BÔITE ASC,S, RNALATER')]."] (from 'NO BÔITE ASC,S, RNALATER' column) does not match the ascite defintion [".$inventory_data_from_file['ASCITE']."] (defined into 'ASCITE' column) ". empty($nc_boxes_cell_data)? '' : "(considering NC box has been deifined [$nc_boxes_cell_data] into 'NO BÔTE ASCITE (NC)' column)"." : Check wrong coma, '/', '.', etc. Created box with label 'WRONG_BOX' to temporary solve the issue.";
				$boxes = array('WRONG_BOX');
				for($i = 1; $i < sizeof($ascite_without_ncs); $i++) { $boxes[] = $boxes[0];	}	
			}
							
			// Set product
			foreach($ascite_without_ncs as $new_source) {
				preg_match('/^([0-9]+)/',  $new_source, $matches);
				$nbr_of_aliquots_to_create = isset($matches[1])? $matches[1] : 1;
				$new_source = str_replace($nbr_of_aliquots_to_create,'', $new_source);
				
				$box = array_shift($boxes);
				if(is_null($box)) die('ERR0098373332');
				
				$aliquots = array();
				while($nbr_of_aliquots_to_create) { 
					$aliquots[] = array('type' =>'tube','storage' => $box); 
					$nbr_of_aliquots_to_create--;
				}
							
				if(in_array($new_source, array('SASC','ASC'))) {
					if(!isset($collections['ascite'])) $collections['ascite'] = array('type' => 'ascite', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
					
					if($new_source == 'ASC') {
						$collections['ascite']['aliquots'] = array_merge($collections['ascite']['aliquots'], $aliquots);
					} else {
						if(!isset($collections['ascite']['derivatives']['ascite supernatant'])) $collections['ascite']['derivatives']['ascite supernatant'] = array('type' => 'ascite supernatant', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
						$collections['ascite']['derivatives']['ascite supernatant']['aliquots'] = array_merge($collections['ascite']['derivatives']['ascite supernatant']['aliquots'], $aliquots) ;
					}				
				
				} else if($new_source == 'LP') {
					if(!isset($collections['peritoneal wash'])) $collections['peritoneal wash'] = array('type' => 'peritoneal wash', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
					$collections['peritoneal wash']['aliquots'] = array_merge($collections['peritoneal wash']['aliquots'], $aliquots) ;
					
				} else if($new_source == 'S'){
//TODO see 6
					if(!isset($collections['blood'])) $collections['blood'] = array('type' => 'blood', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
					if(!isset($collections['blood']['derivatives']['serum'])) $collections['blood']['derivatives']['serum'] = array('type' => 'serum', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
					$collections['blood']['derivatives']['serum']['aliquots'] = array_merge($collections['blood']['derivatives']['serum']['aliquots'], $aliquots) ;	
				
				} else {
					die("<br><FONT COLOR=\"red\" >Line ".$m->line." / NS = $ns [ASCITE][ERROR] 1: ASCITE data [$new_source] unknown or at least 2 NC are defined into the same cell!</FONT>");
				}
			}
		}
	} 

	//--- End of ASCITE	

	// ------------------------------------------------------------------------------
	// [PC] : sample => cell culture ------------------------------------------------
	
	$pc_cell_data = $inventory_data_from_file['PC'];
	if(!empty($pc_cell_data)) {
		$pc_cell_data = strtoupper(str_replace(array(' ', 'PC/', 'PC'), array('', '', ''), $pc_cell_data));	

		$specimens = array();
		if(empty($pc_cell_data)) {
			if(sizeof($collections) == 1) {
				if(key($collections) == 'peritoneal wash') die ("ERR: Peritoneal wash PC not supported!");
				$specimens = array(key($collections));
			} else {
				$warning_messages['high'][] = "The PC intial specimen is not defined or can not be defined by the migration process (see column 'PC').";
			}		
		} else {
			$specimens = explode(',', $pc_cell_data);
		}
		
		if(!empty($specimens)) {
			foreach($specimens as $new_source) {
				preg_match('/^([0-9]+)/', $new_source, $matches);
				$nbr_of_aliquots_to_create = isset($matches[1])?  $matches[1] : 1;
				$new_source = str_replace($nbr_of_aliquots_to_create,'', $new_source);
				
				$aliquots = array();
				while($nbr_of_aliquots_to_create) { 
//TODO see 7
					$aliquots[] = array('type' => 'tube', 'storage' => ''); 
					$nbr_of_aliquots_to_create--;
				}
				
				if(array_key_exists($new_source, Config::$tissueCodeSynonimous)) $new_source = Config::$tissueCodeSynonimous[$new_source];
				if(array_key_exists($new_source, Config::$tissueCode2Details)) {
					// SOURCE = TISSUE				
					if(!isset($collections[$new_source])) $collections[$new_source] = array('type' => 'tissue', 'details' => Config::$tissueCode2Details[$new_source], 'aliquots' => array(), 'derivatives' => array());
					if(!isset($collections[$new_source]['derivatives']['cell culture'])) $collections[$new_source]['derivatives']['cell culture'] = array('type' => 'cell culture', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
					$collections[$new_source]['derivatives']['cell culture']['aliquots'] = array_merge($collections[$new_source]['derivatives']['cell culture']['aliquots'], $aliquots);
			
				} else if($new_source == 'ASC') {
					// SOURCE = ASCITE
				
					if(!isset($collections['ascite'])) $collections['ascite'] = array('type' => 'ascite', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
					if(!isset($collections['ascite']['derivatives']['ascite cell'])) $collections['ascite']['derivatives']['ascite cell'] = array('type' => 'ascite cell', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
					if(!isset($collections['ascite']['derivatives']['ascite cell']['derivatives']['cell culture'])) $collections['ascite']['derivatives']['ascite cell']['derivatives']['cell culture'] = array('type' => 'cell culture', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
					$collections['ascite']['derivatives']['ascite cell']['derivatives']['cell culture']['aliquots'] = array_merge($collections['ascite']['derivatives']['ascite cell']['derivatives']['cell culture']['aliquots'], $aliquots);
								
				} else {
					die("<br><FONT COLOR=\"red\" >Line ".$m->line." [PC][ERROR]: Source '$new_source' is not supported [".$inventory_data_from_file['PC']."].</FONT><br>");
				}
			}
		}
	} 
	
	//--- End of PC	
	
	// ------------------------------------------------------------------------------
	// [VC] : sample => cell culture ------------------------------------------------
	
	$vc_cell_data = $inventory_data_from_file['VC'];
	if(!empty($vc_cell_data)) {
		$vc_cell_data = strtoupper(str_replace(array(' ', '-bt#'), array('','#'), $vc_cell_data));

		$specimens = explode(',', $vc_cell_data);
		foreach($specimens as $new_source) {
			preg_match('/#(.+)$/', $new_source, $matches);
			$box = isset($matches[1])?  $matches[1] : '';	
			$new_source = str_replace(array(('#'.$box)), array(''), $new_source);
						
			preg_match('/^([0-9]+)/', $new_source, $matches);
			$nbr_of_aliquots_to_create = isset($matches[1])?  $matches[1] : 1;
			$new_source = str_replace($nbr_of_aliquots_to_create,'', $new_source);
			
			$aliquots = array();
			while($nbr_of_aliquots_to_create) {
				$aliquots[] = array('type' => 'tube', 'storage' => $box); 
				$nbr_of_aliquots_to_create--;
			}
			
			if(array_key_exists($new_source, Config::$tissueCodeSynonimous)) $new_source = Config::$tissueCodeSynonimous[$new_source];
			if(array_key_exists($new_source, Config::$tissueCode2Details)) {
				// SOURCE = TISSUE				
				if(!isset($collections[$new_source])) $collections[$new_source] = array('type' => 'tissue', 'details' => Config::$tissueCode2Details[$new_source], 'aliquots' => array(), 'derivatives' => array());
				if(!isset($collections[$new_source]['derivatives']['cell culture'])) $collections[$new_source]['derivatives']['cell culture'] = array('type' => 'cell culture', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
				$collections[$new_source]['derivatives']['cell culture']['aliquots'] = array_merge($collections[$new_source]['derivatives']['cell culture']['aliquots'], $aliquots);
		
			} else if($new_source == 'ASC') {
				// SOURCE = ASCITE
			
				if(!isset($collections['ascite'])) $collections['ascite'] = array('type' => 'ascite', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
				if(!isset($collections['ascite']['derivatives']['ascite cell'])) $collections['ascite']['derivatives']['ascite cell'] = array('type' => 'ascite cell', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
				if(!isset($collections['ascite']['derivatives']['ascite cell']['derivatives']['cell culture'])) $collections['ascite']['derivatives']['ascite cell']['derivatives']['cell culture'] = array('type' => 'cell culture', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
				$collections['ascite']['derivatives']['ascite cell']['derivatives']['cell culture']['aliquots'] = array_merge($collections['ascite']['derivatives']['ascite cell']['derivatives']['cell culture']['aliquots'], $aliquots);
							
			} else {
				die("<br><FONT COLOR=\"red\" >Line ".$m->line." [VC][ERROR]: Source '$new_source' is not supported [".$inventory_data_from_file['VC']."].</FONT><br>");
			}
		}
	} 
	
	//--- End of VC	
		
	// ---------------------------------------------------------------------------------------------------------
	// [RNA (PC)] + [N0 BOÎTE  RNA (PC)] : sample => RNA , aliquot => tube -------------------------------------

	$rna_cell_data = $inventory_data_from_file['RNA (PC)'];
	$rna_boxes_cell_data = $inventory_data_from_file[utf8_decode('N0 BOÎTE  RNA (PC) ')];
	
	if(!empty($rna_cell_data)) {
		$rna_cell_data = str_replace(array(' ', 'RNA/', '/'), array('','',','), $rna_cell_data);
		$rna_cell_data = preg_replace('/^(.+)\,$/', '$1', $rna_cell_data);
		$rna_sources = explode(',', $rna_cell_data);
		
		preg_match('/^([0-9]+)$/',  $rna_boxes_cell_data, $matches);
		if(!empty($rna_boxes_cell_data) && !isset($matches[1])) { die( "<br><FONT COLOR=\"red\" >[RNA][WARNING]: Line ".$m->line." / NS = $ns RNA box value [$rna_boxes_cell_data] looks like wrong (not numeric)!</FONT><br>");}
		$rna_box = $rna_boxes_cell_data;
				
		// Set product
		foreach($rna_sources as $new_source) {
			preg_match('/^([0-9]+)/',  $new_source, $matches);
			$nbr_of_aliquots_to_create = isset($matches[1])? $matches[1] : 1;
			$new_source = str_replace($nbr_of_aliquots_to_create,'', $new_source);
			
			$aliquots = array();
			while($nbr_of_aliquots_to_create) {
				$aliquots[] = array('type' => 'tube', 'storage' => $rna_box); 
				$nbr_of_aliquots_to_create--;
			}
			
			if(array_key_exists($new_source, Config::$tissueCodeSynonimous)) $new_source = Config::$tissueCodeSynonimous[$new_source];
			if(array_key_exists($new_source, Config::$tissueCode2Details)) {
				// SOURCE = TISSUE
				if(!isset($collections[$new_source])) $collections[$new_source] = array('type' => 'tissue', 'details' => Config::$tissueCode2Details[$new_source], 'aliquots' => array(), 'derivatives' => array());
				if(!isset($collections[$new_source]['derivatives']['cell culture'])) $collections[$new_source]['derivatives']['cell culture'] = array('type' => 'cell culture', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
				if(!isset($collections[$new_source]['derivatives']['cell culture']['derivatives']['rna'])) $collections[$new_source]['derivatives']['cell culture']['derivatives']['rna'] = array('type' => 'rna', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
				$collections[$new_source]['derivatives']['cell culture']['derivatives']['rna']['aliquots'] = array_merge($collections[$new_source]['derivatives']['cell culture']['derivatives']['rna']['aliquots'], $aliquots);
			
			} else if($new_source == 'ASC') {
				// SOURCE = ASCITE
				if(!isset($collections['ascite'])) $collections['ascite'] = array('type' => 'ascite', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
				if(!isset($collections['ascite']['derivatives']['ascite cell'])) $collections['ascite']['derivatives']['ascite cell'] = array('type' => 'ascite cell', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
				if(!isset($collections['ascite']['derivatives']['ascite cell']['derivatives']['cell culture'])) $collections['ascite']['derivatives']['ascite cell']['derivatives']['cell culture'] = array('type' => 'cell culture', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
				if(!isset($collections['ascite']['derivatives']['ascite cell']['derivatives']['cell culture']['derivatives']['rna'])) $collections['ascite']['derivatives']['ascite cell']['derivatives']['cell culture']['derivatives']['rna'] = array('type' => 'rna', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
				$collections['ascite']['derivatives']['ascite cell']['derivatives']['cell culture']['derivatives']['rna']['aliquots'] = array_merge($collections['ascite']['derivatives']['ascite cell']['derivatives']['cell culture']['derivatives']['rna']['aliquots'], $aliquots);
				
			} else {
				die("<br><FONT COLOR=\"red\" >Line ".$m->line." [RNA][ERROR]: Source '$new_source' is not supported [".$inventory_data_from_file['RNA (PC)']."].</FONT><br>");
			}
		}	
	}//--- End of RNA	
		
	// ---------------------------------------------------------------------------------------------------------
	// [DNA] + [N0 BOÎTE  DNA (PC)] : sample => DNA , aliquot => tube -------------------------------------

	$dna_cell_data = str_replace(' ', '', $inventory_data_from_file['DNA']);
	$dna_boxes_cell_data = $inventory_data_from_file[utf8_decode('N0 BOÎTE DNA (PC)')];
	
	if(!empty($dna_cell_data)) {
		$dna_cell_data = str_replace(array(' ', 'DNA/', '/'), array('','',','), $dna_cell_data);
		$dna_cell_data = preg_replace('/^(.+)\,$/', '$1', $dna_cell_data);
		$dna_sources = explode(',', $dna_cell_data);
		
		preg_match('/^([0-9]+)$/',  $dna_boxes_cell_data, $matches);
		if(!empty($dna_boxes_cell_data) && !isset($matches[1])) { die( "<br><FONT COLOR=\"red\" >[DNA][WARNING]: Line ".$m->line." / NS = $ns DNA box value [$dna_boxes_cell_data] looks like wrong (not numeric)!</FONT><br>");}
		$dna_box = $dna_boxes_cell_data;
				
		// Set product
		foreach($dna_sources as $new_source) {
			preg_match('/^([0-9]+)/',  $new_source, $matches);
			$nbr_of_aliquots_to_create = isset($matches[1])? $matches[1] : 1;
			$new_source = str_replace($nbr_of_aliquots_to_create,'', $new_source);
			
			$aliquots = array();
			while($nbr_of_aliquots_to_create) {
				$aliquots[] = array('type' => 'tube', 'storage' => $dna_box); 
				$nbr_of_aliquots_to_create--;
			}
			
			if(array_key_exists($new_source, Config::$tissueCodeSynonimous)) $new_source = Config::$tissueCodeSynonimous[$new_source];
			if(array_key_exists($new_source, Config::$tissueCode2Details)) {
				// SOURCE = TISSUE
				if(!isset($collections[$new_source])) $collections[$new_source] = array('type' => 'tissue', 'details' => Config::$tissueCode2Details[$new_source], 'aliquots' => array(), 'derivatives' => array());
				if(!isset($collections[$new_source]['derivatives']['cell culture'])) $collections[$new_source]['derivatives']['cell culture'] = array('type' => 'cell culture', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
				if(!isset($collections[$new_source]['derivatives']['cell culture']['derivatives']['dna'])) $collections[$new_source]['derivatives']['cell culture']['derivatives']['dna'] = array('type' => 'dna', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
				$collections[$new_source]['derivatives']['cell culture']['derivatives']['dna']['aliquots'] = array_merge($collections[$new_source]['derivatives']['cell culture']['derivatives']['dna']['aliquots'], $aliquots);
			
			} else if($new_source == 'ASC') {
				// SOURCE = ASCITE
				if(!isset($collections['ascite'])) $collections['ascite'] = array('type' => 'ascite', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
				if(!isset($collections['ascite']['derivatives']['ascite cell'])) $collections['ascite']['derivatives']['ascite cell'] = array('type' => 'ascite cell', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
				if(!isset($collections['ascite']['derivatives']['ascite cell']['derivatives']['cell culture'])) $collections['ascite']['derivatives']['ascite cell']['derivatives']['cell culture'] = array('type' => 'cell culture', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
				if(!isset($collections['ascite']['derivatives']['ascite cell']['derivatives']['cell culture']['derivatives']['dna'])) $collections['ascite']['derivatives']['ascite cell']['derivatives']['cell culture']['derivatives']['dna'] = array('type' => 'dna', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
				$collections['ascite']['derivatives']['ascite cell']['derivatives']['cell culture']['derivatives']['dna']['aliquots'] = array_merge($collections['ascite']['derivatives']['ascite cell']['derivatives']['cell culture']['derivatives']['dna']['aliquots'], $aliquots);
				
			} else {
				die("<br><FONT COLOR=\"red\" >Line ".$m->line." [DNA][ERROR]: Source '$new_source' is not supported [".$inventory_data_from_file['DNA']."].</FONT><br>");
			}
		}	
	}
	
	// Display data for check
	displayCollection($ns, $m, $participant_id, $collections, $spent_time, $warning_messages);
	
	// Add collection notes
	$collections['NOTES'] = $inventory_data_from_file['REMARQUE'];
	$collection_notes = $collections['NOTES'];
	
	//INSERT PROCESS
	
	createCollectionAndSpecimen($ns, $participant_id, $collections, $spent_time);

}

//=========================================================================================================
// Display functions
//=========================================================================================================

function displayCollection($ns, &$m, $participant_id, $collections, $spent_time, $warning_messages) {	
	
	echo "<br>:::::::::::::: SAMPLES SUMMARY - NS = $ns (Line: ".$m->line.") ::::::::::::::<br>";
	
	$space = '. . . . . . ';
	if(empty($collections)) {
		Config::$summary_msg['errors'][] = "[NS = $ns / Line: ".$m->line."] No sample defined for this participant!";
		echo "<br><FONT COLOR=\"red\" >@@ERROR@@ ==> No sample defined for this participant!</FONT><br>";
	} else {
		foreach($collections as $specimen_key => $data) {
			// Manage Specimen
			switch($specimen_key) {
				case 'blood':
					echo "<br><FONT COLOR=\"blue\" >** BLOOD</FONT><br>";
					break;
				
				case 'ascite':
					$pent_time_message = '';
					if(isset($spent_time['details']['ASC'])) {
						$pent_time_message = ', **spent_time = '.
							$spent_time['details']['ASC']['value'].
							$spent_time['details']['ASC']['unit'];
					} else if(isset($spent_time['default']['value'])) {
						$pent_time_message = ', spent_time = '.
						$spent_time['default']['value'].
						$spent_time['default']['unit'];
					}					
					
					echo "<br><FONT COLOR=\"blue\" >** ASCITE </FONT>'.$pent_time_message.'<br>";
					break;
				
				case 'peritoneal wash':
					$pent_time_message = '';
					if(isset($spent_time['details']['LP'])) {
						$pent_time_message = ', **spent_time = '.
							$spent_time['details']['LP']['value'].
							$spent_time['details']['LP']['unit'];
					} else if(isset($spent_time['default']['value'])) {
						$pent_time_message = ', spent_time = '.
						$spent_time['default']['value'].
						$spent_time['default']['unit'];
					}					
					
					echo "<br><FONT COLOR=\"blue\" >** Peritoneal Wash </FONT>'.$pent_time_message.'<br>";
					break;
								
				default:
					if($data['type'] != 'tissue') {
						pr($collections);
						die ('ERR: 9973671812cacacasc '.$data['type']);
					}
					
					//TODO check
					preg_match('/(###.*###)/', $specimen_key, $matches);
					if(!empty($matches)) {
						echo("<br><FONT COLOR=\"red\" >Line ".$m->line." / NS = $ns [WARNING]: The same type of tissue has been created twice (".str_replace($matches[0], '', $specimen_key).").</FONT><br>");
					}
					
					$pent_time_message = '';
					if(isset($spent_time['details'][$data['details']['code']])) {
						$pent_time_message = ', **spent_time = '.
							$spent_time['details'][$data['details']['code']]['value'].
							$spent_time['details'][$data['details']['code']]['unit'];
					} else if(isset($spent_time['default']['value'])) {
						$pent_time_message = ', spent_time = '.
							$spent_time['default']['value'].
							$spent_time['default']['unit'];
					}					
					
					echo "<br><FONT COLOR=\"blue\" >** TISSUE </FONT>(code : ".$data['details']['code'].', source : '.$data['details']['source'].', laterality : '.$data['details']['laterality'].', type : '.$data['details']['type'].' '.$pent_time_message .')<br>';		
			}
						
			// Display Aliquot
			displayAliquots($m, $participant_id, $data['aliquots'], $space);
			
			// Manage Derivative
			displayDerivatives($m, $participant_id, $data['derivatives'], $space, $space);
		}
	}
	
	foreach($warning_messages as $level => $msgs) {
		$color = '';
		$type_msg = '';
		switch($level) {
			case 'high':
				$color = 'red';
				$type_msg = '@@ERROR@@';
				break;
			case 'medium':
				$color = '#C35617';
				$type_msg = '@@WARNING@@';
				break;
			case 'low':
				$color = 'green';
				$type_msg = '@@MESSAGE@@';
				break;
			default:
				die('ERR 999d8as8dasd');
		}
		
		foreach($msgs as $new_msg) {
			Config::$summary_msg[$type_msg][] = utf8_decode("[NS = $ns / Line: ".$m->line."] $new_msg");
			echo utf8_decode("<br><FONT COLOR=\"$color\" >$type_msg ==> $new_msg</FONT>");	
		}
	}	
	
	echo "<br>";
}
function displayAliquots(&$m, $participant_id, $aliquot_data, $space_to_use){
	foreach($aliquot_data as $new_aliquot) {
		echo $space_to_use."|==> ".$new_aliquot['type']." (Box: ".(empty($new_aliquot['storage'])? '-': $new_aliquot['storage']).")<br>";
	}
}

function displayDerivatives(&$m, $participant_id, $derivative_data, $space_to_use, $space){
	if(empty($derivative_data)) return;
	
	if(!empty($derivative_data['details']))die('ERR: 98736621cacacsasccsa line'.$m->line);
	foreach($derivative_data as $new_derivative) {
		echo $space_to_use."|==> <FONT COLOR=\"blue\" >* ".strtoupper($new_derivative['type']).' </FONT><br>';
		displayAliquots($m, $participant_id, $new_derivative['aliquots'], $space.$space_to_use);
		displayDerivatives($m, $participant_id, $new_derivative['derivatives'], $space.$space_to_use,$space);
	}
}

function pr($arr) {
	echo "<pre>";
	print_r($arr);
}

//=========================================================================================================
// Insert functions
//=========================================================================================================

function createCollectionAndSpecimen($ns, $participant_id, $collections, $spent_time) {

	global $connection;
	$created = array(
		"created"		=> "NOW()", 
		"created_by"	=> Config::$db_created_id, 
		"modified"		=> "NOW()",
		"modified_by"	=> Config::$db_created_id
		);
		
	$collection_notes = $collections['NOTES'];
	unset($collections['NOTES']);
	
	// Create Blood Collection
	if(isset($collections['blood'])) {
		
		// Create collection
		$insert = array(
			"acquisition_label" => "'".$ns." Sang (00-00-0000)'",
			"bank_id" => "1", 
			"collection_notes" => "'".$collection_notes."'",
			"collection_property" => "'participant collection'"
		);
		$insert = array_merge($insert, $created);
		$query = "INSERT INTO collections (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		$blood_collection_id = mysqli_insert_id($connection);

		// Create link
		$insert = array(
			"collection_id" => $blood_collection_id,
			"participant_id" => $participant_id
		);
		$insert = array_merge($insert, $created);
		$query = "INSERT INTO clinical_collection_links (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
		// Create sample
		$insert = array(
			"sample_code" 					=> "'tmp_tissue'", 
			"sample_control_id"				=> Config::$sample_aliquot_controls['blood']['sample_control_id'], 
			"initial_specimen_sample_id"	=> "NULL", 
			"initial_specimen_sample_type"	=> "'blood'", 
			"collection_id"					=> "'".$blood_collection_id."'", 
			"parent_id"						=> "NULL" 
		);
		$insert = array_merge($insert, $created);
		$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		$sample_master_id = mysqli_insert_id($connection);
		$query = "UPDATE sample_masters SET sample_code=CONCAT('B - ', id), initial_specimen_sample_id=id WHERE id=".$sample_master_id;
		mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
		$insert = array(
			"sample_master_id"	=> $sample_master_id
		);
		$query = "INSERT INTO sd_spe_bloods (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

		$insert = array(
			"sample_master_id"	=> $sample_master_id
		);
		$insert = array_merge($insert, $created);
		$query = "INSERT INTO specimen_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));				
		
		// Create Derivative
		createDerivative($ns, $participant_id, $blood_collection_id, $sample_master_id, 'blood', $sample_master_id, 'blood', $collections['blood']['derivatives'], 'Sang');
	
		// Create Aliquot
		createAliquot($ns, $participant_id, $blood_collection_id, $sample_master_id, 'blood', $collections['blood']['aliquots'], 'Sang');
		
		unset($collections['blood']);
	}
	
	// Create Tissue Collection
	$tissue_collection_id = null;
	if(!empty($collections)) {
		
		$collection_type = '';
		if((sizeof($collections) == 1) && (array_key_exists('ascite', $collections)))  {
			$collection_type = 'ASC';
		} else if((sizeof($collections) > 1) && (array_key_exists('ascite', $collections)))  {
			$collection_type = 'Tissu/ASC';
		} else {
			$collection_type = 'Tissu';
		}
		
		$insert = array(
			"acquisition_label" => "'".$ns." $collection_type 00-00-0000'",
			"bank_id" => "1", 
			"collection_notes" => "'".$collection_notes."'",
			"collection_property" => "'participant collection'"
		);
		$insert = array_merge($insert, $created);
		$query = "INSERT INTO collections (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		$tissue_collection_id = mysqli_insert_id($connection);

		// link
		$insert = array(
			"collection_id" => $tissue_collection_id,
			"participant_id" => $participant_id
		);
		$insert = array_merge($insert, $created);
		$query = "INSERT INTO clinical_collection_links (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	}
	
	foreach($collections as $specimen_key => $data) {
		if(empty($tissue_collection_id)) die ('cascasc');
		
		$sample_master_id = null;
		$specimen_code = null;
		
		// Create Specimen
		switch($specimen_key) {
			case 'blood':
				die('23234234');
				break;
			
			case 'ascite':
				$insert = array(
					"sample_code" 					=> "'tmp_tissue'", 
					"sample_control_id"				=> Config::$sample_aliquot_controls['ascite']['sample_control_id'], 
					"initial_specimen_sample_id"	=> "NULL", 
					"initial_specimen_sample_type"	=> "'ascite'", 
					"collection_id"					=> "'".$tissue_collection_id."'", 
					"parent_id"						=> "NULL" 
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				$sample_master_id = mysqli_insert_id($connection);
				$query = "UPDATE sample_masters SET sample_code=CONCAT('A - ', id), initial_specimen_sample_id=id WHERE id=".$sample_master_id;
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				
				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				$query = "INSERT INTO sd_spe_ascites (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				if(isset($spent_time['details']['ASC'])) {
					$insert['chuq_evaluated_spent_time_from_coll'] = "'".$spent_time['details']['ASC']['value']."'";
					$insert['chuq_evaluated_spent_time_from_coll_unit'] = "'".$spent_time['details']['ASC']['unit']."'";
				} else if(isset($spent_time['default']['value'])) {
					$insert['chuq_evaluated_spent_time_from_coll'] ="'".$spent_time['default']['value']."'";
					$insert['chuq_evaluated_spent_time_from_coll_unit'] = "'".$spent_time['default']['unit']."'";
				}					
				
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO specimen_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));		

				$specimen_code = 'ASC';
				break;
			
			case 'peritoneal wash':
				$insert = array(
					"sample_code" 					=> "'tmp_tissue'", 
					"sample_control_id"				=> Config::$sample_aliquot_controls['peritoneal wash']['sample_control_id'], 
					"initial_specimen_sample_id"	=> "NULL", 
					"initial_specimen_sample_type"	=> "'peritoneal wash'", 
					"collection_id"					=> "'".$tissue_collection_id."'", 
					"parent_id"						=> "NULL" 
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				$sample_master_id = mysqli_insert_id($connection);
				$query = "UPDATE sample_masters SET sample_code=CONCAT('PW - ', id), initial_specimen_sample_id=id WHERE id=".$sample_master_id;
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				
				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				$query = "INSERT INTO sd_spe_peritoneal_washes (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				if(isset($spent_time['details']['LP'])) {
					$insert['chuq_evaluated_spent_time_from_coll'] = "'".$spent_time['details']['LP']['value']."'";
					$insert['chuq_evaluated_spent_time_from_coll_unit'] = "'".$spent_time['details']['LP']['unit']."'";
				} else if(isset($spent_time['default']['value'])) {
					$insert['chuq_evaluated_spent_time_from_coll'] ="'".$spent_time['default']['value']."'";
					$insert['chuq_evaluated_spent_time_from_coll_unit'] = "'".$spent_time['default']['unit']."'";
				}					
				
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO specimen_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));		

				$specimen_code = 'PW';
				break;
							
			default:
				if($data['type'] != 'tissue') {
					echo "<pre>";
					print_r($collections);
					die ('ERR: 9973671812cacacasc');
				}
				
				$insert = array(
					"sample_code" 					=> "'tmp_tissue'", 
					"sample_control_id"				=> Config::$sample_aliquot_controls['tissue']['sample_control_id'], 
					"initial_specimen_sample_id"	=> "NULL", 
					"initial_specimen_sample_type"	=> "'tissue'", 
					"collection_id"					=> "'".$tissue_collection_id."'", 
					"parent_id"						=> "NULL" 
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				$sample_master_id = mysqli_insert_id($connection);
				$query = "UPDATE sample_masters SET sample_code=CONCAT('T - ', id), initial_specimen_sample_id=id WHERE id=".$sample_master_id;
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				
				$insert = array(
					"sample_master_id"	=> $sample_master_id,
					"chuq_tissue_code" => "'".$data['details']['code']."'",
					"tissue_nature" => "'".$data['details']['type']."'",
					"tissue_source" => "'".$data['details']['source']."'",
					"tissue_laterality" => "'".$data['details']['laterality']."'"
				);
				
				$query = "INSERT INTO sd_spe_tissues (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				if(isset($spent_time['details'][$data['details']['code']])) {
					$insert['chuq_evaluated_spent_time_from_coll'] = "'".$spent_time['details'][$data['details']['code']]['value']."'";
					$insert['chuq_evaluated_spent_time_from_coll_unit'] = "'".$spent_time['details'][$data['details']['code']]['unit']."'";
				} else if(isset($spent_time['default']['value'])) {
					$insert['chuq_evaluated_spent_time_from_coll'] = "'".$spent_time['default']['value']."'";
					$insert['chuq_evaluated_spent_time_from_coll_unit'] = "'".$spent_time['default']['unit']."'";
				}					
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO specimen_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));				
				
				$specimen_code = $data['details']['code'];
				break;				
		}
		
		// Create Derivative
		createDerivative($ns, $participant_id, $tissue_collection_id, $sample_master_id, $data['type'], $sample_master_id, $specimen_key, $data['derivatives'], $specimen_code);
		
		// Create Aliquot
		createAliquot($ns, $participant_id, $tissue_collection_id, $sample_master_id, $data['type'], $data['aliquots'], $specimen_code);
				
	}
}
function createDerivative($ns, $participant_id, $collection_id, $initial_specimen_sample_id, $initial_specimen_sample_type, $parent_sample_master_id,  $parent_sample_type,  $derivative_data, $specimen_code = null) {
	global $connection;
	$created = array(
		"created"		=> "NOW()", 
		"created_by"	=> Config::$db_created_id, 
		"modified"		=> "NOW()",
		"modified_by"	=> Config::$db_created_id
		);
	
	if(empty($derivative_data)) return;
	
	foreach($derivative_data as $der_type => $new_derivative) {
		
		switch($der_type) {
			case 'plasma':
				$insert = array(
					"sample_code" 					=> "'tmp_tissue'", 
					"sample_control_id"				=>  Config::$sample_aliquot_controls['plasma']['sample_control_id'], 
					"initial_specimen_sample_id"	=> $initial_specimen_sample_id, 
					"initial_specimen_sample_type"	=> "'".$initial_specimen_sample_type."'", 
					"collection_id"					=> $collection_id, 
					"parent_id"						=> $parent_sample_master_id,
					"parent_sample_type"			=> "'".$parent_sample_type."'"
				);	
		
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				$sample_master_id = mysqli_insert_id($connection);
				$query = "UPDATE sample_masters SET sample_code=CONCAT('PLS - ', id) WHERE id=".$sample_master_id;
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				$query = "INSERT INTO sd_der_plasmas (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO derivative_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));				

				// Manage Derivative
				if(!empty($derivative_data['derivatives'])) die('ascasc');
				break;

				
			case 'serum':
				$insert = array(
					"sample_code" 					=> "'tmp_tissue'", 
					"sample_control_id"				=> Config::$sample_aliquot_controls['serum']['sample_control_id'], 
					"initial_specimen_sample_id"	=> "'".$initial_specimen_sample_id."'", 
					"initial_specimen_sample_type"	=> "'".$initial_specimen_sample_type."'", 
					"collection_id"					=> "'".$collection_id."'", 
					"parent_id"						=> "'".$parent_sample_master_id."'",
					"parent_sample_type"			=> "'".$parent_sample_type."'"
				);				
				
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				$sample_master_id = mysqli_insert_id($connection);
				$query = "UPDATE sample_masters SET sample_code=CONCAT('SER - ', id) WHERE id=".$sample_master_id;
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				$query = "INSERT INTO 	sd_der_serums (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO derivative_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));				
				
				// Manage Derivative
				if(!empty($new_derivative['derivatives'])) die('ascasc');
				
				break;	
	
			case 'blood cell':
			case 'blood cell (arlt)':
				$insert = array(
					"sample_code" 					=> "'tmp_tissue'", 
					"sample_control_id"				=> Config::$sample_aliquot_controls['blood cell']['sample_control_id'], 
					"initial_specimen_sample_id"	=> "'".$initial_specimen_sample_id."'", 
					"initial_specimen_sample_type"	=> "'".$initial_specimen_sample_type."'", 
					"collection_id"					=> "'".$collection_id."'", 
					"parent_id"						=> "'".$parent_sample_master_id."'",
					"parent_sample_type"			=> "'".$parent_sample_type."'"
				);				
							
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				$sample_master_id = mysqli_insert_id($connection);
				$query = "UPDATE sample_masters SET sample_code=CONCAT('BLD-C - ', id) WHERE id=".$sample_master_id;
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				if($der_type == 'blood cell (arlt)') $insert['chuq_is_erythrocyte'] = "'y'";
				$query = "INSERT INTO 	sd_der_blood_cells (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO derivative_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));				
				
				break;	
				
				
			case 'dna':
				$insert = array(
					"sample_code" 					=> "'tmp_tissue'", 
					"sample_control_id"				=> Config::$sample_aliquot_controls['dna']['sample_control_id'], 
					"initial_specimen_sample_id"	=> "'".$initial_specimen_sample_id."'", 
					"initial_specimen_sample_type"	=> "'".$initial_specimen_sample_type."'", 
					"collection_id"					=> "'".$collection_id."'", 
					"parent_id"						=> "'".$parent_sample_master_id."'",
					"parent_sample_type"			=> "'".$parent_sample_type."'"
				);				
				
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				$sample_master_id = mysqli_insert_id($connection);
				$query = "UPDATE sample_masters SET sample_code=CONCAT('DNA - ', id) WHERE id=".$sample_master_id;
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				$query = "INSERT INTO 	sd_der_dnas (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO derivative_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));				
				
				// Manage Derivative
				if(!empty($new_derivative['derivatives'])) die('ascasc');
				
				break;						
					

			case 'rna':
				$insert = array(
					"sample_code" 					=> "'tmp_tissue'", 
					"sample_control_id"				=> Config::$sample_aliquot_controls['rna']['sample_control_id'], 
					"initial_specimen_sample_id"	=> "'".$initial_specimen_sample_id."'", 
					"initial_specimen_sample_type"	=> "'".$initial_specimen_sample_type."'", 
					"collection_id"					=> "'".$collection_id."'", 
					"parent_id"						=> "'".$parent_sample_master_id."'",
					"parent_sample_type"			=> "'".$parent_sample_type."'"
				);				
				
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				$sample_master_id = mysqli_insert_id($connection);
				$query = "UPDATE sample_masters SET sample_code=CONCAT('RNA - ', id) WHERE id=".$sample_master_id;
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				$query = "INSERT INTO 	sd_der_rnas (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO derivative_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));				
				
				// Manage Derivative
				if(!empty($new_derivative['derivatives'])) die('ascasc');
				
				break;						
	
	
			case 'ascite supernatant':
				$insert = array(
					"sample_code" 					=> "'tmp_tissue'", 
					"sample_control_id"				=> Config::$sample_aliquot_controls['ascite supernatant']['sample_control_id'], 
					"initial_specimen_sample_id"	=> "'".$initial_specimen_sample_id."'", 
					"initial_specimen_sample_type"	=> "'".$initial_specimen_sample_type."'", 
					"collection_id"					=> "'".$collection_id."'", 
					"parent_id"						=> "'".$parent_sample_master_id."'",
					"parent_sample_type"			=> "'".$parent_sample_type."'"
				);				
				
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				$sample_master_id = mysqli_insert_id($connection);
				$query = "UPDATE sample_masters SET sample_code=CONCAT('ASC-S - ', id) WHERE id=".$sample_master_id;
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				$query = "INSERT INTO 	sd_der_ascite_sups (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO derivative_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));				
				
				// Manage Derivative
				if(!empty($new_derivative['derivatives'])) die('ascasc');
				
				break;
				
				
			case 'ascite cell':
				$insert = array(
					"sample_code" 					=> "'tmp_tissue'", 
					"sample_control_id"				=> Config::$sample_aliquot_controls['ascite cell']['sample_control_id'], 
					"initial_specimen_sample_id"	=> "'".$initial_specimen_sample_id."'", 
					"initial_specimen_sample_type"	=> "'".$initial_specimen_sample_type."'", 
					"collection_id"					=> "'".$collection_id."'", 
					"parent_id"						=> "'".$parent_sample_master_id."'",
					"parent_sample_type"			=> "'".$parent_sample_type."'"
				);				
							
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				$sample_master_id = mysqli_insert_id($connection);
				$query = "UPDATE sample_masters SET sample_code=CONCAT('ASC-C - ', id) WHERE id=".$sample_master_id;
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				$query = "INSERT INTO 	sd_der_ascite_cells (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO derivative_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));				
				
				break;		
						

			case 'cell culture':
				$insert = array(
					"sample_code" 					=> "'tmp_tissue'", 
					"sample_control_id"				=> Config::$sample_aliquot_controls['cell culture']['sample_control_id'], 
					"initial_specimen_sample_id"	=> "'".$initial_specimen_sample_id."'", 
					"initial_specimen_sample_type"	=> "'".$initial_specimen_sample_type."'", 
					"collection_id"					=> "'".$collection_id."'", 
					"parent_id"						=> "'".$parent_sample_master_id."'",
					"parent_sample_type"			=> "'".$parent_sample_type."'"
				);				
							
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				$sample_master_id = mysqli_insert_id($connection);
				$query = "UPDATE sample_masters SET sample_code=CONCAT('C-CULT - ', id) WHERE id=".$sample_master_id;
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				$query = "INSERT INTO sd_der_cell_cultures (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO derivative_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));				
				
				break;		
				
			default:
				die('ERR 9998377 : '.$der_type);
		}
		
		// Create Derivative
		createDerivative($ns, $participant_id, $collection_id, $initial_specimen_sample_id, $initial_specimen_sample_type, $sample_master_id, $der_type, $new_derivative['derivatives'], $specimen_code);
		
		// Create Aliquot
		createAliquot($ns, $participant_id, $collection_id, $sample_master_id, $der_type, $new_derivative['aliquots'], $specimen_code);
	}
}
	
function createAliquot($ns, $participant_id, $collection_id, $sample_master_id, $sample_type, $aliquot_data, $specimen_code) {
	global $connection;
	$created = array(
		"created"		=> "NOW()", 
		"created_by"	=> Config::$db_created_id, 
		"modified"		=> "NOW()",
		"modified_by"	=> Config::$db_created_id
		);
	
	if(empty($aliquot_data)) return;
	
	foreach($aliquot_data as $new_aliquot) {
		
		// MANAGE STORAGE
		
		//get storage prefix
		$box_number = null;
		if(!empty($new_aliquot['storage'])) {
			switch($sample_type.'-'.$new_aliquot['type']) {
				case 'blood-tube':
				case 'blood-RNALater tube':	
				case 'plasma-tube':
				case 'serum-tube':
				case 'blood cell-tube':
				case 'blood cell (arlt)-tube':
					$box_number = 'Sang '.$new_aliquot['storage'];
					break;
				case 'dna-tube':
					$box_number = 'DNA '.$new_aliquot['storage'];
					break;
				case 'rna-tube':
					$box_number = 'RNA '.$new_aliquot['storage'];
					break;
				case 'cell culture-tube':
					$box_number = 'VC '.$new_aliquot['storage'];
					break;
				case 'tissue-oct block':
					$box_number = 'OCT '.$new_aliquot['storage'];
					break;
				case 'tissue-frozen tube':
					$box_number = 'Tissu '.$new_aliquot['storage'];
					break;
				case 'tissue-paraffin block':
					$box_number = 'FFPE '.$new_aliquot['storage'];
					break;
				case 'ascite-tube':
				case 'ascite supernatant-tube':
				case 'ascite cell-tube':
					$box_number = 'ASC '.$new_aliquot['storage'];
					break;
				case 'peritoneal wash-tube':
					$box_number = 'PW '.$new_aliquot['storage'];
					break;
				default:
					die ('ERR_9849983 '.$sample_type.'-'.$new_aliquot['type']);
			}
		}
				
		//get storage master id
		$storage_master_id = null;
		if(!empty($box_number)) {
			if(isset(Config::$storages['storages'][$box_number])) {
				$storage_master_id = Config::$storages['storages'][$box_number]['id'];
			} else {
			
				$insert = array(
					"code" => "'-1'",
					"storage_control_id"	=> "8",
					"short_label"			=> "'".$box_number."'",
					"selection_label"		=> "'".$box_number."'",
					"lft"		=> "'".(Config::$storages['next_left'])."'",
					"rght"		=> "'".(Config::$storages['next_left'] + 1)."'"
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO storage_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				$storage_master_id = mysqli_insert_id($connection);
				$query = "UPDATE storage_masters SET code=CONCAT('B - ', id) WHERE id=".$storage_master_id;
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				
				$insert = array(
					"storage_master_id"	=> $storage_master_id,
				);
				$query = "INSERT INTO std_boxs (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
						
				Config::$storages['next_left'] = Config::$storages['next_left'] + 2;
				Config::$storages['storages'][$box_number] = array('id' => $storage_master_id);
			} 
		}		
		
		// CREATE ALIQUOT
		
		$master_insert = array(
			"aliquot_control_id" => null,
			"in_stock" => "'yes - available'",
			"collection_id" => $collection_id,
			"sample_master_id" => $sample_master_id,
			"aliquot_label" => null
		);
		if(!empty($storage_master_id)) $master_insert['storage_master_id'] = $storage_master_id;

		$detail_insert = array();
		$detail_table = 'ad_tubes';
		
		$real_aliquot_type = str_replace(array('oct ','RNALater ','paraffin ', 'frozen '), array('','','', ''), $new_aliquot['type']);
		$real_sample_type = str_replace(array(' (arlt)'), array(''), $sample_type);
		if(!isset(Config::$sample_aliquot_controls[$real_sample_type]) 
		&& !isset(Config::$sample_aliquot_controls[$real_sample_type]['aliquots'][$real_aliquot_type])) {
			die('ERR 993883 : '.$sample_type.'-'.$new_aliquot['type']);
		}
		$aliquot_control_id = Config::$sample_aliquot_controls[$real_sample_type]['aliquots'][$real_aliquot_type]['aliquot_control_id'];

		$prefix = '';
		switch($sample_type.'-'.$new_aliquot['type']) {
			case 'blood-tube':
				$prefix = "'Sang $ns 00-00-0000'";
			case 'blood-RNALater tube':	
				if(empty($prefix)) {
					$prefix = "'RL $ns 00-00-0000'";
					$detail_insert['chuq_blood_solution'] = "'RNA later'";
				}
				$master_insert['aliquot_control_id'] = $aliquot_control_id;
				$master_insert['aliquot_label'] = $prefix;				
				break;
				
			case 'plasma-tube':
				$prefix = 'P';
			case 'ascite supernatant-tube':
				if(empty($prefix)) $prefix = 'SASC';
			case 'serum-tube':
				if(empty($prefix)) $prefix = 'SE';
			case 'ascite cell-tube':
				if(empty($prefix)) $prefix = 'NC';
				$master_insert['aliquot_control_id'] = $aliquot_control_id;
				$master_insert['aliquot_label'] = "'$prefix $ns 00-00-0000'";							
				break;				
				
			case 'tissue-frozen tube':
				$master_insert['aliquot_control_id'] = $aliquot_control_id;
				$master_insert['aliquot_label'] = "'$specimen_code $ns 00-00-0000'";						
				break;	

			case 'tissue-paraffin block':
				$prefix = 'FFPE';
			case 'tissue-oct block':
				if(empty($prefix)) $prefix = 'OCT';
				$master_insert['aliquot_control_id'] = $aliquot_control_id;
				$master_insert['aliquot_label'] = "'$prefix $specimen_code $ns 00-00-0000'";	
				$detail_insert['block_type'] = ($prefix == 'OCT')? "'OCT'" : "'paraffin'";		
				$detail_table = 'ad_blocks';			
				break;	

			case 'dna-tube':
			case 'rna-tube':
				$master_insert['aliquot_control_id'] = $aliquot_control_id;
				$master_insert['aliquot_label'] = "'$specimen_code $ns 00-00-0000'";					
				break;	

			case 'blood cell-tube':
				$prefix = 'BC';
			case 'blood cell (arlt)-tube':
				if(empty($prefix)) $prefix = 'ARLT';
			case 'cell culture-tube':
				if(empty($prefix)) $prefix = 'VC '.$specimen_code;
				$master_insert['aliquot_control_id'] = $aliquot_control_id;
				$master_insert['aliquot_label'] = "'$prefix $ns 00-00-0000'";				
				break;	
				
			case 'ascite-tube':
				$master_insert['aliquot_control_id'] = $aliquot_control_id;
				$master_insert['aliquot_label'] = "'$specimen_code $ns 00-00-0000'";						
				break;

			case 'peritoneal wash-tube':
				$master_insert['aliquot_control_id'] = $aliquot_control_id;
				$master_insert['aliquot_label'] = "'$specimen_code $ns 00-00-0000'";						
				break;
					
			default:
				die('ERR 99628');
		}
		
		$master_insert = array_merge($master_insert, $created);
		$query = "INSERT INTO aliquot_masters (".implode(", ", array_keys($master_insert)).") VALUES (".implode(", ", array_values($master_insert)).")";
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		$aliquot_master_id = mysqli_insert_id($connection);
		
		$detail_insert['aliquot_master_id'] = $aliquot_master_id;
		$query = "INSERT INTO $detail_table (".implode(", ", array_keys($detail_insert)).") VALUES (".implode(", ", array_values($detail_insert)).")";
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

	}
}
