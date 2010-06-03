<?php

class ClinicalCollectionLinksControllerCustom extends ClinicalCollectionLinksController {
//
//	/**
//	 * Upadte the collection participant bank number.
//	 * 
//	 * @param $collection_id Id of the participant collection
//	 * @param $participant_id Id of the participant
//	 * 
//	 * @return TRUE if bank number has been updated.
//	 * 
//	 * @author N. Luc
//	 * @since 2008-03-04
//	 */
//	function updateCollectionParticipantNumber($participant_id, $collection_id) {
//		
//		$bool_is_part_nbr_updated = FALSE;
//		
//		// ** Parameters check: Verify parameters have been set **
//		if(empty($collection_id) || empty($participant_id)) {
//			$this->redirect('/pages/err_clin_funct_param_missing'); 
//			exit;
//		}
//		
//		// ** Get participant data **
//		$criteria = 'Participant.id="'.$participant_id.'"';
//		$participant_data = $this->Participant->find($criteria);
//		
//		if(empty($participant_data)) {
//			$this->redirect('/pages/err_clin_no_part_data'); 
//			exit;			
//		}
//			
//		// ** Get collection data **
//		$criteria = 'Collection.id="'.$collection_id.'"';
//		$collection_data = $this->Collection->find($criteria);
//		
//		if(empty($collection_data)) {
//			//TODO update with a better error message
//			$this->redirect('/pages/err_clin_link_record_err'); 
//			exit;			
//		}
//		
//		$current_coll_partic_bank_nbr 
//			= $collection_data['Collection']['bank_participant_identifier'];
//		
//		// ** Look for new collection participant bank number **
//		$new_coll_partic_bank_nbr = 'n/a';
//		
//		if(!empty($participant_data['MiscIdentifier'])) {			
//			// Search if a participant number has been created for the bank of the collection
//			$collection_bank = $collection_data['Collection']['bank'];
//			
//			foreach($participant_data['MiscIdentifier'] as $id => $new_identifier_data) {			
//				if(strpos($new_identifier_data['name'], $collection_bank) !== FALSE) {
//					// A participant identifier has been found for the collection bank
//					$new_coll_partic_bank_nbr = $new_identifier_data['identifier_value'];
//					break;
//				}				
//			}	
//				
//		}
//		
//		if(strcmp($current_coll_partic_bank_nbr, $new_coll_partic_bank_nbr) != 0) {
//			// Update new collection participant identifier
//			$bool_is_part_nbr_updated = TRUE;
//			
//			$coll_data_to_update = array();
//			$coll_data_to_update['Collection']['id'] 
//				= $collection_data['Collection']['id'];
//			$coll_data_to_update['Collection']['bank_participant_identifier']
//				= $new_coll_partic_bank_nbr;
//			
//			if(!$this->Collection->save($coll_data_to_update)) {
//				//TODO create a better error	
//				$this->redirect('/pages/err_clin_link_record_err'); 
//				exit;
//			}
//					
//		}
//		
//		return $bool_is_part_nbr_updated;
//		
//	}
	
}

?>