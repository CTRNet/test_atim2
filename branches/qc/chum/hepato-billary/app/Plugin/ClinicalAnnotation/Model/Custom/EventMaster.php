<?php
class EventMasterCustom extends EventMaster{
	var $useTable = 'event_masters';
	var $name = 'EventMaster';
	
	function addBmiValue( $event_data ) {
		if((isset($event_data['EventDetail']['weight']))
		&& (isset($event_data['EventDetail']['height']))) {
			$event_data['EventDetail']['bmi'] = '';
			// Format 'numeric' value
			$event_data['EventDetail']['weight'] = str_replace(',', '.', $event_data['EventDetail']['weight']);
			$event_data['EventDetail']['height'] = str_replace(',', '.', $event_data['EventDetail']['height']);
			$weight = $event_data['EventDetail']['weight'];
			$height = $event_data['EventDetail']['height'];
			if(is_numeric($weight) && is_numeric($height) && (!empty($height))) {
				$event_data['EventDetail']['bmi'] =  ($weight/($height*$height)) * 10000;
			}
		}
		return $event_data;
	}
	
	function setHospitalizationDuration( $event_data ) {
		if(isset($event_data['EventDetail']['hospitalization_end_date'])
		&& isset($event_data['EventMaster']['event_date'])) {
			$start_date = $event_data['EventMaster']['event_date'];
			$start_date_accuracy = isset($event_data['EventMaster']['event_date_accuracy'])? $event_data['EventMaster']['event_date_accuracy']: null;
			$end_date =  $event_data['EventDetail']['hospitalization_end_date'];
			$end_date_accuracy = isset($event_data['EventDetail']['hospitalization_end_date_accuracy'])? $event_data['EventDetail']['hospitalization_end_date_accuracy']: null;
			$event_data['EventDetail']['hospitalization_duration_in_days'] = $this->getDuration($start_date, $end_date, 'hospitalization duration in days', $start_date_accuracy, $end_date_accuracy);
		}
		return $event_data;
	}
	
	function setIntensiveCareDuration( $event_data ) {
		if(isset($event_data['EventDetail']['intensive_care_end_date'])
		&& isset($event_data['EventMaster']['event_date'])) {
			$start_date = $event_data['EventMaster']['event_date'];
			$start_date_accuracy = isset($event_data['EventMaster']['event_date_accuracy'])? $event_data['EventMaster']['event_date_accuracy']: null;
			$end_date =  $event_data['EventDetail']['intensive_care_end_date'];
			$end_date_accuracy = isset($event_data['EventDetail']['intensive_care_end_date_accuracy'])? $event_data['EventDetail']['intensive_care_end_date_accuracy']: null;
			$event_data['EventDetail']['intensive_care_duration_in_days'] = $this->getDuration($start_date,$end_date, 'intensive care duration in days', $start_date_accuracy, $end_date_accuracy);
		}
		return $event_data;
	}
	
	
	function getDuration($start_date, $end_date, $field_label, $start_date_accuracy = null, $end_date_accuracy = null) {
		if(!is_array($start_date)) {
			if($start_date_accuracy != 'c') {
				$start_date = array('year'=> null, 'month'=> null, 'day'=>null);
			} else {
				if(!preg_match('/^([0-9]{4})-([0-9]{2})\-([0-9]{2})$/', $start_date, $matches)) AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				$start_date = array('year'=> $matches[1], 'month'=> $matches[2], 'day'=>$matches[3]);
			}		
		}
		if(!is_array($end_date)) {
			if($end_date_accuracy != 'c') {
				$end_date = array('year'=> null, 'month'=> null, 'day'=>null);
			} else {
				if(!preg_match('/^([0-9]{4})-([0-9]{2})\-([0-9]{2})$/', $end_date, $matches)) AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				$end_date = array('year'=> $matches[1], 'month'=> $matches[2], 'day'=>$matches[3]);
			}
		}
		if(empty($start_date['month']) || empty($start_date['day']) || empty($start_date['year']) || empty($end_date['month']) || empty($end_date['day']) || empty($end_date['year'])){
			// At least one date is missing to continue
			AppController::addWarningMsg(str_replace('%field%', __($field_label,true), __('the dates accuracy is not sufficient: the field [%%field%%] can not be generated', true)));
		} else {
			$start = $start_date['year'].'-'.$start_date['month'].'-'.$start_date['day'];
			$end = $end_date['year'].'-'.$end_date['month'].'-'.$end_date['day'];
			$StartDateObj = new DateTime($start);
			$EndDateObj = new DateTime($end);
			$interval = $StartDateObj->diff($EndDateObj);
			if($interval->invert) {
				AppController::addWarningMsg(str_replace('%field%', __($field_label,true), __('error in the dates definitions: the field [%%field%%] can not be generated', true)));
			} else {
				return $interval->format('%a');
			}
		}
		return '';
	}

