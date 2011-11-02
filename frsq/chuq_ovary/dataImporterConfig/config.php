<?php

class Config{
	const	INPUT_TYPE_CSV = 1;
	const	INPUT_TYPE_XLS = 2;
	
	//Configure as needed-------------------
	//db config
	static $db_ip			= "127.0.0.1";
	static $db_port 		= "3306";
	static $db_user 		= "root";
	static $db_pwd			= "";
	static $db_schema		= "chuq_ovary";
	static $db_charset		= "utf8";
	static $db_created_id	= 1;//the user id to use in created_by/modified_by fields
	
	static $timezone		= "America/Montreal";
	
	static $input_type		= Config::INPUT_TYPE_XLS;
	
	//if reading excel file
	static $xls_file_path	= "C:/NicolasLucDir/LocalServer/ATiM/chuq_ovary/data/fall_version/BanqueBachvarov_work_file_20111026.xls";

	static $xls_header_rows = 1;
	
	static $print_queries	= false;//wheter to output the dataImporter generated queries
	static $insert_revs		= true;//wheter to insert generated queries data in revs as well

	static $addon_function_start= 'addonFunctionStart';//function to run at the end of the import process
	static $addon_function_end	= 'addonFunctionEnd';//function to run at the start of the import process
	
	//--------------------------------------

	static $db_connection	= null;
	
	static $addon_queries_end	= array();//queries to run at the start of the import process
	static $addon_queries_start	= array();//queries to run at the end of the import process
	
	static $parent_models	= array();//models to read as parent
	
	static $models			= array();
	
	static $value_domains	= array();
	
	static $config_files	= array();
	
	//--------------------------------------

	static $sample_aliquot_controls = array();
	static $blood_boxes_data = array();
	static $tissueCode2Details = array();
	static $tissueCodeSynonimous = array();
	static $ovCodes = array();
	static $bloodBoxesData = array();
	static $storages = array();	
	
	static $summary_msg = array(
		'NS without consent' => array(), 
		'NS without NO DOS' => array(), 
		'NS without NO PATHO' => array(), 
		'@@ERROR@@' => array(),  
		'@@WARNING@@' => array(),  
		'@@MESSAGE@@' => array());	
	
}

//add you start queries here
//Config::$addon_queries_start[] = "..."

//add your end queries here
//Config::$addon_queries_end[] = "..."

//add some value domains names that you want to use in post read/write functions
//Config::$value_domains['health_status']= new ValueDomain("health_status", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE);

//add the parent models here
Config::$parent_models[] = "Participant";

//add your configs
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/chuq_ovary/dataImporterConfig/tablesMapping/participants.php'; 
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/chuq_ovary/dataImporterConfig/tablesMapping/dos_identifiers.php'; 
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/chuq_ovary/dataImporterConfig/tablesMapping/patho_identifiers.php'; 
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/chuq_ovary/dataImporterConfig/tablesMapping/mdeie_identifiers.php';
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/chuq_ovary/dataImporterConfig/tablesMapping/consents.php'; 
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/chuq_ovary/dataImporterConfig/tablesMapping/diagnoses.php'; 

function addonFunctionStart(){
	
	setStaticDataForCollection();
	
	echo "<br><FONT COLOR=\"red\" >
	=====================================================================<br>
	addonFunctionStart: TODO
	<br>=====================================================================
	</FONT><br>";
	
	echo "<br>** 1 ** Clen up file with user<br>";
	
	echo "<br>** 2  ** Validate tissueCode2Details<br>";
	foreach(Config::$tissueCode2Details as $code => $details) {
		echo " -- <b>$code</b> => source  = '<b>".$details['source']."</b>' / laterality = '<b>".$details['laterality']."</b>' / type  = '<b>".$details['type']."</b>'<br>";
	}
	
	echo "<br>** 3 ** Validate tissueCodeSynonimous<br>";
	foreach(Config::$tissueCodeSynonimous as $code => $details) {
		echo " -- file code [$code] = [$details]<br>";
	}
	
	echo "<br><FONT COLOR=\"red\" ><br>=====================================================================
	</FONT><br>";	
	flush();

}

