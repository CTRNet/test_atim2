<?php

class StudySummary extends StudyAppModel
{
	var $name = 'StudySummary';
	var $useTable = 'study_summaries';

	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['StudySummary.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('StudySummary.id'=>$variables['StudySummary.id'])));
			
			$return = array(
				'menu'			=>	array( NULL, $result['StudySummary']['title'], TRUE),
				'title'			=>	array( NULL, $result['StudySummary']['title'], TRUE),
				'data'			=> $result,
				'structure alias'=>'studysummaries'
			);
		}
		
		return $return;
	}
	
	/**
	 * Get permissible values array gathering all existing studies.
	 *
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  
	function getStudyPermissibleValues() {
		$result = array();
					
		foreach($this->find('all', array('order' => 'StudySummary.title ASC')) as $new_study) {
			$result[$new_study['StudySummary']['id']] = $new_study['StudySummary']['title'];
		}
		
		return $result;
	}

	function allowDeletion($study_summary_id) {	
		$ctrl_model = AppModel::getInstance("Order", "Order", true);
		$ctrl_value = $ctrl_model->find('count', array('conditions' => array('Order.default_study_summary_id' => $study_summary_id), 'recursive' => '-1'));
		if($ctrl_value > 0) { 
			return array('allow_deletion' => false, 'msg' => 'study/project is assigned to an order'); 
		}
		
		$order_ling_model = AppModel::getInstance("Order", "OrderLine", true);
		$returned_nbr = $order_ling_model->find('count', array('conditions' => array('OrderLine.study_summary_id' => $study_summary_id), 'recursive' => '-1'));
		if($returned_nbr > 0) { 
			return array('allow_deletion' => false, 'msg' => 'study/project is assigned to an order line'); 
		}
		
		$ctrl_model = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
		$ctrl_value = $ctrl_model->find('count', array('conditions' => array('AliquotMaster.study_summary_id' => $study_summary_id), 'recursive' => '-1'));
		if($ctrl_value > 0) { 
			return array('allow_deletion' => false, 'msg' => 'study/project is assigned to an aliquot'); 
		}	

		$ctrl_model = AppModel::getInstance("InventoryManagement", "AliquotInternalUse", true);
		$ctrl_value = $ctrl_model->find('count', array('conditions' => array('AliquotInternalUse.study_summary_id' => $study_summary_id), 'recursive' => '-1'));
		if($ctrl_value > 0) { 
			return array('allow_deletion' => false, 'msg' => 'study/project is assigned to an aliquot'); 
		}	
		
		return array('allow_deletion' => true, 'msg' => '');
	}
	
}
?>