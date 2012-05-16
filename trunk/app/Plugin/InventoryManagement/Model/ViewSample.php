<?php

class ViewSample extends InventoryManagementAppModel {
	var $primaryKey = 'sample_master_id';
	
	var $base_model = "SampleMaster";
	var $base_plugin = 'InventoryManagement';
	
	var $belongsTo = array(
		'SampleControl' => array(
			'className'		=> 'InventoryManagement.SampleControl',
			'foreignKey'	=> 'sample_control_id',
			'type'			=> 'INNER'),
		'SampleMaster' => array(
			'className'		=> 'InventoryManagement.SampleMaster',
			'foreignKey'	=> 'sample_master_id',
			'type'			=> 'INNER')
	);
	
	var $hasOne = array(
		'SpecimenDetail' => array(
			'className'   => 'InventoryManagement.SpecimenDetail',
			'foreignKey'  => 'sample_master_id',
			'dependent' => true),
		'DerivativeDetail' => array(
			'className'   => 'InventoryManagement.DerivativeDetail',
			'foreignKey'  => 'sample_master_id',
			'dependent' => true)
	);
	
	var $fields_replace = null;
	
	function __construct($id = false, $table = null, $ds = null, $base_model_name = null, $detail_table = null, $previous_model = null) {
		if($this->fields_replace == null){
			$this->fields_replace = array(
				'coll_to_creation_spent_time_msg' => array(
					'msg' => array(
						-1 => __('collection date missing'),
						-2 => __('spent time cannot be calculated on inaccurate dates'),
						-3 => __('the collection date is after the derivative creation date')
					), 'type' => 'spentTime'
				), 
				'coll_to_rec_spent_time_msg' => array(
					'msg' => array(
						-1 => __('collection date missing'),
						-2 => __('spent time cannot be calculated on inaccurate dates'),
						-3 => __('the collection date is after the specimen reception date')
					), 'type' => 'spentTime'
				)
			); 
		}
		return parent::__construct($id, $table, $ds, $base_model_name, $detail_table, $previous_model);
	}
}
