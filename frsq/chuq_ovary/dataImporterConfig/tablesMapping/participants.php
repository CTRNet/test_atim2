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
					$prefix = '';
					
					if(array_key_exists($new_tissue, $collections)) {
						$prefix_counter = 1;
						while(array_key_exists($new_tissue.$prefix, $collections)) {
							$prefix = '{'.$prefix_counter.'}';
							$prefix_counter++;
						}	
						echo "<br><FONT COLOR=\"red\" >Line ".$m->line." [TISSUS][WARNING]: TISSUS code {$new_tissue} is created at least twice!</FONT><br>";						
					}
					$collections[$new_tissue.$prefix] = array('type' => 'tissue', 'details' => $m->tissueCode2Details[$new_tissue], 'aliquots' => array(), 'derivatives' => array());
					
				}else {
					die("<br><FONT COLOR=\"red\" >Line ".$m->line." [TISSUS][ERROR]: TISSUS code {$new_tissue} is unknown!</FONT><br>");
				}
				$created_tissues_from_tissus_col[] = $new_tissue;
			}
		}
	} //End of TISSUS
	
	// OCT ----------------------------------------------------------------------
	
	if(!empty($invantory_data_from_file['OCT'])) die("<br><FONT COLOR=\"red\" >Line ".$m->line." [OCT][ERROR]: SITE not empty!</FONT><br>");

	// OCT

	$aliquot_type = 'oct tube';
	if(isset($m->boxesData[$ns]['OCT'])) {
		foreach($m->boxesData[$ns]['OCT'] as $new_octs) {
			$storage = str_replace('Bt#', '', $new_octs['box']);
			$intial_tubes_nbr = $new_octs['nbr_tubes'];
			$sources = explode(',', strtoupper($new_octs['samples']));
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
			if($created_tube_nbr != $intial_tubes_nbr) echo("<br><FONT COLOR=\"red\" >Line ".$m->line." / NS = $ns [OCT_file][ERROR]: Nbr of tubes defined into file is wrong ($intial_tubes_nbr != $created_tube_nbr).</FONT><br>");
		}

	}		


	// T ----------------------------------------------------------------------
	
