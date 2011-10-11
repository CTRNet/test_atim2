<?php

class SopMaster extends SopAppModel
{
	var $name = 'SopMaster';
    var $useTable = 'sop_masters';

	var $belongsTo = array(        
	   'SopControl' => array(            
	       'className'    => 'Sop.SopControl',            
	       'foreignKey'    => 'sop_control_id'        
	   )    
	);
	
	function summary( $variables=array() ) {
		$return = false;
		
		if ( isset($variables['SopMaster.id']) ) {
			
			$result = $this->find('first', array('conditions'=>array('SopMaster.id'=>$variables['SopMaster.id'])));
			
			$return = array(
				'menu'			=>	array( NULL, __($result['SopMaster']['title'], TRUE)),
				'title'			=>	array( NULL, __($result['SopMaster']['title'], TRUE)),
				'data'			=> $result,
				'structure alias'=>'sopmasters'
			);
		}
		
		return $return;
	}

 	/**
	 * Get permissible values array gathering all existing sops developped for collections.
	 * To Develop
	 *
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  		
	function getCollectionSopPermissibleValues() {
		return $this->getAllSopPermissibleValues();
	}

 	/**
	 * Get permissible values array gathering all existing sops developped for samples.
	 * To Develop
	 *
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  		
	function getSampleSopPermissibleValues() {
		return $this->getAllSopPermissibleValues();
	}

 	/**
	 * Get permissible values array gathering all existing sops developped for aliquots.
	 * To Develop
	 *
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  		
	function getAliquotSopPermissibleValues() {
		return $this->getAllSopPermissibleValues();
	}				

 	/**
	 * Get permissible values array gathering all existing sops developped for TMA Block.
	 * To Develop
	 *
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  		
	function getTmaBlockSopPermissibleValues() {
		return $this->getAllSopPermissibleValues();		
	}

 	/**
	 * Get permissible values array gathering all existing sops developped for TMA Block Slide.
	 * To Develop
	 *
	 * @author N. Luc
	 * @since 2010-05-26
	 * @updated N. Luc
	 */  	
	function getTmaSlideSopPermissibleValues() {
		return $this->getAllSopPermissibleValues();		
	}
	
	function getAllSopPermissibleValues() {
		$result = array();
		
		// Build tmp array to sort according translation
		foreach($this->find('all', array('order' => 'SopMaster.title')) as $sop) {
			$result[$sop['SopMaster']['id']] = $sop['SopMaster']['title'];
		}
		
		return $result;
	}
	
	function allowDeletion($sop_master_id) {	
		$ctrl_model = AppModel::getInstance("Storagelayout", "TmaSlide", true);
		$ctrl_value = $ctrl_model->find('count', array('conditions' => array('TmaSlide.sop_master_id' => $sop_master_id), 'recursive' => '-1'));
		if($ctrl_value > 0) { 
			return array('allow_deletion' => false, 'msg' => 'sop is assigned to a slide'); 
		}

		$StorageDetail = AppModel::getInstance("Storagelayout", "StorageDetail", true);
		$block_model = new StorageDetail(false, 'std_tma_blocks');			
		$ctrl_value = $block_model->find('count', array('conditions' => array('StorageDetail.sop_master_id' => $sop_master_id), 'recursive' => '-1'));
		if($ctrl_value > 0) { 
			return array('allow_deletion' => false, 'msg' => 'sop is assigned to a block'); 
		}
 		
		$ctrl_model = AppModel::getInstance("Inventorymanagement", "Collection", true);
		$ctrl_value = $ctrl_model->find('count', array('conditions' => array('Collection.sop_master_id' => $sop_master_id), 'recursive' => '-1'));
		if($ctrl_value > 0) { 
			return array('allow_deletion' => false, 'msg' => 'sop is assigned to a collection'); 
		}	
				
		$ctrl_model = AppModel::getInstance("Inventorymanagement", "SampleMaster", true);
		$ctrl_value = $ctrl_model->find('count', array('conditions' => array('SampleMaster.sop_master_id' => $sop_master_id), 'recursive' => '-1'));
		if($ctrl_value > 0) { 
			return array('allow_deletion' => false, 'msg' => 'sop is assigned to a sample'); 
		}	
				
		$ctrl_model = AppModel::getInstance("Inventorymanagement", "AliquotMaster", true);
		$ctrl_value = $ctrl_model->find('count', array('conditions' => array('AliquotMaster.sop_master_id' => $sop_master_id), 'recursive' => '-1'));
		if($ctrl_value > 0) { 
			return array('allow_deletion' => false, 'msg' => 'sop is assigned to an aliquot'); 
		}	

		return array('allow_deletion' => true, 'msg' => '');
	}
}

?>