	/**
	 * Set participant surgeries list for hepatobiliary-lab-biology.
	 *
	 * @param $event_control Event control of the created/studied event.
	 * @param $particpant_id
	 */
	
	function getParticipantSurgeriesList( $event_control, $participant_id = null ) {
		if($event_control['EventControl']['event_group'].'-'.$event_control['EventControl']['event_type'] == 'lab-biology') {
			$treatment_model = AppModel::getInstance('ClinicalAnnotation', 'TreatmentMaster', true);
			$result = array(''=>'');
			$criteria = array("TreatmentControl.tx_method" => 'surgery');
			if(!is_null($participant_id)) $criteria['TreatmentMaster.participant_id'] = $participant_id;
			foreach($treatment_model->find('all', array('conditions'=>$criteria, 'order' => 'TreatmentMaster.start_date DESC')) as $new_surgery) {
				$result[$new_surgery['TreatmentMaster']['id']] = __($new_surgery['TreatmentControl']['disease_site'], true) . ' - ' . __($new_surgery['TreatmentControl']['tx_method'], true) . ' ' . $new_surgery['TreatmentMaster']['start_date'];
			}			
			return $result;
		}
		return null;
	}

	function completeVolumetry( $event_data, &$submitted_data_validates) {
		if(isset($event_data['EventDetail']['is_volumetry_post_pve'])) {
			$remnant_liver_volume = '';
			$remnant_liver_percentage = '';
			if(isset($event_data['EventDetail']['total_liver_volume']) && is_numeric($event_data['EventDetail']['total_liver_volume'])
			&& isset($event_data['EventDetail']['resected_liver_volume']) && is_numeric($event_data['EventDetail']['resected_liver_volume'])) {
				// Remanant liver volume (= total liver volume - resected liver volume)
				$remnant_liver_volume = $event_data['EventDetail']['total_liver_volume'] - $event_data['EventDetail']['resected_liver_volume'];
				if($remnant_liver_volume < 0) {
					$this->validationErrors['total_liver_volume'][] = __('resected volume bigger than liver volume');
					$remnant_liver_volume = '';
					$submitted_data_validates = false;
				}
			}
			if($remnant_liver_volume != ''
			&& isset($event_data['EventDetail']['total_liver_volume']) && is_numeric($event_data['EventDetail']['total_liver_volume'])
			&& isset($event_data['EventDetail']['tumoral_volume']) && is_numeric($event_data['EventDetail']['tumoral_volume'])) {
				// Remanant liver percentage (= (remnant liver volume / (total_liver_volume - tumoral_volume)) * 100 ))
				$diff = $event_data['EventDetail']['total_liver_volume'] - $event_data['EventDetail']['tumoral_volume'];
				if($diff < 0) {
					$this->validationErrors['tumoral_volume'][] = __('tumoral volume bigger than liver volume');
					$submitted_data_validates = false;
				} else if(!empty($diff)) {
					$remnant_liver_percentage = ($remnant_liver_volume / $diff) * 100;
				}
			}
			$event_data['EventDetail']['remnant_liver_volume'] = $remnant_liver_volume;
			$event_data['EventDetail']['remnant_liver_percentage'] = $remnant_liver_percentage;		
		}
		return $event_data;
	}
	
