<?php
class EventMasterCustom extends EventMaster{
	var $useTable = 'event_masters';
	var $name = 'EventMaster';
	
	function summary( $variables=array() ) {
		$return = false;
	
		if ( isset($variables['EventMaster.id'])) {
				
			$result = $this->find('first', array('conditions'=>array('EventMaster.id'=>$variables['EventMaster.id'])));
				
			$return = array(
					'menu'			=>	array( NULL, __($result['EventControl']['disease_site'], TRUE).' - '.__($result['EventControl']['event_type'], TRUE) ),
					'title'			=>	array( NULL, __('annotation', TRUE) ),
					'data'				=> $result,
					'structure alias'	=> 'eventmasters'
			);
		} else if ( isset($variables['EventControl.id'])) {
			
			$event_control_model = AppModel::getInstance("Clinicalannotation", "EventControl", true);
			$result = $event_control_model->find('first', array('conditions'=>array('EventControl.id'=>$variables['EventControl.id'])));
				
			$return = array(
					'menu'			=>	array( NULL, __($result['EventControl']['disease_site'], TRUE).' - '.__($result['EventControl']['event_type'], TRUE) ),
					'title'			=>	null,
					'data'				=> null,
					'structure alias'	=> null
			);
		}

		return $return;
	}
	
	function addBmiValue( $event_data ) {
		if((isset($event_data['EventDetail']['weight']))
		&& (isset($event_data['EventDetail']['height']))) {
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
			$end_date =  $event_data['EventDetail']['hospitalization_end_date'];
			$event_data['EventDetail']['hospitalization_duration_in_days'] = $this->getDuration($start_date,$end_date);
		}
	
		return $event_data;
	}
	
	function setIntensiveCareDuration( $event_data ) {
		if(isset($event_data['EventDetail']['intensive_care_end_date'])
		&& isset($event_data['EventMaster']['event_date'])) {
			$start_date = $event_data['EventMaster']['event_date'];
			$end_date =  $event_data['EventDetail']['intensive_care_end_date'];
			$event_data['EventDetail']['intensive_care_duration_in_days'] = $this->getDuration($start_date,$end_date);
		}
	
		return $event_data;
	}
	
	
	function getDuration($start_date, $end_date) {
		$result = '';
	
		if(empty($start_date['month']) || empty($start_date['day']) || empty($start_date['year'])
		|| empty($end_date['month']) || empty($end_date['day']) || empty($end_date['year'])){
			// At least one date is missing to continue
				
		} else {
			// ** GET TIME IN DAYS **
			$start = mktime(0, 0, 0, $start_date['month'], $start_date['day'], $start_date['year']);
			$end = mktime(0, 0, 0, $end_date['month'], $end_date['day'], $end_date['year']);
			$spent_time = $end - $start;
				
			if(($start === false)||($end === false)){
				// Error in the date
				$result = '';
			} else if($spent_time < 0){
				// Error in the date
				$result = '';
			} else if($spent_time == 0){
				// Nothing to change to $arr_spent_time
				$result = '0';
			} else {
				// Return spend time in days
				$result = floor($spent_time / 86400);
			}
		}
	
		return $result;
	}

	/**
	 * Set participant surgeries list for hepatobiliary-lab-biology.
	 *
	 * @param $event_control Event control of the created/studied event.
	 * @param $particpant_id
	 */
	
	function getParticipantSurgeriesList( $event_control, $participant_id = null ) {
		$event_type_title =
		$event_control['EventControl']['disease_site'].'-'.
		$event_control['EventControl']['event_group'].'-'.
		$event_control['EventControl']['event_type'];
	
		$pattern = '/^hepatobiliary-lab-biology?/';
		if(preg_match($pattern, $event_type_title)) {
			$treatment_model = AppModel::getInstance('clinicalannotation', 'TreatmentMaster', true);
			$result = array(''=>'');
			$criteria = array();
			if(!is_null($participant_id)) $criteria['TreatmentMaster.participant_id'] = $participant_id;
			$criteria[] = "TreatmentControl.tx_method LIKE 'surgery'";
			foreach($treatment_model->find('all', array('conditions'=>$criteria, 'order' => 'TreatmentMaster.start_date DESC')) as $new_surgery) {
				$result[$new_surgery['TreatmentMaster']['id']] = __($new_surgery['TreatmentControl']['disease_site'], true) . ' - ' . __($new_surgery['TreatmentControl']['tx_method'], true) . ' ' . $new_surgery['TreatmentMaster']['start_date'];
			}			
			return $result;
		}
		
		return null;
	}
	
