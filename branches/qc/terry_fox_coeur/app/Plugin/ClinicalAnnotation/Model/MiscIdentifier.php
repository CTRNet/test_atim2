<?php

class MiscIdentifier extends ClinicalAnnotationAppModel {
	
	var $belongsTo = array(
		'Participant' => array(
			'className' => 'ClinicalAnnotation.Participant',
			'foreignKey' => 'participant_id'),
		'MiscIdentifierControl' => array(
			'className' => 'ClinicalAnnotation.MiscIdentifierControl',
			'foreignKey' => 'misc_identifier_control_id'
		)
	);

	private $confid_warning_absent = true;
	
    function summary( $variables=array() ) {
		$return = false;
		
//		if ( isset($variables['MiscIdentifier.id']) ) {
//			
//			$result = $this->find('first', array('conditions'=>array('MiscIdentifier.id'=>$variables['MiscIdentifier.id'])));
//			
//			$return = array(
//				'name'	=>	array( NULL, $result['MiscIdentifier']['name']),
//				'participant_id' => array( NULL, $result['MiscIdentifier']['participant_id']),
//				'data'			=> $result,
//				'structure alias'=>'miscidentifiers'
//			);
//		}
		
		return $return;
	}	
	
	function beforeFind($queryData){
		if(
			!AppController::getInstance()->Session->read('flag_show_confidential') 
			&& is_array($queryData['conditions']) 
			&& AppModel::isFieldUsedAsCondition("MiscIdentifier.identifier_value", $queryData['conditions'])
		){
			if($this->confid_warning_absent){
				AppController::addWarningMsg(__('due to your restriction on confidential data, your search did not return confidential identifiers'));
				$this->confid_warning_absent = false;
			}
			$misc_control_model = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifierControl", true);
			$confidential_control_ids = $misc_control_model->getConfidentialIds();
			$queryData['conditions'][] = array("MiscIdentifier.misc_identifier_control_id NOT" => $misc_control_model->getConfidentialIds()); 
		}
		return $queryData;
	}
	
	function afterFind($results, $primary = false){
		$results = parent::afterFind($results);
		if(!AppController::getInstance()->Session->read('flag_show_confidential') && isset($results[0]) && isset($results[0]['MiscIdentifier'])){
			$misc_control_model = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifierControl", true);
			$confidential_control_ids = $misc_control_model->getConfidentialIds();
			if(!empty($confidential_control_ids)){
				if(isset($results[0]) && isset($results[0]['MiscIdentifier'])){
					if(isset($results[0]['MiscIdentifier']['misc_identifier_control_id'])){
						foreach($results as &$result){
							if(in_array($result['MiscIdentifier']['misc_identifier_control_id'], $confidential_control_ids)){
								$result['MiscIdentifier']['identifier_value'] = CONFIDENTIAL_MARKER;
							}
						}
					}else if(isset($results[0]['MiscIdentifier'][0]) && isset($results[0]['MiscIdentifier'][0]['misc_identifier_control_id'])){
						foreach($results[0]['MiscIdentifier'] as &$result){
							if(in_array($result['misc_identifier_control_id'], $confidential_control_ids)){
								$result['identifier_value'] = CONFIDENTIAL_MARKER;
							}
						}
					}else{
						$warn = true;
					} 
				}else{
					$warn = true;
				}
				if(isset($warn) && $warn && Configure::read('debug') > 0){
					AppController::addWarningMsg('unable to parse MiscIdentifier result', true);
				}
			}
		}
		return $results;
	}
	
	function validates($options = array()){
		$errors = parent::validates($options);
		if(!isset($this->data['MiscIdentifier']['deleted']) || $this->data['MiscIdentifier']['deleted'] == 0){
			if(isset($this->validationErrors['identifier_value']) && !is_array($this->validationErrors['identifier_value'])){
				$this->validationErrors['identifier_value'] = array($this->validationErrors['identifier_value']);
			}
			$rule = null;
			$current = null;
			if($this->id){
				$current = $this->findById($this->id);
			}else{
				assert($this->data['MiscIdentifier']['misc_identifier_control_id']) or die('Missing Identifier Control Id');
				$misc_identifier_control_model = AppModel::getInstance('ClinicalAnnotation', 'MiscIdentifierControl');
				$current = $misc_identifier_control_model->findById($this->data['MiscIdentifier']['misc_identifier_control_id']);
			}
			if($current && $current['MiscIdentifierControl']['reg_exp_validation']){
				$rule = $current['MiscIdentifierControl']['reg_exp_validation'];
			}
			if($rule && !preg_match('/'.$rule.'/', $this->data['MiscIdentifier']['identifier_value'])){
				$msg = __('the format of the identifier is incorrect');
				if(!empty($current['MiscIdentifierControl']['user_readable_format'])) $msg .= ' '.__('expected misc identifier format is %s', $current['MiscIdentifierControl']['user_readable_format']);
				$this->validationErrors['identifier_value'][] = $msg;
				return false;
			}
		}
		return $errors;
	}
}