//	$aliquot_type = 'frozen tube';
//	if(!empty($invantory_data_from_file['T'])) {
//		// Manage TBt13
//		$ts_tmp = str_replace(' ', '', $invantory_data_from_file['T']);
//		if($ts_tmp == 'Tbt13') $ts_tmp = 'T/?bt#13';
////TODO: should be corrected ???
//if($ts_tmp == '2Tbt13') $ts_tmp = 'T/2?bt#13';
//		$ts_tmp = str_replace(',Tbt13', 'bt#13', $ts_tmp);	
////TODO: should be corrected
//$ts_tmp = str_replace(',2Tbt13', 'bt#13', $ts_tmp);		
//		$ts_tmp = str_replace('Tbt13', 'bt#13', $ts_tmp); //For line 329
//		
//		// Continue
//		$ts_tmp = str_replace(',', '/', $ts_tmp);
//		$ts_tmp = str_replace('bt#', '#', $ts_tmp);
//		$storage_for_all = null;
//		if(substr_count($ts_tmp, '#') == 1) { 
//			preg_match('/#([0-9]+)/', $ts_tmp, $matches);	
//			$storage_for_all = $matches[1] ; 
//			$ts_tmp = preg_replace('/#([0-9]+)/', '', $ts_tmp);
//		}
//		$ts = explode('/', strtoupper($ts_tmp));
//
//		if($ts[0] != 'T') die("<br><FONT COLOR=\"red\" >Line ".$m->line." [T]: 'T' cell content dones not start with 'T'!</FONT><br>");
//		unset($ts[0]);
//		if(empty($ts)) {
//			// Just T
//			if(sizeof($created_tissues_from_tissus_col) == 1) {
//				$collections[$created_tissues_from_tissus_col[0]]['aliquots'][] = array('type' =>$aliquot_type,'storage' => null);	
//			} else {
//				if(!isset($collections['unknown_tissue'])) $collections['unknown_tissue'] = array('type' => 'tissue', 'details' => $m->tissueCode2Details['unknown_tissue'], 'aliquots' => array(), 'derivatives' => array());
//				$collections['unknown_tissue']['aliquots'][] = array('type' =>$aliquot_type,'storage' => null);	
//				if(sizeof($created_tissues_from_tissus_col) > 1) echo "<br><FONT COLOR=\"green\" >Line ".$m->line." [T]: Unable to define parent for an 'T' value equals to 'T' because there are many parent tissues defined into TISSUS. Will be linked to 'unknown_tissue'.</FONT><br>";
//			}
//			
//		} else {
//			foreach($ts as $new_source) {
//				$new_source = utf8_encode($new_source);
////$new_source = str_replace('MASSEUTÉRINE', 'MASSE UTÉRINE', $new_source);
//				$storage = $storage_for_all;
//				if(empty($storage)) {
//					preg_match('/#([0-9]+)/', $new_source, $matches);	
//					if(!empty($matches)) $storage = $matches[1] ; 
//					$new_source = preg_replace('/#([0-9]+)/', '', $new_source);			
//				}
//				preg_match('/^([0-9]+)/', $new_source, $matches);	
//				$tubes_nbr = empty($matches)? '1' : $matches[1];
//				$new_source = str_replace($tubes_nbr, '', $new_source);	
//				if(array_key_exists($new_source, $m->tissueCodeSynonimous)) $new_source = $m->tissueCodeSynonimous[$new_source];
//				
//				if(array_key_exists($new_source, $collections)) {
//					// Parent found
//					while($tubes_nbr > 0) { 
//						$collections[$new_source]['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
//						$tubes_nbr--;
//					}
//				} else if(array_key_exists($new_source, $m->tissueCode2Details)) {
//					//Create parent
//					echo "<br><FONT COLOR=\"green\" >Line ".$m->line." [T]: Create parent '$new_source' for a 'T' value equal to '$new_source' because this one is not defined into 'TISSUS' column.</FONT><br>";
//					$collections[$new_source] = array('type' => 'tissue', 'details' => $m->tissueCode2Details[$new_source], 'aliquots' => array(), 'derivatives' => array());
//					while($tubes_nbr > 0) { 
//						$collections[$new_source]['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
//						$tubes_nbr--;
//					}
//				} else {
//					die("<br><FONT COLOR=\"red\" >Line ".$m->line." [ERR][T]: Unable to define parent from a list for an 'T' value equal to '$new_source'. This tissue code is unknown.</FONT><br>");
//				}
//			}
//		}
//	} //End of T
	
	// FFPE ----------------------------------------------------------------------
	
	$aliquot_type = 'paraffin block';
	$storage = empty($invantory_data_from_file['BOITE FFPE'])? null : $invantory_data_from_file['BOITE FFPE'];
	if(!is_null($storage)) {
		preg_match('/^([0-9]+)$/', $storage, $matches);
		if(empty($matches)) die('ER:98873 -'.$invantory_data_from_file['BOITE FFPE']);
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
	} //End of FFPE

	// SANG-PLASMA-SERIM- BUFFY COAT  ----------------------------------------------------------------------
	
	$aliquot_type = 'tube';
	if(!empty($invantory_data_from_file['SANG-PLASMA-SERIM- BUFFY COAT '])) {
		$bloods_tmp = str_replace(' ', '', $invantory_data_from_file['SANG-PLASMA-SERIM- BUFFY COAT ']);
		$bloods = explode('/', strtoupper($bloods_tmp));
		
		foreach($bloods as $new_sample) {
			if(!isset($collections['blood'])) $collections['blood'] = array('type' => 'blood', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
			
			switch($new_sample) {
				case 'SANG':
				case 'RNALATER':
					$blood_aliquot_type = ($new_sample == 'SANG')? 'EDTA '.$aliquot_type : 'RNALater '.$aliquot_type;
					$collections['blood']['aliquots'][] = array('type' =>$blood_aliquot_type,'storage' => null);
					break;
				case 'P':
				case 'PLASMA':
					if(!isset($collections['blood']['derivatives']['plasma'])) $collections['blood']['derivatives']['plasma'] = array('type' => 'plasma', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
					$collections['blood']['derivatives']['plasma']['aliquots'][] = array('type' =>$aliquot_type,'storage' => null);
					break;
				case 'S':
					if(!isset($collections['blood']['derivatives']['serum'])) $collections['blood']['derivatives']['serum'] = array('type' => 'serum', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
					$collections['blood']['derivatives']['serum']['aliquots'][] = array('type' =>$aliquot_type,'storage' => null);
					break;
				case 'BC':
					if(!isset($collections['blood']['derivatives']['buffy coat'])) $collections['blood']['derivatives']['buffy coat'] = array('type' => 'buffy coat', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
					$collections['blood']['derivatives']['buffy coat']['aliquots'][] = array('type' =>$aliquot_type,'storage' => null);
					break;
				default:
					die("<br><FONT COLOR=\"red\" >Line ".$m->line." [BLOOD][ERR]: Blood sample '$new_sample' is not supproted. </FONT><br>");		
			}
		}
	} //End of blocs SANG-PLASMA-SERIM- BUFFY COAT 
	
	// ASCITE  ----------------------------------------------------------------------
	
	//*br*: 
	
	$aliquot_type = 'tube';
	if(!empty($invantory_data_from_file['ASCITE'])) {
		$ascites_tmp = str_replace(' ', '', $invantory_data_from_file['ASCITE']);
		$ascites = explode('/', strtoupper($ascites_tmp));

		foreach($ascites as $new_sample) {
			if(!empty($new_sample)) {
				if(!isset($collections['ascite'])) $collections['ascite'] = array('type' => 'ascite', 'details' => null, 'aliquots' => array(), 'derivatives' => array());

				preg_match('/^([0-9]+)/', $new_sample, $matches);	
				$tubes_nbr = empty($matches)? '1' : $matches[1];
				$new_sample = str_replace($tubes_nbr, '', $new_sample);	
	
				switch($new_sample) {
					case 'ASC':
						while($tubes_nbr > 0) { 
							$collections['ascite']['aliquots'][] = array('type' =>$aliquot_type,'storage' => null); 
							$tubes_nbr--;
						}
						break;
					case 'S':
					case 'SASC':
						if(!isset($collections['ascite']['derivatives']['ascite supernatant'])) $collections['ascite']['derivatives']['ascite supernatant'] = array('type' => 'ascite supernatant', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
						while($tubes_nbr > 0) { 
							$collections['ascite']['derivatives']['ascite supernatant']['aliquots'][] = array('type' =>$aliquot_type,'storage' => null); 
							$tubes_nbr--;
						}
						break;
					case 'NC':
						if(!isset($collections['ascite']['derivatives']['ascite cells'])) $collections['ascite']['derivatives']['ascite cells'] = array('type' => 'ascite cells', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
						while($tubes_nbr > 0) { 
							$collections['ascite']['derivatives']['ascite cells']['aliquots'][] = array('type' =>$aliquot_type,'storage' => null); 
							$tubes_nbr--;
						}
						break;
					default:
						die("<br><FONT COLOR=\"red\" >Line ".$m->line." [ERR][ASCITE]: Ascite sample '$new_sample' is not supported. </FONT><br>");		
				}
			}
		}
	} //End of ASCITE
	
//	// PC  ----------------------------------------------------------------------
//	
//	//*br*: Ne pas prendre ne compte les valuer 'PC'
//	//*br*: Seul PC ont été définie a partir de Epiplon EP et ascite ASC
//	
//	$aliquot_type = 'tube';
//	if(!empty($invantory_data_from_file['PC']) && ($invantory_data_from_file['PC'] != 'PC')) {
//		$PCs_tmp = str_replace('PC/', '', $invantory_data_from_file['PC']);
//
//		preg_match('/^([0-9]+)/', $PCs_tmp, $matches);	
//		$tubes_nbr = empty($matches)? '1' : $matches[1];
//		$new_source = str_replace($tubes_nbr, '', $PCs_tmp);			
//		
//		switch($new_source) {
//			case 'ASC':
//				if(!isset($collections['ascite'])) $collections['ascite'] = array('type' => 'ascite', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
//				if(!isset($collections['ascite']['derivatives']['ascite cells'])) $collections['ascite']['derivatives']['ascite cells'] = array('type' => 'ascite cells', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
//				$collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture'] = array('type' => 'cell culture', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
//				while($tubes_nbr > 0) { 
//					$collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture']['aliquots'][] = array('type' =>$aliquot_type,'storage' => null); 
//					$tubes_nbr--;
//				}
//				break;
//			case 'EP':	
//				if(!array_key_exists($new_source, $m->tissueCode2Details)) die("<br><FONT COLOR=\"red\" >Line ".$m->line." [ERR][PC]: TISSUS code '$new_source' unknown!</FONT><br>");
//				if(!isset($collections[$new_source])) $collections[$new_source] = array('type' => 'tissue', 'details' => $m->tissueCode2Details[$new_source], 'aliquots' => array(), 'derivatives' => array());
//				$collections[$new_source]['derivatives']['cell culture'] = array('type' => 'cell culture', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
//				while($tubes_nbr > 0) { 
//					$collections[$new_source]['derivatives']['cell culture']['aliquots'][] = array('type' =>$aliquot_type,'storage' => null); 
//					$tubes_nbr--;
//				}
//				break;
//			default:
//				die("<br><FONT COLOR=\"red\" >Line ".$m->line." [ERR][PC]: Source '$new_source' of the PC is not supported. </FONT><br>");
//		}
//	} //End of PC
	
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
	$storage = empty($invantory_data_from_file['BOITE ARN'])? null : $invantory_data_from_file['BOITE ARN'];
	if(!is_null($storage)) {
		preg_match('/^([0-9]+)$/', $storage, $matches);
		if(empty($matches)) die('ER:98873 -'.$invantory_data_from_file['BOITE ARN']);
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
	$storage = empty($invantory_data_from_file['BOITE ADN'])? null : $invantory_data_from_file['BOITE ADN'];
	if(!is_null($storage)) {
		preg_match('/^([0-9]+)$/', $storage, $matches);
		if(empty($matches)) die('ER:98873 -'.$invantory_data_from_file['BOITE ADN']);
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
	

	
	
	
	
	//
	
	echo "<br>:::::::::::::: SAMPLES SUMMARY ::::::::::::::<br>";
	
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
					echo '<br><FONT COLOR=\"red\" >** ASCITE</FONT><br>';
					break;
				default:
					if($data['type'] != 'tissue') {
						echo "<pre>";
						print_r($collections);
						die ('ERR: 9973671812cacacasc');
					}
					echo '<br><FONT COLOR=\"red\" >** TISSUE </FONT>(code : '.$data['details']['code'].', source : '.$data['details']['source'].', laterality : '.$data['details']['laterality'].', type : '.$data['details']['type'].')<br>';		
			}
			
			// Display Aliquot
			manageAliquots($m, $participant_id, $data['aliquots'], $space);
			
			// Manage Derivative
			manageDerivative($m, $participant_id, $data['derivatives'], $space, $space);
		}
	}
	echo "<br>";

}

//=========================================================================================================
// Additional function
//=========================================================================================================

function setDataForpostParticipantWrite(Model &$m) {
	
	$m->tissueCode2Details = array(
		'OV' => array('code' => '', 'source' => 'ovary', 'laterality' => '', 'type' => ''),
		'OVD' => array('code' => '', 'source' => 'ovary', 'laterality' => 'right', 'type' => ''),
		'OVG' => array('code' => '', 'source' => 'ovary', 'laterality' => 'left', 'type' => ''),
		'BOVD' => array('code' => '', 'source' => 'ovary', 'laterality' => 'right', 'type' => 'benin'),
		'BOVG' => array('code' => '', 'source' => 'ovary', 'laterality' => 'left', 'type' => 'benin'),
		'KOV' => array('code' => '', 'source' => 'ovary', 'laterality' => '', 'type' => 'cyst'),
		'KOVD' => array('code' => '', 'source' => 'ovary', 'laterality' => 'right', 'type' => 'cyst'),
		'KOVG' => array('code' => '', 'source' => 'ovary', 'laterality' => 'left', 'type' => 'cyst'),
		'NOV' => array('code' => '', 'source' => 'ovary', 'laterality' => '', 'type' => 'normal'),
		'NOVD' => array('code' => '', 'source' => 'ovary', 'laterality' => 'right', 'type' => 'normal'),
		'NOVG' => array('code' => '', 'source' => 'ovary', 'laterality' => 'left', 'type' => 'normal'),
		'TOVD' => array('code' => '', 'source' => 'ovary', 'laterality' => 'right', 'type' => 'tumoral'),
		'TOVG' => array('code' => '', 'source' => 'ovary', 'laterality' => 'left', 'type' => 'tumoral'),
		
		'AP' => array('code' => '', 'source' => 'other', 'laterality' => '', 'type' => ''),
		'EP' => array('code' => '', 'source' => 'epiplon', 'laterality' => '', 'type' => ''),
		'EPD' => array('code' => '', 'source' => 'epiplon', 'laterality' => 'right', 'type' => ''),
		'EPG' => array('code' => '', 'source' => 'epiplon', 'laterality' => 'left', 'type' => ''),
		'NEP' => array('code' => '', 'source' => 'epiplon', 'laterality' => '', 'type' => 'normal'),
		'TEP' => array('code' => '', 'source' => 'epiplon', 'laterality' => '', 'type' => 'tumoral'),
		'IP' => array('code' => '', 'source' => 'peritoneal implant', 'laterality' => '', 'type' => ''),
		'IPG' => array('code' => '', 'source' => 'peritoneal implant', 'laterality' => 'left', 'type' => ''),
		'IPD' => array('code' => '', 'source' => 'peritoneal implant', 'laterality' => 'right', 'type' => ''),
		'MP' => array('code' => '', 'source' => 'pelvic mass', 'laterality' => '', 'type' => ''));
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
		'OG' => 'OVG',
		'EPPD' => 'EPD',
		'M.P' => 'MP',
	//TODO: to confirm
		'ANXG' => 'AP');

	$m->ovCodes = array();
	foreach($m->tissueCode2Details as $code => $data) {
		if($data['source'] == 'ovary') $m->ovCodes[] = $code;
	}
	
	$m->boxesData = getBoxesDataFromFile();
}

function getBoxesDataFromFile() {
	$boxes_data = array();
	
	$xls_reader_boxes = new Spreadsheet_Excel_Reader();
	$xls_reader_boxes->read( "/Documents and Settings/u703617/Desktop/Banque_Bachvarov_boites_20110603.xls");
	
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
				'box' => $new_line['4']);
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
				'box' => $new_line['3']);
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
				'box' => $new_line['4']);
		}	
	}	

	// ARN TISSU

	foreach($xls_reader_boxes->sheets[$sheets_nbr['ARN TISSU']]['cells'] as $line => $new_line) {
		preg_match('/^([0-9]+)$/', $new_line['1'], $matches);
		if(!empty($matches)) { 
			$ns = $new_line['1'];
			if(!isset($new_line['2'])) { echo"<pre>";print_r($new_line);die('Err765-'.$line); }
			if(!isset($new_line['3'])) { echo"<pre>";print_r($new_line);die('Err9993-'.$line); }
			$boxes_data[$ns]['ADN TISSU'][] = array(
				'samples' => $new_line['2'], 
				'nbr_tubes' => null, 
				'box' => $new_line['3']);
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
				'box' => $new_line['3']);
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
					'box' => $new_line['3']);				
			}
			
			if(isset($new_line['4']) || isset($new_line['5'])) { 
				if(!isset($new_line['4']) && !isset($new_line['5'])) { echo"<pre>";print_r($new_line);die('Err1211133-'.$line); }
				$boxes_data[$ns]['SANG'][] = array(
					'samples' => $new_line['4'], 
					'nbr_tubes' => null, 
					'box' => $new_line['5']);				
			}
			
			if(isset($new_line['6']) || isset($new_line['7'])) { 
				if(!isset($new_line['6']) && !isset($new_line['7'])) { echo"<pre>";print_r($new_line);die('Err1211133-'.$line); }
				$boxes_data[$ns]['SANG'][] = array(
					'samples' => $new_line['6'], 
					'nbr_tubes' => null, 
					'box' => $new_line['7']);				
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
					'box' => $new_line['3']);				
			}
			
			if(isset($new_line['4']) || isset($new_line['5']) || isset($new_line['6'])) {
				if(!isset($new_line['6'])) { echo"<pre>";print_r($new_line);die('Err11111111111-'.$line); }
				if(!isset($new_line['4']) && !isset($new_line['5'])) { echo"<pre>";print_r($new_line);die('Err2222222-'.$line); }
				$boxes_data[$ns]['SANG'][] = array(
					'samples' => (isset($new_line['4'])?$new_line['4'].',':'').(isset($new_line['5'])?$new_line['5']:''), 
					'nbr_tubes' => null, 
					'box' => $new_line['6']);			
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


