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
		Collection.created AS created,
Bank.name AS bank_name,
MiscIdentifier.identifier_value AS identifier_value,
MiscIdentifierControl.misc_identifier_name AS identifier_name,
Collection.visit_label AS visit_label
		FROM collections AS Collection
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1
LEFT JOIN banks As Bank ON Collection.bank_id = Bank.id AND Bank.deleted <> 1
LEFT JOIN misc_identifiers AS MiscIdentifier on MiscIdentifier.misc_identifier_control_id = Bank.misc_identifier_control_id AND MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.deleted <> 1
LEFT JOIN misc_identifier_controls AS MiscIdentifierControl ON MiscIdentifier.misc_identifier_control_id=MiscIdentifierControl.id
		WHERE Collection.deleted <> 1 %%WHERE%%';
	
	function find($type = 'first', $query = array()) {
		if($type == 'all' && isset($query['conditions'])) {
			$identifier_values = array();
			$query_conditions = is_array($query['conditions'])? $query['conditions'] : array($query['conditions']);
			foreach($query_conditions as $key => $new_condition) {
				if($key === 'ViewCollection.identifier_value') {
					$identifier_values = $new_condition;
					break;
				} else if(is_string($new_condition)) {
					if(preg_match_all('/ViewCollection\.identifier_value LIKE \'%([0-9]+)%\'/', $new_condition, $matches)) {
						$identifier_values = $matches[1];
						break;
					}
				}
			}
			if(!empty($identifier_values)) {
				$misc_identifier_model = AppModel::getInstance('ClinicalAnnotation', 'MiscIdentifier', true);
				$result = $misc_identifier_model->find('all', array('conditions' => array('MiscIdentifier.misc_identifier_control_id' => 6, 'MiscIdentifier.identifier_value' => $identifier_values), 'fields' => 'MiscIdentifier.identifier_value'));
				if($result){
					$all_values = array();
					foreach($result as $new_res) $all_values[] = $new_res['MiscIdentifier']['identifier_value'];
					AppController::addWarningMsg(__('no labos [%s] matche old bank numbers', implode(', ', $all_values)));
				}
			}
		}
		return parent::find($type, $query);
	}
}