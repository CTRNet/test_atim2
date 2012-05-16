<?php

class ViewAliquot extends InventoryManagementAppModel {
	var $primaryKey = 'aliquot_master_id';
	var $base_model = "AliquotMaster";
	var $base_plugin = 'InventoryManagement';
	
	var $belongsTo = array(
		'AliquotControl' => array(
			'className'    => 'InventoryManagement.AliquotControl',
			'foreignKey'    => 'aliquot_control_id',
			'type'			=> 'INNER'),
		'AliquotMaster'	=> array(
			'className'    => 'InventoryManagement.AliquotMaster',
			'foreignKey'    => 'aliquot_master_id',
			'type'			=> 'INNER'),
		'Collection' => array(
			'className'    => 'InventoryManagement.Collection',
			'foreignKey'    => 'collection_id',
			'type'			=> 'INNER'),
		'SampleMaster' => array(
			'className'    => 'InventoryManagement.SampleMaster',
			'foreignKey'    => 'sample_master_id',
			'type'			=> 'INNER'),
		'StorageMaster' => array(
			'className'    => 'StorageLayout.StorageMaster',
			'foreignKey'    => 'storage_master_id')
	);
	
	function __construct($id = false, $table = null, $ds = null, $base_model_name = null, $detail_table = null, $previous_model = null) {
		if($this->fields_replace == null){
			$this->fields_replace = array(
				'coll_to_stor_spent_time_msg' => array(
						'msg' => array(
								-1 => __('collection date missing'),
								-2 => __('spent time cannot be calculated on inaccurate dates'),
								-3 => __('the collection date is after the storage date')
						), 'type' => 'spentTime'
				),
				'rec_to_stor_spent_time_msg' => array(
						'msg' => array(
								-1 => __('reception date missing'),
								-2 => __('spent time cannot be calculated on inaccurate dates'),
								-3 => __('the reception date is after the storage date')
						), 'type' => 'spentTime'
				),
				'creat_to_stor_spent_time_msg' => array(
						'msg' => array(
								-1 => __('creation date missing'),
								-2 => __('spent time cannot be calculated on inaccurate dates'),
								-3 => __('the creation date is after the storage date')
						), 'type' => 'spentTime'
				)
			);
		}
		return parent::__construct($id, $table, $ds, $base_model_name, $detail_table, $previous_model);
	}
}