	function setScores($event_control_event_type, $event_data, &$submitted_data_validates){	
		if($event_control_event_type == "child pugh score (classic)" || $event_control_event_type == "child pugh score (mod)"){
			return $this->setChildPughScore($event_data);
		}else if($event_control_event_type == "okuda score"){
			return $this->setOkudaScore($event_data);
		}else if($event_control_event_type == "barcelona score"){
			return $this->setBarcelonaScore($event_data);
		}else if($event_control_event_type == "clip score"){
			return $this->setClipScore($event_data);
		}else if($event_control_event_type == "fong score"){
			return $this->setFongScore($event_data);
		}else if($event_control_event_type == "gretch score"){
			return $this->setGretchScore($event_data);
		}else if($event_control_event_type == "meld score"){
			return $this->setMeldScore($event_data, $submitted_data_validates);
		}else if($event_control_event_type == "charlson score"){
			return $this->setCharlsonScore($event_data, $submitted_data_validates);
		}
		return $event_data;
	}
	
	function setChildPughScore($event_data){
		$score = 0;
		$set_score = true;
	
		if($event_data['EventDetail']['bilirubin'] == "<34µmol/l" || $event_data['EventDetail']['bilirubin'] == "<68µmol/l"){
			++ $score;
		}else if($event_data['EventDetail']['bilirubin'] == "34 - 50µmol/l" || $event_data['EventDetail']['bilirubin'] == "68 - 170µmol/l"){
			$score += 2;
		}else if($event_data['EventDetail']['bilirubin'] == ">50µmol/l" || $event_data['EventDetail']['bilirubin'] == ">170µmol/l"){
			$score += 3;
		} else {
			$set_score = false;
		}
	
		if($event_data['EventDetail']['albumin'] == "<28g/l"){
			$score += 3;
			//++ $score;
		}else if($event_data['EventDetail']['albumin'] == "28 - 35g/l"){
			$score += 2;
		}else if($event_data['EventDetail']['albumin'] == ">35g/l"){
			++ $score;
			//$score += 3;
		} else {
			$set_score = false;
		}
	
		if($event_data['EventDetail']['inr'] == "<1.7"){
			++ $score;
		}else if($event_data['EventDetail']['inr'] == "1.7 - 2.2"){
			$score += 2;
		}else if($event_data['EventDetail']['inr'] == ">2.2"){
			$score += 3;
		} else {
			$set_score = false;
		}
	
		if($event_data['EventDetail']['encephalopathy'] == "none"){
			++ $score;
		}else if($event_data['EventDetail']['encephalopathy'] == "grade I-II"){
			$score += 2;
		}else if($event_data['EventDetail']['encephalopathy'] == "grade III-IV"){
			$score += 3;
		} else {
			$set_score = false;
		}
	
		if($event_data['EventDetail']['ascite'] == "none"){
			++ $score;
		}else if($event_data['EventDetail']['ascite'] == "mild"){
			$score += 2;
		}else if($event_data['EventDetail']['ascite'] == "severe"){
			$score += 3;
		} else {
			$set_score = false;
		}
	
		if($set_score) {
			//no score if bellow 4
			if($score < 7 && $score > 4){
				$event_data['EventDetail']['result'] = "A";
			}else if($score <10){
				$event_data['EventDetail']['result'] = "B";
			}else if($score < 16){
				$event_data['EventDetail']['result'] = "C";
			}
			$event_data['EventDetail']['result'] .= " (".$score.")";
		} else {
			$event_data['EventDetail']['result'] = '';
		}
	
		return $event_data;
	}
	
	function setOkudaScore($event_data){
		$score = 0;
		$set_score = true;
	
		if($event_data['EventDetail']['bilirubin'] == ">=50µmol/l"){
			++ $score;
		} else if(empty($event_data['EventDetail']['bilirubin'])) {
			$set_score = false;
		}
	
		if($event_data['EventDetail']['albumin'] == "<30g/l"){
			++ $score;
		} else if(empty($event_data['EventDetail']['albumin'])) {
			$set_score = false;
		}
	
		if($event_data['EventDetail']['ascite'] == "y"){
			++ $score;
		} else if(empty($event_data['EventDetail']['ascite'])) {
			$set_score = false;
		}
	
		if($event_data['EventDetail']['tumor_size_ratio'] == ">=50%"){
			++ $score;
		} else if(empty($event_data['EventDetail']['tumor_size_ratio'])) {
			$set_score = false;
		}
		
		if($set_score) {
			//no score if bellow 4
			if($score < 1){
				$event_data['EventDetail']['result'] = "I";
			}else if($score < 3){
				$event_data['EventDetail']['result'] = "II";
			}else{
				$event_data['EventDetail']['result'] = "III";
			}
			$event_data['EventDetail']['result'] .= " (".$score.")";
		} else {
			$event_data['EventDetail']['result'] = '';
		}
		
		return $event_data;
	}
	