function addonFunctionEnd(){
	global $connection;
	$query = "DELETE FROM misc_identifiers WHERE identifier_value LIKE ''"; 
	mysqli_query($connection, $query) or die("misc_identifiers clean up failed [".$query."] ".mysqli_error($connection));
	$query = "DELETE FROM misc_identifiers_revs WHERE identifier_value LIKE ''"; 
	mysqli_query($connection, $query) or die("misc_identifiers clean up failed [".$query."] ".mysqli_error($connection));
	
	$query = "UPDATE aliquot_masters SET barcode= id";
	mysqli_query($connection, $query) or die("aliquot barcode record [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	
	echo "<br><FONT COLOR=\"red\" >
	=====================================================================<br>
	addonFunctionEnd: CCL
	<br>=====================================================================
	</FONT><br>";
	
	if(!empty(Config::$summary_msg['@@ERROR@@'])) {
		echo "<br><FONT COLOR=\"red\" >Errors summary (".sizeof(Config::$summary_msg['@@ERROR@@'])."):</FONT><br>";
		foreach(Config::$summary_msg['@@ERROR@@'] as $msg) {
			echo "$msg<br>";
		}
	}	
	
	if(!empty(Config::$summary_msg['@@WARNING@@'])) {
		echo "<br><FONT COLOR=\"red\" >Warnings summary (".sizeof(Config::$summary_msg['@@WARNING@@'])."):</FONT><br>";
		foreach(Config::$summary_msg['@@WARNING@@'] as $msg) {
			echo "$msg<br>";
		}
	}
		
	if(!empty(Config::$summary_msg['NS without consent'])) {
		echo "<br><FONT COLOR=\"red\" >Following NS have no consent data (created obtained consent by default):</FONT><br>";
		echo implode(" ,",Config::$summary_msg['NS without consent'])."<br>";
	}
	
	if(!empty(Config::$summary_msg['NS without NO DOS'])) {
		echo "<br><FONT COLOR=\"red\" >Following NS have no NO DOS:</FONT><br>";
		echo implode(" ,",Config::$summary_msg['NS without NO DOS'])."<br>";
	}
	
	if(!empty(Config::$summary_msg['NS without NO PATHO'])) {
		echo "<br><FONT COLOR=\"red\" >Following NS have no NO PATHO:</FONT><br>";
		echo implode(" ,",Config::$summary_msg['NS without NO PATHO'])."<br>";
	}
	
	if(!empty(Config::$bloodBoxesData)) {
		echo "<br><FONT COLOR=\"red\" >Following NS are just listed into the blood box worksheet:</FONT><br>";
		echo implode(" ,",array_keys(Config::$bloodBoxesData))."<br>";
	}
	
	echo "<br>";
	
	completeInventoryRevsTable();	
}

//=========================================================================================================
// Additional functions
//=========================================================================================================

function setStaticDataForCollection() {
	global $connection;
	
	// Load tissues types defintion
	Config::$tissueCode2Details = array(
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
	foreach(Config::$tissueCode2Details as $key => $detail) { Config::$tissueCode2Details[$key]['code'] = $key; }
	
	Config::$tissueCodeSynonimous = array(
		'E' => 'EP',
		'EPPD' => 'EPD', 
		'EPN' => 'NEP',
	
		'?' => 'AP',
		'A' => 'AP',
		'AS' => 'AP',
		
		'O' => 'OV',
		'MT' => 'OV',
		'ANXG' => 'OVG',
		'OD' => 'OVD',
		'OVGT' => 'TOVG',
		'OVVD' => 'OVD',
		'KYSTE' => 'KOV',
		'OVDN' => 'NOVD',
		'OVGN' => 'NOVG',
		'OVDT' => 'TOVD',
		'OVGT' => 'TOVG',
		'OG' => 'OVG',
		'VG' => 'OVG',
		'VOG' => 'OVG',
		
		'M.P' => 'MP');

	Config::$ovCodes = array();
	foreach(Config::$tissueCode2Details as $code => $data) {
		if($data['source'] == 'ovary') Config::$ovCodes[] = $code;
	}
	
	// Load blood boxes
	Config::$bloodBoxesData = getBloodBoxesDataFromFile();
	
	// Set storages
	Config::$storages = array('storages' => array(), 'next_left' => 1);
	
	// Set sample aliquot controls
	$query = "select id,sample_type,detail_tablename from sample_controls where sample_type in ('tissue','blood', 'ascite', 'peritoneal wash', 'ascite cell', 'ascite supernatant', 'cell culture', 'serum', 'plasma', 'dna', 'rna', 'blood cell')";
	$results = mysqli_query($connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$sample_aliquot_controls[$row['sample_type']] = array('sample_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename'], 'aliquots' => array());
	}	
	if(sizeof(Config::$sample_aliquot_controls) != 12) die("get sample controls failed");
	
	foreach(Config::$sample_aliquot_controls as $sample_type => $data) {
		$query = "select id,aliquot_type,detail_tablename,volume_unit from aliquot_controls where flag_active = '1' AND sample_control_id = '".$data['sample_control_id']."'";
		$results = mysqli_query($connection, $query) or die(__FUNCTION__." ".__LINE__);
		while($row = $results->fetch_assoc()){
			Config::$sample_aliquot_controls[$sample_type]['aliquots'][$row['aliquot_type']] = array('aliquot_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename'], 'volume_unit' => $row['volume_unit']);
		}	
	}
}

