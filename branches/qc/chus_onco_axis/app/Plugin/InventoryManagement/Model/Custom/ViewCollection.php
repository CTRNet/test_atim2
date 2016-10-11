<?php
class ViewCollectionCustom extends ViewCollection{
	
	var $name = 'ViewCollection';
	static $table_query = '
		SELECT
		Collection.id AS collection_id,
		Collection.bank_id AS bank_id,
		Collection.sop_master_id AS sop_master_id,
		Collection.participant_id AS participant_id,
		Collection.diagnosis_master_id AS diagnosis_master_id,
		Collection.consent_master_id AS consent_master_id,
		Collection.treatment_master_id AS treatment_master_id,
		Collection.event_master_id AS event_master_id,
		Participant.participant_identifier AS participant_identifier,
		Collection.acquisition_label AS acquisition_label,
		Collection.collection_site AS collection_site,
		Collection.collection_datetime AS collection_datetime,
		Collection.collection_datetime_accuracy AS collection_datetime_accuracy,
		Collection.collection_property AS collection_property,
		Collection.collection_notes AS collection_notes,
Collection.chus_chemo_naive,
Collection.chus_radio_naive,
Collection.chus_blood_vessels_clamped_time,
Collection.chus_warm_ischemia_time_mn,
Collection.chus_default_collection_study_summary_id,
StudySummary.title,
EventMaster.chus_patho_report_number as patho_report_report_number,
		Collection.created AS created
		FROM collections AS Collection
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1
LEFT JOIN study_summaries AS StudySummary ON Collection.chus_default_collection_study_summary_id = StudySummary.id AND StudySummary.deleted <> 1
LEFT JOIN event_masters AS EventMaster ON Collection.event_master_id = EventMaster.id
		WHERE Collection.deleted <> 1 %%WHERE%%';
	
	function summary($variables=array()) {
		$return = false;
	
		if(isset($variables['Collection.id'])) {
			
			$collection_data = $this->find('first', array('conditions'=>array('ViewCollection.collection_id' => $variables['Collection.id']), 'recursive' => '-1'));
			
			$bank_model = AppModel::getInstance("Administrate", "Bank", true);
			$bank = $bank_model->find('first', array('conditions' => array('Bank.id' => $collection_data['ViewCollection']['bank_id'])));
			$bank_name = $bank? $bank['Bank']['name'] : '?';
			
			$return = array(
				'menu' => array(null, $bank_name.' - '.$collection_data['ViewCollection']['acquisition_label']),
				'title' => array(null, $bank_name.' - '.$collection_data['ViewCollection']['acquisition_label']),
				'structure alias' 	=> 'view_collection',
				'data'				=> $collection_data
			);
			
			$consent_status = $this->getUnconsentedParticipantCollections(array('data' => $collection_data));
			if(!empty($consent_status)){
				if(!$collection_data['ViewCollection']['participant_id']){
					AppController::addWarningMsg(__('no participant is linked to the current participant collection'));
				}else if($consent_status[$variables['Collection.id']] == null){
					$link = '';
					if(AppController::checkLinkPermission('/ClinicalAnnotation/ClinicalCollectionLinks/detail/')){
						$link = sprintf(' <a href="%sClinicalAnnotation/ClinicalCollectionLinks/detail/%d/%d">%s</a>', AppController::getInstance()->request->webroot, $collection_data['ViewCollection']['participant_id'], $collection_data['ViewCollection']['collection_id'], __('click here to access it'));
					}
					AppController::addWarningMsg(__('no consent is linked to the current participant collection').'.'.$link);
				}else{
					AppController::addWarningMsg(__('the linked consent status is [%s]', __($consent_status[$variables['Collection.id']])));
				}
			}
		}
	
		return $return;
	}
	
	function afterFind($results, $primary = false){
		$results = parent::afterFind($results);
		
		$SampleMasterModel = AppModel::getInstance("InventoryManagement", "SampleMaster", true);
		$SampleMasterModel->unbindModel(array('hasMany' => array('AliquotMaster')));				
		if(isset($results[0]['ViewCollection']['collection_id'])) {
			foreach($results as &$result){
				$res = $SampleMasterModel->find('first', array(
					'conditions' => array('SampleMaster.collection_id' => $results[0]['ViewCollection']['collection_id'], 'SampleControl.sample_category' => 'specimen'), 
					'fields' => array("GROUP_CONCAT(SampleControl.sample_type SEPARATOR '//') AS sample_types"), 
					'group' => array('SampleMaster.collection_id'),
					'recursive' => '0'));
				$tmps_sample_types = '';
				if($res) {
					$tmps_sample_types = array();
					foreach(explode('//', $res[0]['sample_types']) as $new_type) $tmps_sample_types[] = __($new_type);
					$tmps_sample_types = implode(' & ', $tmps_sample_types);
				}
				$result['ViewCollection']['chus_generated_sample_types'] = $tmps_sample_types;
			}
		} else if(isset($results['ViewCollection'])){
			pr('TODO afterFind ViewCollection');
			pr($results);
			exit;
		}
	
		return $results;
	}	
	
}