	function setBarcelonaScore($event_data){
		if($event_data['EventDetail']['who'] == "3 - 4"
		|| $event_data['EventDetail']['tumor_morphology'] == "indifferent"
		|| $event_data['EventDetail']['okuda_score'] == "III"
		|| $event_data['EventDetail']['liver_function'] == "child-pugh C"){
			$event_data['EventDetail']['result'] = "D";
			return $event_data;
		}
	
		if($event_data['EventDetail']['who'] == "1 - 2"
		|| $event_data['EventDetail']['tumor_morphology'] == "metastasis"
		|| $event_data['EventDetail']['tumor_morphology'] == "vascular invasion"){
			$event_data['EventDetail']['result'] = "C";
			return $event_data;
		}
	
		// Stade A, B: all fields should be completed
		if(($event_data['EventDetail']['who'] == '')
		|| empty($event_data['EventDetail']['tumor_morphology'])
		|| empty($event_data['EventDetail']['okuda_score'])
		|| empty($event_data['EventDetail']['liver_function'])) {
			$event_data['EventDetail']['result'] = '';
			return $event_data;
		}
	
		// At this level:
		//   - $event_data['EventDetail']['who'] equals 0 (automatically)
	
		if(($event_data['EventDetail']['tumor_morphology'] == "multinodular")
		&& (($event_data['EventDetail']['okuda_score'] == "I")
		|| ($event_data['EventDetail']['okuda_score'] == "II"))
		&& (($event_data['EventDetail']['liver_function'] == "child-pugh A")
		|| ($event_data['EventDetail']['liver_function'] == "child-pugh B"))) {
			$event_data['EventDetail']['result'] = 'B';
			return $event_data;
		}
	
		if(($event_data['EventDetail']['tumor_morphology'] == "3 tumors, < 3 cm")
		&& (($event_data['EventDetail']['okuda_score'] == "I")
		|| ($event_data['EventDetail']['okuda_score'] == "II"))
		&& (($event_data['EventDetail']['liver_function'] == "child-pugh A")
		|| ($event_data['EventDetail']['liver_function'] == "child-pugh B"))) {
			$event_data['EventDetail']['result'] = 'A4';
			return $event_data;
		}
	
		if(($event_data['EventDetail']['tumor_morphology'] == "unique, < 5cm")
		&& ($event_data['EventDetail']['okuda_score'] == "I")) {
			if($event_data['EventDetail']['liver_function'] == "HTP, hyperbilirubinemia"){
				$event_data['EventDetail']['result'] = "A3";
			}else if($event_data['EventDetail']['liver_function'] == "HTP, bilirubin N"){
				$event_data['EventDetail']['result'] = "A2";
			}else {
				$event_data['EventDetail']['result'] = "A1";
			}
			return $event_data;
		}
	
		$event_data['EventDetail']['result'] = "?";
		return $event_data;
	}
	
	function setClipScore($event_data){
		$set_score = true;
	
		$event_data['EventDetail']['result'] = 0;
		if($event_data['EventDetail']['child_pugh_score'] == "B"){
			++ $event_data['EventDetail']['result'];
		}else if($event_data['EventDetail']['child_pugh_score'] == "C"){
			$event_data['EventDetail']['result'] += 2;
		} else if(empty($event_data['EventDetail']['child_pugh_score'])) {
			$set_score = false;
		}
	
		if($event_data['EventDetail']['morphology_of_tumor'] == "multiple nodules & < 50%"){
			++ $event_data['EventDetail']['result'];
		}else if($event_data['EventDetail']['morphology_of_tumor'] == "massive or >= 50%"){
			$event_data['EventDetail']['result'] += 2;
		} else if(empty($event_data['EventDetail']['morphology_of_tumor'])) {
			$set_score = false;
		}
	
		if($event_data['EventDetail']['alpha_foetoprotein'] == ">= 400 g/L"){
			++ $event_data['EventDetail']['result'];
		} else if(empty($event_data['EventDetail']['alpha_foetoprotein'])) {
			$set_score = false;
		}
		
		if($event_data['EventDetail']['portal_thrombosis'] == "y"){
			++ $event_data['EventDetail']['result'];
		} else if(empty($event_data['EventDetail']['portal_thrombosis'])) {
			$set_score = false;
		}
	
		if(!$set_score) {
			$event_data['EventDetail']['result'] = '';
		}
		
		return $event_data;
	}
	
