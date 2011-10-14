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
			$result[$new_study['StudySummary']['id']] = $new_study['StudySummary']['title'] . (empty($new_study['StudySummary']['disease_site'])? '' : '(' . __($new_study['StudySummary']['disease_site'], true) .')');
		}
		
		return $result;
	}

	function allowDeletion($study_summary_id) {	
//TODO end of study summary allowDeletion()
//ALTER TABLE `study_contacts`
//  ADD CONSTRAINT `FK_study_contacts_study_summaries` FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`);
//
//ALTER TABLE `study_ethics_boards`
//  ADD CONSTRAINT `FK_study_ethics_boards_study_summaries` FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`);
//
//ALTER TABLE `study_fundings`
//  ADD CONSTRAINT `FK_study_fundings_study_summaries` FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`);
//
//ALTER TABLE `study_investigators`
//  ADD CONSTRAINT `FK_study_investigators_study_summaries` FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`);
//
//ALTER TABLE `study_related`
//  ADD CONSTRAINT `FK_study_related_study_summaries` FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`);
//
//ALTER TABLE `study_results`
//  ADD CONSTRAINT `FK_study_results_study_summaries` FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`);
//
//ALTER TABLE `study_reviews`
//  ADD CONSTRAINT `FK_study_reviews_study_summaries` FOREIGN KEY (`study_summary_id`) REFERENCES `study_summaries` (`id`);

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
		
		$ctrl_model = AppModel::getInstance("Inventorymanagement", "AliquotMaster", true);
		$ctrl_value = $ctrl_model->find('count', array('conditions' => array('AliquotMaster.study_summary_id' => $study_summary_id), 'recursive' => '-1'));
		if($ctrl_value > 0) { 
			return array('allow_deletion' => false, 'msg' => 'study/project is assigned to an aliquot'); 
		}	

		$ctrl_model = AppModel::getInstance("Inventorymanagement", "AliquotInternalUse", true);
		$ctrl_value = $ctrl_model->find('count', array('conditions' => array('AliquotInternalUse.study_summary_id' => $study_summary_id), 'recursive' => '-1'));
		if($ctrl_value > 0) { 
			return array('allow_deletion' => false, 'msg' => 'study/project is assigned to an aliquot'); 
		}	
		
		return array('allow_deletion' => true, 'msg' => '');
	}
	
}
?>