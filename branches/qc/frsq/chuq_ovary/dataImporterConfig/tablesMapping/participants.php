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
	excelDateFix($m);
	
//echo "** New Participant : NS = ".$m->values['NS']." (Line: ".$m->line.")";

	return true;
}

function createParticipantCollections(Model $m){
	
	$participant_id = $m->last_id;
	$line =  $m->line;
	$invantory_data_from_file =  $m->values;
	$ns = $invantory_data_from_file['NS'];
	
	$collections = array();
	$collections['NOTES'] = $invantory_data_from_file['REMARQUE'];

	//Get Spent Time
	
	$spent_time = array('default' => null, 'details' => array());
	$spent_time_data = $invantory_data_from_file[utf8_decode('Délais chir.')];
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
				if(sizeof($matches_day) != 2) { pr($matches_day);die('a1'); }
				$value = str_replace('JOUR', '', $matches_day[0]);
				$unit = 'd';
				$tissue = str_replace($matches_day[0], '', $new);
				
			} else if(!empty($matches_hour)) {
				if(sizeof($matches_hour) != 2)  {  pr($matches_hour);die('a2'); }
				$value = str_replace('H', '', $matches_hour[0]);
				$unit = 'h';
				$tissue = str_replace($matches_hour[0], '', $new);
				
			} else if(!empty($matches_mn)) {
				if(sizeof($matches_mn) != 2) {  pr($matches_mn);die('a3'); }
				$value = str_replace('MIN.', '', $matches_mn[0]);
				$unit = 'mn';
				$tissue = str_replace($matches_mn[0], '', $new);
			
			} else {
				echo"<pre>$new";
				print_r($times);
				die('98466733');
			} 
		
			if(empty($tissue)) {
				if(!empty($spent_time['default'])) { die('3131313'); }
				$spent_time['default'] = array('value' => $value, 'unit' => $unit);
			} else {
				if(!empty($spent_time['default'])) { die('3131313'); }
				if(isset($spent_time['details'][$tissue])) {
					echo "<br><FONT COLOR=\"red\" >Line ".$m->line." WARNING: Spent time defined twice for tissue ($tissue)!</FONT><br>";
				} else {
					$spent_time['details'][$tissue] = array('value' => $value, 'unit' => $unit);
				}
			}
		}	
	}

	// ------------------------------------------------------------------------------
	// [TISSUS] : sample => tissue --------------------------------------------------
	
	$tissu_cell_data = $invantory_data_from_file['TISSUS'];
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
							echo "<br><FONT COLOR=\"green\" >WARNING: Line ".$m->line." [TISSUS][WARNING]: TISSUS code {$new_tissue} is created at least twice!</FONT><br>";						
						}
						$collections[$new_tissue.$suffix] = array('type' => 'tissue', 'details' => Config::$tissueCode2Details[$new_tissue], 'aliquots' => array(), 'derivatives' => array());
						
					}else {
						die("<br><FONT COLOR=\"red\" >Line ".$m->line." [TISSUS][ERROR]: TISSUS code {$new_tissue} is unknown!</FONT><br>");
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
	
	$oct_cell_data = $invantory_data_from_file['OCT'];
	if(!empty($oct_cell_data)) {
		//Get all different types of source
		$oct_cell_data = str_replace( array(" ", "OCT/", "/"), array("", "", ","), strtoupper($oct_cell_data));
		$oct_cell_data = preg_replace('/^(.+)\,$/', '$1', $oct_cell_data);
		$oct_sources = explode(',', $oct_cell_data);

		// Set boxes array per source types
		$boxes = explode(',', str_replace(array(" ", "/", "."), array("", ",", ","), $invantory_data_from_file[utf8_decode('N0 BOÎTE OCT')]));
		$boxes =(empty($boxes))? array('') : $boxes;
		if(sizeof($boxes) == 1) { for($i = 1; $i < sizeof($oct_sources); $i++) { $boxes[] = $boxes[0]; } }	
		if(sizeof($boxes) != sizeof($oct_sources)) die("<br><FONT COLOR=\"red\" >Line ".$m->line." / NS = $ns [OCT][ERROR] 1: The box definitions [".$invantory_data_from_file[utf8_decode('N0 BOÎTE OCT')]."] does not match the oct defintion [".$invantory_data_from_file['OCT']."] (check wrong coma, etc).</FONT><br>"); 
		
		// Set product
		foreach($oct_sources as $new_source) {
			preg_match('/^([0-9]+)?/',  $new_source, $matches);
			$nbr_of_aliquots_to_create = isset($matches[1])? $matches[1] : 1;
			$new_source = str_replace($nbr_of_aliquots_to_create,'', $new_source);
			
			if(array_key_exists($new_source, Config::$tissueCodeSynonimous)) $new_source = Config::$tissueCodeSynonimous[$new_source];
			if(!array_key_exists($new_source, Config::$tissueCode2Details)) die("<br><FONT COLOR=\"red\" >Line ".$m->line." / NS = $ns [OCT][ERROR]: Parent type '$new_source' of an oct tube is not supported.</FONT><br>");
				
			if(!array_key_exists($new_source, $collections)) {
				//Create parent
				echo "<br><FONT>[OCT][WARNING]: Line ".$m->line." / NS = $ns Created parent '$new_source' for an 'oct tube' value equal to '$new_source' because this one does not exist into 'SOURCE' column.</FONT><br>";
				$collections[$new_source] = array('type' => 'tissue', 'details' => Config::$tissueCode2Details[$new_source], 'aliquots' => array(), 'derivatives' => array());
			}

			$box = array_shift($boxes);
			if(is_null($box)) die('ERR0098373');
			preg_match('/^([0-9]+)$/', $box, $matches);
			if(!empty($box) && !isset($matches[1])) { echo "<br><FONT COLOR=\"green\" >[OCT][WARNING]: Line ".$m->line." / NS = $ns OCT box value [$box] looks like wrong (not numeric)!</FONT><br>";}
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
	
	$tissu_cell_data = $invantory_data_from_file['TISSU'];
	if(!empty($tissu_cell_data)) {
		//Get all different types of source
		$tissu_cell_data = str_replace( array(" ", "T/", "/"), array("", "", ","), strtoupper($tissu_cell_data));
		$tissu_cell_data = preg_replace('/^(.+)\,$/', '$1', $tissu_cell_data);
		$tissue_sources = explode(',', $tissu_cell_data);

		// Set boxes array per source types
		$boxes = explode(',', str_replace(array(" ", "/", "."), array("", ",", ","), $invantory_data_from_file[utf8_decode('N0 BOÎTE TISSU')]));
		$boxes =(empty($boxes))? array('') : $boxes;
		if(sizeof($boxes) == 1) { for($i = 1; $i < sizeof($tissue_sources); $i++) { $boxes[] = $boxes[0]; } }	
		if(sizeof($boxes) != sizeof($tissue_sources)) {
//TODO			die("<br><FONT COLOR=\"red\" >Line ".$m->line." / NS = $ns [TISSU][ERROR] 1: The box definitions [".$invantory_data_from_file[utf8_decode('N0 BOÎTE TISSU')]."] does not match the TISSU defintion [".$invantory_data_from_file['TISSU']."] (check wrong coma, etc).</FONT><br>"); 

echo "<br><FONT COLOR=\"red\" >Line ".$m->line." / NS = $ns [TISSU][ERROR] 1: The box definitions [".$invantory_data_from_file[utf8_decode('N0 BOÎTE TISSU')]."] does not match the TISSU defintion [".$invantory_data_from_file['TISSU']."] (check wrong coma, etc).</FONT><br>"; 
$boxes = array('WRONG_BOX');
for($i = 1; $i < sizeof($tissue_sources); $i++) { $boxes[] = $boxes[0];	}		
		}
		
		// Set product
		foreach($tissue_sources as $new_source) {
			preg_match('/^([0-9]+)?/',  $new_source, $matches);
			$nbr_of_aliquots_to_create = isset($matches[1])? $matches[1] : 1;
			$new_source = str_replace($nbr_of_aliquots_to_create,'', $new_source);
			
			if(array_key_exists($new_source, Config::$tissueCodeSynonimous)) $new_source = Config::$tissueCodeSynonimous[$new_source];
			if(!array_key_exists($new_source, Config::$tissueCode2Details)) {
//TODO				die("<br><FONT COLOR=\"red\" >Line ".$m->line." / NS = $ns [TISSU][ERROR]: Parent type '$new_source' of an TISSU tube is not supported.</FONT><br>");
echo "<br><FONT COLOR=\"red\" >Line ".$m->line." / NS = $ns [TISSU][ERROR]: Parent type '$new_source' of an TISSU tube is not supported.</FONT><br>";
$new_source = 'AP';				
			}	
			if(!array_key_exists($new_source, $collections)) {
				//Create parent
				echo "<br><FONT>[TISSU][WARNING]: Line ".$m->line." / NS = $ns Created parent '$new_source' for an 'TISSU tube' value equal to '$new_source' because this one does not exist into 'SOURCE' column.</FONT><br>";
				$collections[$new_source] = array('type' => 'tissue', 'details' => Config::$tissueCode2Details[$new_source], 'aliquots' => array(), 'derivatives' => array());
			}

			$box = array_shift($boxes);
			if(is_null($box)) die('ERR0098374');
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
	
	$ffpe_cell_data = $invantory_data_from_file['FFPE'];
	if(!empty($ffpe_cell_data)) {
		//Get all different types of source
		$ffpe_cell_data = str_replace( array(" ", "P/", "/"), array("", "", ","), strtoupper($ffpe_cell_data));
		$ffpe_cell_data = preg_replace('/^(.+)\,$/', '$1', $ffpe_cell_data);
		$ffpe_sources = explode(',', $ffpe_cell_data);

		// Set boxes array per source types
		$boxes = explode(',', str_replace(array(" ", "/", "."), array("", ",", ","), $invantory_data_from_file[utf8_decode('N0 BOÎTE FFPE')]));
		$boxes =(empty($boxes))? array('') : $boxes;
		if(sizeof($boxes) == 1) { for($i = 1; $i < sizeof($ffpe_sources); $i++) { $boxes[] = $boxes[0]; } }	
		if(sizeof($boxes) != sizeof($ffpe_sources)) die("<br><FONT COLOR=\"red\" >Line ".$m->line." / NS = $ns [FFPE][ERROR] 1: The box definitions [".$invantory_data_from_file[utf8_decode('N0 BOÎTE FFPE')]."] does not match the ffpe defintion [".$invantory_data_from_file['FFPE']."] (check wrong coma, etc).</FONT><br>"); 
		
		// Set product
		foreach($ffpe_sources as $new_source) {
			preg_match('/^([0-9]+)?/',  $new_source, $matches);
			$nbr_of_aliquots_to_create = isset($matches[1])? $matches[1] : 1;
			$new_source = str_replace($nbr_of_aliquots_to_create,'', $new_source);
			
			if(array_key_exists($new_source, Config::$tissueCodeSynonimous)) $new_source = Config::$tissueCodeSynonimous[$new_source];
			if(!array_key_exists($new_source, Config::$tissueCode2Details)) die("<br><FONT COLOR=\"red\" >Line ".$m->line." / NS = $ns [FFPE][ERROR]: Parent type '$new_source' of an ffpe tube is not supported.</FONT><br>");
				
			if(!array_key_exists($new_source, $collections)) {
				//Create parent
				echo "<br><FONT>[FFPE][WARNING]: Line ".$m->line." / NS = $ns Created parent '$new_source' for an 'ffpe tube' value equal to '$new_source' because this one does not exist into 'SOURCE' column.</FONT><br>";
				$collections[$new_source] = array('type' => 'tissue', 'details' => Config::$tissueCode2Details[$new_source], 'aliquots' => array(), 'derivatives' => array());
			}

			$box = array_shift($boxes);
			if(is_null($box)) die('ERR0098376');
			preg_match('/^([0-9]+)$/', $box, $matches);
			if(!empty($box) && !isset($matches[1])) { echo "<br><FONT COLOR=\"green\" >[FFPE][WARNING]: Line ".$m->line." / NS = $ns FFPE box value [$box] looks like wrong (not numeric)!</FONT><br>";}
			while($nbr_of_aliquots_to_create) { 
				$collections[$new_source]['aliquots'][] = array('type' =>$aliquot_type, 'storage' => $box); 
				$nbr_of_aliquots_to_create--;
			}
		}
	}
	
	//--- End of FFPE	
	
	// --------------------------------------------------------------------------
	// [SANG-PLASMA-SÉRUM- CULOT ENRICHI ] + blood_file_data : sample => blood,etc , aliquot => +-tube
	$aliquot_type = 'paraffin block';
	
	$merged_blood_data = array_key_exists($ns, Config::$bloodBoxesData)? Config::$bloodBoxesData[$ns] : array();
	unset(Config::$bloodBoxesData[$ns]);

	$blood_cell_data = $invantory_data_from_file[utf8_decode('SANG-PLASMA-SÉRUM- CULOT ENRICHI ')];
	if(!empty($blood_cell_data) || !empty($merged_blood_data)) {

		if(!empty($blood_cell_data)) {
			// Merge data from box worksheet witht data of main worksheet
			$blood_cell_data = str_replace(array(" ", 'sang', 'RNAlater'), array("", 'Sang', 'RL'), $blood_cell_data);
			$blood_cell_data = preg_replace('/^(.+)\,$/', '$1', $blood_cell_data);
			$blood_data_from_all_file = explode(',', $blood_cell_data);		

			foreach($blood_data_from_all_file as $new_blood_type) {
				preg_match('/^([0-9]+)?/',  $new_blood_type, $matches);
				$nbr_of_aliquots_to_create = isset($matches[1])? $matches[1] : 1;
				$new_blood_type = str_replace($nbr_of_aliquots_to_create,'', $new_blood_type);
				if(!in_array($new_blood_type, array('Sang', 'P', 'CE', 'S', 'RL', 'ARLT'))) die("<br><FONT COLOR=\"red\" >Line ".$m->line." / NS = $ns [SANG][ERROR]: Blood type '$new_blood_type' is not supported.</FONT><br>");
				
				if(isset($merged_blood_data[$new_blood_type]) && sizeof($merged_blood_data[$new_blood_type]) == $nbr_of_aliquots_to_create) {
					// Same data into the 2 worksheets.... nothing to do
				} else if(isset($merged_blood_data[$new_blood_type]) && sizeof($merged_blood_data[$new_blood_type]) != $nbr_of_aliquots_to_create) {
					echo "<br><FONT COLOR=\"green\" >[BLOOD][WARNING]: Line ".$m->line." / NS = $ns Nbr of [$new_blood_type] is not the same into teh 2 worksheets (".sizeof($merged_blood_data[$new_blood_type])." != $nbr_of_aliquots_to_create)!</FONT><br>";
					$nbr_to_add = $nbr_of_aliquots_to_create - sizeof($merged_blood_data[$new_blood_type]);
					$nbr_to_add = ($nbr_to_add < 0)? 0 : $nbr_to_add;
						
					while($nbr_to_add) {
						$merged_blood_data[$new_blood_type][] = array('box' => '');
						$nbr_to_add--;
					}		
				} else {$exit = true;
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
			$aliquot_type = ($product_type == 'RL')? 'RNALater tube': (($product_type == 'ARLT')? 'Erythrocytes tube': 'tube');
			$aliquots_array = array();
			foreach ($aliquots as $new_aliquot) {
				$aliquots_array[] = array('type' =>$aliquot_type,'storage' => $new_aliquot['box']);
			}
			
			// Add blood
			if(!isset($collections['blood'])) $collections['blood'] = array('type' => 'blood', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
			
			switch($product_type) {
				case 'Sang':
				case 'RL':
					$collections['blood']['aliquots'] += $aliquots_array;
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
				case 'ARLT':
//TODO	to confirm
					if(!isset($collections['blood']['derivatives']['blood cell'])) $collections['blood']['derivatives']['blood cell'] = array('type' => 'blood cell', 'details' => null, 'aliquots' => array(), 'derivatives' => array());						
					$collections['blood']['derivatives']['blood cell']['aliquots'] = array_merge($collections['blood']['derivatives']['blood cell']['aliquots'], $aliquots_array);						
					break;							
				default:
					pr($merged_blood_data);
					die("<br><FONT COLOR=\"red\" >Line ".$m->line." [blood_file][ERROR]: blood sample '$product_type' is not supported. </FONT><br>");		
			}			
		}

	}
	
	//--- End of SANG		
	
	// - ASCITE + LP --------------------------------------------------------------------
	// [ASCITE] + [NO BÔITE ASC,S, RNALATER] + [NO BÔTE ASCITE (NC)] : sample => ascite,etc , aliquot => tube --
	
//TODO	NO BÔITE ASC,S, RNALATER means serum and blood rnalater?	

	$ascite_cell_data = $invantory_data_from_file['ASCITE'];
	$ascite_boxes = $invantory_data_from_file[utf8_decode('NO BÔITE ASC,S, RNALATER')];
	$nc_boxes = $invantory_data_from_file[utf8_decode('NO BÔTE ASCITE (NC)')];
	
	if(!empty($ascite_cell_data)) {
		$ascite_cell_data = str_replace(' ', '', $ascite_cell_data);
		
		// MANAGE NC
		$nc_tubes_nbrs = 0;
		$ncs_string = '';
		preg_match('/([0-9]*NC)/',  $ascite_cell_data, $matches);
		if(isset($matches[1]))  {
			$ncs_string = $matches[1];
			preg_match('/^([0-9]+)/',  $ncs_string, $matches);
			$nc_tubes_nbrs = isset($matches[1])? $matches[1] : 1;
		}
		$ascite_cell_data =  str_replace(array($ncs_string, ',,'), array('', ','), $ascite_cell_data);
		if($nc_tubes_nbrs) {
			preg_match('/^([0-9]+)?/',  $nc_boxes, $matches);
			if(!empty($nc_boxes) && !isset($matches[1])) { die( "<br><FONT COLOR=\"red\" >[ASCITE][WARNING]: Line ".$m->line." / NS = $ns NC box value [$nc_boxes] looks like wrong (not numeric)!</FONT><br>");}
			$nc_boxes = empty($nc_boxes)? 0 : $nc_boxes;

			if(!isset($collections['ascite'])) $collections['ascite'] = array('type' => 'ascite', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
			$collections['ascite']['derivatives']['ascite cell'] = array('type' => 'ascite cell', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
			while($nc_tubes_nbrs) { 
				$collections['ascite']['derivatives']['ascite cell']['aliquots'][] = array('type' =>'tube', 'storage' => $nc_boxes); 
				$nc_tubes_nbrs--;
			}
		}
		
		// MANAGE ASCITE WITHOUT NC
		$ascite_cell_data = preg_replace('/^(.+)\,$/', '$1', $ascite_cell_data);
		if(!empty($ascite_cell_data)) {
			$ascite_without_ncs = explode(',', $ascite_cell_data);
			
			// Set boxes array
			$boxes = explode(',', str_replace(array(" ", "/", "."), array("", ",", ","), $ascite_boxes));
			$boxes =(empty($boxes))? array('') : $boxes;
			if(sizeof($boxes) == 1) { for($i = 1; $i < sizeof($ascite_without_ncs); $i++) { $boxes[] = $boxes[0]; } }	
			if(sizeof($boxes) != sizeof($ascite_without_ncs)) die("<br><FONT COLOR=\"red\" >Line ".$m->line." / NS = $ns [ASCITE][ERROR] 1: The box definitions [".$invantory_data_from_file[utf8_decode('NO BÔITE ASC,S, RNALATER')]."] does not match the ascite defintion [".$invantory_data_from_file['ASCITE']."] (check wrong coma, etc).</FONT><br>"); 
				
			// Set product
			foreach($ascite_without_ncs as $new_source) {
				preg_match('/^([0-9]+)?/',  $new_source, $matches);
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
					
					if($new_source = 'ASC') {
						$collections['ascite']['aliquots'] = array_merge($collections['ascite']['aliquots'], $aliquots);
					} else {
						if(!isset($collections['ascite']['derivatives']['ascite supernatant'])) $collections['ascite']['derivatives']['ascite supernatant'] = array('type' => 'ascite supernatant', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
						$collections['ascite']['derivatives']['ascite supernatant']['aliquots'] = array_merge($collections['ascite']['derivatives']['ascite supernatant']['aliquots'], $aliquots) ;
					}				
				
				} else if($new_source == 'LP') {
					if(!isset($collections['peritoneal wash'])) $collections['peritoneal wash'] = array('type' => 'peritoneal wash', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
					$collections['peritoneal wash']['aliquots'] = array_merge($collections['peritoneal wash']['aliquots'], $aliquots) ;
					
				} else if($new_source == 'S'){
//TODO confrim
					if(!isset($collections['blood'])) $collections['blood'] = array('type' => 'blood', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
					if(!isset($collections['blood']['derivatives']['serum'])) $collections['blood']['derivatives']['serum'] = array('type' => 'serum', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
					$collections['blood']['derivatives']['serum']['aliquots'] = array_merge($collections['blood']['derivatives']['serum']['aliquots'], $aliquots) ;	
				} else {
					die("<br><FONT COLOR=\"red\" >Line ".$m->line." / NS = $ns [ASCITE][ERROR] 1: ASCITE data [$new_source] unknown!</FONT>");
				}
			}
		}
	} 	
	
	
//	// ASCITE  ----------------------------------------------------------------------
//	
////	$aliquot_type = 'tube';
////	if(!empty($invantory_data_from_file['ASCITE'])) {
////		$ascites_tmp = str_replace(' ', '', $invantory_data_from_file['ASCITE']);
////		$ascites = explode('/', strtoupper($ascites_tmp));
////
////		foreach($ascites as $new_sample) {
////			if(!empty($new_sample)) {
////				if(!isset($collections['ascite'])) $collections['ascite'] = array('type' => 'ascite', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
////
////				preg_match('/^([0-9]+)/', $new_sample, $matches);	
////				$tubes_nbr = empty($matches)? '1' : $matches[1];
////				$new_sample = str_replace($tubes_nbr, '', $new_sample);	
////	
////				switch($new_sample) {
////					case 'ASC':
////						while($tubes_nbr > 0) { 
////							$collections['ascite']['aliquots'][] = array('type' =>$aliquot_type,'storage' => null); 
////							$tubes_nbr--;
////						}
////						break;
////					case 'S':
////					case 'SASC':
////						if(!isset($collections['ascite']['derivatives']['ascite supernatant'])) $collections['ascite']['derivatives']['ascite supernatant'] = array('type' => 'ascite supernatant', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
////						while($tubes_nbr > 0) { 
////							$collections['ascite']['derivatives']['ascite supernatant']['aliquots'][] = array('type' =>$aliquot_type,'storage' => null); 
////							$tubes_nbr--;
////						}
////						break;
////					case 'NC':
////						if(!isset($collections['ascite']['derivatives']['ascite cells'])) $collections['ascite']['derivatives']['ascite cells'] = array('type' => 'ascite cells', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
////						while($tubes_nbr > 0) { 
////							$collections['ascite']['derivatives']['ascite cells']['aliquots'][] = array('type' =>$aliquot_type,'storage' => null); 
////							$tubes_nbr--;
////						}
////						break;
////					default:
////						die("<br><FONT COLOR=\"red\" >Line ".$m->line." [ERR][ASCITE]: Ascite sample '$new_sample' is not supported. </FONT><br>");		
////				}
////			}
////		}
////	} //End of ASCITE	
//	
//	// ASCITE FROM FILE ---------------------------------------------------------------------- 
//	
//	$aliquot_type = 'tube';
//	if(isset($m->boxesData[$ns]['ASCITE'])) {
//		foreach($m->boxesData[$ns]['ASCITE'] as $ascite_tubes) {
//			$storage = str_replace('BT#', '', str_replace(' ','', $ascite_tubes['box']));
//			if(!empty($ascite_tubes['nbr_tubes'])) die("ERR:dadaad9");
//			$sources = explode(',', strtoupper(str_replace(' ','', $ascite_tubes['samples'])));
//			foreach($sources as $new_source) {
//				if(!empty($new_source)) {
//					if(!isset($collections['ascite'])) $collections['ascite'] = array('type' => 'ascite', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
//					
//					preg_match('/^([0-9]+)/', $new_source, $matches);	
//					$tubes_nbr = empty($matches)? '1' : $matches[1];
//					$new_source = str_replace($tubes_nbr, '', $new_source);	
//					
//					switch($new_source) {
//						case 'ASC':
//							while($tubes_nbr > 0) { 
//								$collections['ascite']['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
//								$tubes_nbr--;
//							}
//							break;
//						case 'S':
//						case 'SASC':
//							if(!isset($collections['ascite']['derivatives']['ascite supernatant'])) $collections['ascite']['derivatives']['ascite supernatant'] = array('type' => 'ascite supernatant', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
//							while($tubes_nbr > 0) { 
//								$collections['ascite']['derivatives']['ascite supernatant']['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
//								$tubes_nbr--;
//							}
//							break;
//						case 'NC':
//							die ('8981239123');
//							break;
//						default:
//							die("<br><FONT COLOR=\"red\" >Line ".$m->line." [ERR][ASCITE_file]: Ascite sample '$new_source' is not supported. </FONT><br>");		
//					}
//				}				
//			}
//		}
//	}
//	
//	// ASC NC FROM FILE ---------------------------------------------------------------------- 
//	
//	$aliquot_type = 'tube';
//	if(isset($m->boxesData[$ns]['ASC_NC'])) {
//		foreach($m->boxesData[$ns]['ASC_NC'] as $ascite_tubes) {
//			$storage = str_replace('BT#', '', str_replace(' ','', $ascite_tubes['box']));
//			if(!empty($ascite_tubes['nbr_tubes'])) die("ERR:dadaad9");
//			$sources = explode(',', strtoupper(str_replace(' ','', $ascite_tubes['samples'])));
//			foreach($sources as $new_source) {
//				if(!empty($new_source)) {
//					if(!isset($collections['ascite'])) $collections['ascite'] = array('type' => 'ascite', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
//					
//					preg_match('/^([0-9]+)/', $new_source, $matches);	
//					$tubes_nbr = empty($matches)? '1' : $matches[1];
//					$new_source = str_replace($tubes_nbr, '', $new_source);	
//					
//					switch($new_source) {
//						case 'ASC':
//						case 'S':
//						case 'SASC':
//							die ('8981239123');
//							break;
//						case 'NC':
//							if(!isset($collections['ascite']['derivatives']['ascite cells'])) $collections['ascite']['derivatives']['ascite cells'] = array('type' => 'ascite cells', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
//							while($tubes_nbr > 0) { 
//								$collections['ascite']['derivatives']['ascite cells']['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
//								$tubes_nbr--;
//							}
//							break;
//						default:
//							die("<br><FONT COLOR=\"red\" >Line ".$m->line." [ERR][ASCITE_NC_file]: Ascite sample '$new_source' is not supported. </FONT><br>");		
//					}
//				}				
//			}
//		}
//	}
//	
	
	

	
	
	


//	
//	// DNA TISSUE FROM FILE ---------------------------------------------------------------------- 
//
//	$aliquot_type = 'tube';
//	if(isset($m->boxesData[$ns]['ADN TISSU'])) {
//		foreach($m->boxesData[$ns]['ADN TISSU'] as $dna_tubes) {
//			$storage = str_replace('BT#', '', str_replace(' ','', $dna_tubes['box']));
//			if(!empty($dna_tubes['nbr_tubes'])) die("ERR:79829");
//			$sources = explode(',', strtoupper(str_replace(' ','', $dna_tubes['samples'])));
//			foreach($sources as $new_source) {
//				if(!empty($new_source)) {
//					preg_match('/^([0-9]+)/', $new_source, $matches);	
//					$tubes_nbr = empty($matches)? '1' : $matches[1];
//	
//					$new_source = str_replace($tubes_nbr, '', $new_source);	
//					if(array_key_exists($new_source, Config::$tissueCodeSynonimous)) $new_source = Config::$tissueCodeSynonimous[$new_source];
//					if(!array_key_exists($new_source, Config::$tissueCode2Details)) die("<br><FONT COLOR=\"red\" >Line ".$m->line." / NS = $ns [DNA_file][ERROR]: Parent type '$new_source' of a dna tissue tube is not supported.</FONT><br>");
//					
//					if(!array_key_exists($new_source, $collections)) {
//						//Create parent
//						echo "<br><FONT COLOR=\"green\" >Line ".$m->line." / NS = $ns [DNA_file]: Created parent '$new_source' for a frozen tube value equal to '$new_source' because this one does not exist into 'SOURCE' column.</FONT><br>";
//						$collections[$new_source] = array('type' => 'tissue', 'details' => Config::$tissueCode2Details[$new_source], 'aliquots' => array(), 'derivatives' => array());
//					}
//					if(!isset($collections[$new_source]['derivatives']['dna'])) $collections[$new_source]['derivatives']['dna'] = array('type' => 'dna', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
//					
//					while($tubes_nbr > 0) { 
//						$collections[$new_source]['derivatives']['dna']['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
//						$tubes_nbr--;
//					}
//				}				
//			}
//		}
//	}	
//	
//	// RNA TISSUE FROM FILE ---------------------------------------------------------------------- 
//	
//	$aliquot_type = 'tube';
//	if(isset($m->boxesData[$ns]['ARN TISSU'])) {
//		foreach($m->boxesData[$ns]['ARN TISSU'] as $rna_tubes) {
//			$storage = str_replace('BT#', '', str_replace(' ','', $rna_tubes['box']));
//			if(!empty($rna_tubes['nbr_tubes'])) die("ERR:79829");
//			$sources = explode(',', strtoupper(str_replace(' ','', $rna_tubes['samples'])));
//			foreach($sources as $new_source) {
//				if(!empty($new_source)) {
//					preg_match('/^([0-9]+)/', $new_source, $matches);	
//					$tubes_nbr = empty($matches)? '1' : $matches[1];
//	
//					$new_source = str_replace($tubes_nbr, '', $new_source);	
//					if(array_key_exists($new_source, Config::$tissueCodeSynonimous)) $new_source = Config::$tissueCodeSynonimous[$new_source];
//					if(!array_key_exists($new_source, Config::$tissueCode2Details)) die("<br><FONT COLOR=\"red\" >Line ".$m->line." / NS = $ns [rna_file][ERROR]: Parent type '$new_source' of a rna tissue tube is not supported.</FONT><br>");
//					
//					if(!array_key_exists($new_source, $collections)) {
//						//Create parent
//						echo "<br><FONT COLOR=\"green\" >Line ".$m->line." / NS = $ns [rna_file]: Created parent '$new_source' for a frozen tube value equal to '$new_source' because this one does not exist into 'SOURCE' column.</FONT><br>";
//						$collections[$new_source] = array('type' => 'tissue', 'details' => Config::$tissueCode2Details[$new_source], 'aliquots' => array(), 'derivatives' => array());
//					}
//					if(!isset($collections[$new_source]['derivatives']['rna'])) $collections[$new_source]['derivatives']['rna'] = array('type' => 'rna', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
//					
//					while($tubes_nbr > 0) { 
//						$collections[$new_source]['derivatives']['rna']['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
//						$tubes_nbr--;
//					}
//				}				
//			}
//		}
//	}
//


//	

//	// VC ----------------------------------------------------------------------
//	
//	$aliquot_type = 'tube';
//	if(!empty($invantory_data_from_file['VC'])) {
//		$vcs_tmp = str_replace(' ', '', $invantory_data_from_file['VC']);
//		$vcs_tmp = str_replace('-bt#', '#', $vcs_tmp);
//		$vcs_tmp = str_replace('bt#', '#', $vcs_tmp);
//		$storage_for_all = null;
//		if(substr_count($vcs_tmp, '#') == 1) { 
//			preg_match('/#([0-9]+\(I+\))|#([0-9]+A)|#([0-9]+)/', $vcs_tmp, $matches);
//			$storage_for_all = str_replace('#', '', $matches[0]); 
//			$vcs_tmp = preg_replace('/#([0-9]+\(I+\))|#([0-9]+A)|#([0-9]+)/', '', $vcs_tmp);
//		}
//		$vcs = explode(',', strtoupper($vcs_tmp));
//		
//		foreach($vcs as $new_source) {
//			$storage = $storage_for_all;
//			if(empty($storage)) {
//				preg_match('/#([0-9]+\(I+\))|#([0-9]+A)|#([0-9]+)/', $new_source, $matches);	
//				if(!empty($matches)) $storage = str_replace('#', '', $matches[0]); 
//				$new_source = preg_replace('/#([0-9]+\(I+\))|#([0-9]+A)|#([0-9]+)/', '', $new_source);			
//			}
//			preg_match('/^([0-9]+)/', $new_source, $matches);	
//			$tubes_nbr = empty($matches)? '1' : $matches[1];
//			$new_source = str_replace($tubes_nbr, '', $new_source);	
//
//			if(array_key_exists($new_source, Config::$tissueCodeSynonimous)) $new_source = Config::$tissueCodeSynonimous[$new_source];
//			
//			if(array_key_exists($new_source, Config::$tissueCode2Details)) {
//				// SOURCE = TISSUE
//				
////				if(($new_source == 'OV') && (!array_key_exists($new_source, $collections))) {
////					// Try to match with existing ovary
////					$ovaries_already_recorded = '';
////					$ov_list_to_display = '';
////					foreach($collections as $key_source => $tmp) {
////						if(in_array($key_source, $m->ovCodes)) {
////							$ovaries_already_recorded[] = $key_source;
////							$ov_list_to_display .= $key_source.', ';
////						}
////					}
////					if(sizeof($ovaries_already_recorded) == 1) {
////						$source_already_recorded = $ovaries_already_recorded[0];
////						echo "<br><FONT COLOR=\"green\" >Line ".$m->line." [VC]: Changed the parent defintion for a 'VC' value from {OV} to {$source_already_recorded} because only one ovary type has already been defined as collected for this participant.</FONT><br>";
////						$new_source = $source_already_recorded;
////					} else if(sizeof($ovaries_already_recorded) > 1) {
////						echo "<br><FONT COLOR=\"red\" >Line ".$m->line." [VC][WARNING]: Unable to define parent for a 'VC' value equals to {$new_source} because there is too many existing parents that could be applied (".$ov_list_to_display."). Will create a new {OV}.</FONT><br>";
////					}	
////				}
//				
//				if(!isset($collections[$new_source])) $collections[$new_source] = array('type' => 'tissue', 'details' => Config::$tissueCode2Details[$new_source], 'aliquots' => array(), 'derivatives' => array());
//				if(!isset($collections[$new_source]['derivatives']['cell culture'])) $collections[$new_source]['derivatives']['cell culture'] = array('type' => 'cell culture', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
//				while($tubes_nbr > 0) { 
//					$collections[$new_source]['derivatives']['cell culture']['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
//					$tubes_nbr--;
//				}
//			
//			} else if($new_source == 'ASC') {
//				// SOURCE = ASCITE
//				
//				if(!isset($collections['ascite'])) $collections['ascite'] = array('type' => 'ascite', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
//				if(!isset($collections['ascite']['derivatives']['ascite cells'])) $collections['ascite']['derivatives']['ascite cells'] = array('type' => 'ascite cells', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
//				if(!isset($collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture'])) $collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture'] = array('type' => 'cell culture', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
//				while($tubes_nbr > 0) { 
//					$collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture']['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
//					$tubes_nbr--;
//				}
//								
//			} else {
//				die("<br><FONT COLOR=\"red\" >Line ".$m->line." [VC][ERROR]: Source '$new_source' is not supported. ".$invantory_data_from_file['VC']."</FONT><br>");
//			}
//		}	
//	} //End of VC
//	
//	// RNA ----------------------------------------------------------------------
//	
//	$aliquot_type = 'tube';
//	$storage = empty($invantory_data_from_file['boite ARN'])? null : $invantory_data_from_file['boite ARN'];
//	if(!is_null($storage)) {
//		preg_match('/^([0-9]+)$/', $storage, $matches);
//		if(empty($matches)) die('ER:98873 -'.$invantory_data_from_file['boite ARN']);
//	}	
//	if(!empty($invantory_data_from_file['RNA (PC)'])) {
//		$rnas_tmp = str_replace(' ', '', $invantory_data_from_file['RNA (PC)']);
//		$rnas_tmp = str_replace(',', '/', $rnas_tmp);
//		$rnas = explode('/', strtoupper($rnas_tmp));
//
//		if($rnas[0] != 'RNA') die("<br><FONT COLOR=\"red\" >Line ".$m->line." [RNA]: RNA cell content dones not start with 'RNA'!</FONT><br>");
//		unset($rnas[0]);
//		if(empty($rnas)) die("<br><FONT COLOR=\"red\" >Line ".$m->line." [RNA]: RNA cell content is empty!</FONT><br>");
//		
//		foreach($rnas as $new_source) {
//			if(!empty($new_source)) {
//				preg_match('/^([0-9]+)/', $new_source, $matches);	
//				$tubes_nbr = empty($matches)? '1' : $matches[1];
//				$new_source = str_replace($tubes_nbr, '', $new_source);	
//				
//				if(array_key_exists($new_source, Config::$tissueCodeSynonimous)) $new_source = Config::$tissueCodeSynonimous[$new_source];
//				
//				if(array_key_exists($new_source, Config::$tissueCode2Details)) {
//					// SOURCE = TISSUE
////					if(($new_source == 'OV') && (!array_key_exists($new_source, $collections))) {
////						// Try to match with existing ovary
////						$ovaries_already_recorded = '';
////						$ov_list_to_display = '';
////						foreach($collections as $key_source => $tmp) {
////							if(in_array($key_source, $m->ovCodes)) {
////								$ovaries_already_recorded[] = $key_source;
////								$ov_list_to_display .= $key_source.', ';
////							}
////						}
////						if(sizeof($ovaries_already_recorded) == 1) {
////							$source_already_recorded = $ovaries_already_recorded[0];
////							echo "<br><FONT COLOR=\"green\" >Line ".$m->line." [RNA]: Changed the parent defintion for a 'RNA' value from {OV} to {$source_already_recorded} because only one ovary type has already been defined as collected for this participant.</FONT><br>";
////							$new_source = $source_already_recorded;
////						} else if(sizeof($ovaries_already_recorded) > 1) {
////							echo "<br><FONT COLOR=\"red\" >Line ".$m->line." [RNA][WARNING]: Unable to define parent for a 'RNA' value equals to {$new_source} because there is too many existing parents that could be applied (".$ov_list_to_display."). Will create a new {OV}.</FONT><br>";
////						}	
////					}
//					
//					if(!isset($collections[$new_source])) $collections[$new_source] = array('type' => 'tissue', 'details' => Config::$tissueCode2Details[$new_source], 'aliquots' => array(), 'derivatives' => array());
//					if(!isset($collections[$new_source]['derivatives']['cell culture'])) $collections[$new_source]['derivatives']['cell culture'] = array('type' => 'cell culture', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
//					if(!isset($collections[$new_source]['derivatives']['cell culture']['derivatives']['rna'])) $collections[$new_source]['derivatives']['cell culture']['derivatives']['rna'] = array('type' => 'rna', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
//					while($tubes_nbr > 0) { 
//						$collections[$new_source]['derivatives']['cell culture']['derivatives']['rna']['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
//						$tubes_nbr--;
//					}
//				
//				} else if($new_source == 'ASC') {
//					// SOURCE = ASCITE
//					if(!isset($collections['ascite'])) $collections['ascite'] = array('type' => 'ascite', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
//					if(!isset($collections['ascite']['derivatives']['ascite cells'])) $collections['ascite']['derivatives']['ascite cells'] = array('type' => 'ascite cells', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
//					if(!isset($collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture'])) $collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture'] = array('type' => 'cell culture', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
//					if(!isset($collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture']['derivatives']['rna'])) $collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture']['derivatives']['rna'] = array('type' => 'rna', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
//					while($tubes_nbr > 0) { 
//						$collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture']['derivatives']['rna']['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
//						$tubes_nbr--;
//					}
//									
//				} else {
//					die("<br><FONT COLOR=\"red\" >Line ".$m->line." [RNA][ERROR]: Source '$new_source' is not supported. ".$invantory_data_from_file['RNA (PC)']."</FONT><br>");
//				}
//			}
//		}
//	} //End of RNA
//	
//	// DNA ----------------------------------------------------------------------
//
//	$aliquot_type = 'tube';
//	$storage = empty($invantory_data_from_file['boite ADN'])? null : $invantory_data_from_file['boite ADN'];
//	if(!is_null($storage)) {
//		preg_match('/^([0-9]+)$/', $storage, $matches);
//		if(empty($matches)) die('ER:98873 -'.$invantory_data_from_file['boite ADN']);
//	}	
//	if((!empty($invantory_data_from_file['DNA(PC)'])) && ($invantory_data_from_file['DNA(PC)'] != ' ')) {
//		$dnas_tmp = str_replace(' ', '', $invantory_data_from_file['DNA(PC)']);
//		$dnas_tmp = str_replace(',', '/', $dnas_tmp);
//		$dnas = explode('/', strtoupper($dnas_tmp));
//
//		if($dnas[0] != 'DNA') die("<br><FONT COLOR=\"red\" >Line ".$m->line." [DNA]: DNA cell content dones not start with 'DNA'!</FONT><br>");
//		unset($dnas[0]);
//		if(empty($dnas)) die("<br><FONT COLOR=\"red\" >Line ".$m->line." [DNA]: DNA cell content is empty!</FONT><br>");
//		
//		foreach($dnas as $new_source) {
//			if(!empty($new_source)) {
//				preg_match('/^([0-9]+)/', $new_source, $matches);	
//				$tubes_nbr = empty($matches)? '1' : $matches[1];
//				$new_source = str_replace($tubes_nbr, '', $new_source);	
//				
//				if(array_key_exists($new_source, Config::$tissueCodeSynonimous)) $new_source = Config::$tissueCodeSynonimous[$new_source];
//				
//				if(array_key_exists($new_source, Config::$tissueCode2Details)) {
//					// SOURCE = TISSUE
////					if(($new_source == 'OV') && (!array_key_exists($new_source, $collections))) {
////						// Try to match with existing ovary
////						$ovaries_already_recorded = '';
////						$ov_list_to_display = '';
////						foreach($collections as $key_source => $tmp) {
////							if(in_array($key_source, $m->ovCodes)) {
////								$ovaries_already_recorded[] = $key_source;
////								$ov_list_to_display .= $key_source.', ';
////							}
////						}
////						if(sizeof($ovaries_already_recorded) == 1) {
////							$source_already_recorded = $ovaries_already_recorded[0];
////							echo "<br><FONT COLOR=\"green\" >Line ".$m->line." [DNA]: Changed the parent defintion for a 'DNA' value from {OV} to {$source_already_recorded} because only one ovary type has already been defined as collected for this participant.</FONT><br>";
////							$new_source = $source_already_recorded;
////						} else if(sizeof($ovaries_already_recorded) > 1) {
////							echo "<br><FONT COLOR=\"red\" >Line ".$m->line." [DNA][WARNING]: Unable to define parent for a 'DNA' value equals to {$new_source} because there is too many existing parents that could be applied (".$ov_list_to_display."). Will create a new {OV}.</FONT><br>";
////						}	
////					}
//					
//					if(!isset($collections[$new_source])) $collections[$new_source] = array('type' => 'tissue', 'details' => Config::$tissueCode2Details[$new_source], 'aliquots' => array(), 'derivatives' => array());
//					if(!isset($collections[$new_source]['derivatives']['cell culture'])) $collections[$new_source]['derivatives']['cell culture'] = array('type' => 'cell culture', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
//					if(!isset($collections[$new_source]['derivatives']['cell culture']['derivatives']['dna'])) $collections[$new_source]['derivatives']['cell culture']['derivatives']['dna'] = array('type' => 'dna', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
//					while($tubes_nbr > 0) { 
//						$collections[$new_source]['derivatives']['cell culture']['derivatives']['dna']['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
//						$tubes_nbr--;
//					}
//				
//				} else if($new_source == 'ASC') {
//					// SOURCE = ASCITE
//					if(!isset($collections['ascite'])) $collections['ascite'] = array('type' => 'ascite', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
//					if(!isset($collections['ascite']['derivatives']['ascite cells'])) $collections['ascite']['derivatives']['ascite cells'] = array('type' => 'ascite cells', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
//					if(!isset($collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture'])) $collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture'] = array('type' => 'cell culture', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
//					if(!isset($collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture']['derivatives']['dna'])) $collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture']['derivatives']['dna'] = array('type' => 'dna', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
//					while($tubes_nbr > 0) { 
//						$collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture']['derivatives']['dna']['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
//						$tubes_nbr--;
//					}
//									
//				} else {
//					die("<br><FONT COLOR=\"red\" >Line ".$m->line." [DNA][ERROR]: Source '$new_source' is not supported. ".$invantory_data_from_file['DNA(PC)']."</FONT><br>");
//				}
//			}
//		}
//	} //End of DNA	
//	
//	// Display data
//	
//	echo "<br>:::::::::::::: SAMPLES SUMMARY ::::::::::::::<br>";
//	
//	echo "<br>Comments: ".$collections['NOTES'];
//	$collection_notes = $collections['NOTES'];
//	unset($collections['NOTES']);
//	
//	$space = '. . . . . . ';
//	if(empty($collections)) {
//		echo "<br><FONT COLOR=\"red\" >Line ".$m->line." [WARNING]: No sample defined for this participant!</FONT><br>";
//	} else {
//		foreach($collections as $specimen_key => $data) {
//			// Manage Specimen
//			switch($specimen_key) {
//				case 'blood':
//					echo '<br><FONT COLOR=\"red\" >** BLOOD</FONT><br>';
//					break;
//				
//				case 'ascite':
//					$pent_time_message = '';
//					if(isset($spent_time['details']['ASC'])) {
//						$pent_time_message = ', **spent_time = '.
//							$spent_time['details']['ASC']['value'].
//							$spent_time['details']['ASC']['unit'];
//					} else if(isset($spent_time['default']['value'])) {
//						$pent_time_message = ', spent_time = '.
//						$spent_time['default']['value'].
//						$spent_time['default']['unit'];
//					}					
//					
//					echo '<br><FONT COLOR=\"red\" >** ASCITE '.$pent_time_message.'</FONT><br>';
//					break;
//				
//				default:
//					if($data['type'] != 'tissue') {
//						echo "<pre>";
//						print_r($collections);
//						die ('ERR: 9973671812cacacasc');
//					}
//					
//					//TODO check
//					preg_match('/(###.*###)/', $specimen_key, $matches);
//					if(!empty($matches)) {
//						echo("<br><FONT COLOR=\"red\" >Line ".$m->line." / NS = $ns [WARNING]: The same type of tissue has been created twice (".str_replace($matches[0], '', $specimen_key).").</FONT><br>");
//					}
//					
//					$pent_time_message = '';
//					if(isset($spent_time['details'][$data['details']['code']])) {
//						$pent_time_message = ', **spent_time = '.
//							$spent_time['details'][$data['details']['code']]['value'].
//							$spent_time['details'][$data['details']['code']]['unit'];
//					} else if(isset($spent_time['default']['value'])) {
//						$pent_time_message = ', spent_time = '.
//							$spent_time['default']['value'].
//							$spent_time['default']['unit'];
//					}					
//					
//					echo '<br><FONT COLOR=\"red\" >** TISSUE </FONT>(code : '.$data['details']['code'].', source : '.$data['details']['source'].', laterality : '.$data['details']['laterality'].', type : '.$data['details']['type'].' '.$pent_time_message .')<br>';		
//			}
//						
//			// Display Aliquot
//			displayAliquots($m, $participant_id, $data['aliquots'], $space);
//			
//			// Manage Derivative
//			displayDerivatives($m, $participant_id, $data['derivatives'], $space, $space);
//		}
//	}
//	echo "<br>";
//	
//	//INSERT PROCESS
//
//	global $connection;
//	$created = array(
//		"created"		=> "NOW()", 
//		"created_by"	=> "1", 
//		"modified"		=> "NOW()",
//		"modified_by"	=> "1"
//		);
//		
//	// Create Blood Collection
//	if(isset($collections['blood'])) {
//		
//		// Create collection
//		$insert = array(
//			"acquisition_label" => "'".$ns." Sang (00-00-0000)'",
//			"bank_id" => "1", 
//			"collection_notes" => "'".$collection_notes."'",
//			"collection_property" => "'participant collection'"
//		);
//		$insert = array_merge($insert, $created);
//		$query = "INSERT INTO collections (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
//		mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
//		$blood_collection_id = mysqli_insert_id($connection);
//
//		// Create link
//		$insert = array(
//			"collection_id" => $blood_collection_id,
//			"participant_id" => $participant_id
//		);
//		$insert = array_merge($insert, $created);
//		$query = "INSERT INTO clinical_collection_links (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
//		mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
//
//		// Create sample
//		$insert = array(
//			"sample_code" 					=> "'tmp_tissue'", 
//			"sample_category"				=> "'specimen'", 
//			"sample_control_id"				=> "2", 
//			"sample_type"					=> "'blood'", 
//			"initial_specimen_sample_id"	=> "NULL", 
//			"initial_specimen_sample_type"	=> "'blood'", 
//			"collection_id"					=> "'".$blood_collection_id."'", 
//			"parent_id"						=> "NULL" 
//		);
//		$insert = array_merge($insert, $created);
//		$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
//		mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
//		$sample_master_id = mysqli_insert_id($connection);
//		$query = "UPDATE sample_masters SET sample_code=CONCAT('B - ', id), initial_specimen_sample_id=id WHERE id=".$sample_master_id;
//		mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
//		
//		$insert = array(
//			"sample_master_id"	=> $sample_master_id
//		);
//		
//		$insert = array_merge($insert, $created);
//		$query = "INSERT INTO sd_spe_bloods (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
//		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
//
//		$insert = array(
//			"sample_master_id"	=> $sample_master_id
//		);
//		$insert = array_merge($insert, $created);
//		$query = "INSERT INTO specimen_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
//		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));				
//		
//		// Create Derivative
//		createDerivative($m, $ns, $participant_id, $blood_collection_id, $sample_master_id, 'blood', $sample_master_id, 'blood', $collections['blood']['derivatives'], 'Sang');
//	
//		// Create Aliquot
//		createAliquot($m, $ns, $participant_id, $blood_collection_id, $sample_master_id, 'blood', $collections['blood']['aliquots'], 'Sang');
//		
//		unset($collections['blood']);
//	}
//	
//	// Create Tissue Collection
//	$tissue_collection_id = null;
//	if(!empty($collections)) {
//		
//		$collection_type = '';
//		if((sizeof($collections) == 1) && (array_key_exists('ascite', $collections)))  {
//			$collection_type = 'ASC';
//		} else if((sizeof($collections) > 1) && (array_key_exists('ascite', $collections)))  {
//			$collection_type = 'Tissu/ASC';
//		} else {
//			$collection_type = 'Tissu';
//		}
//		
//		$insert = array(
//			"acquisition_label" => "'".$ns." $collection_type 00-00-0000'",
//			"bank_id" => "1", 
//			"collection_notes" => "'".$collection_notes."'",
//			"collection_property" => "'participant collection'"
//		);
//		$insert = array_merge($insert, $created);
//		$query = "INSERT INTO collections (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
//		mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
//		$tissue_collection_id = mysqli_insert_id($connection);
//
//		// link
//		$insert = array(
//			"collection_id" => $tissue_collection_id,
//			"participant_id" => $participant_id
//		);
//		$insert = array_merge($insert, $created);
//		$query = "INSERT INTO clinical_collection_links (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
//		mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
//	}
//	
//	foreach($collections as $specimen_key => $data) {
//		if(empty($tissue_collection_id)) die ('cascasc');
//		
//		$sample_master_id = null;
//		$specimen_code = null;
//		
//		// Create Specimen
//		switch($specimen_key) {
//			case 'blood':
//				die('23234234');
//				break;
//			
//			case 'ascite':
//				$insert = array(
//					"sample_code" 					=> "'tmp_tissue'", 
//					"sample_category"				=> "'specimen'", 
//					"sample_control_id"				=> "1", 
//					"sample_type"					=> "'ascite'", 
//					"initial_specimen_sample_id"	=> "NULL", 
//					"initial_specimen_sample_type"	=> "'ascite'", 
//					"collection_id"					=> "'".$tissue_collection_id."'", 
//					"parent_id"						=> "NULL" 
//				);
//				$insert = array_merge($insert, $created);
//				$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
//				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
//				$sample_master_id = mysqli_insert_id($connection);
//				$query = "UPDATE sample_masters SET sample_code=CONCAT('A - ', id), initial_specimen_sample_id=id WHERE id=".$sample_master_id;
//				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
//				
//				$insert = array(
//					"sample_master_id"	=> $sample_master_id
//				);
//				$insert = array_merge($insert, $created);
//				$query = "INSERT INTO sd_spe_ascites (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
//				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
//
//				$insert = array(
//					"sample_master_id"	=> $sample_master_id
//				);
//				if(isset($spent_time['details']['ASC'])) {
//					$insert['chuq_evaluated_spent_time_from_coll'] = "'".$spent_time['details']['ASC']['value']."'";
//					$insert['chuq_evaluated_spent_time_from_coll_unit'] = "'".$spent_time['details']['ASC']['unit']."'";
//				} else if(isset($spent_time['default']['value'])) {
//					$insert['chuq_evaluated_spent_time_from_coll'] ="'".$spent_time['default']['value']."'";
//					$insert['chuq_evaluated_spent_time_from_coll_unit'] = "'".$spent_time['default']['unit']."'";
//				}					
//				
//				$insert = array_merge($insert, $created);
//				$query = "INSERT INTO specimen_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
//				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));		
//
//				$specimen_code = 'ASC';
//				break;
//			
//			default:
//				if($data['type'] != 'tissue') {
//					echo "<pre>";
//					print_r($collections);
//					die ('ERR: 9973671812cacacasc');
//				}
//				
//				$insert = array(
//					"sample_code" 					=> "'tmp_tissue'", 
//					"sample_category"				=> "'specimen'", 
//					"sample_control_id"				=> "3", 
//					"sample_type"					=> "'tissue'", 
//					"initial_specimen_sample_id"	=> "NULL", 
//					"initial_specimen_sample_type"	=> "'tissue'", 
//					"collection_id"					=> "'".$tissue_collection_id."'", 
//					"parent_id"						=> "NULL" 
//				);
//				$insert = array_merge($insert, $created);
//				$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
//				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
//				$sample_master_id = mysqli_insert_id($connection);
//				$query = "UPDATE sample_masters SET sample_code=CONCAT('T - ', id), initial_specimen_sample_id=id WHERE id=".$sample_master_id;
//				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
//				
//				$insert = array(
//					"sample_master_id"	=> $sample_master_id,
//					"chuq_tissue_code" => "'".$data['details']['code']."'",
//					"tissue_nature" => "'".$data['details']['type']."'",
//					"tissue_source" => "'".$data['details']['source']."'",
//					"tissue_laterality" => "'".$data['details']['laterality']."'"
//				);
//				
//				$insert = array_merge($insert, $created);
//				$query = "INSERT INTO sd_spe_tissues (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
//				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
//
//				$insert = array(
//					"sample_master_id"	=> $sample_master_id
//				);
//				if(isset($spent_time['details'][$data['details']['code']])) {
//					$insert['chuq_evaluated_spent_time_from_coll'] = "'".$spent_time['details'][$data['details']['code']]['value']."'";
//					$insert['chuq_evaluated_spent_time_from_coll_unit'] = "'".$spent_time['details'][$data['details']['code']]['unit']."'";
//				} else if(isset($spent_time['default']['value'])) {
//					$insert['chuq_evaluated_spent_time_from_coll'] = "'".$spent_time['default']['value']."'";
//					$insert['chuq_evaluated_spent_time_from_coll_unit'] = "'".$spent_time['default']['unit']."'";
//				}					
//				$insert = array_merge($insert, $created);
//				$query = "INSERT INTO specimen_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
//				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));				
//				
//				$specimen_code = $data['details']['code'];
//				break;				
//		}
//		
//		// Create Derivative
//		createDerivative($m, $ns, $participant_id, $tissue_collection_id, $sample_master_id, $data['type'], $sample_master_id, $specimen_key, $data['derivatives'], $specimen_code);
//		
//		// Create Aliquot
//		createAliquot($m, $ns, $participant_id, $tissue_collection_id, $sample_master_id, $data['type'], $data['aliquots'], $specimen_code);
//				
//	}

	
	
	
}

//=========================================================================================================
// Additional function
//=========================================================================================================

function displayAliquots(&$m, $participant_id, $aliquot_data, $space_to_use){
	foreach($aliquot_data as $new_aliquot) {
		echo $space_to_use."|==> @ 1 ".$new_aliquot['type']." (Box: ".(empty($new_aliquot['storage'])? '-': $new_aliquot['storage']).")<br>";
	}
}

function displayDerivatives(&$m, $participant_id, $derivative_data, $space_to_use, $space){
	
	if(!empty($derivative_data['details']))die('ERR: 98736621cacacsasccsa');
		foreach($derivative_data as $new_derivative) {
			echo $space_to_use.'|==> <FONT COLOR=\"red\" >* '.strtoupper($new_derivative['type']).' </FONT><br>';
			displayAliquots($m, $participant_id, $new_derivative['aliquots'], $space.$space_to_use);
			displayDerivatives($m, $participant_id, $new_derivative['derivatives'], $space.$space_to_use,$space);
	}
}

function pr($arr) {
	echo "<pre>";
	print_r($arr);
}

function createDerivative(&$m, $ns, $participant_id, $collection_id, $initial_specimen_sample_id, $initial_specimen_sample_type, $parent_sample_master_id,  $parent_sample_type,  $derivative_data, $specimen_code = null) {
	global $connection;
	$created = array(
		"created"		=> "NOW()", 
		"created_by"	=> "1", 
		"modified"		=> "NOW()",
		"modified_by"	=> "1"
		);
	
	if(empty($derivative_data)) return;
	
	foreach($derivative_data as $der_type => $new_derivative) {
		
		switch($der_type) {
			case 'plasma':
				$insert = array(
					"sample_code" 					=> "'tmp_tissue'", 
					"sample_category"				=> "'derivative'", 
					"sample_control_id"				=> "9", 
					"sample_type"					=> "'plasma'", 
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
				$insert = array_merge($insert, $created);
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
					"sample_category"				=> "'derivative'", 
					"sample_control_id"				=> "10", 
					"sample_type"					=> "'serum'", 
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
				$insert = array_merge($insert, $created);
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

				
			case 'buffy coat':
				$insert = array(
					"sample_code" 					=> "'tmp_tissue'", 
					"sample_category"				=> "'derivative'", 
					"sample_control_id"				=> "7", 
					"sample_type"					=> "'blood cell'", 
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
				$insert = array_merge($insert, $created);
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
					"sample_category"				=> "'derivative'", 
					"sample_control_id"				=> "12", 
					"sample_type"					=> "'dna'", 
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
				$insert = array_merge($insert, $created);
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
					"sample_category"				=> "'derivative'", 
					"sample_control_id"				=> "13", 
					"sample_type"					=> "'rna'", 
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
				$insert = array_merge($insert, $created);
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
					"sample_category"				=> "'derivative'", 
					"sample_control_id"				=> "6", 
					"sample_type"					=> "'ascite supernatant'", 
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
				$insert = array_merge($insert, $created);
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
				
				
			case 'ascite cells':
				$insert = array(
					"sample_code" 					=> "'tmp_tissue'", 
					"sample_category"				=> "'derivative'", 
					"sample_control_id"				=> "5", 
					"sample_type"					=> "'ascite cell'", 
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
				$insert = array_merge($insert, $created);
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
					"sample_category"				=> "'derivative'", 
					"sample_control_id"				=> "11", 
					"sample_type"					=> "'cell culture'", 
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
				$insert = array_merge($insert, $created);
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
				die('to support'.$der_type);
		}
		
		// Create Derivative
		createDerivative($m, $ns, $participant_id, $collection_id, $initial_specimen_sample_id, $initial_specimen_sample_type, $sample_master_id, $der_type, $new_derivative['derivatives'], $specimen_code);
		
		// Create Aliquot
		createAliquot($m, $ns, $participant_id, $collection_id, $sample_master_id, $der_type, $new_derivative['aliquots'], $specimen_code);
	}
}
	
function createAliquot(&$m, $ns, $participant_id, $collection_id, $sample_master_id, $sample_type, $aliquot_data, $specimen_code) {
	global $connection;
	$created = array(
		"created"		=> "NOW()", 
		"created_by"	=> "1", 
		"modified"		=> "NOW()",
		"modified_by"	=> "1"
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
				case 'buffy coat-tube':
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
				case 'ascite cells-tube':
					$box_number = 'ASC '.$new_aliquot['storage'];
					break;
				default:
					die ('ERR_9849983 '.$sample_type.'-'.$new_aliquot['type']);
			}
		}
				
		//get storage master id
		$storage_master_id = null;
		if(!empty($box_number)) {
			if(isset($m->storages['storages'][$box_number])) {
				$storage_master_id = $m->storages['storages'][$box_number]['id'];
			} else {
			
				$insert = array(
					"code" => "'-1'",
					"storage_type"			=> "'box'",
					"storage_control_id"	=> "8",
					"short_label"			=> "'".$box_number."'",
					"selection_label"		=> "'".$box_number."'",
					"lft"		=> "'".($m->storages['next_left'])."'",
					"rght"		=> "'".($m->storages['next_left'] + 1)."'",
					"set_temperature"	=> "'FALSE'"
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
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO std_boxs (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
						
				$m->storages['next_left'] = $m->storages['next_left'] + 2;
				$m->storages['storages'][$box_number] = array('id' => $storage_master_id);
			} 
		}		
		
		// CREATE ALIQUOT
		
		$master_insert = array(
			"aliquot_type" => null,
			"aliquot_control_id" => null,
			"in_stock" => "'yes - available'",
			"collection_id" => $collection_id,
			"sample_master_id" => $sample_master_id,
			"aliquot_label" => null
		);
		if(!empty($storage_master_id)) $master_insert['storage_master_id'] = $storage_master_id;

		$detail_insert = array();
		$detail_table = 'ad_tubes';
		
		$prefix = '';
		switch($sample_type.'-'.$new_aliquot['type']) {
			case 'blood-tube':
				$prefix = "'Sang $ns 00-00-0000'";
			case 'blood-RNALater tube':	
				if(empty($prefix)) {
					$prefix = "'RL $ns 00-00-0000'";
					$detail_insert['chuq_blood_solution'] = "'RNA later'";
				}
				$master_insert['aliquot_type'] = "'tube'";
				$master_insert['aliquot_control_id'] = "16";
				$master_insert['aliquot_label'] = $prefix;				
				break;
				
			case 'plasma-tube':
				$prefix = 'P';
			case 'ascite supernatant-tube':
				if(empty($prefix)) $prefix = 'SASC';
			case 'serum-tube':
				if(empty($prefix)) $prefix = 'SE';
			case 'ascite cells-tube':
				if(empty($prefix)) $prefix = 'NC';
				$master_insert['aliquot_type'] = "'tube'";
				$master_insert['aliquot_control_id'] = "8";
				$master_insert['aliquot_label'] = "'$prefix $ns 00-00-0000'";							
				break;				
				
			case 'tissue-frozen tube':
				$master_insert['aliquot_type'] = "'tube'";
				$master_insert['aliquot_control_id'] = "1";
				$master_insert['aliquot_label'] = "'$specimen_code $ns 00-00-0000'";						
				break;	

			case 'tissue-paraffin block':
				$prefix = 'FFPE';
			case 'tissue-oct block':
				if(empty($prefix)) $prefix = 'OCT';
				$master_insert['aliquot_type'] = "'block'";
				$master_insert['aliquot_control_id'] = "4";
				$master_insert['aliquot_label'] = "'$prefix $specimen_code $ns 00-00-0000'";	
				$detail_insert['block_type'] = ($prefix == 'OCT')? "'OCT'" : "'paraffin'";		
				$detail_table = 'ad_blocks';			
				break;	

			case 'dna-tube':
			case 'rna-tube':
				$master_insert['aliquot_type'] = "'tube'";
				$master_insert['aliquot_control_id'] = "11";
				$master_insert['aliquot_label'] = "'$specimen_code $ns 00-00-0000'";					
				break;	

			case 'buffy coat-tube':
				$prefix = 'BC';
			case 'cell culture-tube':
				if(empty($prefix)) $prefix = 'VC '.$specimen_code;
				$master_insert['aliquot_type'] = "'tube'";
				$master_insert['aliquot_control_id'] = "15";
				$master_insert['aliquot_label'] = "'$prefix $ns 00-00-0000'";				
				break;	
				
			case 'ascite-tube':
				$master_insert['aliquot_type'] = "'tube'";
				$master_insert['aliquot_control_id'] = "2";
				$master_insert['aliquot_label'] = "'$specimen_code $ns 00-00-0000'";						
				break;
				
			default:
				die('ERR 99628');
		}
		
		$master_insert = array_merge($master_insert, $created);
		$query = "INSERT INTO aliquot_masters (".implode(", ", array_keys($master_insert)).") VALUES (".implode(", ", array_values($master_insert)).")";
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		$aliquot_master_id = mysqli_insert_id($connection);
		$query = "UPDATE aliquot_masters SET barcode= CONCAT('tmp_','".$sample_master_id."','_','".$aliquot_master_id."') WHERE id=".$aliquot_master_id;
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
		$detail_insert['aliquot_master_id'] = $aliquot_master_id;
		$detail_insert = array_merge($detail_insert, $created);
		$query = "INSERT INTO $detail_table (".implode(", ", array_keys($detail_insert)).") VALUES (".implode(", ", array_values($detail_insert)).")";
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

	}
}