	function setFongScore($event_data){
		$event_data['EventDetail']['result'] = 0;
		foreach(array('metastatic_lymph_nodes', 'interval_under_year', 'more_than_one_metastasis', 'metastasis_greater_five_cm','cea_greater_two_hundred') as $field) {
			if($event_data['EventDetail'][$field] == "y"){
				++ $event_data['EventDetail']['result'];
			} else if(empty($event_data['EventDetail'][$field])) {
				$event_data['EventDetail']['result'] = '';
				return $event_data;
			}
		}
		return $event_data;
	}
	
	function setGretchScore($event_data){
		$score = 0;
		$set_score = true;
	
		if($event_data['EventDetail']['karnofsky_index'] == "<= 80%"){
			$score += 3;
		} else if(empty($event_data['EventDetail']['karnofsky_index'])) {
			$set_score = false;
		}
		if($event_data['EventDetail']['bilirubin'] == ">=50µmol/l"){
			$score += 3;
		} else if(empty($event_data['EventDetail']['bilirubin'])) {
			$set_score = false;
		}
		if($event_data['EventDetail']['alkaline_phosphatase'] == ">= 2N"){
			$score += 2;
		} else if(empty($event_data['EventDetail']['alkaline_phosphatase'])) {
			$set_score = false;
		}
		if($event_data['EventDetail']['alpha_foetoprotein'] == ">= 35 µg/L"){
			$score += 2;
		} else if(empty($event_data['EventDetail']['alpha_foetoprotein'])) {
			$set_score = false;
		}
		if($event_data['EventDetail']['portal_thrombosis'] == "y"){
			$score += 2;
		} else  if(empty($event_data['EventDetail']['portal_thrombosis'])) {
			$set_score = false;
		}	
	
		if(!$set_score) {
			$event_data['EventDetail']['result'] = '';
		} else {
			if($score == 0){
				$event_data['EventDetail']['result'] = "A (0)";
			}else if($score < 6){
				$event_data['EventDetail']['result'] = "B (".$score.")";
			}else{
				$event_data['EventDetail']['result'] = "C (".$score.")";
			}
		}
		return $event_data;
	}	
	
	function setMeldScore($event_data, &$submitted_data_validates){
		$event_data['EventDetail']['result'] = null;
		$event_data['EventDetail']['sodium_result'] = null;
		
		// Get data
		$creat = str_replace(",",".",$event_data['EventDetail']['creatinine']);
		if(!is_numeric($creat)) return $event_data;
		if(empty($event_data['EventDetail']['dialysis'])) return $event_data;
		$creat = ($event_data['EventDetail']['dialysis'] == "y")? 4 : ($creat/88.4);
	
		$bilirubin = str_replace(",",".",$event_data['EventDetail']['bilirubin']);
		if(!is_numeric($bilirubin)) return $event_data;
		$bilirubin = (($bilirubin/17.1) < 1)? 1 : ($bilirubin/17.1);
	
		$inr = str_replace(",",".",$event_data['EventDetail']['inr']);
		if(!is_numeric($inr)) return $event_data;
		// Calculate MELD
		$event_data['EventDetail']['result'] = ( (0.957*log($creat)) + (0.378*log($bilirubin)) + (1.12*log($inr)) + 0.643 ) *10;
		if($event_data['EventDetail']['result'] < 0) {
			$submitted_data_validates = false;
			$event_data['EventDetail']['result'] = '';
			$this->validationErrors['result'][] = str_replace('%field%', __('result'), __('calculated value for field [%field%] is negative'));
		}
		
		// Calculate MELD-Na
		$sodium = str_replace(",",".",$event_data['EventDetail']['sodium']);
		if(!is_numeric($sodium)) return $event_data;
	
		$tmp = (0.028*($event_data['EventDetail']['result']-17)*($sodium-135))+2.53;
	
		$event_data['EventDetail']['sodium_result'] =(0.855*$event_data['EventDetail']['result'])+0.705*(140-$sodium)+$tmp;
		if($event_data['EventDetail']['sodium_result'] < 0) {
			$submitted_data_validates = false;
			$event_data['EventDetail']['sodium_result'] = '';
			$this->validationErrors['sodium_result'][] = str_replace('%field%', __('MELD-Na'), __('calculated value for field [%field%] is negative'));
		}
			
		return $event_data;
	}
	
