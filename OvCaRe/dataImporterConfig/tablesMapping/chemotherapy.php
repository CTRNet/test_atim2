<?php
$pkey = "VOA Number";
$child = array();
$master_fields = array(
	"treatment_control_id" => "@5",
	"participant_id" => $pkey,
	"diagnosis_master_id" => "#diagnosis_master_id",
	"start_date" => "Date Chemo Start",
	"finish_date" => "Date Chemo End",
	"notes" => "Chemotherapy");
$detail_fields = array(
	"ovcare_neoadjuvant" => array("Neoadjuvant Chemotherapy" => array(
		"" => "",
		"y" => "y",
		"n" => "n")));
	
//see the Model class definition for more info
$model = new MasterDetailModel(0, $pkey, $child, false, "participant_id", $pkey, 'treatment_masters', $master_fields, 'txd_chemos', 'treatment_master_id', $detail_fields);

//we can then attach post read/write functions
$model->custom_data = array(
	"date_fields" => array(
		$master_fields["start_date"] => null,
		$master_fields["finish_date"] =>  null
	) 
);
$model->post_read_function = 'postChemotherapyRead';
$model->insert_condition_function = 'preChemotherapyWrite';

//adding this model to the config
Config::$models['Chemotherapy'] = $model;
	
function postChemotherapyRead(Model $m){	
	if(in_array(strtolower($m->values['Chemotherapy']), array('no','nbo','radiotherapy','unable to determine','unknown'))) $m->values['Chemotherapy'] = '';  
	$m->values['Date Chemo Start'] = str_replace('none', '', $m->values['Date Chemo Start']);
	$m->values['Date Chemo End'] = str_replace('none', '', $m->values['Date Chemo End']);
	$m->values['Neoadjuvant Chemotherapy'] = str_replace('n/a', '', $m->values['Neoadjuvant Chemotherapy']);
	
	if(empty($m->values['Chemotherapy']) && empty($m->values['Date Chemo Start']) && (empty($m->values['Date Chemo End']))) {
		$dont_import = true;
		$msg = '';
		
		if(!empty($m->values['Neoadjuvant Chemotherapy'])) {
			if($m->values['Neoadjuvant Chemotherapy'] == 'no') {
				$msg .= 'Chemo neoadjuvant value exists ['.$m->values['Neoadjuvant Chemotherapy'].'] but no chemo data is defined (start,end and chemo fields). ';
			} else {
				$msg .= 'Chemo neoadjuvant value exists ['.$m->values['Neoadjuvant Chemotherapy'].'] but no chemo data is defined (start,end and chemo fields). ';
				$dont_import = false;
			}
		}
		
		if($dont_import) {
			if(!empty($msg)) Config::$summary_msg['@@WARNING@@']['Chemo reponse/neoadjuvant #1'][] = $msg. 'No chemo will be created [VOA#: '.$m->values['VOA Number'].' / line: '.$m->line.']';
			return false;
		} else {
			if(!empty($msg)) Config::$summary_msg['@@MESSAGE@@']['Chemo reponse/neoadjuvant #2'][] = $msg. 'But chemo will be created [VOA#: '.$m->values['VOA Number'].' / line: '.$m->line.']';	
		}
	}

	excelDateFix($m);	
	
	return true;
}

function preChemotherapyWrite(Model $m){
	$m->values['Chemotherapy'] = strtolower($m->values['Chemotherapy']);
	if(!in_array($m->values['Chemotherapy'], array('yes','previous',''))) die ('ERR_CHEMO_123141414 : ['.$m->values['Chemotherapy'].']');
	if($m->values['Chemotherapy'] == 'previous') {
		$m->values['Chemotherapy'] = 'Chemotherapy defined as Previous.';
	} else {
		$m->values['Chemotherapy'] = '';
	}
	switch(strtolower($m->values['Neoadjuvant Chemotherapy'])) {
		case 'yes':
			$m->values['Neoadjuvant Chemotherapy'] = 'y';
			break;
		case 'no':
			$m->values['Neoadjuvant Chemotherapy'] = 'n';
			break;
		case 'yes but only 1 cycle':
			$m->values['Neoadjuvant Chemotherapy'] = 'y';
			$m->values['Chemotherapy'] .= (empty($m->values['Chemotherapy'])? '' : ' ').'Neoadjuvant chemotherapy only 1 cycle';
			break;
		default:
			$m->values['Neoadjuvant Chemotherapy'] = '';
	}

	$m->values['diagnosis_master_id'] = Config::$record_ids_from_voa[Config::$current_voa_nbr]['ovcare_diagnosis_id'];
	
	return true;	
}


