<?php
/**
 * Display a warning if an EXACT SEARCH is based on a BANK NO LABO and that the 
 * match participant has an OLD BANK NUMBER as well.
 * @param int $search_id
 * @param array $data
 * @param string $model_name
 */
function checkForOldBankId($search_id, $data, $model_name){
	$key = $model_name.'.identifier_value';
	if($search_id
		&& isset($_SESSION['ctrapp_core']['search'][$search_id]['criteria'][$key])
		&& count($_SESSION['ctrapp_core']['search'][$search_id]['criteria'][$key]) == 1
		&& strpos($_SESSION['ctrapp_core']['search'][$search_id]['criteria'][$key][0], '%') === false
	){
		$misc_identifier_model = AppModel::getInstance('ClinicalAnnotation', 'MiscIdentifier', true);
		if($data){
			$result = $misc_identifier_model->find('first', array('conditions' => array('MiscIdentifier.misc_identifier_control_id' => 6, 'MiscIdentifier.participant_id' => $data[0][$model_name]['participant_id'])));
			if($result){
				AppController::addWarningMsg(__('an old bank number is matched to the one used as search parameter', true));
			}
		}
		
		//whether there is data or not, show a warning if the inputed number matches an old bank id
		$result = $misc_identifier_model->find('first', array('conditions' => array('MiscIdentifier.misc_identifier_control_id' => 6, 'MiscIdentifier.identifier_value' => $_SESSION['ctrapp_core']['search'][$search_id]['criteria'][$key][0])));
		if($result){
			AppController::addWarningMsg(__('the bank number matches an old bank number', true));
		}
	}
}