<?php
$pkey = "NS";
$child = array('ConsentMaster','DiagnosisMaster','PathoMiscIdentfier','DosMiscIdentfier','MdeieMiscIdentfier');
$fields = array(
	"participant_identifier" => "NS", 
	"date_of_birth" => "DN",
	"vital_status" => array("CT" => 
		array(
			"O" => "alive",
			"*DCD" => "deceased",
			"DCD" => "deceased",
			"*O" => "alive",
			"N" => "",
			"O*" => "alive",
			"O                       O" => "alive")));

//see the Model class definition for more info
$model = new Model(0, $pkey, $child, true, NULL, 'participants', $fields);

//we can then attach post read/write functions
$model->post_read_function = 'postParticipantRead';
$model->post_write_function = 'postParticipantWrite';
$model->custom_data = array(
	"date_fields" => array(
		$fields["date_of_birth"] => null
	) 
);

//adding this model to the config
Config::$models['Participant'] = $model;

function postParticipantRead(Model $m){
	excelDateFix($m);
	
echo"<br>----------------------------------------------------------------------<br>";	
echo "New Participant : NS = ".$m->values['NS']." (Line: ".$m->line.")";
echo"<br>----------------------------------------------------------------------<br>";	
}

setDataForpostParticipantWrite($model);

