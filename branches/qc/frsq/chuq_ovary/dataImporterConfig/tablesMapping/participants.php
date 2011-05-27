<?php
$pkey = "NS";
$child = array('ConsentMaster','DiagnosisMaster','PathoMiscIdentfier','DosMiscIdentfier');
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

$model->tissueCode2Details = array(
	'BOVD' => array('code' => 'BOVD', 'source' => 'ovary', 'laterality' => 'right', 'type' => 'benin'),
	'BOVG' => array('code' => 'BOVG', 'source' => 'ovary', 'laterality' => 'left', 'type' => 'benin'),
	'KOVD' => array('code' => 'KOVD', 'source' => 'ovary', 'laterality' => 'right', 'type' => 'benin'),
	'KOVG' => array('code' => 'KOVG', 'source' => 'ovary', 'laterality' => 'left', 'type' => 'benin'),
	'TOVG' => array('code' => 'TOVG', 'source' => 'ovary', 'laterality' => 'left', 'type' => 'malignant'),
	'NOVD' => array('code' => 'NOVD', 'source' => 'ovary', 'laterality' => 'right', 'type' => 'normal'),
	'NOVG' => array('code' => 'NOVG', 'source' => 'ovary', 'laterality' => 'left', 'type' => 'normal'),
	'OVDN' => array('code' => 'NOVD', 'source' => 'ovary', 'laterality' => 'right', 'type' => 'normal'),
	'OVGN' => array('code' => 'NOVG', 'source' => 'ovary', 'laterality' => 'left', 'type' => 'normal'),
	'OV' => array('code' => 'OV', 'source' => 'ovary', 'laterality' => 'unknown', 'type' => 'unknown'),
	'OVD' => array('code' => 'OVD', 'source' => 'ovary', 'laterality' => 'right', 'type' => 'unknown'),
	'OVG' => array('code' => 'OVG', 'source' => 'ovary', 'laterality' => 'left', 'type' => 'unknown'),
	'TOVG' => array('code' => 'TOVG', 'source' => 'ovary', 'laterality' => 'left', 'type' => 'malignant'),
	'TOVD' => array('code' => 'TOVG', 'source' => 'ovary', 'laterality' => 'right', 'type' => 'malignant'),
	'TOV' => array('code' => 'TOV', 'source' => 'ovary', 'laterality' => 'unknown', 'type' => 'malignant'),
'AN.UT' => array('code' => 'AN.UT', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
	'AND' => array('code' => 'AND', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
	'AS' => array('code' => 'AS', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
	'ASC' => array('code' => 'ASC', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
	'AOV' => array('code' => 'AOV', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
'AU' => array('code' => 'AU', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
'AEP' => array('code' => 'AEP', 'source' => 'unknown', 'laterality' => '', 'type' => ''),

'A' => array('code' => 'A', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
	'AG' => array('code' => 'AG', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
'G' => array('code' => 'G', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
	'B' => array('code' => 'B', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
'D' => array('code' => 'D', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
'TEP' => array('code' => 'TEP', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
'N' => array('code' => 'N', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
'E' => array('code' => 'E', 'source' => 'endometrium', 'laterality' => '', 'type' => ''),
	'EP' => array('code' => 'EP', 'source' => 'epiplon', 'laterality' => '', 'type' => ''),
	'IP' => array('code' => 'IP', 'source' => 'peritoneal implant', 'laterality' => '', 'type' => ''),
	'KYSTE' => array('code' => 'KYSTE ', 'source' => 'cyst', 'laterality' => '', 'type' => ''),
	'M.BUT' => array('code' => 'M.BUT', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
	'MASSEABDOMINAL' => array('code' => 'MA', 'source' => 'abdominal mass', 'laterality' => '', 'type' => ''),
	'MP' => array('code' => 'MP', 'source' => 'pelvic mass', 'laterality' => '', 'type' => ''),
	'NC' => array('code' => 'NC', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
	'ND' => array('code' => 'ND', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
	'NM' => array('code' => 'NM', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
'ANXG'=> array('code' => 'ANXG', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
	'NODUL' => array('code' => 'NODUL', 'source' => 'nodule', 'laterality' => '', 'type' => ''),
	'NP' => array('code' => 'NP', 'source' => 'peritoneum', 'laterality' => '', 'type' => ''),
	'PO' => array('code' => 'PO', 'source' => 'unknown', 'laterality' => '', 'type' => ''),

'R' => array('code' => 'R', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
'R-E' => array('code' => 'R-E', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
'R-OG' => array('code' => 'R-OG', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
'R-OD' => array('code' => 'R-OD', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
'E-N' => array('code' => 'E-N', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
'E-T' => array('code' => 'E-T', 'source' => 'unknown', 'laterality' => '', 'type' => ''),

	'SIGMOIDE' => array('code' => 'SIGMOIDE', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
	'TCS' => array('code' => 'TCS', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
	'TR' => array('code' => 'TR', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
	'UT' => array('code' => 'UT', 'source' => 'uterus', 'laterality' => '', 'type' => ''));

$model->tissueCodeSynonimous = array(
	'ED' => 'E',
	'EG' => 'E',
	'ENDO.' => 'E',
	'ENDO.BT' => 'E',
	'ENDOMÈTRE' => 'E',
	'EPN' => 'EP',
'OGT' => 'TOVG',
	'EPD' => 'EP',
	'NEP' => 'EP',
	'IMP' => 'IP',
	'IMP.G.' => 'IP',
	'IMP.PEL.' => 'IP',
	'IMP.PERIT' => 'IP',
	'IMP.PERIT.' => 'IP',
	'IMPG' => 'IP',
	'IMPL.PERIT' => 'IP',
	'IMPLANTPERTONEL' => 'IP',
	'IMPLANTSPERITON.' => 'IP',
	'KYSTETROMPE' => 'KYSTE',
	'M.ABDOM' => 'MASSEABDOMINAL',
	'M.A.' => 'MASSEABDOMINAL',
	'MAP' => 'MASSEABDOMINAL',
	'M.P' => 'MP',
	'MASSPELVIENNE' => 'MP',
	'MASSEPEL.' => 'MP',
	'MASSEPELVIEN' => 'MP',
	'MASSEPELVIENE' => 'MP',
	'MASSEPELVIENNE' => 'MP',
	'MPG' => 'MP',
	'M.PEL.' => 'MP',
	'PELVIEN' => 'MP',
	'NOD' => 'NODUL',
	'NODULEPELVIEN' => 'NODUL',
	'NODULES' => 'NODUL',
	'O' => 'OV',
	'T' => 'TOV',
	'OD' => 'OVD',
	'OG' => 'OVG',
	'PRIM.OV.' => 'PO',
	'MASSEUTÉRINE' => 'UT',
	'MASSEUTÉRINEBÉNIN' => 'UT',
	'UTÉRUS' => 'UT');

$model->tissueCode2Details['unknown_tissue'] = array('code' => 'UNK', 'source' => 'unknown', 'laterality' => '', 'type' => '');
$model->tissueCodeSynonimous['?'] = 'unknown_tissue';

$model->epCodes = array();
$model->ovCodes = array();
//TODO confirm
foreach($model->tissueCode2Details as $code => $data) {
	if($data['source'] == $model->tissueCode2Details['OV']['source']) $model->ovCodes[] = $code;
	if($data['source'] == $model->tissueCode2Details['EP']['source']) $model->epCodes[] = $code;
}

function postParticipantRead(Model $m){
	excelDateFix($m);
}

function postParticipantWrite(Model $m, $participant_id){
	$line =  $m->line;
	$invantory_data_from_file =  $m->values;
	$collections = array();
	
echo"<br>Line ".$m->line. " -------------------------------------------------<br>";
	
	// TISSUS ----------------------------------------------------------------------
	
	//*br*: Separe selon /
	//*br*:Doit être retrouvé dans le tableau ci dessus pour details
	
	$created_tissues_from_tissus_col = array();
	if(!empty($invantory_data_from_file['TISSUS'])) {
		$tissues = explode('/', strtoupper(str_replace(' ', '', $invantory_data_from_file['TISSUS'])));
		foreach($tissues as $new_tissue) {
			if(!empty($new_tissue)) {
				$new_tissue = utf8_encode($new_tissue);
				if(array_key_exists($new_tissue, $m->tissueCodeSynonimous)) $new_tissue = $m->tissueCodeSynonimous[$new_tissue];
				if(array_key_exists($new_tissue, $m->tissueCode2Details)) {
					$collections[$new_tissue] = array('type' => 'tissue', 'details' => $m->tissueCode2Details[$new_tissue], 'aliquots' => array(), 'derivatives' => array());
				}else {
					die("<br><FONT COLOR=\"red\" >Line ".$m->line." [ERR][TISSUS]: TISSUS code '$new_tissue' unknown!</FONT><br>");
				}
				$created_tissues_from_tissus_col[] = $new_tissue;
			}
		}
	} //End of TISSUS
	
	// OCT ----------------------------------------------------------------------
	
	//*br*: Suppression des espaces.
	//*br*: remplacer , par /.
	//*br*: remplacer , bt# par # pour isoler le numero de boite
	//*?*: On importe pas les boites de ce fichier? Car incoherence?
	//*br*: Si une seule boite par ligne... le storage s'applique a tous sinon on associe la boite au type d'OCT
	//*br*: 3OV signifie que on va créer 3 tubes
	//*br*: Si on a juste OCT dans la cellule, on procede comme suit:
	//             - Si la cellule de TISSUS est vide on créé un tissue unknown
	//             - Si la cellule de TISSUS contient un tissu on l'associe
	//             - Sinon erreur 
	//*br*: Sinon on étudie chaque nouveau type de tissue parent (séparé par /):
	//             - Si existe dans colonne TISSUS, on associe les aliquots au tissue
	//             - Si nouveau type est OD ou OG on verifie que dans TISSUS on a pas un TOVD, NOVD, etc pour les associer
	//             - Si pas trouvé dans la colonne tissus on verifie que le code du parent est supporté et on créé ce parent (ex TCS dans colonne oct mais pas dans colonne TISSU)
	//             - Sinon erreur.

	$aliquot_type = 'oct tube';
	if(!empty($invantory_data_from_file['OCT'])) {
		$octs_tmp = str_replace(' ', '', $invantory_data_from_file['OCT']);
		
		$octs_tmp = str_replace(',', '/', $octs_tmp);
		$octs_tmp = str_replace('bt#', '#', $octs_tmp);
		$storage_for_all = null;
		if(substr_count($octs_tmp, '#') == 1) { 
			preg_match('/#([0-9]+)/', $octs_tmp, $matches);	
			$storage_for_all = $matches[1] ; 
			$octs_tmp = preg_replace('/#([0-9]+)/', '', $octs_tmp);
		}
		$octs = explode('/', strtoupper($octs_tmp));
		if($octs[0] != 'OCT') die("<br><FONT COLOR=\"red\" >Line ".$m->line." [OCT]: an OCT cell content dones not start with 'OCT'!</FONT><br>");
		unset($octs[0]);
		if(empty($octs)) {
			// Just OCT
			if(sizeof($created_tissues_from_tissus_col) == 1) {
				$collections[$created_tissues_from_tissus_col[0]]['aliquots'][] = array('type' =>$aliquot_type,'storage' => null);	
			} else {
				if(!isset($collections['unknown_tissue'])) $collections['unknown_tissue'] = array('type' => 'tissue', 'details' => $m->tissueCode2Details['unknown_tissue'], 'aliquots' => array(), 'derivatives' => array());
				$collections['unknown_tissue']['aliquots'][] = array('type' =>$aliquot_type,'storage' => null);	
				if(sizeof($created_tissues_from_tissus_col) > 1) echo "<br><FONT COLOR=\"green\" >Line ".$m->line." [OCT]: Unable to define parent (from parent alreday defined into excel) for an 'OCT' cell value equals to 'OCT' because there are many parent tissues defined into 'TISSUS'. Will be linked to 'unknown_tissue'.</FONT><br>";
			}
			
		} else {
			foreach($octs as $new_source) {
				$new_source = utf8_encode($new_source);
				$storage = $storage_for_all;
				if(empty($storage)) {
					preg_match('/#([0-9]+)/', $new_source, $matches);	
					if(!empty($matches)) $storage = $matches[1] ; 
					$new_source = preg_replace('/#([0-9]+)/', '', $new_source);			
				}
				preg_match('/^([0-9]+)/', $new_source, $matches);	
				$tubes_nbr = empty($matches)? '1' : $matches[1];
				$new_source = str_replace($tubes_nbr, '', $new_source);	
				if(array_key_exists($new_source, $m->tissueCodeSynonimous)) $new_source = $m->tissueCodeSynonimous[$new_source];
				
				if(array_key_exists($new_source, $collections)) {
					// Parent found
					while($tubes_nbr > 0) { 
						$collections[$new_source]['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
						$tubes_nbr--;
					}
				} else if(array_key_exists($new_source, $m->tissueCode2Details)) {
					//Create parent
					echo "<br><FONT COLOR=\"green\" >Line ".$m->line." [OCT]: Create specimen '$new_source' for an 'OCT' value equal to '$new_source' because this one does not exist into 'TISSUS' column.</FONT><br>";
					$collections[$new_source] = array('type' => 'tissue', 'details' => $m->tissueCode2Details[$new_source], 'aliquots' => array(), 'derivatives' => array());
					while($tubes_nbr > 0) { 
						$collections[$new_source]['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
						$tubes_nbr--;
					}
				} else {
					die ("<br><FONT COLOR=\"red\" >Line ".$m->line." [ERR][OCT]: Unable to define parent from a list for an 'OCT' value equal to '$new_source'. This tissue code is unknown.</FONT><br>");
				}
			}
		}
	} //End of OCT
	
	// T ----------------------------------------------------------------------
	
	//*br*: Similaire a OCT excepté pour les TBt13

	$aliquot_type = 'frozen tube';
	if(!empty($invantory_data_from_file['T'])) {
		// Manage TBt13
		$ts_tmp = str_replace(' ', '', $invantory_data_from_file['T']);
		if($ts_tmp == 'Tbt13') $ts_tmp = 'T/?bt#13';
//TODO: should be corrected ???
if($ts_tmp == '2Tbt13') $ts_tmp = 'T/2?bt#13';
		$ts_tmp = str_replace(',Tbt13', 'bt#13', $ts_tmp);	
//TODO: should be corrected
$ts_tmp = str_replace(',2Tbt13', 'bt#13', $ts_tmp);		
		$ts_tmp = str_replace('Tbt13', 'bt#13', $ts_tmp); //For line 329
		
		// Continue
		$ts_tmp = str_replace(',', '/', $ts_tmp);
		$ts_tmp = str_replace('bt#', '#', $ts_tmp);
		$storage_for_all = null;
		if(substr_count($ts_tmp, '#') == 1) { 
			preg_match('/#([0-9]+)/', $ts_tmp, $matches);	
			$storage_for_all = $matches[1] ; 
			$ts_tmp = preg_replace('/#([0-9]+)/', '', $ts_tmp);
		}
		$ts = explode('/', strtoupper($ts_tmp));

		if($ts[0] != 'T') die("<br><FONT COLOR=\"red\" >Line ".$m->line." [T]: 'T' cell content dones not start with 'T'!</FONT><br>");
		unset($ts[0]);
		if(empty($ts)) {
			// Just T
			if(sizeof($created_tissues_from_tissus_col) == 1) {
				$collections[$created_tissues_from_tissus_col[0]]['aliquots'][] = array('type' =>$aliquot_type,'storage' => null);	
			} else {
				if(!isset($collections['unknown_tissue'])) $collections['unknown_tissue'] = array('type' => 'tissue', 'details' => $m->tissueCode2Details['unknown_tissue'], 'aliquots' => array(), 'derivatives' => array());
				$collections['unknown_tissue']['aliquots'][] = array('type' =>$aliquot_type,'storage' => null);	
				if(sizeof($created_tissues_from_tissus_col) > 1) echo "<br><FONT COLOR=\"green\" >Line ".$m->line." [T]: Unable to define parent for an 'T' value equals to 'T' because there are many parent tissues defined into TISSUS. Will be linked to 'unknown_tissue'.</FONT><br>";
			}
			
		} else {
			foreach($ts as $new_source) {
				$new_source = utf8_encode($new_source);
//$new_source = str_replace('MASSEUTÉRINE', 'MASSE UTÉRINE', $new_source);
				$storage = $storage_for_all;
				if(empty($storage)) {
					preg_match('/#([0-9]+)/', $new_source, $matches);	
					if(!empty($matches)) $storage = $matches[1] ; 
					$new_source = preg_replace('/#([0-9]+)/', '', $new_source);			
				}
				preg_match('/^([0-9]+)/', $new_source, $matches);	
				$tubes_nbr = empty($matches)? '1' : $matches[1];
				$new_source = str_replace($tubes_nbr, '', $new_source);	
				if(array_key_exists($new_source, $m->tissueCodeSynonimous)) $new_source = $m->tissueCodeSynonimous[$new_source];
				
				if(array_key_exists($new_source, $collections)) {
					// Parent found
					while($tubes_nbr > 0) { 
						$collections[$new_source]['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
						$tubes_nbr--;
					}
				} else if(array_key_exists($new_source, $m->tissueCode2Details)) {
					//Create parent
					echo "<br><FONT COLOR=\"green\" >Line ".$m->line." [T]: Create parent '$new_source' for a 'T' value equal to '$new_source' because this one is not defined into 'TISSUS' column.</FONT><br>";
					$collections[$new_source] = array('type' => 'tissue', 'details' => $m->tissueCode2Details[$new_source], 'aliquots' => array(), 'derivatives' => array());
					while($tubes_nbr > 0) { 
						$collections[$new_source]['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
						$tubes_nbr--;
					}
				} else {
					die("<br><FONT COLOR=\"red\" >Line ".$m->line." [ERR][T]: Unable to define parent from a list for an 'T' value equal to '$new_source'. This tissue code is unknown.</FONT><br>");
				}
			}
		}
	} //End of T
	
	// blocs paraffenes ----------------------------------------------------------------------
	
	//*br*: 
	
	$aliquot_type = 'paraffin block';
	if(!empty($invantory_data_from_file['blocs paraffenes'])) {
		$pbs_tmp = str_replace(' ', '', $invantory_data_from_file['blocs paraffenes']);
		$pbs_tmp = str_replace(',', '/', $pbs_tmp);
//TODO: Should be corrected
$pbs_tmp = str_replace('P/333', 'P', $pbs_tmp);
//TODO: What about -1, -2, etc
$pbs_tmp = preg_replace('/-[0-9]/', '', $pbs_tmp);	

		$pbs = explode('/', strtoupper($pbs_tmp));

		if($pbs[0] != 'P') die("<br><FONT COLOR=\"red\" >Line ".$m->line." [blocs paraffenes]: blocs paraffenes cell content dones not start with 'P'!</FONT><br>");
		unset($pbs[0]);
		if(empty($pbs)) {
			// Just P
			if(sizeof($created_tissues_from_tissus_col) == 1) {
				$collections[$created_tissues_from_tissus_col[0]]['aliquots'][] = array('type' =>$aliquot_type,'storage' => null);	
			} else {
				if(!isset($collections['unknown_tissue'])) $collections['unknown_tissue'] = array('type' => 'tissue', 'details' => $m->tissueCode2Details['unknown_tissue'], 'aliquots' => array(), 'derivatives' => array());
				$collections['unknown_tissue']['aliquots'][] = array('type' =>$aliquot_type,'storage' => null);	
				if(sizeof($created_tissues_from_tissus_col) > 1) echo "<br><FONT COLOR=\"green\" >Line ".$m->line." [blocs paraffenes]: Unable to define parent for an 'blocs paraffenes' value equals to 'P' because there are many parent tissues defined into TISSUS. Will be linked to unknown_tissue.</FONT><br>";
			}
			
		} else {
			foreach($pbs as $new_source) {
				$new_source = utf8_encode($new_source);
				$storage = null;
				preg_match('/^([0-9]+)/', $new_source, $matches);	
				$tubes_nbr = empty($matches)? '1' : $matches[1];
				$new_source = str_replace($tubes_nbr, '', $new_source);	
				if(array_key_exists($new_source, $m->tissueCodeSynonimous)) $new_source = $m->tissueCodeSynonimous[$new_source];
				
				if(array_key_exists($new_source, $collections)) {
					// Parent found
					while($tubes_nbr > 0) { 
						$collections[$new_source]['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
						$tubes_nbr--;
					}
				} else if(array_key_exists($new_source, $m->tissueCode2Details)) {
					//Create parent
					echo "<br><FONT COLOR=\"green\" >Line ".$m->line." [blocs paraffenes]: Create parent '$new_source' for a 'blocs paraffenes' value equal to '$new_source' because this one does not exist into 'TISSUS' column.</FONT><br>";
					$collections[$new_source] = array('type' => 'tissue', 'details' => $m->tissueCode2Details[$new_source], 'aliquots' => array(), 'derivatives' => array());
					while($tubes_nbr > 0) { 
						$collections[$new_source]['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
						$tubes_nbr--;
					}
				} else {
					die("<br><FONT COLOR=\"red\" >Line ".$m->line." [ERR][blocs paraffenes]: Unable to define parent from a list for an 'blocs paraffenes' value equal to '$new_source'. This tissue code is unknown.</FONT><br>");
				}
			}
		}
	} //End of blocs paraffenes

	// SANG-PLASMA-SERIM- BUFFY COAT  ----------------------------------------------------------------------
	
	//*br*: 
	
	$aliquot_type = 'tube';
	if(!empty($invantory_data_from_file['SANG-PLASMA-SERIM- BUFFY COAT '])) {
		$bloods_tmp = str_replace('MD #', 'MD#', $invantory_data_from_file['SANG-PLASMA-SERIM- BUFFY COAT ']);
		$bloods_tmp = str_replace(' ', '/', $bloods_tmp);
		$bloods_tmp = str_replace('//', '/', $bloods_tmp);
		$bloods = explode('/', strtoupper($bloods_tmp));

		foreach($bloods as $new_sample) {
			if(!empty($new_sample) && (strpos($new_sample, 'BGF') === false) && (strpos($new_sample, 'MD#') === false)) {
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
						die("<br><FONT COLOR=\"red\" >Line ".$m->line." [ERR][BLOOD]: Blood sample unknown '$new_sample'. </FONT><br>");		
				}
			}
		}
	} //End of blocs SANG-PLASMA-SERIM- BUFFY COAT 
	
	// ASCITE  ----------------------------------------------------------------------
	
	//*br*: 
	
	$aliquot_type = 'tube';
	if(!empty($invantory_data_from_file['ASCITE'])) {
		$ascites_tmp = str_replace(' ', '/', $invantory_data_from_file['ASCITE']);
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
						echo "<br><FONT COLOR=\"red\" >Line ".$m->line." [WARNING][ascite]: Ascite sample S is considered as supernatant.</FONT><br>";
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
						die("<br><FONT COLOR=\"red\" >Line ".$m->line." [ERR][ascite]: Ascite sample unknown '$new_sample'. </FONT><br>");		
				}
			}
		}
	} //End of ASCITE
	
	// PC  ----------------------------------------------------------------------
	
	//*br*: Ne pas prendre ne compte les valuer 'PC'
	//*br*: Seul PC ont été définie a partir de Epiplon EP et ascite ASC
	
	$aliquot_type = 'tube';
	if(!empty($invantory_data_from_file['PC']) && ($invantory_data_from_file['PC'] != 'PC')) {
		$PCs_tmp = str_replace('PC/', '', $invantory_data_from_file['PC']);

		preg_match('/^([0-9]+)/', $PCs_tmp, $matches);	
		$tubes_nbr = empty($matches)? '1' : $matches[1];
		$new_source = str_replace($tubes_nbr, '', $PCs_tmp);			
		
		switch($new_source) {
			case 'ASC':
				if(!isset($collections['ascite'])) $collections['ascite'] = array('type' => 'ascite', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
				if(!isset($collections['ascite']['derivatives']['ascite cells'])) $collections['ascite']['derivatives']['ascite cells'] = array('type' => 'ascite cells', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
				$collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture'] = array('type' => 'cell culture', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
				while($tubes_nbr > 0) { 
					$collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture']['aliquots'][] = array('type' =>$aliquot_type,'storage' => null); 
					$tubes_nbr--;
				}
				break;
			case 'EP':	
				if(!array_key_exists($new_source, $m->tissueCode2Details)) die("<br><FONT COLOR=\"red\" >Line ".$m->line." [ERR][PC]: TISSUS code '$new_source' unknown!</FONT><br>");
				if(!isset($collections[$new_source])) $collections[$new_source] = array('type' => 'tissue', 'details' => $m->tissueCode2Details[$new_source], 'aliquots' => array(), 'derivatives' => array());
				$collections[$new_source]['derivatives']['cell culture'] = array('type' => 'cell culture', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
				while($tubes_nbr > 0) { 
					$collections[$new_source]['derivatives']['cell culture']['aliquots'][] = array('type' =>$aliquot_type,'storage' => null); 
					$tubes_nbr--;
				}
				break;
			default:
				die("<br><FONT COLOR=\"red\" >Line ".$m->line." [ERR][PC]: Source '$new_source' of the PC is not supported. </FONT><br>");
		}
	} //End of PC
	
	// VC ----------------------------------------------------------------------

	//*br*: Si une seule boite par ligne... le storage s'applique a tous sinon on associe la boite cas par cas
	//*br*: Si un tissu source n'est pas trouvé:
	//             - Si cellule tissus vide => on le créé
	
	$aliquot_type = 'tube';
	if(!empty($invantory_data_from_file['VC'])) {
		$vcs_tmp = str_replace(' ', '', $invantory_data_from_file['VC']);
		$vcs_tmp = str_replace('-bt', '#', $vcs_tmp);
		$storage_for_all = null;
		if(substr_count($vcs_tmp, '#') == 1) { 
			preg_match('/#([0-9]+\(I+\))|#([0-9]+A)|#([0-9]+)/', $vcs_tmp, $matches);
			$storage_for_all = str_replace('#', '', $matches[0]); 
			$vcs_tmp = preg_replace('/#([0-9]+\(I+\))|#([0-9]+A)|#([0-9]+)/', '', $vcs_tmp);
		}
		$vcs = explode(',', strtoupper($vcs_tmp));
		
		foreach($vcs as $new_source) {
			$new_source = utf8_encode($new_source);
			$storage = $storage_for_all;
			if(empty($storage)) {
				preg_match('/#([0-9]+\(I+\))|#([0-9]+A)|#([0-9]+)/', $new_source, $matches);	
				if(!empty($matches)) $storage = str_replace('#', '', $matches[0]); 
				$new_source = preg_replace('/#([0-9]+\(I+\))|#([0-9]+A)|#([0-9]+)/', '', $new_source);			
			}
			preg_match('/^([0-9]+)/', $new_source, $matches);	
			$tubes_nbr = empty($matches)? '1' : $matches[1];
			$new_source = str_replace($tubes_nbr, '', $new_source);	
			
			switch($new_source) {
				
				case 'ASC':
					if(!isset($collections['ascite'])) $collections['ascite'] = array('type' => 'ascite', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
					if(!isset($collections['ascite']['derivatives']['ascite cells'])) $collections['ascite']['derivatives']['ascite cells'] = array('type' => 'ascite cells', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
					if(!isset($collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture'])) $collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture'] = array('type' => 'cell culture', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
					while($tubes_nbr > 0) { 
						$collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture']['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
						$tubes_nbr--;
					}
					break;
				
				case 'OV':
				case 'OVG':
				case 'OVD':
				case 'TOVD':
				case 'EP':
				case 'EPD':
				case 'MP':
				case 'M.P':
					if(array_key_exists($new_source, $m->tissueCodeSynonimous)) $new_source = $m->tissueCodeSynonimous[$new_source];
					if(!array_key_exists($new_source, $m->tissueCode2Details)) die("<br><FONT COLOR=\"red\" >Line ".$m->line." [ERR][VC]: TISSUS code '$new_source' unknown!</FONT><br>");
					
					if(array_key_exists($new_source, $collections)) {
						// Parent found
						if(!isset($collections[$new_source]['derivatives']['cell culture'])) $collections[$new_source]['derivatives']['cell culture'] = array('type' => 'cell culture', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
						while($tubes_nbr > 0) { 
							$collections[$new_source]['derivatives']['cell culture']['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
							$tubes_nbr--;
						}
					
					} else if($new_source == 'MP' ||  $new_source == 'M.P') {
						echo "<br><FONT COLOR=\"green\" >Line ".$m->line." [VC]: Unable to define parent for an 'VC' value equals to $new_source because there is no parent tissues matching into TISSUS. Will create parent.</FONT><br>";
						$collections[$new_source] = array('type' => 'tissue', 'details' => $m->tissueCode2Details[$new_source], 'aliquots' => array(), 'derivatives' => array());
						$collections[$new_source]['derivatives']['cell culture'] = array('type' => 'cell culture', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
						while($tubes_nbr > 0) { 
							$collections[$new_source]['derivatives']['cell culture']['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
							$tubes_nbr--;
						}
												
					} else {
						if($new_source == 'OV') {
							$source_already_recorded = '';
							$matches = 0;
							foreach($collections as $key_source => $tmp) {
								if(in_array($key_source, $m->ovCodes)) {
									$source_already_recorded = $key_source;
									$matches++;
								}
							}
							if($matches == 1) {
								echo "<br><FONT COLOR=\"green\" >Line ".$m->line." [VC]: Changed the parent defintion for a 'VC' value equals to $new_source to $source_already_recorded because one ov tissue has already been created.</FONT><br>";
								$new_source = $source_already_recorded;
							} else if($matches == 0) {
								echo "<br><FONT COLOR=\"green\" >Line ".$m->line." [VC]: Unable to define parent for an 'VC' value equals to $new_source because there is no parent tissues matching into TISSUS. Will create parent.</FONT><br>";
							} else {
								echo "<br><FONT COLOR=\"red\" >Line ".$m->line." [WARNING][VC]: Unable to define parent for an 'VC' value equals to $new_source because there is too many parents that could be used. Will create a new one.</FONT><br>";
							}
							
						} else if($new_source == 'EP') {
							$source_already_recorded = '';
							$matches = 0;
							foreach($collections as $key_source => $tmp) {
								if(in_array($key_source, $m->epCodes)) {
									$source_already_recorded = $key_source;
									$matches++;
								}
							}
							if($matches == 1) {
								echo "<br><FONT COLOR=\"green\" >Line ".$m->line." [VC]: Changed the parent defintion for a 'VC' value equals to $new_source to $source_already_recorded because one ep tissue has already been created.</FONT><br>";
								$new_source = $source_already_recorded;
							} else if($matches == 0) {
								echo "<br><FONT COLOR=\"green\" >Line ".$m->line." [VC]: Unable to define parent for an 'VC' value equals to $new_source because there is no parent tissues matching into TISSUS. Will create parent.</FONT><br>";
							} else {
								echo "<br><FONT COLOR=\"red\" >Line ".$m->line." [WARNING][VC]: Unable to define parent for an 'VC' value equals to $new_source because there is too many parents that could be used. Will create a new one.</FONT><br>";
							}
							
						} else {
							echo "<br><FONT COLOR=\"red\" >Line ".$m->line." [WARNING][VC]: Unable to define parent for an 'VC' value equals to $new_source because there is no parent tissues matching into TISSUS. Will create parent.</FONT><br>";
						}
						if(!isset($collections[$new_source])) $collections[$new_source] = array('type' => 'tissue', 'details' => $m->tissueCode2Details[$new_source], 'aliquots' => array(), 'derivatives' => array());
						if(!isset($collections[$new_source]['derivatives']['cell culture'])) $collections[$new_source]['derivatives']['cell culture'] = array('type' => 'cell culture', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
						while($tubes_nbr > 0) { 
							$collections[$new_source]['derivatives']['cell culture']['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
							$tubes_nbr--;
						}
					}
					break;	
				
				default:
					die("<br><FONT COLOR=\"red\" >Line ".$m->line." [ERR][VC]: Source '$new_source' of the PC is not supported. </FONT><br>");
			}
		}	
	} //End of VC
	
	// RNA ----------------------------------------------------------------------
	
	//*br*: 
	
	$aliquot_type = 'tube';
	if(!empty($invantory_data_from_file['RNA'])) {
		$rnas_tmp = str_replace(' ', '', $invantory_data_from_file['RNA']);
		$rnas_tmp = preg_replace('/(\(tissu\))|(\(T,PC\))|(\(PC\))/', '', $rnas_tmp);
		$rnas_tmp = str_replace(',', '/', $rnas_tmp);
		$rnas = explode('/', strtoupper($rnas_tmp));

		if($rnas[0] != 'RNA') die("<br><FONT COLOR=\"red\" >Line ".$m->line." [RNA]: RNA cell content dones not start with 'RNA'!</FONT><br>");
		unset($rnas[0]);
		if(empty($rnas)) {
 			die("<br><FONT COLOR=\"red\" >Line ".$m->line." [RNA]: RNA cell content is empty!</FONT><br>");
		} else {
			foreach($rnas as $new_source) {
				$new_source = utf8_encode($new_source);
				$storage = null;
				preg_match('/^([0-9]+)/', $new_source, $matches);	
				$tubes_nbr = empty($matches)? '1' : $matches[1];
				$new_source = str_replace($tubes_nbr, '', $new_source);	
				
				if($new_source == 'ASC') {
					if(!isset($collections['ascite'])) $collections['ascite'] = array('type' => 'ascite', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
					if(!isset($collections['ascite']['derivatives']['ascite cells'])) $collections['ascite']['derivatives']['ascite cells'] = array('type' => 'ascite cells', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
					if(!isset($collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture'])) $collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture'] = array('type' => 'cell culture', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
					$collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture']['derivatives']['rna'] = array('type' => 'rna', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
					while($tubes_nbr > 0) { 
						$collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture']['derivatives']['rna'][] = array('type' =>$aliquot_type,'storage' => null); 
						$tubes_nbr--;
					}	
					
				} else {
					if(array_key_exists($new_source, $m->tissueCodeSynonimous)) $new_source = $m->tissueCodeSynonimous[$new_source];
					if(array_key_exists($new_source, $collections)) {
						if(!isset($collections[$new_source]['derivatives']['cell culture'])) $collections[$new_source]['derivatives']['cell culture'] = array('type' => 'cell culture', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
						$collections[$new_source]['derivatives']['cell culture']['derivatives']['rna'] = array('type' => 'rna', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
						while($tubes_nbr > 0) { 
							$collections[$new_source]['derivatives']['cell culture']['derivatives']['rna'][] = array('type' =>$aliquot_type,'storage' => null); 
							$tubes_nbr--;
						}
					} else if(array_key_exists($new_source, $m->tissueCode2Details)) {
						echo "<br><FONT COLOR=\"green\" >Line ".$m->line." [RNA]: Create parent '$new_source' for a 'RNA' value equal to '$new_source' because this one does not exist into 'TISSUS' column.</FONT><br>";
						if(!isset($collections[$new_source])) $collections[$new_source] = array('type' => 'tissue', 'details' => $m->tissueCode2Details[$new_source], 'aliquots' => array(), 'derivatives' => array());
						if(!isset($collections[$new_source]['derivatives']['cell culture'])) $collections[$new_source]['derivatives']['cell culture'] = array('type' => 'cell culture', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
						$collections[$new_source]['derivatives']['cell culture']['derivatives']['rna'] = array('type' => 'rna', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
						while($tubes_nbr > 0) { 
							$collections[$new_source]['derivatives']['cell culture']['derivatives']['rna']['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
							$tubes_nbr--;
						}
					} else {
						die("<br><FONT COLOR=\"red\" >Line ".$m->line." [ERR][RNA]: TISSUS code '$new_source' unknown!</FONT><br>");
					}
				}
			}
		}
	} //End of RNA
	

	
	// RNA ----------------------------------------------------------------------
	
	//*br*: 
	
	$aliquot_type = 'tube';
	if(!empty($invantory_data_from_file['DNA'])) {
		$dnas_tmp = str_replace(' ', '', $invantory_data_from_file['DNA']);
		$dnas_tmp = str_replace(',', '/', $dnas_tmp);echo "<br>^^^$dnas_tmp^^<br>";
		$dnas = explode('/', strtoupper($dnas_tmp));
print_r($dnas);
		if($dnas[0] != 'ADN' && $dnas[0] != 'DNA') die("<br><FONT COLOR=\"red\" >Line ".$m->line." [DNA]: DNA cell content dones not start with 'ADN'!</FONT><br>");
		unset($dnas[0]);
		if(empty($dnas)) {
 			die("<br><FONT COLOR=\"red\" >Line ".$m->line." [DNA]: DNA cell content is empty!</FONT><br>");
		} else {
			foreach($dnas as $new_source) {
				$new_source = utf8_encode($new_source);
				$storage = null;
				preg_match('/^([0-9]+)/', $new_source, $matches);	
				$tubes_nbr = empty($matches)? '1' : $matches[1];
				$new_source = str_replace($tubes_nbr, '', $new_source);	
				
				if($new_source == 'ASC') {
					if(!isset($collections['ascite'])) $collections['ascite'] = array('type' => 'ascite', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
					if(!isset($collections['ascite']['derivatives']['ascite cells'])) $collections['ascite']['derivatives']['ascite cells'] = array('type' => 'ascite cells', 'details' => null, 'aliquots' => array(), 'derivatives' => array());
					if(!isset($collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture'])) $collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture'] = array('type' => 'cell culture', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
					$collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture']['derivatives']['DNA'] = array('type' => 'DNA', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
					while($tubes_nbr > 0) { 
						$collections['ascite']['derivatives']['ascite cells']['derivatives']['cell culture']['derivatives']['DNA'][] = array('type' =>$aliquot_type,'storage' => null); 
						$tubes_nbr--;
					}	
					
				} else {
					if(array_key_exists($new_source, $m->tissueCodeSynonimous)) $new_source = $m->tissueCodeSynonimous[$new_source];
					if(array_key_exists($new_source, $collections)) {
						if(!isset($collections[$new_source]['derivatives']['cell culture'])) $collections[$new_source]['derivatives']['cell culture'] = array('type' => 'cell culture', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
						$collections[$new_source]['derivatives']['cell culture']['derivatives']['DNA'] = array('type' => 'DNA', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
						while($tubes_nbr > 0) { 
							$collections[$new_source]['derivatives']['cell culture']['derivatives']['DNA'][] = array('type' =>$aliquot_type,'storage' => null); 
							$tubes_nbr--;
						}
					} else if(array_key_exists($new_source, $m->tissueCode2Details)) {
						echo "<br><FONT COLOR=\"green\" >Line ".$m->line." [DNA]: Create parent '$new_source' for a 'DNA' value equal to '$new_source' because this one does not exist into 'TISSUS' column.</FONT><br>";
						if(!isset($collections[$new_source])) $collections[$new_source] = array('type' => 'tissue', 'details' => $m->tissueCode2Details[$new_source], 'aliquots' => array(), 'derivatives' => array());
						if(!isset($collections[$new_source]['derivatives']['cell culture'])) $collections[$new_source]['derivatives']['cell culture'] = array('type' => 'cell culture', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
						$collections[$new_source]['derivatives']['cell culture']['derivatives']['DNA'] = array('type' => 'DNA', 'details' => null, 'aliquots' => array(), 'derivatives' => array());		
						while($tubes_nbr > 0) { 
							$collections[$new_source]['derivatives']['cell culture']['derivatives']['DNA']['aliquots'][] = array('type' =>$aliquot_type,'storage' => $storage); 
							$tubes_nbr--;
						}
					} else {
						die("<br><FONT COLOR=\"red\" >Line ".$m->line." [ERR][DNA]: TISSUS code '$new_source' unknown!</FONT><br>");
					}
				}
			}
		}
	} //End of DNA
	
	echo "<pre>";
	print_r($collections);
}