	function setCharlsonScore($event_data, &$submitted_data_validates){
		$event_data['EventDetail']['result'] = 0;
		
		switch($event_data['EventDetail']['scoring_age']) {
			case '<=40yrs': break;
			case '41-50': $event_data['EventDetail']['result'] += 1;  break;
			case '51-60': $event_data['EventDetail']['result'] += 2;  break;
			case '61-70': $event_data['EventDetail']['result'] += 3;  break;
			case '71-80': $event_data['EventDetail']['result'] += 4;  break;
		}

		$scoring_data = array(
			'1' => array(
				'myocardial_infarction',
				'congestive_heart_failure',
				'peripheral_disease',
				'cerebrovascular_disease',
				'dementia',
				'chronic_pulmonary_disease',
				'connective_tissue_disease',
				'peptic_ulcer_disease',
				'mild_liver_disease',
				'diabetes_without_end-organ_damage'),
	  		'2' => array(		
				'hemiplegia',
				'moderate_or_severe_renal_disease',
				'diabetes_with_end-organ_damage',
				'tumor_without_metastasis',
				'leukemia',
				'lymphoma'),
	  		'3' => array(		
				'moderate_or_severe_liver_disease'),
	  		'6' => array(	
				'metastatic_solid_tumor',
				'aids'));
		foreach($scoring_data as $value => $all_fields) {
			foreach($all_fields as $specific_field) {
				if(!array_key_exists($specific_field, $event_data['EventDetail']))die('ERR322323 '.$specific_field);
				if($event_data['EventDetail'][$specific_field]) {
					$event_data['EventDetail']['result'] += $value;				
				}
			}
		}
		
		return $event_data;
	}
	
	function allowDeletion($event_master_id){
		$res = parent::allowDeletion($event_master_id);
		if($res['allow_deletion']){
			if($event_master_id != $this->id){
				//not the same, fetch
				$data = $this->findById($event_master_id);
			}else{
				$data = $this->data;
			}
			$participant_id = $data['EventMaster']['participant_id'];
			if(!$participant_id) AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			$TreatmentControl = AppModel::getInstance('ClinicalAnnotation', 'TreatmentControl', true);
			$studied_treatment_control_ids = $TreatmentControl->find('list', array('conditions' => array('TreatmentControl.detail_tablename' => array('qc_hb_txd_surgery_livers','qc_hb_txd_surgery_pancreas'), 'TreatmentControl.flag_active' => '1'), 'fields' => array('TreatmentControl.id')));
			$TreatmentMaster = AppModel::getInstance('ClinicalAnnotation', 'TreatmentMaster', true);
			$linked_surgeries = $TreatmentMaster->find('all', array('conditions' => array('TreatmentMaster.treatment_control_id' => $studied_treatment_control_ids, 'TreatmentMaster.participant_id' => $participant_id)));
			$linked_to_surgery = false;
			foreach($linked_surgeries as $new_one) {
				if(($new_one['TreatmentDetail']['lab_report_id'] == $event_master_id)
				|| ($new_one['TreatmentDetail']['imagery_id'] == $event_master_id)
				|| ($new_one['TreatmentDetail']['fong_score_id'] == $event_master_id)
				|| ($new_one['TreatmentDetail']['meld_score_id'] == $event_master_id) 
				|| ($new_one['TreatmentDetail']['gretch_score_id'] == $event_master_id) 
				|| ($new_one['TreatmentDetail']['clip_score_id'] == $event_master_id) 
				|| ($new_one['TreatmentDetail']['barcelona_score_id'] == $event_master_id) 
				|| ($new_one['TreatmentDetail']['okuda_score_id'] == $event_master_id))  $linked_to_surgery = true;
			}
			if($linked_to_surgery) $res = array('allow_deletion' => false, 'msg' => 'at least one pre operative data is linked to this annotation');
		}
		return $res;
		
	}
	
}