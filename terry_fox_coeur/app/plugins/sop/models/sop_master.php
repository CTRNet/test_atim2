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
	
	
	
	
}

?>