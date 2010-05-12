<?php

class MiscIdentifiersControllerCustom extends MiscIdentifiersController {

	



	
	/**
	 * Manage bank collection participant identfier plus all sample labels
	 * when user delete a bank participant identifier.
	 * 
	 * @author N. Luc
	 * @since 2008-02-20
	 */		
	function manageBankParticipantNbrDeletion($participant_id, $partic_identifier_id) {
		
		// Check parameter
		if(empty($participant_id) || empty($partic_identifier_id)) {
			$this->redirect('/pages/err_clin_funct_param_missing'); 
			exit;						
		}
		
		$criteria = array();
		$criteria['MiscIdentifier']['id'] = $partic_identifier_id;
		$criteria['MiscIdentifier']['participant_id'] = $participant_id;
		
		$partic_ident_data = $this->MiscIdentifier->find($criteria);
		
		if(empty($partic_ident_data)){
			// TODO clarify error
			$this->redirect('/pages/error'); 
			exit;				
		}
		
		// Verify if its a bank identifier
		$bank_name_lng = strpos($partic_ident_data['MiscIdentifier']['name'], " bank no lab");

		if($bank_name_lng !== FALSE) {
			// It's a participant bank Identifier: Get bank and update bank participant collections
			$bank = substr($partic_ident_data['MiscIdentifier']['name'], 0, $bank_name_lng);				
			$this->updateBankCollectionsPartIdentifier($participant_id, $bank, 'n/a');
		}
		
	}
	
	/**
	 * Update all collection bank identifier plus all the collections samples labels
	 * of a participant collection attached to a bank.
	 * 
	 * @param $participant_id Id of the studied participant
	 * @param $bank Studied bank
	 * @param $participant_id $new_bank_nbr_id New bank participant identifier
	 * 
	 * @author N. Luc
	 * @since 2008-02-20
	 */
	function updateBankCollectionsPartIdentifier($participant_id, $bank, $new_bank_nbr_id) {
	
		// Load Collection and ClinicalCollectionLink models
		if (!class_exists('Collection')) {
			$custom_model_path = 
				APP . 'plugins' . DS . $this->params['plugin'] . DS . 'models' . DS .  
				'collection.php';					
			if (file_exists($custom_model_path)) {
				require($custom_model_path);
			} else {
				// TODO clarify error
				$this->redirect('/pages/error'); 
				exit;		
			}	
		}				
		$Collection =& new Collection();	
		
		if (!class_exists('ClinicalCollectionLink')) {
			$custom_model_path = 
				APP . 'plugins' . DS . $this->params['plugin'] . DS . 'models' . DS .  
				'clinical_collection_link.php';					
			if (file_exists($custom_model_path)) {
				require($custom_model_path);
			} else {
				// TODO clarify error
				$this->redirect('/pages/error'); 
				exit;		
			}	
		}				
		$ClinicalCollectionLink =& new ClinicalCollectionLink();
		
		//Search participant collection attached to the bank								
		$criteria = array();
		$criteria['ClinicalCollectionLink.participant_id'] = $participant_id;
		$criteria[] = "Collection.bank = '$bank'";
		$arr_collection_links_list = $ClinicalCollectionLink->findAll($criteria);					
			
		if(!empty($arr_collection_links_list)){
			// At least one participant collection is attached to the bank of the identifier
			
			//Manage collection bank participant number
			foreach($arr_collection_links_list as $id => $link_data) {
				$studied_collection_id = $link_data['Collection']['id'];
				
				// Update new bank collection bank_participant_identifier
				$arr_data_to_save = array();				
				$arr_data_to_save['Collection']['id'] = $studied_collection_id;					
				$arr_data_to_save['Collection']['bank_participant_identifier'] = $new_bank_nbr_id;				
				
				if ( !$Collection->save( $arr_data_to_save ) ) {
					// TODO clarify error
					$this->redirect('/pages/error'); 
					exit;						
				}
						
//				// Update collection sample labels
//
//Note: Comment this line code because it's not good to make a loop on requestAction function
//and replace thies by call of 'function updateBankPartCollSampleLab' below.
//
//				$this->requestAction(
//					'/inventorymanagement/sample_masters/updateCollSampleLabelInBatch/'.
//					$studied_collection_id);							
				
			} 
			
			//Update bank participant collections samples labels	
			$this->requestAction(
				'/inventorymanagement/sample_masters/updateBankPartCollSampleLab/'.$participant_id.'/'.$bank);
			
		}	
	}
			
}

?>