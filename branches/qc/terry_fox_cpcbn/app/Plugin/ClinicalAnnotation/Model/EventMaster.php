<?php

class EventMaster extends ClinicalAnnotationAppModel {
	
	var $belongsTo = array(        
	   'EventControl' => array(            
	       'className'    => 'ClinicalAnnotation.EventControl',            
	       'foreignKey'    => 'event_control_id'        
	   )    
	);
	
	var $browsing_search_dropdown_info = array(
		'browsing_filter'	=> array(
			1	=> array('lang' => 'keep entries with the most recent date per participant', 'group by' => 'participant_id', 'field' => 'event_date', 'attribute' => 'MAX'),
			2	=> array('lang' => 'keep entries with the oldest date per participant', 'group by' => 'participant_id', 'field' => 'event_date', 'attribute' => 'MIN')
		)
	);
	
	function summary( $variables=array() ) {
		$return = false;
	
		if ( isset($variables['EventMaster.id'])) {
				
			$result = $this->find('first', array('conditions'=>array('EventMaster.id'=>$variables['EventMaster.id'])));
				
			$return = array(
				'menu'			=>	array( NULL, __($result['EventControl']['event_type'], TRUE).(empty($result['EventControl']['disease_site'])? '' : ' - '.__($result['EventControl']['disease_site'], TRUE)) ),
				'title'			=>	array( NULL, __('annotation', TRUE) ),
				'data'				=> $result,
				'structure alias'	=> 'eventmasters'
			);
		}else if(isset($variables['EventControl.id'])){
			$return = array();
		}
	
		return $return;
	}
	
	/**
	 * Compares dx data with a cap report and generates warning when there are
	 * mismatches.
	 * @param array $diagnosis_data
	 * @param array $event_data
	 */
	static function generateDxCompatWarnings(array $diagnosis_data, array $event_data){
		$diagnosis_data = $diagnosis_data['DiagnosisMaster'];
		$event_data = $event_data['EventDetail'];
		
		$to_check = array(
			//field			=> untranslated language label
			'path_tstage'	=> 'path tstage',
			'path_nstage'	=> 'path nstage',
			'path_mstage'	=> 'path mstage',
			'tumour_grade'	=> 'histologic grade'
		);
		foreach($to_check as $field => $language_label){
			if(array_key_exists($field, $event_data) && $diagnosis_data[$field] != $event_data[$field]){
				AppController::addWarningMsg(
					sprintf(
						__('the diagnosis value for %s does not match the cap report value'), 
						__($language_label)
					)
				);
			}
		}
	}
	
	function allowDeletion($event_master_id){
		$collection_model = AppModel::getInstance('InventoryManagement', 'Collection');
		if($collection_model->find('first', array('conditions' => array('Collection.event_master_id' => $event_master_id)))){
			return array('allow_deletion' => false, 'msg' => 'at least one collection is linked to that annotation');
		}
		
		return array('allow_deletion' => true, 'msg' => '');
	}
	
	function calculatedDetailFields(array &$data){
		if(($data['EventControl']['detail_tablename'] == 'ed_all_lifestyle_smokings') && array_key_exists('started_on', $data['EventDetail']) && array_key_exists('stopped_on', $data['EventDetail'])){		
			//for smoking, smoked for and stopped since fields
			if(!empty($data['EventDetail']['started_on']) && $data['EventDetail']['started_on_accuracy'] == 'c' && !empty($data['EventDetail']['stopped_on']) && $data['EventDetail']['stopped_on_accuracy'] == 'c'){
				$data['EventDetail']['smoked_for'] = AppModel::manageSpentTimeDataDisplay(AppModel::getSpentTime($data['EventDetail']['started_on'].' 00:00:00', $data['EventDetail']['stopped_on'].' 00:00:00'), false);
				
			}else{
				$data['EventDetail']['smoked_for'] = __('cannot calculate on incomplete date');
			}
			if(!empty($data['EventDetail']['stopped_on']) && $data['EventDetail']['stopped_on_accuracy'] == 'c'){
				$data['EventDetail']['stopped_since'] = AppModel::manageSpentTimeDataDisplay(AppModel::getSpentTime($data['EventDetail']['stopped_on'].' 00:00:00', now()), false);
			}else{
				$data['EventDetail']['stopped_since'] = __('cannot calculate on incomplete date');
			}
		}
	}
}