function postParticipantWrite(Model $m, $participant_id){

	$line =  $m->line;
	$invantory_data_from_file =  $m->values;
	$ns = $invantory_data_from_file['NS'];
	$collections = array();
	
	$collections['NOTES'] = $invantory_data_from_file['REMARQUE'];

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
					echo "<br><FONT COLOR=\"red\" >Line ".$m->line." [WARNING]: Spent time defined twice for tissue ($tissue)!</FONT><br>";
				} else {
					$spent_time['details'][$tissue] = array('value' => $value, 'unit' => $unit);
				}
			}
		}	
	}

	// SITE  ----------------------------------------------------------------------

	//	if(!empty($invantory_data_from_file['SITE'])) die("<br><FONT COLOR=\"red\" >Line ".$m->line." [SITE][ERROR]: SITE not empty!</FONT><br>");

	// TISSUS  ----------------------------------------------------------------------
	
	if(!empty($invantory_data_from_file['TISSUS'])) die("<br><FONT COLOR=\"red\" >Line ".$m->line." [TISSUS][ERROR]: SITE not empty!</FONT><br>");
	
	// SOURCE ----------------------------------------------------------------------
	
	$created_tissues_from_tissus_col = array();
	if(!empty($invantory_data_from_file['SOURCE'])) {
		$tissues = explode(',', strtoupper(str_replace(' ', '', $invantory_data_from_file['SOURCE'])));
		foreach($tissues as $new_tissue) {
			if(!empty($new_tissue)) {
				if(array_key_exists($new_tissue, $m->tissueCodeSynonimous)) $new_tissue = $m->tissueCodeSynonimous[$new_tissue];
				if(array_key_exists($new_tissue, $m->tissueCode2Details)) {
					$suffix = '';
					
					if(array_key_exists($new_tissue, $collections)) {
						$suffix_counter = 1;
						while(array_key_exists($new_tissue.$suffix, $collections)) {
							$suffix = '###'.$suffix_counter.'###';
							$suffix_counter++;
						}	
						echo "<br><FONT COLOR=\"red\" >Line ".$m->line." [TISSUS][WARNING]: TISSUS code {$new_tissue} is created at least twice!</FONT><br>";						
					}
					$collections[$new_tissue.$suffix] = array('type' => 'tissue', 'details' => $m->tissueCode2Details[$new_tissue], 'aliquots' => array(), 'derivatives' => array());
					
				}else {
					die("<br><FONT COLOR=\"red\" >Line ".$m->line." [TISSUS][ERROR]: TISSUS code {$new_tissue} is unknown!</FONT><br>");
				}
				$created_tissues_from_tissus_col[] = $new_tissue;
			}
		}
	} //End of TISSUS
	
	// OCT ----------------------------------------------------------------------
	
	if(!empty($invantory_data_from_file['OCT'])) die("<br><FONT COLOR=\"red\" >Line ".$m->line." [OCT][ERROR]: SITE not empty!</FONT><br>");

	// OCT FROM FILE ---------------------------------------------------------------------- 

	$aliquot_type = 'oct block';
	if(isset($m->boxesData[$ns]['OCT'])) {
		foreach($m->boxesData[$ns]['OCT'] as $new_octs) {
			$storage = str_replace('BT#', '', str_replace(' ','', $new_octs['box']));
			$intial_tubes_nbr = str_replace(' ','', $new_octs['nbr_tubes']);
			if(empty($intial_tubes_nbr)) $intial_tubes_nbr = 1;
			$sources = explode(',', strtoupper(str_replace(' ','', $new_octs['samples'])));
			$created_tube_nbr = 0;
			foreach($sources as $new_source) {
				$tubes_nbr = (sizeof($sources) == 1)? $intial_tubes_nbr : 1;
				preg_match('/^([0-9]+)/', $new_source, $matches);	
				$tubes_nbr = empty($matches)? $tubes_nbr : $matches[1];

				$new_source = str_replace($tubes_nbr, '', $new_source);	
				if(array_key_exists($new_source, $m->tissueCodeSynonimous)) $new_source = $m->tissueCodeSynonimous[$new_source];
				if(!array_key_exists($new_source, $m->tissueCode2Details)) die("<br><FONT COLOR=\"red\" >Line ".$m->line." / NS = $ns [OCT_file][ERROR]: Parent type '$new_source' of an oct tube is not supported.</FONT><br>");
				
				if(!array_key_exists($new_source, $collections)) {
					//Create parent
					echo "<br><FONT COLOR=\"green\" >Line ".$m->line." / NS = $ns [OCT_file]: Created parent '$new_source' for an 'oct tube' value equal to '$new_source' because this one does not exist into 'SOURCE' column.</FONT><br>";
					$collections[$new_source] = array('type' => 'tissue', 'details' => $m->tissueCode2Details[$new_source], 'aliquots' => array(), 'derivatives' => array());
				}
				
				while($tubes_nbr > 0) { 
					$collections[$new_source]['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
					$tubes_nbr--;
					$created_tube_nbr++;
				}				
			}
			if($created_tube_nbr != $intial_tubes_nbr) echo("<br><FONT COLOR=\"red\" >Line ".$m->line." / NS = $ns [OCT_file][WARNING]: Nbr of tubes defined into file is wrong ($intial_tubes_nbr != $created_tube_nbr).</FONT><br>");
		}
	}		
	
	// FROZEN TISSUE FROM FILE ---------------------------------------------------------------------- 

	$aliquot_type = 'frozen tube';
	if(isset($m->boxesData[$ns]['TISSU'])) {
		foreach($m->boxesData[$ns]['TISSU'] as $new_forzen_tubes) {
			$storage = str_replace('BT#', '', str_replace(' ','', $new_forzen_tubes['box']));
			$intial_tubes_nbr = str_replace(' ','', $new_forzen_tubes['nbr_tubes']);
			if(empty($intial_tubes_nbr)) $intial_tubes_nbr = 1;
			$sources = explode(',', strtoupper(str_replace(' ','', $new_forzen_tubes['samples'])));
			$created_tube_nbr = 0;
			foreach($sources as $new_source) {
				if(!empty($new_source)) {
					$tubes_nbr = (sizeof($sources) == 1)? $intial_tubes_nbr : 1;
					preg_match('/^([0-9]+)/', $new_source, $matches);	
					$tubes_nbr = empty($matches)? $tubes_nbr : $matches[1];
	
					$new_source = str_replace($tubes_nbr, '', $new_source);	
					if(array_key_exists($new_source, $m->tissueCodeSynonimous)) $new_source = $m->tissueCodeSynonimous[$new_source];
					$suffix = '';
					switch($new_source) {
						case 'OV-1':
							$new_source = 'OV';
							break;
						case 'OV-2':
							$new_source = 'OV';
							$suffix = '###1###';
							break;
						default;	
					}
					if(!array_key_exists($new_source, $m->tissueCode2Details)) die("<br><FONT COLOR=\"red\" >Line ".$m->line." / NS = $ns [TISSUE_file][ERROR]: Parent type '$new_source' of a frozen tube is not supported.</FONT><br>");
					
					if(!array_key_exists($new_source.$suffix, $collections)) {
						//Create parent
						echo "<br><FONT COLOR=\"green\" >Line ".$m->line." / NS = $ns [TISSUE_file]: Created parent '$new_source.$suffix' for a frozen tube value equal to '$new_source.$suffix' because this one does not exist into 'SOURCE' column.</FONT><br>";
						$collections[$new_source.$suffix] = array('type' => 'tissue', 'details' => $m->tissueCode2Details[$new_source], 'aliquots' => array(), 'derivatives' => array());
					}
					
					while($tubes_nbr > 0) { 
						$collections[$new_source.$suffix]['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
						$tubes_nbr--;
						$created_tube_nbr++;
					}
				}				
			}
			if(!empty($intial_tubes_nbr) && ($created_tube_nbr != $intial_tubes_nbr)) echo("<br><FONT COLOR=\"red\" >Line ".$m->line." / NS = $ns [TISSUE_file][WARNING]: Nbr of tubes defined into file is wrong ($intial_tubes_nbr != $created_tube_nbr).</FONT><br>");
		}
	}	
	
	// FFPE ----------------------------------------------------------------------
	
	$aliquot_type = 'paraffin block';
	$storage = empty($invantory_data_from_file['boite FFPE'])? null : $invantory_data_from_file['boite FFPE'];
	if(!is_null($storage)) {
		preg_match('/^([0-9]+)$/', $storage, $matches);
		if(empty($matches)) die('ER:98873 -'.$invantory_data_from_file['boite FFPE']);
	}
	if(!empty($invantory_data_from_file['FFPE'])) {
		$pbs_tmp = str_replace(' ', '', $invantory_data_from_file['FFPE']);
		$pbs_tmp = str_replace(',', '/', $pbs_tmp);
		$pbs = explode('/', strtoupper($pbs_tmp));
		if($pbs[0] != 'P') die("<br><FONT COLOR=\"red\" >Line ".$m->line." [FFPE][ERROR]: FFPE cell content does not start with 'P'!</FONT><br>");
		unset($pbs[0]);
		if(empty($pbs)) die("<br><FONT COLOR=\"red\" >Line ".$m->line." [FFPE][ERROR]: FFPE cell content does not contain source!</FONT><br>");

		foreach($pbs as $new_source) {
			if(!empty($new_source)) {
				preg_match('/^([0-9]+)/', $new_source, $matches);	
				$tubes_nbr = empty($matches)? '1' : $matches[1];
				$new_source = str_replace($tubes_nbr, '', $new_source);	
				if(array_key_exists($new_source, $m->tissueCodeSynonimous)) $new_source = $m->tissueCodeSynonimous[$new_source];
				if(!array_key_exists($new_source, $m->tissueCode2Details)) die("<br><FONT COLOR=\"red\" >Line ".$m->line." [FFPE][ERROR]: Parent type '$new_source' of a paraffin block is not supported.</FONT><br>");
				
				if(!array_key_exists($new_source, $collections)) {
					//Create parent
					echo "<br><FONT COLOR=\"green\" >Line ".$m->line." [FFPE]: Created parent '$new_source' for a 'paraffin blocs' value equal to '$new_source' because this one does not exist into 'SOURCE' column.</FONT><br>";
					$collections[$new_source] = array('type' => 'tissue', 'details' => $m->tissueCode2Details[$new_source], 'aliquots' => array(), 'derivatives' => array());
				}
				
				while($tubes_nbr > 0) { 
					$collections[$new_source]['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
					$tubes_nbr--;
				}
			}
		}
	}
	
	// DNA TISSUE FROM FILE ---------------------------------------------------------------------- 

	$aliquot_type = 'tube';
	if(isset($m->boxesData[$ns]['ADN TISSU'])) {
		foreach($m->boxesData[$ns]['ADN TISSU'] as $dna_tubes) {
			$storage = str_replace('BT#', '', str_replace(' ','', $dna_tubes['box']));
			if(!empty($dna_tubes['nbr_tubes'])) die("ERR:79829");
			$sources = explode(',', strtoupper(str_replace(' ','', $dna_tubes['samples'])));
			foreach($sources as $new_source) {
				if(!empty($new_source)) {
					preg_match('/^([0-9]+)/', $new_source, $matches);	
					$tubes_nbr = empty($matches)? '1' : $matches[1];
	
					$new_source = str_replace($tubes_nbr, '', $new_source);	
					if(array_key_exists($new_source, $m->tissueCodeSynonimous)) $new_source = $m->tissueCodeSynonimous[$new_source];
					if(!array_key_exists($new_source, $m->tissueCode2Details)) die("<br><FONT COLOR=\"red\" >Line ".$m->line." / NS = $ns [DNA_file][ERROR]: Parent type '$new_source' of a dna tissue tube is not supported.</FONT><br>");
					
					if(!array_key_exists($new_source, $collections)) {
						//Create parent
						echo "<br><FONT COLOR=\"green\" >Line ".$m->line." / NS = $ns [DNA_file]: Created parent '$new_source' for a frozen tube value equal to '$new_source' because this one does not exist into 'SOURCE' column.</FONT><br>";
						$collections[$new_source] = array('type' => 'tissue', 'details' => $m->tissueCode2Details[$new_source], 'aliquots' => array(), 'derivatives' => array());
					}
					if(!isset($collections[$new_source]['derivatives']['dna'])) $collections[$new_source]['derivatives']['dna'] = array('type' => 'dna', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
					
					while($tubes_nbr > 0) { 
						$collections[$new_source]['derivatives']['dna']['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
						$tubes_nbr--;
					}
				}				
			}
		}
	}	
	
	// RNA TISSUE FROM FILE ---------------------------------------------------------------------- 
	
	$aliquot_type = 'tube';
	if(isset($m->boxesData[$ns]['ARN TISSU'])) {
		foreach($m->boxesData[$ns]['ARN TISSU'] as $rna_tubes) {
			$storage = str_replace('BT#', '', str_replace(' ','', $rna_tubes['box']));
			if(!empty($rna_tubes['nbr_tubes'])) die("ERR:79829");
			$sources = explode(',', strtoupper(str_replace(' ','', $rna_tubes['samples'])));
			foreach($sources as $new_source) {
				if(!empty($new_source)) {
					preg_match('/^([0-9]+)/', $new_source, $matches);	
					$tubes_nbr = empty($matches)? '1' : $matches[1];
	
					$new_source = str_replace($tubes_nbr, '', $new_source);	
					if(array_key_exists($new_source, $m->tissueCodeSynonimous)) $new_source = $m->tissueCodeSynonimous[$new_source];
					if(!array_key_exists($new_source, $m->tissueCode2Details)) die("<br><FONT COLOR=\"red\" >Line ".$m->line." / NS = $ns [rna_file][ERROR]: Parent type '$new_source' of a rna tissue tube is not supported.</FONT><br>");
					
					if(!array_key_exists($new_source, $collections)) {
						//Create parent
						echo "<br><FONT COLOR=\"green\" >Line ".$m->line." / NS = $ns [rna_file]: Created parent '$new_source' for a frozen tube value equal to '$new_source' because this one does not exist into 'SOURCE' column.</FONT><br>";
						$collections[$new_source] = array('type' => 'tissue', 'details' => $m->tissueCode2Details[$new_source], 'aliquots' => array(), 'derivatives' => array());
					}
					if(!isset($collections[$new_source]['derivatives']['rna'])) $collections[$new_source]['derivatives']['rna'] = array('type' => 'rna', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
					
					while($tubes_nbr > 0) { 
						$collections[$new_source]['derivatives']['rna']['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
						$tubes_nbr--;
					}
				}				
			}
		}
	}

	// SANG-PLASMA-SERIM- BUFFY COAT  ----------------------------------------------------------------------
	
//	$aliquot_type = 'tube';
//	if(!empty($invantory_data_from_file['SANG-PLASMA-SERIM- BUFFY COAT '])) {
//		$bloods_tmp = str_replace(' ', '', $invantory_data_from_file['SANG-PLASMA-SERIM- BUFFY COAT ']);
//		$bloods = explode('/', strtoupper($bloods_tmp));
//		
//		foreach($bloods as $new_sample) {
//			if(!isset($collections['blood'])) $collections['blood'] = array('type' => 'blood', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
//			
//			switch($new_sample) {
//				case 'SANG':
//				case 'RNALATER':
//					$blood_aliquot_type = ($new_sample == 'SANG')? 'EDTA '.$aliquot_type : 'RNALater '.$aliquot_type;
//					$collections['blood']['aliquots'][] = array('type' =>$blood_aliquot_type,'storage' => null);
//					break;
//				case 'P':
//				case 'PLASMA':
//					if(!isset($collections['blood']['derivatives']['plasma'])) $collections['blood']['derivatives']['plasma'] = array('type' => 'plasma', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
//					$collections['blood']['derivatives']['plasma']['aliquots'][] = array('type' =>$aliquot_type,'storage' => null);
//					break;
//				case 'S':
//					if(!isset($collections['blood']['derivatives']['serum'])) $collections['blood']['derivatives']['serum'] = array('type' => 'serum', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
//					$collections['blood']['derivatives']['serum']['aliquots'][] = array('type' =>$aliquot_type,'storage' => null);
//					break;
//				case 'BC':
//					if(!isset($collections['blood']['derivatives']['buffy coat'])) $collections['blood']['derivatives']['buffy coat'] = array('type' => 'buffy coat', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
//					$collections['blood']['derivatives']['buffy coat']['aliquots'][] = array('type' =>$aliquot_type,'storage' => null);
//					break;
//				default:
//					die("<br><FONT COLOR=\"red\" >Line ".$m->line." [BLOOD][ERR]: Blood sample '$new_sample' is not supproted. </FONT><br>");		
//			}
//		}
//	} //End of blocs SANG-PLASMA-SERIM- BUFFY COAT 

	// SANG FROM FILE  ----------------------------------------------------------------------

	$aliquot_type = 'tube';
	if(isset($m->boxesData[$ns]['SANG'])) {
		foreach($m->boxesData[$ns]['SANG'] as $blood_tubes) {
			$storage = str_replace('BT#', '', str_replace(' ','', $blood_tubes['box']));
			if(!empty($blood_tubes['nbr_tubes'])) die("ERR:dccc");
			$sources = explode('/', strtoupper(str_replace(' ','', $blood_tubes['samples'])));
			foreach($sources as $new_source) {
				if(!empty($new_source)) {
					if(!isset($collections['blood'])) $collections['blood'] = array('type' => 'blood', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
					
					preg_match('/^([0-9]+)/', $new_source, $matches);	
					$tubes_nbr = empty($matches)? '1' : $matches[1];
					$new_source = str_replace($tubes_nbr, '', $new_source);	
					
					switch($new_source) {
						case 'SANG':
						case 'RL':
							$blood_aliquot_type = ($new_source == 'SANG')? 'EDTA '.$aliquot_type : 'RNALater '.$aliquot_type;
							while($tubes_nbr > 0) { 
								$collections['blood']['aliquots'][] = array('type' =>$blood_aliquot_type,'storage' => $storage); 
								$tubes_nbr--;
							}
							break;
						case 'P':
							if(!isset($collections['blood']['derivatives']['plasma'])) $collections['blood']['derivatives']['plasma'] = array('type' => 'plasma', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
							while($tubes_nbr > 0) { 
								$collections['blood']['derivatives']['plasma']['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
								$tubes_nbr--;
							}							
							break;
						case 'SE':
							if(!isset($collections['blood']['derivatives']['serum'])) $collections['blood']['derivatives']['serum'] = array('type' => 'serum', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
							while($tubes_nbr > 0) { 
								$collections['blood']['derivatives']['serum']['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
								$tubes_nbr--;
							}							
							break;
						case 'BC':
							if(!isset($collections['blood']['derivatives']['buffy coat'])) $collections['blood']['derivatives']['buffy coat'] = array('type' => 'buffy coat', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
							while($tubes_nbr > 0) { 
								$collections['blood']['derivatives']['buffy coat']['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
								$tubes_nbr--;
							}							
							break;							
						default:
							die("<br><FONT COLOR=\"red\" >Line ".$m->line." [blood_file][ERROR]: blood sample '$new_source' is not supported. </FONT><br>");		
					}
				}				
			}
		}
	}
	
	// ASCITE  ----------------------------------------------------------------------
	
//	$aliquot_type = 'tube';
//	if(!empty($invantory_data_from_file['ASCITE'])) {
//		$ascites_tmp = str_replace(' ', '', $invantory_data_from_file['ASCITE']);
//		$ascites = explode('/', strtoupper($ascites_tmp));
//
//		foreach($ascites as $new_sample) {
//			if(!empty($new_sample)) {
//				if(!isset($collections['ascite'])) $collections['ascite'] = array('type' => 'ascite', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
//
//				preg_match('/^([0-9]+)/', $new_sample, $matches);	
//				$tubes_nbr = empty($matches)? '1' : $matches[1];
//				$new_sample = str_replace($tubes_nbr, '', $new_sample);	
//	
//				switch($new_sample) {
//					case 'ASC':
//						while($tubes_nbr > 0) { 
//							$collections['ascite']['aliquots'][] = array('type' =>$aliquot_type,'storage' => null); 
//							$tubes_nbr--;
//						}
//						break;
//					case 'S':
//					case 'SASC':
//						if(!isset($collections['ascite']['derivatives']['ascite supernatant'])) $collections['ascite']['derivatives']['ascite supernatant'] = array('type' => 'ascite supernatant', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
//						while($tubes_nbr > 0) { 
//							$collections['ascite']['derivatives']['ascite supernatant']['aliquots'][] = array('type' =>$aliquot_type,'storage' => null); 
//							$tubes_nbr--;
//						}
//						break;
//					case 'NC':
//						if(!isset($collections['ascite']['derivatives']['ascite cells'])) $collections['ascite']['derivatives']['ascite cells'] = array('type' => 'ascite cells', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
//						while($tubes_nbr > 0) { 
//							$collections['ascite']['derivatives']['ascite cells']['aliquots'][] = array('type' =>$aliquot_type,'storage' => null); 
//							$tubes_nbr--;
//						}
//						break;
//					default:
//						die("<br><FONT COLOR=\"red\" >Line ".$m->line." [ERR][ASCITE]: Ascite sample '$new_sample' is not supported. </FONT><br>");		
//				}
//			}
//		}
//	} //End of ASCITE	
	
	// ASCITE FROM FILE ---------------------------------------------------------------------- 
	
	$aliquot_type = 'tube';
	if(isset($m->boxesData[$ns]['ASCITE'])) {
		foreach($m->boxesData[$ns]['ASCITE'] as $ascite_tubes) {
			$storage = str_replace('BT#', '', str_replace(' ','', $ascite_tubes['box']));
			if(!empty($ascite_tubes['nbr_tubes'])) die("ERR:dadaad9");
			$sources = explode(',', strtoupper(str_replace(' ','', $ascite_tubes['samples'])));
			foreach($sources as $new_source) {
				if(!empty($new_source)) {
					if(!isset($collections['ascite'])) $collections['ascite'] = array('type' => 'ascite', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
					
					preg_match('/^([0-9]+)/', $new_source, $matches);	
					$tubes_nbr = empty($matches)? '1' : $matches[1];
					$new_source = str_replace($tubes_nbr, '', $new_source);	
					
					switch($new_source) {
						case 'ASC':
							while($tubes_nbr > 0) { 
								$collections['ascite']['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
								$tubes_nbr--;
							}
							break;
						case 'S':
						case 'SASC':
							if(!isset($collections['ascite']['derivatives']['ascite supernatant'])) $collections['ascite']['derivatives']['ascite supernatant'] = array('type' => 'ascite supernatant', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
							while($tubes_nbr > 0) { 
								$collections['ascite']['derivatives']['ascite supernatant']['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
								$tubes_nbr--;
							}
							break;
						case 'NC':
							die ('8981239123');
							break;
						default:
							die("<br><FONT COLOR=\"red\" >Line ".$m->line." [ERR][ASCITE_file]: Ascite sample '$new_source' is not supported. </FONT><br>");		
					}
				}				
			}
		}
	}
	
	// ASC NC FROM FILE ---------------------------------------------------------------------- 
	
	$aliquot_type = 'tube';
	if(isset($m->boxesData[$ns]['ASC_NC'])) {
		foreach($m->boxesData[$ns]['ASC_NC'] as $ascite_tubes) {
			$storage = str_replace('BT#', '', str_replace(' ','', $ascite_tubes['box']));
			if(!empty($ascite_tubes['nbr_tubes'])) die("ERR:dadaad9");
			$sources = explode(',', strtoupper(str_replace(' ','', $ascite_tubes['samples'])));
			foreach($sources as $new_source) {
				if(!empty($new_source)) {
					if(!isset($collections['ascite'])) $collections['ascite'] = array('type' => 'ascite', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
					
					preg_match('/^([0-9]+)/', $new_source, $matches);	
					$tubes_nbr = empty($matches)? '1' : $matches[1];
					$new_source = str_replace($tubes_nbr, '', $new_source);	
					
					switch($new_source) {
						case 'ASC':
						case 'S':
						case 'SASC':
							die ('8981239123');
							break;
						case 'NC':
							if(!isset($collections['ascite']['derivatives']['ascite cells'])) $collections['ascite']['derivatives']['ascite cells'] = array('type' => 'ascite cells', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
							while($tubes_nbr > 0) { 
								$collections['ascite']['derivatives']['ascite cells']['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
								$tubes_nbr--;
							}
							break;
						default:
							die("<br><FONT COLOR=\"red\" >Line ".$m->line." [ERR][ASCITE_NC_file]: Ascite sample '$new_source' is not supported. </FONT><br>");		
					}
				}				
			}
		}
	}
	
	// VC ----------------------------------------------------------------------
	
	$aliquot_type = 'tube';
	if(!empty($invantory_data_from_file['VC'])) {
		$vcs_tmp = str_replace(' ', '', $invantory_data_from_file['VC']);
		$vcs_tmp = str_replace('-bt#', '#', $vcs_tmp);
		$vcs_tmp = str_replace('bt#', '#', $vcs_tmp);
		$storage_for_all = null;
		if(substr_count($vcs_tmp, '#') == 1) { 
			preg_match('/#([0-9]+\(I+\))|#([0-9]+A)|#([0-9]+)/', $vcs_tmp, $matches);
			$storage_for_all = str_replace('#', '', $matches[0]); 
			$vcs_tmp = preg_replace('/#([0-9]+\(I+\))|#([0-9]+A)|#([0-9]+)/', '', $vcs_tmp);
		}
		$vcs = explode(',', strtoupper($vcs_tmp));
		
		foreach($vcs as $new_source) {
			$storage = $storage_for_all;
			if(empty($storage)) {
				preg_match('/#([0-9]+\(I+\))|#([0-9]+A)|#([0-9]+)/', $new_source, $matches);	
				if(!empty($matches)) $storage = str_replace('#', '', $matches[0]); 
				$new_source = preg_replace('/#([0-9]+\(I+\))|#([0-9]+A)|#([0-9]+)/', '', $new_source);			
			}
			preg_match('/^([0-9]+)/', $new_source, $matches);	
			$tubes_nbr = empty($matches)? '1' : $matches[1];
			$new_source = str_replace($tubes_nbr, '', $new_source);	

			if(array_key_exists($new_source, $m->tissueCodeSynonimous)) $new_source = $m->tissueCodeSynonimous[$new_source];
			
			if(array_key_exists($new_source, $m->tissueCode2Details)) {
				// SOURCE = TISSUE
				
				if(($new_source == 'OV') && (!array_key_exists($new_source, $collections))) {
					// Try to match with existing ovary
					$ovaries_already_recorded = '';
					$ov_list_to_display = '';
					foreach($collections as $key_source => $tmp) {
						if(in_array($key_source, $m->ovCodes)) {
							$ovaries_already_recorded[] = $key_source;
							$ov_list_to_display .= $key_source.', ';
						}
					}
					if(sizeof($ovaries_already_recorded) == 1) {
						$source_already_recorded = $ovaries_already_recorded[0];
						echo "<br><FONT COLOR=\"green\" >Line ".$m->line." [VC]: Changed the parent defintion for a 'VC' value from {OV} to {$source_already_recorded} because only one ovary type has already been defined as collected for this participant.</FONT><br>";
						$new_source = $source_already_recorded;
					} else if(sizeof($ovaries_already_recorded) > 1) {
						echo "<br><FONT COLOR=\"red\" >Line ".$m->line." [VC][WARNING]: Unable to define parent for a 'VC' value equals to {$new_source} because there is too many existing parents that could be applied (".$ov_list_to_display."). Will create a new {OV}.</FONT><br>";
					}	
				}
				
				if(!isset($collections[$new_source])) $collections[$new_source] = array('type' => 'tissue', 'details' => $m->tissueCode2Details[$new_source], 'aliquots' => array(), 'derivatives' => array());
				if(!isset($collections[$new_source]['derivatives']['cell culture'])) $collections[$new_source]['derivatives']['cell culture'] = array('type' => 'cell culture', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
				while($tubes_nbr > 0) { 
					$collections[$new_source]['derivatives']['cell culture']['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
					$tubes_nbr--;
				}
			
			} else if($new_source == 'ASC') {
				// SOURCE = ASCITE
				
				if(!isset($collections['ascite'])) $collections['ascite'] = array('type' => 'ascite', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
				if(!isset($collections['ascite']['derivatives']['ascite cells'])) $collections['ascite']['derivatives']['ascite cells'] = array('type' => 'ascite cells', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
				if(!isset($collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture'])) $collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture'] = array('type' => 'cell culture', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
				while($tubes_nbr > 0) { 
					$collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture']['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
					$tubes_nbr--;
				}
								
			} else {
				die("<br><FONT COLOR=\"red\" >Line ".$m->line." [VC][ERROR]: Source '$new_source' is not supported. ".$invantory_data_from_file['VC']."</FONT><br>");
			}
		}	
	} //End of VC
	
	// RNA ----------------------------------------------------------------------
	
	$aliquot_type = 'tube';
	$storage = empty($invantory_data_from_file['boite ARN'])? null : $invantory_data_from_file['boite ARN'];
	if(!is_null($storage)) {
		preg_match('/^([0-9]+)$/', $storage, $matches);
		if(empty($matches)) die('ER:98873 -'.$invantory_data_from_file['boite ARN']);
	}	
	if(!empty($invantory_data_from_file['RNA (PC)'])) {
		$rnas_tmp = str_replace(' ', '', $invantory_data_from_file['RNA (PC)']);
		$rnas_tmp = str_replace(',', '/', $rnas_tmp);
		$rnas = explode('/', strtoupper($rnas_tmp));

		if($rnas[0] != 'RNA') die("<br><FONT COLOR=\"red\" >Line ".$m->line." [RNA]: RNA cell content dones not start with 'RNA'!</FONT><br>");
		unset($rnas[0]);
		if(empty($rnas)) die("<br><FONT COLOR=\"red\" >Line ".$m->line." [RNA]: RNA cell content is empty!</FONT><br>");
		
		foreach($rnas as $new_source) {
			if(!empty($new_source)) {
				preg_match('/^([0-9]+)/', $new_source, $matches);	
				$tubes_nbr = empty($matches)? '1' : $matches[1];
				$new_source = str_replace($tubes_nbr, '', $new_source);	
				
				if(array_key_exists($new_source, $m->tissueCodeSynonimous)) $new_source = $m->tissueCodeSynonimous[$new_source];
				
				if(array_key_exists($new_source, $m->tissueCode2Details)) {
					// SOURCE = TISSUE
					if(($new_source == 'OV') && (!array_key_exists($new_source, $collections))) {
						// Try to match with existing ovary
						$ovaries_already_recorded = '';
						$ov_list_to_display = '';
						foreach($collections as $key_source => $tmp) {
							if(in_array($key_source, $m->ovCodes)) {
								$ovaries_already_recorded[] = $key_source;
								$ov_list_to_display .= $key_source.', ';
							}
						}
						if(sizeof($ovaries_already_recorded) == 1) {
							$source_already_recorded = $ovaries_already_recorded[0];
							echo "<br><FONT COLOR=\"green\" >Line ".$m->line." [RNA]: Changed the parent defintion for a 'RNA' value from {OV} to {$source_already_recorded} because only one ovary type has already been defined as collected for this participant.</FONT><br>";
							$new_source = $source_already_recorded;
						} else if(sizeof($ovaries_already_recorded) > 1) {
							echo "<br><FONT COLOR=\"red\" >Line ".$m->line." [RNA][WARNING]: Unable to define parent for a 'RNA' value equals to {$new_source} because there is too many existing parents that could be applied (".$ov_list_to_display."). Will create a new {OV}.</FONT><br>";
						}	
					}
					
					if(!isset($collections[$new_source])) $collections[$new_source] = array('type' => 'tissue', 'details' => $m->tissueCode2Details[$new_source], 'aliquots' => array(), 'derivatives' => array());
					if(!isset($collections[$new_source]['derivatives']['cell culture'])) $collections[$new_source]['derivatives']['cell culture'] = array('type' => 'cell culture', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
					if(!isset($collections[$new_source]['derivatives']['cell culture']['derivatives']['rna'])) $collections[$new_source]['derivatives']['cell culture']['derivatives']['rna'] = array('type' => 'rna', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
					while($tubes_nbr > 0) { 
						$collections[$new_source]['derivatives']['cell culture']['derivatives']['rna']['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
						$tubes_nbr--;
					}
				
				} else if($new_source == 'ASC') {
					// SOURCE = ASCITE
					if(!isset($collections['ascite'])) $collections['ascite'] = array('type' => 'ascite', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
					if(!isset($collections['ascite']['derivatives']['ascite cells'])) $collections['ascite']['derivatives']['ascite cells'] = array('type' => 'ascite cells', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
					if(!isset($collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture'])) $collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture'] = array('type' => 'cell culture', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
					if(!isset($collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture']['derivatives']['rna'])) $collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture']['derivatives']['rna'] = array('type' => 'rna', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
					while($tubes_nbr > 0) { 
						$collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture']['derivatives']['rna']['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
						$tubes_nbr--;
					}
									
				} else {
					die("<br><FONT COLOR=\"red\" >Line ".$m->line." [RNA][ERROR]: Source '$new_source' is not supported. ".$invantory_data_from_file['RNA (PC)']."</FONT><br>");
				}
			}
		}
	} //End of RNA
	
	// DNA ----------------------------------------------------------------------

	$aliquot_type = 'tube';
	$storage = empty($invantory_data_from_file['boite ADN'])? null : $invantory_data_from_file['boite ADN'];
	if(!is_null($storage)) {
		preg_match('/^([0-9]+)$/', $storage, $matches);
		if(empty($matches)) die('ER:98873 -'.$invantory_data_from_file['boite ADN']);
	}	
	if((!empty($invantory_data_from_file['DNA(PC)'])) && ($invantory_data_from_file['DNA(PC)'] != ' ')) {
		$dnas_tmp = str_replace(' ', '', $invantory_data_from_file['DNA(PC)']);
		$dnas_tmp = str_replace(',', '/', $dnas_tmp);
		$dnas = explode('/', strtoupper($dnas_tmp));

		if($dnas[0] != 'DNA') die("<br><FONT COLOR=\"red\" >Line ".$m->line." [DNA]: DNA cell content dones not start with 'DNA'!</FONT><br>");
		unset($dnas[0]);
		if(empty($dnas)) die("<br><FONT COLOR=\"red\" >Line ".$m->line." [DNA]: DNA cell content is empty!</FONT><br>");
		
		foreach($dnas as $new_source) {
			if(!empty($new_source)) {
				preg_match('/^([0-9]+)/', $new_source, $matches);	
				$tubes_nbr = empty($matches)? '1' : $matches[1];
				$new_source = str_replace($tubes_nbr, '', $new_source);	
				
				if(array_key_exists($new_source, $m->tissueCodeSynonimous)) $new_source = $m->tissueCodeSynonimous[$new_source];
				
				if(array_key_exists($new_source, $m->tissueCode2Details)) {
					// SOURCE = TISSUE
					if(($new_source == 'OV') && (!array_key_exists($new_source, $collections))) {
						// Try to match with existing ovary
						$ovaries_already_recorded = '';
						$ov_list_to_display = '';
						foreach($collections as $key_source => $tmp) {
							if(in_array($key_source, $m->ovCodes)) {
								$ovaries_already_recorded[] = $key_source;
								$ov_list_to_display .= $key_source.', ';
							}
						}
						if(sizeof($ovaries_already_recorded) == 1) {
							$source_already_recorded = $ovaries_already_recorded[0];
							echo "<br><FONT COLOR=\"green\" >Line ".$m->line." [DNA]: Changed the parent defintion for a 'DNA' value from {OV} to {$source_already_recorded} because only one ovary type has already been defined as collected for this participant.</FONT><br>";
							$new_source = $source_already_recorded;
						} else if(sizeof($ovaries_already_recorded) > 1) {
							echo "<br><FONT COLOR=\"red\" >Line ".$m->line." [DNA][WARNING]: Unable to define parent for a 'DNA' value equals to {$new_source} because there is too many existing parents that could be applied (".$ov_list_to_display."). Will create a new {OV}.</FONT><br>";
						}	
					}
					
					if(!isset($collections[$new_source])) $collections[$new_source] = array('type' => 'tissue', 'details' => $m->tissueCode2Details[$new_source], 'aliquots' => array(), 'derivatives' => array());
					if(!isset($collections[$new_source]['derivatives']['cell culture'])) $collections[$new_source]['derivatives']['cell culture'] = array('type' => 'cell culture', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
					if(!isset($collections[$new_source]['derivatives']['cell culture']['derivatives']['dna'])) $collections[$new_source]['derivatives']['cell culture']['derivatives']['dna'] = array('type' => 'dna', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
					while($tubes_nbr > 0) { 
						$collections[$new_source]['derivatives']['cell culture']['derivatives']['dna']['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
						$tubes_nbr--;
					}
				
				} else if($new_source == 'ASC') {
					// SOURCE = ASCITE
					if(!isset($collections['ascite'])) $collections['ascite'] = array('type' => 'ascite', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
					if(!isset($collections['ascite']['derivatives']['ascite cells'])) $collections['ascite']['derivatives']['ascite cells'] = array('type' => 'ascite cells', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
					if(!isset($collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture'])) $collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture'] = array('type' => 'cell culture', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
					if(!isset($collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture']['derivatives']['dna'])) $collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture']['derivatives']['dna'] = array('type' => 'dna', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
					while($tubes_nbr > 0) { 
						$collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture']['derivatives']['dna']['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
						$tubes_nbr--;
					}
									
				} else {
					die("<br><FONT COLOR=\"red\" >Line ".$m->line." [DNA][ERROR]: Source '$new_source' is not supported. ".$invantory_data_from_file['DNA(PC)']."</FONT><br>");
				}
			}
		}
	} //End of DNA	
	
	// Display data
	
	echo "<br>:::::::::::::: SAMPLES SUMMARY ::::::::::::::<br>";
	
	echo "<br>Comments: ".$collections['NOTES'];
	$collection_notes = $collections['NOTES'];
	unset($collections['NOTES']);
	
	$space = '. . . . . . ';
	if(empty($collections)) {
		echo "<br><FONT COLOR=\"red\" >Line ".$m->line." [WARNING]: No sample defined for this participant!</FONT><br>";
	} else {
		foreach($collections as $specimen_key => $data) {
			// Manage Specimen
			switch($specimen_key) {
				case 'blood':
					echo '<br><FONT COLOR=\"red\" >** BLOOD</FONT><br>';
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
					
					echo '<br><FONT COLOR=\"red\" >** ASCITE '.$pent_time_message.'</FONT><br>';
					break;
				
				default:
					if($data['type'] != 'tissue') {
						echo "<pre>";
						print_r($collections);
						die ('ERR: 9973671812cacacasc');
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
					
					echo '<br><FONT COLOR=\"red\" >** TISSUE </FONT>(code : '.$data['details']['code'].', source : '.$data['details']['source'].', laterality : '.$data['details']['laterality'].', type : '.$data['details']['type'].' '.$pent_time_message .')<br>';		
			}
						
			// Display Aliquot
			manageAliquots($m, $participant_id, $data['aliquots'], $space);
			
			// Manage Derivative
			manageDerivative($m, $participant_id, $data['derivatives'], $space, $space);
		}
	}
	echo "<br>";
	
	//INSERT PROCESS

	global $connection;
	$created = array(
		"created"		=> "NOW()", 
		"created_by"	=> "1", 
		"modified"		=> "NOW()",
		"modified_by"	=> "1"
		);
		
	if(isset($collections['blood'])) {
		
		// Collection
		$insert = array(
			"acquisition_label" => "'".$ns." Sang (migration)'",
			"bank_id" => "1", 
			"collection_notes" => "'".$collection_notes."'",
			"collection_property" => "'participant collection'"
		);
		$insert = array_merge($insert, $created);
		$query = "INSERT INTO collections (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		$blood_collection_id = mysqli_insert_id($connection);

		// link
		$insert = array(
			"collection_id" => $blood_collection_id,
			"participant_id" => $participant_id
		);
		$insert = array_merge($insert, $created);
		$query = "INSERT INTO clinical_collection_links (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

		$insert = array(
			"sample_code" 					=> "'tmp_tissue'", 
			"sample_category"				=> "'specimen'", 
			"sample_control_id"				=> "2", 
			"sample_type"					=> "'blood'", 
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
		
		$insert = array_merge($insert, $created);
		$query = "INSERT INTO sd_spe_bloods (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

		$insert = array(
			"sample_master_id"	=> $sample_master_id
		);
		$insert = array_merge($insert, $created);
		$query = "INSERT INTO specimen_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));				
		
		// Manage Derivative
		createDerivative($m, $ns, $participant_id, $blood_collection_id, $sample_master_id, 'blood', $sample_master_id, 'blood', $collections['blood']['derivatives']);
	
		// Manage Aliquot
		createAliquot($m, $ns, $participant_id, $blood_collection_id, $sample_master_id, 'blood', $collections['blood']['aliquots']);
		
		unset($collections['blood']);
	}
	
	$tissue_collection_id = null;
	if(!empty($collections)) {
		$insert = array(
			"acquisition_label" => "'".$ns." Tissue & autre (migration)'",
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
		
		// Manage Specimen
		switch($specimen_key) {
			case 'blood':
				die('23234234');
				break;
			
			case 'ascite':
				$insert = array(
					"sample_code" 					=> "'tmp_tissue'", 
					"sample_category"				=> "'specimen'", 
					"sample_control_id"				=> "1", 
					"sample_type"					=> "'ascite'", 
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
				$insert = array_merge($insert, $created);
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

				// Manage Derivative
				createDerivative($m, $ns, $participant_id, $tissue_collection_id, $sample_master_id, 'ascite', $sample_master_id, 'ascite', $data['derivatives']);
				
				break;
			
			default:
				if($data['type'] != 'tissue') {
					echo "<pre>";
					print_r($collections);
					die ('ERR: 9973671812cacacasc');
				}
				
				$insert = array(
					"sample_code" 					=> "'tmp_tissue'", 
					"sample_category"				=> "'specimen'", 
					"sample_control_id"				=> "3", 
					"sample_type"					=> "'tissue'", 
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
				
				$insert = array_merge($insert, $created);
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
							
				createDerivative($m, $ns, $participant_id, $tissue_collection_id, $sample_master_id, 'tissue', $sample_master_id, 'tissue', $data['derivatives']);
				
				break;				
		}
					
		// Display Aliquot
//		manageAliquots($m, $participant_id, $data['aliquots'], $space);
		
		// Manage Derivative
//		manageDerivative($m, $participant_id, $data['derivatives'], $space, $space);
	}	
	
	
	
	
	
	
	
	
	
//		global $connection;
//	$created = array(
//		"created"		=> "NOW()", 
//		"created_by"	=> "1", 
//		"modified"		=> "NOW()",
//		"modified_by"	=> "1"
//		);
//	if($m->values['Collected Specimen Type'] == 'tissue'){
//		$insert = array(
//			"sample_code" 					=> "'tmp_tissue'", 
//			"sample_category"				=> "'specimen'", 
//			"sample_control_id"				=> "3", 
//			"sample_type"					=> "'tissue'", 
//			"initial_specimen_sample_id"	=> "NULL", 
//			"initial_specimen_sample_type"	=> "'tissue'", 
//			"collection_id"					=> "'".$collection_id."'", 
//			"parent_id"						=> "NULL" 
//		);
//		$insert = array_merge($insert, $created);
//		$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
//		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
//		$sample_master_id = mysqli_insert_id($connection);
//		$query = "UPDATE sample_masters SET sample_code=CONCAT('T - ', id), initial_specimen_sample_id=id WHERE id=".$sample_master_id;
//		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	
}

//=========================================================================================================
// Additional function
//=========================================================================================================

function setDataForpostParticipantWrite(Model &$m) {
	
	$m->tissueCode2Details = array(
		//OV:ovary
		'OV' => array('code' => '', 'source' => 'ovary', 'laterality' => '', 'type' => ''),
		'OVD' => array('code' => '', 'source' => 'ovary', 'laterality' => 'right', 'type' => ''),
		'OVG' => array('code' => '', 'source' => 'ovary', 'laterality' => 'left', 'type' => ''),
	
		'BOV' => array('code' => '', 'source' => 'ovary', 'laterality' => '', 'type' => 'benin'),
		'BOVD' => array('code' => '', 'source' => 'ovary', 'laterality' => 'right', 'type' => 'benin'),
		'BOVG' => array('code' => '', 'source' => 'ovary', 'laterality' => 'left', 'type' => 'benin'),
		
		'KOV' => array('code' => '', 'source' => 'ovary', 'laterality' => '', 'type' => 'cyst'),
		'KOVD' => array('code' => '', 'source' => 'ovary', 'laterality' => 'right', 'type' => 'cyst'),
		'KOVG' => array('code' => '', 'source' => 'ovary', 'laterality' => 'left', 'type' => 'cyst'),
		
		'NOV' => array('code' => '', 'source' => 'ovary', 'laterality' => '', 'type' => 'normal'),
		'NOVD' => array('code' => '', 'source' => 'ovary', 'laterality' => 'right', 'type' => 'normal'),
		'NOVG' => array('code' => '', 'source' => 'ovary', 'laterality' => 'left', 'type' => 'normal'),
		
		'TOV' => array('code' => '', 'source' => 'ovary', 'laterality' => '', 'type' => 'tumoral'),
		'TOVD' => array('code' => '', 'source' => 'ovary', 'laterality' => 'right', 'type' => 'tumoral'),
		'TOVG' => array('code' => '', 'source' => 'ovary', 'laterality' => 'left', 'type' => 'tumoral'),
		
		//AP: other
		'AP' => array('code' => '', 'source' => 'other', 'laterality' => '', 'type' => ''),
		'APD' => array('code' => '', 'source' => 'other', 'laterality' => 'right', 'type' => ''),
		'APG' => array('code' => '', 'source' => 'other', 'laterality' => 'left', 'type' => ''),
	
		'NAP' => array('code' => '', 'source' => 'other', 'laterality' => '', 'type' => 'normal'),
		'NAPD' => array('code' => '', 'source' => 'other', 'laterality' => 'right', 'type' => 'normal'),
		'NAPG' => array('code' => '', 'source' => 'other', 'laterality' => 'left', 'type' => 'normal'),
		
		'TAP' => array('code' => '', 'source' => 'other', 'laterality' => '', 'type' => 'tumoral'),
		'TAPD' => array('code' => '', 'source' => 'other', 'laterality' => 'right', 'type' => 'tumoral'),
		'TAPG' => array('code' => '', 'source' => 'other', 'laterality' => 'left', 'type' => 'tumoral'),
	
		//EP: epiplon
		'EP' => array('code' => '', 'source' => 'epiplon', 'laterality' => '', 'type' => ''),
		'EPD' => array('code' => '', 'source' => 'epiplon', 'laterality' => 'right', 'type' => ''),
		'EPG' => array('code' => '', 'source' => 'epiplon', 'laterality' => 'left', 'type' => ''),

		'NEP' => array('code' => '', 'source' => 'epiplon', 'laterality' => '', 'type' => 'normal'),
		'NEPD' => array('code' => '', 'source' => 'epiplon', 'laterality' => 'right', 'type' => 'normal'),
		'NEPG' => array('code' => '', 'source' => 'epiplon', 'laterality' => 'left', 'type' => 'normal'),
		
		'TEP' => array('code' => '', 'source' => 'epiplon', 'laterality' => '', 'type' => 'tumoral'),
		'TEPD' => array('code' => '', 'source' => 'epiplon', 'laterality' => 'right', 'type' => 'tumoral'),
		'TEPG' => array('code' => '', 'source' => 'epiplon', 'laterality' => 'left', 'type' => 'tumoral'),
	
		//IP: peritoneal implant
		'IP' => array('code' => '', 'source' => 'peritoneal implant', 'laterality' => '', 'type' => ''),
		'IPD' => array('code' => '', 'source' => 'peritoneal implant', 'laterality' => 'right', 'type' => ''),
		'IPG' => array('code' => '', 'source' => 'peritoneal implant', 'laterality' => 'left', 'type' => ''),
		
		'NIP' => array('code' => '', 'source' => 'peritoneal implant', 'laterality' => '', 'type' => 'normal'),
		'NIPD' => array('code' => '', 'source' => 'peritoneal implant', 'laterality' => 'right', 'type' => 'normal'),
		'NIPG' => array('code' => '', 'source' => 'peritoneal implant', 'laterality' => 'left', 'type' => 'normal'),
		
		'TIP' => array('code' => '', 'source' => 'peritoneal implant', 'laterality' => '', 'type' => 'tumoral'),
		'TIPD' => array('code' => '', 'source' => 'peritoneal implant', 'laterality' => 'right', 'type' => 'tumoral'),
		'TIPG' => array('code' => '', 'source' => 'peritoneal implant', 'laterality' => 'left', 'type' => 'tumoral'),

		//MP: pelvic mass
		'MP' => array('code' => '', 'source' => 'pelvic mass', 'laterality' => '', 'type' => ''),
		'MPD' => array('code' => '', 'source' => 'pelvic mass', 'laterality' => 'right', 'type' => ''),
		'MPG' => array('code' => '', 'source' => 'pelvic mass', 'laterality' => 'left', 'type' => ''),
		
		'NMP' => array('code' => '', 'source' => 'pelvic mass', 'laterality' => '', 'type' => 'normal'),
		'NMPD' => array('code' => '', 'source' => 'pelvic mass', 'laterality' => 'right', 'type' => 'normal'),
		'NMPG' => array('code' => '', 'source' => 'pelvic mass', 'laterality' => 'left', 'type' => 'normal'),
		
		'TMP' => array('code' => '', 'source' => 'pelvic mass', 'laterality' => '', 'type' => 'tumoral'),
		'TMPD' => array('code' => '', 'source' => 'pelvic mass', 'laterality' => 'right', 'type' => 'tumoral'),
		'TMPG' => array('code' => '', 'source' => 'pelvic mass', 'laterality' => 'left', 'type' => 'tumoral')
	);
	foreach($m->tissueCode2Details as $key => $detail) {
		$m->tissueCode2Details[$key]['code'] = $key;
	}
	
	$m->tissueCodeSynonimous = array(
		'EPN' => 'NEP',
		'OVGT' => 'TOVG',
		'?' => 'AP',
		'A' => 'AP',
		'O' => 'OV',
		'OD' => 'OVD',
		'OVDN' => 'NOVD',
		'OVGN' => 'NOVG',
		'OVDT' => 'TOVD',
		'OVGT' => 'TOVG',
		'OG' => 'OVG',
		'VG' => 'OVG',
		'VOG' => 'OVG',
		'EPPD' => 'EPD', 
		'M.P' => 'MP',
		'MT' => 'OV',
		'ANXG' => 'OVG');

	$m->ovCodes = array();
	foreach($m->tissueCode2Details as $code => $data) {
		if($data['source'] == 'ovary') $m->ovCodes[] = $code;
	}
	
	$m->boxesData = getBoxesDataFromFile();
	
	$m->Storages = array('next_left' => 1);
}

function getBoxesDataFromFile() {
	$boxes_data = array();
	
	$xls_reader_boxes = new Spreadsheet_Excel_Reader();
	$xls_reader_boxes->read( "/Documents and Settings/u703617/Desktop/chuq_boites_small_20110606_17h10.xls");
	
	$sheets_nbr = array();
	foreach($xls_reader_boxes->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	
	// TISSU
	
	foreach($xls_reader_boxes->sheets[$sheets_nbr['TISSU']]['cells'] as $line => $new_line) {
		preg_match('/^([0-9]+)$/', $new_line['1'], $matches);
		if(!empty($matches)) { 
			$ns = $new_line['1'];
			if(!isset($new_line['5'])) die('Err78903-'.$line);
			if(!isset($new_line['4'])) die('Err789032-'.$line);
			$boxes_data[$ns]['TISSU'][] = array(
				'samples' => $new_line['5'], 
				'nbr_tubes' => isset($new_line['3'])? $new_line['3']: null, 
				'box' => strtoupper($new_line['4']));
		}	
	}
	
	// OCT

	foreach($xls_reader_boxes->sheets[$sheets_nbr['OCT']]['cells'] as $line => $new_line) {
		preg_match('/^([0-9]+)$/', $new_line['1'], $matches);
		if(!empty($matches)) { 
			$ns = $new_line['1'];
			if(!isset($new_line['3'])) { echo"<pre>";print_r($new_line);die('Err789013-'.$line); }
			if(!isset($new_line['4'])) { echo"<pre>";print_r($new_line);die('Err789043-'.$line); }
			$boxes_data[$ns]['OCT'][] = array(
				'samples' => $new_line['4'], 
				'nbr_tubes' => isset($new_line['2'])? $new_line['2']: null, 
				'box' => strtoupper($new_line['3']));
		}	
	}	
	
	// ADN TISSU

	foreach($xls_reader_boxes->sheets[$sheets_nbr['ADN TISSU']]['cells'] as $line => $new_line) {
		preg_match('/^([0-9]+)$/', $new_line['1'], $matches);
		if(!empty($matches)) { 
			$ns = $new_line['1'];
			if(!isset($new_line['2'])) { echo"<pre>";print_r($new_line);die('Err7ca13-'.$line); }
			if(!isset($new_line['4'])) { echo"<pre>";print_r($new_line);die('Err78vsa9043-'.$line); }
			$boxes_data[$ns]['ADN TISSU'][] = array(
				'samples' => $new_line['2'].(isset($new_line['3'])?','.$new_line['3']:''), 
				'nbr_tubes' => null, 
				'box' => strtoupper($new_line['4']));
		}	
	}	

	// ARN TISSU

	foreach($xls_reader_boxes->sheets[$sheets_nbr['ARN TISSU']]['cells'] as $line => $new_line) {
		preg_match('/^([0-9]+)$/', $new_line['1'], $matches);
		if(!empty($matches)) { 
			$ns = $new_line['1'];
			if(!isset($new_line['2'])) { echo"<pre>";print_r($new_line);die('Err765-'.$line); }
			if(!isset($new_line['3'])) { echo"<pre>";print_r($new_line);die('Err9993-'.$line); }
			$boxes_data[$ns]['ARN TISSU'][] = array(
				'samples' => $new_line['2'], 
				'nbr_tubes' => null, 
				'box' => strtoupper($new_line['3']));
		}	
	}		

	// ASCITE

	foreach($xls_reader_boxes->sheets[$sheets_nbr['ASCITES']]['cells'] as $line => $new_line) {
		preg_match('/^([0-9]+)$/', $new_line['2'], $matches);
		if(!empty($matches)) { 
			$ns = $new_line['2'];
			if(!isset($new_line['3'])) { echo"<pre>";print_r($new_line);die('Err7c335-'.$line); }
			if(!isset($new_line['4']) && !isset($new_line['5'])) { echo"<pre>";print_r($new_line);die('Err1193-'.$line); }
			$boxes_data[$ns]['ASCITE'][] = array(
				'samples' => (isset($new_line['4'])?$new_line['4'].',':'').(isset($new_line['5'])?$new_line['5']:''), 
				'nbr_tubes' => null, 
				'box' => strtoupper($new_line['3']));
		}	
	}
	
	// ASCITE NC
	
	foreach($xls_reader_boxes->sheets[$sheets_nbr['ASC NC']]['cells'] as $line => $new_line) {
		preg_match('/^([0-9]+)$/', $new_line['1'], $matches);
		if(!empty($matches)) { 
			$ns = $new_line['1'];
			if(!isset($new_line['2'])) { echo"<pre>";print_r($new_line);die('Err7c335-'.$line); }
			if(!isset($new_line['3'])) { echo"<pre>";print_r($new_line);die('Err1193-'.$line); }
			$boxes_data[$ns]['ASC_NC'][] = array(
				'samples' => $new_line['3'], 
				'nbr_tubes' => null, 
				'box' => strtoupper($new_line['2']));
		}	
	}	
	
	// SANG
	
	foreach($xls_reader_boxes->sheets[$sheets_nbr['SANG']]['cells'] as $line => $new_line) {
		preg_match('/^([0-9]+)$/', $new_line['1'], $matches);
		if(!empty($matches)) { 
			$ns = $new_line['1'];
			
			if(isset($new_line['2']) || isset($new_line['3'])) { 
				if(!isset($new_line['2']) && !isset($new_line['3'])) { echo"<pre>";print_r($new_line);die('Err121555433-'.$line); }
				$boxes_data[$ns]['SANG'][] = array(
					'samples' => $new_line['2'], 
					'nbr_tubes' => null, 
					'box' => strtoupper($new_line['3']));				
			}
			
			if(isset($new_line['4']) || isset($new_line['5'])) { 
				if(!isset($new_line['4']) && !isset($new_line['5'])) { echo"<pre>";print_r($new_line);die('Err1211133-'.$line); }
				$boxes_data[$ns]['SANG'][] = array(
					'samples' => $new_line['4'], 
					'nbr_tubes' => null, 
					'box' => strtoupper($new_line['5']));				
			}
			
			if(isset($new_line['6']) || isset($new_line['7'])) { 
				if(!isset($new_line['6']) && !isset($new_line['7'])) { echo"<pre>";print_r($new_line);die('Err1211133-'.$line); }
				$boxes_data[$ns]['SANG'][] = array(
					'samples' => $new_line['6'], 
					'nbr_tubes' => null, 
					'box' => strtoupper($new_line['7']));				
			}
		}	
	}	
	
	// SANG2
	
	foreach($xls_reader_boxes->sheets[$sheets_nbr['SANG2']]['cells'] as $line => $new_line) {
		preg_match('/^([0-9]+)$/', $new_line['1'], $matches);
		if(!empty($matches)) { 
			$ns = $new_line['1'];
			
			if(isset($new_line['2']) || isset($new_line['3'])) { 
				if(!isset($new_line['2']) && !isset($new_line['3'])) { echo"<pre>";print_r($new_line);die('Err121555433-'.$line); }
				$boxes_data[$ns]['SANG'][] = array(
					'samples' => $new_line['2'], 
					'nbr_tubes' => null, 
					'box' => strtoupper($new_line['3']));				
			}
			
			if(isset($new_line['4']) || isset($new_line['5']) || isset($new_line['6'])) {
				if(!isset($new_line['6'])) { echo"<pre>";print_r($new_line);die('Err11111111111-'.$line); }
				if(!isset($new_line['4']) && !isset($new_line['5'])) { echo"<pre>";print_r($new_line);die('Err2222222-'.$line); }
				$boxes_data[$ns]['SANG'][] = array(
					'samples' => (isset($new_line['4'])?$new_line['4'].'/':'').(isset($new_line['5'])?$new_line['5']:''), 
					'nbr_tubes' => null, 
					'box' => strtoupper($new_line['6']));			
			}
		}	
	}
		
	return $boxes_data;	
}

function manageAliquots(Model $m, $participant_id, $aliquot_data, $space_to_use){
	foreach($aliquot_data as $new_aliquot) {
		echo $space_to_use."|==> @ 1 ".$new_aliquot['type']." (Box: ".(empty($new_aliquot['storage'])? '-': $new_aliquot['storage']).")<br>";
	}
}

function manageDerivative(Model $m, $participant_id, $derivative_data, $space_to_use, $space){
	
	if(!empty($derivative_data['details']))die('ERR: 98736621cacacsasccsa');
		foreach($derivative_data as $new_derivative) {
			echo $space_to_use.'|==> <FONT COLOR=\"red\" >* '.strtoupper($new_derivative['type']).' </FONT><br>';
			manageAliquots($m, $participant_id, $new_derivative['aliquots'], $space.$space_to_use);
			manageDerivative($m, $participant_id, $new_derivative['derivatives'], $space.$space_to_use,$space);
	}
}

function pr($arr) {
	echo "<pre>";
	print_r($arr);
}

function createDerivative($m, $ns, $participant_id, $collection_id, $initial_specimen_sample_id, $initial_specimen_sample_type, $parent_sample_master_id,  $parent_sample_type,  $derivative_data) {
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
				
				if(!empty($new_derivative['derivatives'])) die('ascasc');
				break;	

				
			case 'buffy coat':
				$insert = array(
					"sample_code" 					=> "'tmp_tissue'", 
					"sample_category"				=> "'derivative'", 
					"sample_control_id"				=> "8", 
					"sample_type"					=> "'pbmc'", 
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
				$query = "UPDATE sample_masters SET sample_code=CONCAT('PBMC - ', id) WHERE id=".$sample_master_id;
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO 	sd_der_pbmcs (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO derivative_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));				
				
				createDerivative($m, $ns, $participant_id, $collection_id, $initial_specimen_sample_id, $initial_specimen_sample_type, $sample_master_id, 'pbmc', $new_derivative['derivatives']);
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
				
				createDerivative($m, $ns, $participant_id, $collection_id, $initial_specimen_sample_id, $initial_specimen_sample_type, $sample_master_id, 'ascite cell', $new_derivative['derivatives']);
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
				$query = "INSERT INTO 	sd_der_cell_cultures (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO derivative_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));				
				
				createDerivative($m, $ns, $participant_id, $collection_id, $initial_specimen_sample_id, $initial_specimen_sample_type, $sample_master_id, 'cell culture', $new_derivative['derivatives']);
				break;		
				
			default:
				die('to support'.$der_type);
		}
	}
}
	
function createAliquot($m, $ns, $participant_id, $collection_id, $sample_master_id, $sample_type, $aliquot_data) {
	global $connection;
	$created = array(
		"created"		=> "NOW()", 
		"created_by"	=> "1", 
		"modified"		=> "NOW()",
		"modified_by"	=> "1"
		);
	
	if(empty($aliquot_data)) return;
	
	foreach($aliquot_data as $new_aliquot) {
		switch($sample_type) {
			case 'blood':
				$insert = array(
					"aliquot_type" => "'tube'",
					"aliquot_control_id" => "16",
					"collection_id" => $collection_id,
					"sample_master_id" => $sample_master_id,
					"aliquot_label" => "'".(($new_aliquot['type'] == 'RNALater tube')? 'RL ' : 'Sang ').$ns.' 0000-00-00'."'"
				);
//				$storage_master_id = getStorageId($m, 'blood aliquot', $$new_aliquot['storage']);
				if(!empty($storage_master_id)) $insert['storage_master_id'] = $storage_master_id;
					
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO aliquot_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				$aliquot_master_id = mysqli_insert_id($connection);
				$query = "UPDATE aliquot_masters SET barcode= CONCAT('tmp_','".$sample_master_id."','_','".$aliquot_master_id."') WHERE id=".$aliquot_master_id;
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				
				$insert = array(
					"aliquot_master_id"		=> $aliquot_master_id,
				);
				if($new_aliquot['type'] == 'RNALater tube') $insert['chuq_blood_solution'] = 'RNA later';
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO ad_tubes (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
			
			break;
			
			
			
			
			
			default:
		}
		
	}
}

function getStorageId($m, $aliquot_class, $box_number) {
	global $connection;
	$created = array(
		"created"		=> "NOW()", 
		"created_by"	=> "1", 
		"modified"		=> "NOW()",
		"modified_by"	=> "1"
		);
		
	$storage_master_id = '';
	if(!empty($box_number)) {
		if(!isset($m->Storages[$aliquot_class][$box_number])) {	
			$insert = array(
				"storage_type"			=> "'box'",
				"storage_control_id"	=> "8",
				"short_label"			=> "'".$box_number."'",
				"selection_label"		=> "'".$box_number."'",
				"lft"		=> "'".($m->Storages['next_left'] + 1)."'",
				"rght"		=> "'".($m->Storages['next_left'] + 2)."'",
				"set_temperature"	=> "'FALSE'"
			);
			$insert = array_merge($insert, $created);
			$query = "INSERT INTO storage_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
			mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
			$storage_master_id = mysqli_insert_id($connection);
			
			$insert = array(
				"storage_master_id"	=> $storage_master_id,
			);
			$insert = array_merge($insert, $created);
			$query = "INSERT INTO std_boxs (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
			mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
					
			$m->Storages['next_left'] = $m->Storages['next_left'] + 2;
			$m->Storages[$aliquot_class][$box_number] = array('id' => $storage_master_id);
		} else {
			$storage_master_id = $m->Storages[$aliquot_class][$box_number]['id'];
		}
	}
	return $storage_master_id;
}