function getBloodBoxesDataFromFile() {
	$boxes_data = array();
	
	$xls_reader_boxes = new Spreadsheet_Excel_Reader();
	$xls_reader_boxes->read( Config::$xls_file_path);
	
	$sheets_nbr = array();
	foreach($xls_reader_boxes->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;

	if(!array_key_exists('BLOOD_BOXES', $sheets_nbr)) die("ERROR: Worksheet BLOOD_BOXES is missing!\n");

	$headers = array('1' => 'NS',
		'2' => 'SANG',
		'3' => 'BOX SANG',
		'4' => 'DERIVE1',
		'5' => 'BOX DERIVE1',
		'6' => 'DERIVE2',
		'7' => 'BOX DERIVE2');
	
	$line_counter = 0;
	foreach($xls_reader_boxes->sheets[$sheets_nbr['BLOOD_BOXES']]['cells'] as $line => $new_line) {
		$line_counter++;
		
		if($line_counter == 1) {
			$check = array_diff_assoc($headers, $new_line);
			if(!empty($check)) die("ERROR: Wrong headers in worksheet BLOOD_BOXES!\n");
		
		} else {
			$ns = $new_line['1'];
			if(!empty($ns)) {
				if(array_key_exists($ns, $boxes_data)) die("ERROR: NS recorded twice into the worksheet BLOOD_BOXES!");
				$tmp_box = array();
				
				parseAndAddBoxData((isset($new_line['2'])? $new_line['2'] : null), (isset($new_line['3'])? $new_line['3'] : null), $tmp_box, $line_counter);
				parseAndAddBoxData((isset($new_line['4'])? $new_line['4'] : null), (isset($new_line['5'])? $new_line['5'] : null), $tmp_box, $line_counter);
				parseAndAddBoxData((isset($new_line['6'])? $new_line['6'] : null), (isset($new_line['7'])? $new_line['7'] : null), $tmp_box, $line_counter);
				
				$boxes_data[$ns] = $tmp_box;
			}
		}
	}

	return $boxes_data;	
}	

function parseAndAddBoxData($content, $box, &$boxes_data, $line_counter) {				
	if(!empty($content) && !empty($box)) {
		// *1* Get box
		$box_code = '';
		preg_match('/^BT#([0-9A-Z]+)$/',  strtoupper($box), $matches);
		if(isset($matches[1])) $box_code = $matches[1];
		if(empty($box_code)) {
			echo("WARNING: Wrong box value [$box] at line $line_counter (worksheet BLOOD_BOXES)!\n");

		} else {
			// *2* Get content
			$contents = explode('/', $content);
			foreach($contents as $new_product) {
				// Get nbr of tubes
				$nbr_tubes = 1;
				preg_match('/^([0-9]+)/',  strtoupper($new_product), $matches);
				if(isset($matches[1])) {
					$nbr_tubes = $matches[1];
					$new_product = str_replace($nbr_tubes,'', $new_product);
				}
				
				// *3* Record
				if(!in_array($new_product, array('Sang', 'P', 'CE', 'S', 'RL', 'ARLT'))) {
					echo("WARNING: Wrong blood product type [$new_product] at line $line_counter (worksheet BLOOD_BOXES)!\n");
				} else {	
					while($nbr_tubes) {
						$boxes_data[$new_product][] = array('box' => $box_code);
						$nbr_tubes--;
					}
				}	
			}
		}
	} else if(!empty($content) || !empty($box)) {	
		echo("WARNING: Data not complete at line $line_counter (worksheet BLOOD_BOXES)!\n");
	}
}

function completeInventoryRevsTable() {
	
	global $connection;
	
	if(Config::$insert_revs){
		$revs_tables = array(
			'clinical_collection_links',	
			'collections',	
	
			'sample_masters',
			'specimen_details',
			'derivative_details',
			'sd_der_ascite_cells',
			'sd_der_ascite_sups',
			'sd_der_blood_cells',
			'sd_der_cell_cultures',
			'sd_der_dnas',
			'sd_der_rnas',
			'sd_spe_ascites',
			'sd_der_serums',
			'sd_der_plasmas',
			'sd_spe_bloods',
			'sd_spe_peritoneal_washes',
			'sd_spe_tissues',
			
			'aliquot_masters',
			'ad_blocks',
			'ad_tubes',
			
			'storage_masters',
			'std_boxs');		
		
		foreach ($revs_tables as $table_name) {
			$query = '';
			switch($table_name) {
				case 'clinical_collection_links':
					$query = "INSERT INTO ".$table_name."_revs (id, collection_id, participant_id, version_created) "
						."SELECT id, collection_id, participant_id, NOW() FROM ".$table_name;
					break;		
					
				case 'collections':	
					$query = "INSERT INTO ".$table_name."_revs (id, acquisition_label, bank_id, collection_notes, collection_property, version_created) "
						."SELECT id, acquisition_label, bank_id, collection_notes, collection_property, NOW() FROM ".$table_name;
					break;
					
				case 'sample_masters':
					$query = "INSERT INTO ".$table_name."_revs (id, sample_code, sample_control_id, initial_specimen_sample_id, initial_specimen_sample_type, collection_id, parent_id, version_created) "
						."SELECT id, sample_code, sample_control_id, initial_specimen_sample_id, initial_specimen_sample_type, collection_id, parent_id, NOW() FROM ".$table_name;
					break;					
					
					
				case 'specimen_details':
				case 'derivative_details':

				case 'sd_der_ascite_cells':
				case 'sd_der_ascite_sups':
				case 'sd_der_blood_cells':
				case 'sd_der_cell_cultures':
				case 'sd_der_dnas':
				case 'sd_der_rnas':
				case 'sd_spe_ascites':
				case 'sd_der_serums':
				case 'sd_der_plasmas':
				case 'sd_spe_bloods':
				case 'sd_spe_peritoneal_washes':
				
					$query = "INSERT INTO ".$table_name."_revs (id, sample_master_id, version_created) "
						."SELECT id, sample_master_id, NOW() FROM ".$table_name;
					break;	
				
					
				case 'sd_spe_tissues':
				
					$query = "INSERT INTO ".$table_name."_revs (id, sample_master_id, chuq_tissue_code, tissue_nature, tissue_source, tissue_laterality, version_created) "
						."SELECT id, sample_master_id, chuq_tissue_code, tissue_nature, tissue_source, tissue_laterality, NOW() FROM ".$table_name;
					break;	

				case 'aliquot_masters':		
					$query = "INSERT INTO ".$table_name."_revs (id, sample_master_id, aliquot_control_id, in_stock, collection_id, aliquot_label, storage_master_id, version_created) "
						."SELECT id, sample_master_id, aliquot_control_id, in_stock, collection_id, aliquot_label, storage_master_id, NOW() FROM ".$table_name;
					break;	

				case 'ad_blocks':
					$query = "INSERT INTO ".$table_name."_revs (id, aliquot_master_id, block_type, version_created) "
						."SELECT id, aliquot_master_id, block_type, NOW() FROM ".$table_name;
					break;	
			
				case 'ad_tubes':
					$query = "INSERT INTO ".$table_name."_revs (id, aliquot_master_id, chuq_blood_solution, chuq_blood_cell_stored_into_rlt, version_created) "
						."SELECT id, aliquot_master_id, chuq_blood_solution, chuq_blood_cell_stored_into_rlt, NOW() FROM ".$table_name;
					break;	
			
				case 'storage_masters':
					$query = "INSERT INTO ".$table_name."_revs (id, code, storage_control_id, rght, lft, selection_label, short_label, version_created) "
						."SELECT id, code, storage_control_id, rght, lft, selection_label, short_label, NOW() FROM ".$table_name;
					break;					
				case 'std_boxs':	
					$query = "INSERT INTO ".$table_name."_revs (id, storage_master_id, version_created) "
						."SELECT id, storage_master_id, NOW() FROM ".$table_name;
					break;				
				
				default:
					die("ERR 007 : ".$table_name);	
			}
			mysqli_query($connection, $query) or die("inventroy revs table completion [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));		
		}	
	}
}





?>
