<?php

class ViewCollectionCustom extends ViewCollection {
	
	var $name = 'ViewCollection';
	
	var $belongsTo = array(
		'Collection' => array(
			'className'   => 'InventoryManagement.Collection',
			'foreignKey'  => 'collection_id',
			'type'			=> 'INNER'
		),
		'Participant' => array(
				'className' => 'ClinicalAnnotation.Participant',
				'foreignKey' => 'participant_id'
		), 'DiagnosisMaster' => array(
				'className' => 'ClinicalAnnotation.DiagnosisMaster',
				'foreignKey' => 'diagnosis_master_id'
		), 'ConsentMaster' => array(
				'className' => 'ClinicalAnnotation.ConsentMaster',
				'foreignKey' => 'consent_master_id'
		),
		'MiscIdentifier' => array(
				'className' => 'ClinicalAnnotation.MiscIdentifier',
				'foreignKey' => 'misc_identifier_id'
		)
	);
	
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
Collection.misc_identifier_id AS misc_identifier_id,
MiscIdentifier.identifier_value AS muhc_participant_coded_identifier,
Participant.muhc_participant_bank_id AS muhc_participant_bank_id,
		Participant.participant_identifier AS participant_identifier,
		Collection.acquisition_label AS acquisition_label,
		Collection.collection_site AS collection_site,
Collection.muhc_age_at_collection AS muhc_age_at_collection,
Collection.muhc_collection_room	AS muhc_collection_room,	
		Collection.collection_datetime AS collection_datetime,
		Collection.collection_datetime_accuracy AS collection_datetime_accuracy,
		Collection.collection_property AS collection_property,
		Collection.collection_notes AS collection_notes,
		Collection.created AS created 
		FROM collections AS Collection 
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1 
LEFT JOIN misc_identifiers AS MiscIdentifier ON Collection.misc_identifier_id = MiscIdentifier.id AND MiscIdentifier.deleted <> 1 
		WHERE Collection.deleted <> 1 %%WHERE%%';

	function summary($variables=array()) {
		$return = false;
		
		if(isset($variables['Collection.id'])) {
			$collection_data = $this->find('first', array('conditions'=>array('ViewCollection.collection_id' => $variables['Collection.id'])));

			$muhc_participant_coded_identifier = empty($collection_data['ViewCollection']['muhc_participant_coded_identifier'])? '?' : $collection_data['ViewCollection']['muhc_participant_coded_identifier'];
			$muhc_irb_nbr = '?';
			if($collection_data['ViewCollection']['bank_id']) {
				$BankModel = AppModel::getInstance('Administrate', 'Bank', true);
				$bank_result = $BankModel->find('first', array('conditions' => array('Bank.id' => $collection_data['ViewCollection']['bank_id'])));
				$muhc_irb_nbr = $bank_result['Bank']['muhc_irb_nbr'];
			}
			$label_1 = "$muhc_irb_nbr #$muhc_participant_coded_identifier ";
			$label_2 = $label_1.substr($collection_data['ViewCollection']['collection_datetime'], 0, strpos($collection_data['ViewCollection']['collection_datetime'], ' '));
			$return = array(
				'menu' => array(null, $label_2),
				'title' => array(null, __('collection') . ' : ' . $label_1),
				'structure alias' 	=> 'view_collection',
				'data'				=> $collection_data
			);
		}
		
		return $return;
	}	
}

?>
