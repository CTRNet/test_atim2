<?php

	/* 
	@author Stephen Fung
	@since 2015-04-27
	Eventum ID: 3214
	Update StudySummary method allowDeletion() to check for linked consent form. 
	*/

class StudySummaryCustom extends StudySummary {
	

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
		
		$ctrl_model = AppModel::getInstance("ClinicalAnnotation", "ConsentMaster", true);
		$ctrl_value = $ctrl_model->find('count', array('conditions' => array('ConsentMaster.study_summary_id' => $study_summary_id), 'recrusive' => '-1'));
		if($ctrl_value > 0) {
			return array('allow_deletion' => false, 'msg' => 'study/project is assigned to a consent form');
		}
		
		return array('allow_deletion' => true, 'msg' => '');
	}
	
	
	
}