	function completeVolumetry( $event_data ) {
		if(isset($event_data['EventDetail']['is_volumetry_post_pve'])) {
	
			if(isset($event_data['EventDetail']['total_liver_volume'])
			&& is_numeric($event_data['EventDetail']['total_liver_volume'])
			&& isset($event_data['EventDetail']['resected_liver_volume'])
			&& is_numeric($event_data['EventDetail']['resected_liver_volume'])) {
					
				// Remanant liver volume (= total liver volume - resected liver volume)
				$remnant_liver_volume = $event_data['EventDetail']['total_liver_volume'] - $event_data['EventDetail']['resected_liver_volume'];
					
				// Remanant liver percentage (= (remnant liver volume / (total_liver_volume - tumoral_volume)) * 100 ))
				$remnant_liver_percentage = '';
				if(isset($event_data['EventDetail']['tumoral_volume'])
				&& is_numeric($event_data['EventDetail']['tumoral_volume'])) {
					$diff = $event_data['EventDetail']['total_liver_volume'] - $event_data['EventDetail']['tumoral_volume'];
					if(!empty($diff)) {
						$remnant_liver_percentage = ($remnant_liver_volume / $diff) * 100;
					}
				}
					
				$event_data['EventDetail']['remnant_liver_volume'] = $remnant_liver_volume;
				$event_data['EventDetail']['remnant_liver_percentage'] = $remnant_liver_percentage;
			}
	
			// Remanant liver volume
			if(isset($event_data['EventDetail']['total_liver_volume'])
			&& is_numeric($event_data['EventDetail']['total_liver_volume'])
			&& isset($event_data['EventDetail']['tumoral_volume'])
			&& is_numeric($event_data['EventDetail']['tumoral_volume'])) {
				$event_data['EventDetail']['remnant_liver_volume'] = $event_data['EventDetail']['total_liver_volume'] - $event_data['EventDetail']['resected_liver_volume'];
			}
		}
	
		return $event_data;
	}
	
	function setScores($event_control_event_type){
		if($event_control_event_type == "child pugh score (classic)" || $event_control_event_type == "child pugh score (mod)"){
			$this->setChildPughScore();
		}else if($event_control_event_type == "okuda score"){
			$this->setOkudaScore();
		}else if($event_control_event_type == "barcelona score"){
			$this->setBarcelonaScore();
		}else if($event_control_event_type == "clip score"){
			$this->setClipScore();
		}else if($event_control_event_type == "fong score"){
			$this->setFongScore();
		}else if($event_control_event_type == "gretch score"){
			$this->setGretchScore();
		}else if($event_control_event_type == "meld score"){
			$this->setMeldScore();
		}
	}
	
	function setChildPughScore(){
		$score = 0;
		$set_score = true;
	
		if($this->data['EventDetail']['bilirubin'] == "<34µmol/l" || $this->data['EventDetail']['bilirubin'] == "<68µmol/l"){
			++ $score;
		}else if($this->data['EventDetail']['bilirubin'] == "34 - 50µmol/l" || $this->data['EventDetail']['bilirubin'] == "68 - 170µmol/l"){
			$score += 2;
		}else if($this->data['EventDetail']['bilirubin'] == ">50µmol/l" || $this->data['EventDetail']['bilirubin'] == ">170µmol/l"){
			$score += 3;
		} else {
			$set_score = false;
		}
	
		if($this->data['EventDetail']['albumin'] == "<28g/l"){
			++ $score;
		}else if($this->data['EventDetail']['albumin'] == "28 - 35g/l"){
			$score += 2;
		}else if($this->data['EventDetail']['albumin'] == ">35g/l"){
			$score += 3;
		} else {
			$set_score = false;
		}
	
		if($this->data['EventDetail']['inr'] == "<1.7"){
			++ $score;
		}else if($this->data['EventDetail']['inr'] == "1.7 - 2.2"){
			$score += 2;
		}else if($this->data['EventDetail']['inr'] == ">2.2"){
			$score += 3;
		} else {
			$set_score = false;
		}
	
		if($this->data['EventDetail']['encephalopathy'] == "none"){
			++ $score;
		}else if($this->data['EventDetail']['encephalopathy'] == "grade I-II"){
			$score += 2;
		}else if($this->data['EventDetail']['encephalopathy'] == "grade III-IV"){
			$score += 3;
		} else {
			$set_score = false;
		}
	
		if($this->data['EventDetail']['ascite'] == "none"){
			++ $score;
		}else if($this->data['EventDetail']['ascite'] == "mild"){
			$score += 2;
		}else if($this->data['EventDetail']['ascite'] == "severe"){
			$score += 3;
		} else {
			$set_score = false;
		}
	
		if($set_score) {
			//no score if bellow 4
			if($score < 7 && $score > 4){
				$this->data['EventDetail']['result'] = "A";
			}else if($score <10){
				$this->data['EventDetail']['result'] = "B";
			}else if($score < 16){
				$this->data['EventDetail']['result'] = "C";
			}
			$this->data['EventDetail']['result'] .= " (".$score.")";
		} else {
			$this->data['EventDetail']['result'] = '';
		}
	
	}
	
