<?php

class ViewCollectionCustom extends ViewCollection {
	
	var $name = 'ViewCollection';
	
// 	static $table_query = '
// 		SELECT
// 		Collection.id AS collection_id,
// 		Collection.bank_id AS bank_id,
// 		Collection.sop_master_id AS sop_master_id,
// 		Collection.participant_id AS participant_id,
// 		Collection.diagnosis_master_id AS diagnosis_master_id,
// 		Collection.consent_master_id AS consent_master_id,
// 		Collection.treatment_master_id AS treatment_master_id,
// 		Collection.event_master_id AS event_master_id,
// 		Participant.participant_identifier AS participant_identifier,
// 		Collection.acquisition_label AS acquisition_label,
// Collection.misc_identifier_id AS misc_identifier_id,
// MiscIdentifier.identifier_value AS frsq_number,	
// 		Collection.collection_site AS collection_site,
// --		Collection.collection_datetime AS collection_datetime,
// --		Collection.collection_datetime_accuracy AS collection_datetime_accuracy,
// Collection.chus_collection_date AS chus_collection_date,
// Collection.chus_collection_date_accuracy AS chus_collection_date_accuracy,
// 		Collection.collection_property AS collection_property,
// 		Collection.collection_notes AS collection_notes,
// 		Collection.created AS created
// 		FROM collections AS Collection
// 		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1
// LEFT JOIN misc_identifiers MiscIdentifier ON Collection.misc_identifier_id = MiscIdentifier.id and MiscIdentifier.deleted <> 1
// 		WHERE Collection.deleted <> 1 %%WHERE%%';
// 	function summary($variables=array()) {
// 		$return = false;
	
// 		if(isset($variables['Collection.id'])) {
// 			$collection_data = $this->find('first', array('conditions'=>array('ViewCollection.collection_id' => $variables['Collection.id'])));
			
// 			$label = (empty($collection_data['ViewCollection']['frsq_number'])? '?': $collection_data['ViewCollection']['frsq_number'])
// 				. (empty($collection_data['ViewCollection']['chus_collection_date'])? '' : ' [' . $collection_data['ViewCollection']['chus_collection_date'].']');
// 			$return = array(
// 					'menu' => array( NULL, ($label) ),
// 					'title' => array( NULL, ($label) ),
// 					'structure alias' 	=> 'view_collection',
// 					'data'				=> $collection_data
// 			);
				
// 			$consent_status = $this->getUnconsentedParticipantCollections(array('data' => $collection_data));
// 			if(!empty($consent_status)){
// 				if(!$collection_data['ViewCollection']['participant_id']){
// 					AppController::addWarningMsg(__('no participant is linked to the current participant collection'));
// 				}else if($consent_status[$variables['Collection.id']] == null){
// 					$link = '';
// 					if(AppController::checkLinkPermission('/ClinicalAnnotation/ClinicalCollectionLinks/detail/')){
// 						$link = sprintf(' <a href="%sClinicalAnnotation/ClinicalCollectionLinks/detail/%d/%d">%s</a>', AppController::getInstance()->request->webroot, $collection_data['ViewCollection']['participant_id'], $collection_data['ViewCollection']['collection_id'], __('click here to access it'));
// 					}
// 					AppController::addWarningMsg(__('no consent is linked to the current participant collection').'.'.$link);
// 				}else{
// 					AppController::addWarningMsg(__('the linked consent status is [%s]', __($consent_status[$variables['Collection.id']])));
// 				}
// 			}
// 		}
	
// 		return $return;
// 	}
	
}

?>
