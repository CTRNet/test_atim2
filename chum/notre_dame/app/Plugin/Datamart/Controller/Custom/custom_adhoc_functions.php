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
	
	function sampleListWithAliquotCount($parent_controller, array $ids){
		$structure = $parent_controller->Structures->get('form', 'view_sample_joined_to_collection');
		$view_sample = AppModel::getInstance('inventorymanagement', 'ViewSample', true);
		$ctrl_limit = 1001;
		$result = $view_sample->find('all', array(
				'fields'	=> array('ViewSample.*', 'COUNT(DISTINCT(AliquotStockAvail.id)) AS avail', 'COUNT(DISTINCT(AliquotStockNotAvail.id)) as not_avail', 'COUNT(DISTINCT(AliquotNotStock.id)) AS not_stock'),
				'conditions' => $ids ? array('ViewSample.sample_master_id' => $ids) : $parent_controller->Structures->parseSearchConditions($structure),
				'joins'	=> array(
					array(
						'type'	=> 'LEFT',
						'table'	=> 'aliquot_masters',
						'alias'	=> 'AliquotStockAvail',
						'conditions'	=> array('ViewSample.sample_master_id=AliquotStockAvail.sample_master_id', 'AliquotStockAvail.in_stock' => 'yes - available', 'AliquotStockAvail.deleted' => 0)
					), array(
						'type'	=> 'LEFT',
						'table'	=> 'aliquot_masters',
						'alias'	=> 'AliquotStockNotAvail',
						'conditions'	=> array('ViewSample.sample_master_id=AliquotStockNotAvail.sample_master_id', 'AliquotStockNotAvail.in_stock' => 'yes - not available', 'AliquotStockNotAvail.deleted' => 0)
					), array(
						'type'	=> 'LEFT',
						'table'	=> 'aliquot_masters',
						'alias'	=> 'AliquotNotStock',
						'conditions'	=> array('ViewSample.sample_master_id=AliquotNotStock.sample_master_id', 'AliquotNotStock.in_stock' => 'no', 'AliquotNotStock.deleted' => 0)
					)
				), 'group' => array('ViewSample.sample_master_id'),
				'limit'	=> $ctrl_limit
			)
		);
		if(count($result) == $ctrl_limit){
			array_pop($result);
			AppController::addWarningMsg(sprintf(__('results truncated to %d', true), $ctrl_limit - 1));
		}
		
		foreach($result as &$line){
			$line['ViewSample']['id'] = $line['ViewSample']['sample_master_id']; 
		}
		return $result;
	}
}