	function setOkudaScore(){
		$score = 0;
		$set_score = true;
	
		if($this->data['EventDetail']['bilirubin'] == ">=50µmol/l"){
			++ $score;
		} else if(empty($this->data['EventDetail']['bilirubin'])) {
			$set_score = false;
		}
	
		if($this->data['EventDetail']['albumin'] == "<30g/l"){
			++ $score;
		} else if(empty($this->data['EventDetail']['albumin'])) {
			$set_score = false;
		}
	
		if($this->data['EventDetail']['ascite'] == "y"){
			++ $score;
		} else if(empty($this->data['EventDetail']['ascite'])) {
			$set_score = false;
		}
	
		if($this->data['EventDetail']['tumor_size_ratio'] == ">=50%"){
			++ $score;
		} else if(empty($this->data['EventDetail']['tumor_size_ratio'])) {
			$set_score = false;
		}
		
		if($set_score) {
			//no score if bellow 4
			if($score < 1){
				$this->data['EventDetail']['result'] = "I";
			}else if($score < 3){
				$this->data['EventDetail']['result'] = "II";
			}else{
				$this->data['EventDetail']['result'] = "III";
			}
			$this->data['EventDetail']['result'] .= " (".$score.")";
		} else {
			$this->data['EventDetail']['result'] = '';
		}
	}
	
	function setBarcelonaScore(){
		if($this->data['EventDetail']['who'] == "3 - 4"
		|| $this->data['EventDetail']['tumor_morphology'] == "indifferent"
		|| $this->data['EventDetail']['okuda_score'] == "III"
		|| $this->data['EventDetail']['liver_function'] == "child-pugh C"){
			$this->data['EventDetail']['result'] = "D";
			return;
		}
	
		if($this->data['EventDetail']['who'] == "1 - 2"
		|| $this->data['EventDetail']['tumor_morphology'] == "metastasis"
		|| $this->data['EventDetail']['tumor_morphology'] == "vascular invasion"){
			$this->data['EventDetail']['result'] = "C";
			return;
		}
	
		// Stade A, B: all fields should be completed
		if(($this->data['EventDetail']['who'] == '')
		|| empty($this->data['EventDetail']['tumor_morphology'])
		|| empty($this->data['EventDetail']['okuda_score'])
		|| empty($this->data['EventDetail']['liver_function'])) {
			$this->data['EventDetail']['result'] = '';
			return;
		}
	
		// At this level:
		//   - $this->data['EventDetail']['who'] equals 0 (automatically)
	
		if(($this->data['EventDetail']['tumor_morphology'] == "multinodular")
		&& (($this->data['EventDetail']['okuda_score'] == "I")
		|| ($this->data['EventDetail']['okuda_score'] == "II"))
		&& (($this->data['EventDetail']['liver_function'] == "child-pugh A")
		|| ($this->data['EventDetail']['liver_function'] == "child-pugh B"))) {
			$this->data['EventDetail']['result'] = 'B';
			return;
		}
	
		if(($this->data['EventDetail']['tumor_morphology'] == "3 tumors, < 3 cm")
		&& (($this->data['EventDetail']['okuda_score'] == "I")
		|| ($this->data['EventDetail']['okuda_score'] == "II"))
		&& (($this->data['EventDetail']['liver_function'] == "child-pugh A")
		|| ($this->data['EventDetail']['liver_function'] == "child-pugh B"))) {
			$this->data['EventDetail']['result'] = 'A4';
			return;
		}
	
		if(($this->data['EventDetail']['tumor_morphology'] == "unique, < 5cm")
		&& ($this->data['EventDetail']['okuda_score'] == "I")) {
			if($this->data['EventDetail']['liver_function'] == "HTP, hyperbilirubinemia"){
				$this->data['EventDetail']['result'] = "A3";
			}else if($this->data['EventDetail']['liver_function'] == "HTP, bilirubin N"){
				$this->data['EventDetail']['result'] = "A2";
			}else {
				$this->data['EventDetail']['result'] = "A1";
			}
			return;
		}
	
		$this->data['EventDetail']['result'] = "?";
	}
	
