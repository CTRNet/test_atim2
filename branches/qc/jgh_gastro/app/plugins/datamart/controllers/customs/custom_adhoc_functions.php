<?php
class CustomAdhocFunctions{
	
	/**
	 * 
	 * Demo function just to show the ability of CustomAdhocFunctions 
	 * @param Controller $parent_controller The parent contoller
	 * @param array $ids Ids to filter with. Blank if no filter should be applied
	 * @return An array of the data to send to the view
	 */
	function demoFuncParticipant($parent_controller, array $ids){
		$parent_controller->Structures->set('participants');
		$participant_model = AppModel::getInstance("Clinicalannotation", "Participant", true);
		$structure = $parent_controller->Structures->get('form', 'participants');
		
		if($ids){
			return $participant_model->find('all', array('conditions' => array('Participant.id' => $ids)));
		}
		return $participant_model->find('all', array('conditions' => $parent_controller->Structures->parseSearchConditions($structure))); 
	}
}