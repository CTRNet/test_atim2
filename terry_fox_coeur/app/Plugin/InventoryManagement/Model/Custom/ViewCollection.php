<?php

class ViewCollectionCustom extends ViewCollection {
	
	var $name = 'ViewCollection';
	
	static $table_query = '
		SELECT 
		Collection.id AS collection_id,
		Collection.bank_id AS bank_id,
Participant.qc_tf_bank_identifier AS qc_tf_bank_identifier,	
Participant.qc_tf_bank_id AS qc_tf_bank_id,	
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
		Collection.created AS created 
		FROM collections AS Collection 
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1 
		WHERE Collection.deleted <> 1 %%WHERE%%';
	
	function summary($variables=array()) {
		$return = false;
		
		if(isset($variables['Collection.id'])) {
			$collection_data = $this->find('first', array('conditions'=>array('ViewCollection.collection_id' => $variables['Collection.id'])));

			$BankModel = AppModel::getInstance("Administrate", "Bank", true);
			$bank_data = $BankModel->find('first',array('conditions' => array('Bank.id' => $collection_data['ViewCollection']['qc_tf_bank_id'])));

			$title = $collection_data['ViewCollection']['acquisition_label'];
			if(AppController::getInstance()->Session->read('flag_show_confidential')) {
				$title =  $bank_data['Bank']['name'].' #'.$collection_data['ViewCollection']['qc_tf_bank_identifier'].' ['. $title.']';
			}

			$return = array(
				'menu' => array(null, $title),
				'title' => array(null, __('collection') . ' : ' . $title),
				'structure alias' 	=> 'view_collection',
				'data'				=> $collection_data
			);
		}
		
		return $return;
	}
	
}

?>
