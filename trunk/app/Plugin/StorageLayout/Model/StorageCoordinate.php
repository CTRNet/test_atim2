<?php

class StorageCoordinate extends StorageLayoutAppModel {
		
	var $belongsTo = array(       
		'StorageMaster' => array(           
			'className'    => 'StorageLayout.StorageMaster',            
			'foreignKey'    => 'storage_master_id'
		)	    
	);
	
	/**
	 * Define if a storage coordinate can be deleted.
	 *
	 * @param $storage_master_id Id of the studied storage.
	 * @param $storage_coordinate_data Storage coordinate data.
	 *
	 * @return Return results as array:
	 * 	['allow_deletion'] = true/false
	 * 	['msg'] = message to display when previous field equals false
	 *
	 * @author N. Luc
	 * @since 2008-02-04
	 * @updated A. Suggitt
	 */
	function allowDeletion($storage_master_id, $storage_coordinate_data){
		// Check storage contains no chlidren storage stored within this position
		$storage_master_model = AppModel::getInstance("StorageLayout", "StorageMaster", true);
		$nbr_children_storages = $storage_master_model->find('count', array('conditions' => array('StorageMaster.parent_id' => $storage_master_id, 'StorageMaster.parent_storage_coord_x' => $storage_coordinate_data['StorageCoordinate']['coordinate_value']), 'recursive' => '-1'));
		if($nbr_children_storages > 0) { 
			return array('allow_deletion' => false, 'msg' => 'children storage is stored within the storage at this position'); 
		}

		// Verify storage contains no aliquots
		$aliquot_master_model = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
		$nbr_storage_aliquots = $this->AliquotMaster->find('count', array('conditions' => array('AliquotMaster.storage_master_id' => $storage_master_id, 'AliquotMaster.storage_coord_x ' =>  $storage_coordinate_data['StorageCoordinate']['coordinate_value']), 'recursive' => '-1'));
		if($nbr_storage_aliquots > 0) { 
			return array('allow_deletion' => false, 'msg' => 'aliquot is stored within the storage at this position'); 
		}
			
		return array('allow_deletion' => true, 'msg' => '');
	}
	
	/**
	 * Check the coordinate value does not already exists and set error if not.
	 * 
	 * @param $storage_master_id Id of the studied storage.
	 * @param $new_coordinate_value New coordinate value.
	 * 
	 * @return Return true if the storage coordinate has already been set.
	 * 
	 * @author N. Luc
	 * @since 2008-02-04
	 * @updated A. Suggitt
	 */
	function isDuplicatedValue($storage_master_id, $new_coordinate_value) {	
		$nbr_coord_values = $this->find('count', array('conditions' => array('StorageCoordinate.storage_master_id' => $storage_master_id, 'StorageCoordinate.coordinate_value' => $new_coordinate_value), 'recursive' => '-1'));
		
		if($nbr_coord_values == 0) { 
			return false; 
		}

		// The value already exists: Set the errors
		$this->StorageCoordinate->validationErrors['coordinate_value']	= 'coordinate must be unique for the storage';

		return true;		
	}

	/**
	 * Check the coordinate order does not already exists and set error if not.
	 * 
	 * @param $storage_master_id Id of the studied storage.
	 * @param $new_coordinate_order New coordinate order.
	 * 
	 * @return Return true if the storage coordinate order has already been set.
	 * 
	 * @author N. Luc
	 * @since 2008-02-04
	 * @updated A. Suggitt
	 */
	function isDuplicatedOrder($storage_master_id, $new_coordinate_order) {	
		$nbr_coord_values = $this->find('count', array('conditions' => array('StorageCoordinate.storage_master_id' => $storage_master_id, 'StorageCoordinate.order' => $new_coordinate_order), 'recursive' => '-1'));
		
		if($nbr_coord_values == 0) { 
			return false; 
		}

		// The value already exists: Set the errors
		$this->StorageCoordinate->validationErrors['order']	= 'coordinate order must be unique for the storage';

		return true;		
	}	
	
}

?>