	function setClipScore(){
		$set_score = true;
	
		$this->data['EventDetail']['result'] = 0;
		if($this->data['EventDetail']['child_pugh_score'] == "B"){
			++ $this->data['EventDetail']['result'];
		}else if($this->data['EventDetail']['child_pugh_score'] == "C"){
			$this->data['EventDetail']['result'] += 2;
		} else if(empty($this->data['EventDetail']['child_pugh_score'])) {
			$set_score = false;
		}
	
		if($this->data['EventDetail']['morphology_of_tumor'] == "multiple nodules & < 50%"){
			++ $this->data['EventDetail']['result'];
		}else if($this->data['EventDetail']['morphology_of_tumor'] == "massive or >= 50%"){
			$this->data['EventDetail']['result'] += 2;
		} else if(empty($this->data['EventDetail']['morphology_of_tumor'])) {
			$set_score = false;
		}
	
		if($this->data['EventDetail']['alpha_foetoprotein'] == ">= 400 g/L"){
			++ $this->data['EventDetail']['result'];
		} else if(empty($this->data['EventDetail']['alpha_foetoprotein'])) {
			$set_score = false;
		}
		
		if($this->data['EventDetail']['portal_thrombosis'] == "y"){
			++ $this->data['EventDetail']['result'];
		} else if(empty($this->data['EventDetail']['portal_thrombosis'])) {
			$set_score = false;
		}
	
		if(!$set_score) {
			$this->data['EventDetail']['result'] = '';
		}
	}
	
	function setFongScore(){
		$this->data['EventDetail']['result'] = 0;
		foreach(array('metastatic_lymph_nodes', 'interval_under_year', 'more_than_one_metastasis', 'metastasis_greater_five_cm','cea_greater_two_hundred') as $field) {
			if($this->data['EventDetail'][$field] == "y"){
				++ $this->data['EventDetail']['result'];
			} else if(empty($this->data['EventDetail'][$field])) {
				$this->data['EventDetail']['result'] = '';
				return;
			}
		}	
	}
	
	function setGretchScore(){
		$score = 0;
		$set_score = true;
	
		if($this->data['EventDetail']['karnofsky_index'] == "<= 80%"){
			$score += 3;
		} else if(empty($this->data['EventDetail']['karnofsky_index'])) {
			$set_score = false;
		}
		if($this->data['EventDetail']['bilirubin'] == ">=50µmol/l"){
			$score += 3;
		} else if(empty($this->data['EventDetail']['bilirubin'])) {
			$set_score = false;
		}
		if($this->data['EventDetail']['alkaline_phosphatase'] == ">= 2N"){
			$score += 2;
		} else if(empty($this->data['EventDetail']['alkaline_phosphatase'])) {
			$set_score = false;
		}
		if($this->data['EventDetail']['alpha_foetoprotein'] == ">= 35 µg/L"){
			$score += 2;
		} else if(empty($this->data['EventDetail']['alpha_foetoprotein'])) {
			$set_score = false;
		}
		if($this->data['EventDetail']['portal_thrombosis'] == "y"){
			$score += 2;
		} else  if(empty($this->data['EventDetail']['portal_thrombosis'])) {
			$set_score = false;
		}	
	
		if(!$set_score) {
			$this->data['EventDetail']['result'] = '';
		} else {
			if($score == 0){
				$this->data['EventDetail']['result'] = "A (0)";
			}else if($score < 6){
				$this->data['EventDetail']['result'] = "B (".$score.")";
			}else{
				$this->data['EventDetail']['result'] = "C (".$score.")";
			}
		}
	}	
	
	function setMeldScore(){
		$this->data['EventDetail']['result'] = null;
		$this->data['EventDetail']['sodium_result'] = null;
		
		// Get data
		$creat = str_replace(",",".",$this->data['EventDetail']['creatinine']);
		if(!is_numeric($creat)) return;
		if(empty($this->data['EventDetail']['dialysis'])) return;
		$creat = ($this->data['EventDetail']['dialysis'] == "y")? 4 : ($creat/88.4);
	
		$bilirubin = str_replace(",",".",$this->data['EventDetail']['bilirubin']);
		if(!is_numeric($bilirubin)) return;
		$bilirubin = (($bilirubin/17.1) < 1)? 1 : ($bilirubin/17.1);
	
		$inr = str_replace(",",".",$this->data['EventDetail']['inr']);
		if(!is_numeric($inr)) return;
		// Calculate MELD
		$this->data['EventDetail']['result'] = ( (0.957*log($creat)) + (0.378*log($bilirubin)) + (1.12*log($inr)) + 0.643 ) *10;
	
		// Calculate MELD-Na
		$sodium = str_replace(",",".",$this->data['EventDetail']['sodium']);
		if(!is_numeric($sodium)) return;
	
		$tmp = (0.028*($this->data['EventDetail']['result']-17)*($sodium-135))+2.53;
	
		$this->data['EventDetail']['sodium_result'] =(0.855*$this->data['EventDetail']['result'])+0.705*(140-$sodium)+$tmp;
	}
	
}