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
	'AND' => array('code' => 'UNK', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
	'AS' => array('code' => 'UNK', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
	'AU' => array('code' => 'UNK', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
	'ENDOMÈTRE' => array('code' => 'UNK', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
	'ENDO.' => array('code' => 'UNK', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
	'EP' => array('code' => 'EP', 'source' => 'epiplon', 'laterality' => '', 'type' => ''),
	'IMP' => array('code' => 'UNK', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
	'IMP.G.' => array('code' => 'UNK', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
	'IMPG' => array('code' => 'UNK', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
	'IMP.PEL.' => array('code' => 'UNK', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
	'IP' => array('code' => 'IP', 'source' => '', 'laterality' => '', 'type' => ''),
	'KYSTE' => array('code' => 'UNK', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
	'MASSE ABDOMINAL' => array('code' => 'UNK', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
	'MP' => array('code' => 'MP', 'source' => 'pelvic mass', 'laterality' => '', 'type' => ''),
	'NC' => array('code' => 'UNK', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
	'NEP' => array('code' => 'UNK', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
	'NM' => array('code' => 'UNK', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
	'NODUL' => array('code' => 'UNK', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
	'NODULE PELVIEN' => array('code' => 'UNK', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
	'NP' => array('code' => 'UNK', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
	'NOVD' => array('code' => 'NOVD', 'source' => 'ovary', 'laterality' => 'right', 'type' => 'normal'),
	'NOVG' => array('code' => 'NOVG', 'source' => 'ovary', 'laterality' => 'left', 'type' => 'normal'),
	'OV' => array('code' => 'OV', 'source' => 'ovary', 'laterality' => 'unknown', 'type' => 'unknown'),
	'OVD' => array('code' => 'OVD', 'source' => 'ovary', 'laterality' => 'right', 'type' => 'unknown'),
	'OVG' => array('code' => 'OVG', 'source' => 'ovary', 'laterality' => 'left', 'type' => 'unknown'),
	'OVDN' => array('code' => 'NOVD', 'source' => 'ovary', 'laterality' => 'right', 'type' => 'normal'),
	'OVGN' => array('code' => 'NOVG', 'source' => 'ovary', 'laterality' => 'left', 'type' => 'normal'),
	'BOVD' => array('code' => 'BOVD', 'source' => 'ovary', 'laterality' => 'right', 'type' => 'benin'),
	'BOVG' => array('code' => 'BOVG', 'source' => 'ovary', 'laterality' => 'left', 'type' => 'benin'),
	'TOVG' => array('code' => 'TOVG', 'source' => 'ovary', 'laterality' => 'left', 'type' => 'malin'),
	'KOVD' => array('code' => 'KOVD', 'source' => 'ovary', 'laterality' => 'right', 'type' => 'benin'),
	'KOVG' => array('code' => 'KOVG', 'source' => 'ovary', 'laterality' => 'left', 'type' => 'benin'),
	'TCS' => array('code' => 'UNK', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
	'UT' => array('code' => 'UT', 'source' => 'uterus', 'laterality' => '', 'type' => ''),
	'NOD' => array('code' => 'UNK', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
	'ND' => array('code' => 'UNK', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
	'MPG' => array('code' => 'UNK', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
	'TR' => array('code' => 'UNK', 'source' => 'unknown', 'laterality' => '', 'type' => ''),
	'PO' => array('code' => 'UNK', 'source' => 'unknown', 'laterality' => '', 'type' => ''));

$model->tissueCodeSynonimous = array(
	'O' => 'OV',
	'UTÉRUS' => 'UT',
	'OD' => 'OVD',
	'D' => 'OVD',
	'E' => 'EP',
	'ED' => 'EP',
	'OG' => 'OVG',
	'NODULES' => 'NODUL',
	'M.P' => 'MP',
	'MASS PELVIENNE' => 'MP',
	'MASSE PEL.' => 'MP',
	'MASSE PELVIEN' => 'MP',
	'MASSE PELVIENE' => 'MP',
	'MASSE PELVIENNE' => 'MP',
	'PELVIEN' => 'MP',
	'IMPLANT PERTONEL' => 'IP',
	'IMPLANTS PERITON.' => 'IP',
	'EPN' => 'EP',
	'MASSE UTÉRINE BÉNIN' => 'UT',
	'MASSE UTÉRINE' => 'UT',
	'SIGMOIDE' => 'unknown_tissue',
	'MAP' => 'unknown_tissue',
	'M.BUT' => 'unknown_tissue',
	'AN.UT' => 'unknown_tissue',
	'ASC' => 'unknown_tissue',
	'M.ABDOM' => 'unknown_tissue',
	'IMPL.PERIT' => 'unknown_tissue',
	'PRIM.OV.' => 'unknown_tissue',
	'KYSTETROMPE' => 'unknown_tissue',
	'IMP.PERIT' => 'unknown_tissue',
	'IMP.PERIT.' => 'unknown_tissue',
	'ENDO.BT' => 'unknown_tissue');

$model->tissueCode2Details['unknown_tissue'] = array('code' => 'UNK', 'source' => 'unknown', 'laterality' => '', 'type' => '');
$model->tissueCodeSynonimous['?'] = 'unknown_tissue';

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
		$tissues = explode('/', strtoupper($invantory_data_from_file['TISSUS']));
		foreach($tissues as $new_tissue) {
			if(!empty($new_tissue)) {
				$new_tissue = utf8_encode($new_tissue);
				if(array_key_exists($new_tissue, $m->tissueCodeSynonimous)) $new_tissue = $m->tissueCodeSynonimous[$new_tissue];
				if(array_key_exists($new_tissue, $m->tissueCode2Details)) {
					$collections[$new_tissue] = array('type' => 'tissue', 'details' => $m->tissueCode2Details[$new_tissue], 'aliquots' => array(), 'derivatives' => array());
				}else {
					die("<br><FONT COLOR=\"red\" >Line ".$m->line." [ERR][TISSUS]: TISSUS code '$new_tissue' unsupported!</FONT><br>");
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
		if($octs[0] != 'OCT') die("<br><FONT COLOR=\"red\" >Line ".$m->line." [OCT]: OCT value dones not start with OCT!</FONT><br>");
		unset($octs[0]);
		if(empty($octs)) {
			// Just OCT
			if(sizeof($created_tissues_from_tissus_col) == 1) {
				$collections[$created_tissues_from_tissus_col[0]]['aliquots'][] = array('type' =>$aliquot_type,'storage' => null);	
			} else {
				if(!isset($collections['unknown_tissue'])) $collections['unknown_tissue'] = array('type' => 'tissue', 'details' => $m->tissueCode2Details['unknown_tissue'], 'aliquots' => array(), 'derivatives' => array());
				$collections['unknown_tissue']['aliquots'][] = array('type' =>$aliquot_type,'storage' => null);	
				if(sizeof($created_tissues_from_tissus_col) > 1) echo "<br><FONT COLOR=\"green\" >Line ".$m->line." [OCT]: Unable to define parent for an 'OCT' value equals to 'OCT' because there are many parent tissues defined into TISSUS. Will be linked to unknown_tissue</FONT><br>";
			}
			
		} else {
			foreach($octs as $new_source) {
				$new_source = utf8_encode($new_source);
				$new_source = str_replace('MASSEUTÉRINE', 'MASSE UTÉRINE', $new_source);
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
					echo "<br><FONT COLOR=\"green\" >Line ".$m->line." [OCT]: Create parent (not defined into TISSU) for an 'OCT' value equal to '$new_source'.</FONT><br>";
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
	
	//*br*: Similaire a OCT excepté pour les TBt

	$aliquot_type = 'frozen tube';
	if(!empty($invantory_data_from_file['T'])) {
		// Manage TBt13
		$ts_tmp = $invantory_data_from_file['T'];
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

		if($ts[0] != 'T') die("<br><FONT COLOR=\"red\" >Line ".$m->line." [T]: T value dones not start with 'T'!</FONT><br>");
		unset($ts[0]);
		if(empty($ts)) {
			// Just T
			if(sizeof($created_tissues_from_tissus_col) == 1) {
				$collections[$created_tissues_from_tissus_col[0]]['aliquots'][] = array('type' =>$aliquot_type,'storage' => null);	
			} else {
				if(!isset($collections['unknown_tissue'])) $collections['unknown_tissue'] = array('type' => 'tissue', 'details' => $m->tissueCode2Details['unknown_tissue'], 'aliquots' => array(), 'derivatives' => array());
				$collections['unknown_tissue']['aliquots'][] = array('type' =>$aliquot_type,'storage' => null);	
				if(sizeof($created_tissues_from_tissus_col) > 1) echo "<br><FONT COLOR=\"green\" >Line ".$m->line." [T]: Unable to define parent for an 'T' value equals to 'T' because there are many parent tissues defined into TISSUS. Will be linked to unknown_tissue</FONT><br>";
			}
			
		} else {
			foreach($ts as $new_source) {
				$new_source = utf8_encode($new_source);
				$new_source = str_replace('MASSEUTÉRINE', 'MASSE UTÉRINE', $new_source);
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
					echo "<br><FONT COLOR=\"green\" >Line ".$m->line." [T]: Create parent (not defined into TISSU) for a 'T' value equal to '$new_source'.</FONT><br>";
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
	

	echo "<pre>";
	print_r($collections);
}