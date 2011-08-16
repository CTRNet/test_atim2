<?php

class ViewAliquotUse extends InventorymanagementAppModel {
	const JOINS = 0;
	const SOURCE_ID = 1; 
	const USE_DEFINITION = 2;
	const USE_CODE = 3;
	const USE_DETAIL = 4;
	const USE_VOLUME = 5;
	const CREATED = 6; 
	const DETAIL_URL = 7;
	const SAMPLE_MASTER_ID = 8;
	const COLLECTION_ID = 9; 
	const USE_DATETIME = 10;
	const USE_BY = 11;
	const VOLUME_UNIT = 12;
	const PLUGIN = 13;
	
	function findFastFromAliquotMasterId($aliquot_master_id){
		$models_details = array(
			"SourceAliquot" => array(
				self::PLUGIN			=> "Inventorymanagement",
				self::JOINS				=> array(
											AliquotMaster::joinOnAliquotDup('SourceAliquot.aliquot_master_id'),
											AliquotMaster::$join_aliquot_control_on_dup,
											array('table' => 'sample_masters', 'alias' => 'sample_derivative', 'type' => 'INNER', 'conditions' => array('SourceAliquot.sample_master_id = sample_derivative.id')),
											array('table' => 'derivative_details', 'alias' => 'DerivativeDetail', 'type' => 'INNER', 'conditions' => array('sample_derivative.id = DerivativeDetail.sample_master_id')),
											array('table' => 'sample_masters', 'alias' => 'sample_source', 'type' => 'INNER', 'conditions' => array('aliquot_masters_dup.sample_master_id = sample_source.id'))),
				self::SOURCE_ID			=> 'CONCAT(SourceAliquot.id, 1)',
				self::USE_DEFINITION	=> '"sample derivative creation"',
				self::USE_CODE			=> '""',
				self::USE_DETAIL		=> '""',
				self::USE_VOLUME		=> 'SourceAliquot.used_volume',
				self::VOLUME_UNIT		=> 'AliquotControl.volume_unit',
				self::USE_DATETIME		=> 'DerivativeDetail.creation_datetime',
				self::USE_BY			=> 'DerivativeDetail.creation_by',
				self::CREATED			=> 'SourceAliquot.created',
				self::DETAIL_URL		=> 'CONCAT("|inventorymanagement|aliquot_masters|listAllSourceAliquots|",sample_derivative.collection_id ,"|",sample_derivative.id)',
				self::SAMPLE_MASTER_ID	=> 'sample_source.id',
				self::COLLECTION_ID		=> 'sample_source.collection_id'
			), "Realiquoting" => array(
				self::PLUGIN			=> "Inventorymanagement",
				self::JOINS				=> array(
											AliquotMaster::joinOnAliquotDup('Realiquoting.parent_aliquot_master_id'),
											AliquotMaster::$join_aliquot_control_on_dup,
											array('table' => 'sample_masters', 'alias' => 'SampleMaster', 'type' => 'INNER', 'conditions' => array('aliquot_masters_dup.sample_master_id = SampleMaster.id'))),
				self::SOURCE_ID			=> 'CONCAT(Realiquoting.id, 2)',
				self::USE_DEFINITION	=> '"realiquoted to"',
				self::USE_CODE			=> 'AliquotMasterChildren.barcode',
				self::USE_DETAIL		=> '""',
				self::USE_VOLUME		=> 'Realiquoting.parent_used_volume',
				self::VOLUME_UNIT		=> 'AliquotControl.volume_unit',
				self::USE_DATETIME		=> 'Realiquoting.realiquoting_datetime',
				self::USE_BY			=> 'Realiquoting.realiquoted_by',
				self::CREATED			=> 'Realiquoting.created',
				self::DETAIL_URL		=> 'CONCAT("|inventorymanagement|aliquot_masters|listAllRealiquotedParents|",AliquotMasterChildren.collection_id,"|",AliquotMasterChildren.sample_master_id,"|",AliquotMasterChildren.id)',
				self::SAMPLE_MASTER_ID	=> 'SampleMaster.id',
				self::COLLECTION_ID		=> 'SampleMaster.collection_id'
			), "QualityCtrl" => array(
				self::PLUGIN			=> "Inventorymanagement",
				self::JOINS				=> array(
											AliquotMaster::joinOnAliquotDup('QualityCtrl.aliquot_master_id'),
											AliquotMaster::$join_aliquot_control_on_dup),
				self::SOURCE_ID			=> 'CONCAT(QualityCtrl.id, 3)',
				self::USE_DEFINITION	=> '"quality control"',
				self::USE_CODE			=> 'QualityCtrl.qc_code',
				self::USE_DETAIL		=> '""',
				self::USE_VOLUME		=> 'QualityCtrl.used_volume',
				self::VOLUME_UNIT		=> 'AliquotControl.volume_unit',
				self::USE_DATETIME		=> 'QualityCtrl.date',
				self::USE_BY			=> 'QualityCtrl.run_by',
				self::CREATED			=> 'QualityCtrl.created',
				self::DETAIL_URL		=> 'CONCAT("|inventorymanagement|quality_ctrls|detail|",AliquotMaster.collection_id,"|",AliquotMaster.sample_master_id,"|",QualityCtrl.id)',
				self::SAMPLE_MASTER_ID	=> 'SampleMaster.id',
				self::COLLECTION_ID		=> 'SampleMaster.collection_id'
			), "OrderItem" => array(
				self::PLUGIN			=> "Order",
				self::JOINS				=> array(
											AliquotMaster::joinOnAliquotDup('OrderItem.aliquot_master_id'),
											AliquotMaster::$join_aliquot_control_on_dup,
											array('table' => 'sample_masters' ,'alias' => 'SampleMaster', 'type' => 'INNER', 'conditions' => array('aliquot_masters_dup.sample_master_id = SampleMaster.id'))),
				self::SOURCE_ID			=> 'CONCAT(OrderItem.id, 4)',
				self::USE_DEFINITION	=> '"aliquot shipment"',
				self::USE_CODE			=> 'Shipment.shipment_code',
				self::USE_DETAIL		=> '""',
				self::USE_VOLUME		=> '""',
				self::VOLUME_UNIT		=> '""',
				self::USE_DATETIME		=> 'Shipment.datetime_shipped',
				self::USE_BY			=> 'Shipment.shipped_by',
				self::CREATED			=> 'Shipment.created',
				self::DETAIL_URL		=> 'CONCAT("|order|shipments|detail|",Shipment.order_id,"|",Shipment.id)',
				self::SAMPLE_MASTER_ID	=> 'SampleMaster.id',
				self::COLLECTION_ID		=> 'SampleMaster.collection_id'
			), "AliquotReviewMaster" => array(
				self::PLUGIN			=> "Inventorymanagement",
				self::JOINS				=> array(
											AliquotMaster::joinOnAliquotDup('AliquotReviewMaster.aliquot_master_id'),
											AliquotMaster::$join_aliquot_control_on_dup,
											array('table' => 'sample_masters' ,'alias' => 'SampleMaster', 'type' => 'INNER', 'conditions' => array('aliquot_masters_dup.sample_master_id = SampleMaster.id'))),
				self::SOURCE_ID			=> 'CONCAT(AliquotReviewMaster.id, 5)',
				self::USE_DEFINITION	=> '"specimen review"',
				self::USE_CODE			=> 'SpecimenReviewMaster.review_code',
				self::USE_DETAIL		=> '""',
				self::USE_VOLUME		=> '""',
				self::VOLUME_UNIT		=> '""',
				self::USE_DATETIME		=> 'SpecimenReviewMaster.review_date',
				self::USE_BY			=> '""',
				self::CREATED			=> 'AliquotReviewMaster.created',
				self::DETAIL_URL		=> 'CONCAT("|inventorymanagement|specimen_reviews|detail|",AliquotMaster.collection_id,"|",AliquotMaster.sample_master_id,"|",SpecimenReviewMaster.id)',
				self::SAMPLE_MASTER_ID	=> 'SampleMaster.id',
				self::COLLECTION_ID		=> 'SampleMaster.collection_id'
			), "AliquotInternalUse" => array(
				self::PLUGIN			=> "Inventorymanagement",
				self::JOINS				=> array(
											AliquotMaster::joinOnAliquotDup('AliquotInternalUse.aliquot_master_id'),
											AliquotMaster::$join_aliquot_control_on_dup,
											array('table' => 'sample_masters' ,'alias' => 'SampleMaster', 'type' => 'INNER', 'conditions' => array('aliquot_masters_dup.sample_master_id = SampleMaster.id'))),
				self::SOURCE_ID			=> 'CONCAT(AliquotInternalUse.id, 6)',
				self::USE_DEFINITION	=> '"internal use"',
				self::USE_CODE			=> 'AliquotInternalUse.use_code',
				self::USE_DETAIL		=> 'AliquotInternalUse.use_details',
				self::USE_VOLUME		=> 'AliquotInternalUse.used_volume',
				self::VOLUME_UNIT		=> 'AliquotControl.volume_unit',
				self::USE_DATETIME		=> 'AliquotInternalUse.use_datetime',
				self::USE_BY			=> 'AliquotInternalUse.used_by',
				self::CREATED			=> 'AliquotInternalUse.created',
				self::DETAIL_URL		=> 'CONCAT("|inventorymanagement|aliquot_masters|detailAliquotInternalUse|",AliquotMaster.id,"|",AliquotInternalUse.id)',
				self::SAMPLE_MASTER_ID	=> 'SampleMaster.id',
				self::COLLECTION_ID		=> 'SampleMaster.collection_id'
			)
		);
		$data = array();
		foreach($models_details as $model_name => $model_conf){
			$model = AppModel::getInstance($model_conf[self::PLUGIN], $model_name, true);
			$tmp_data = $model->find('all', array(
				'conditions' => array('AliquotMaster.id' => $aliquot_master_id),
				'joins' => $model_conf[self::JOINS],
				'fields' => array(
					$model_conf[self::SOURCE_ID].' AS id',
					'AliquotMaster.id AS aliquot_master_id',
					$model_conf[self::USE_DEFINITION].' AS use_definition',
					$model_conf[self::USE_CODE].' AS use_code',
					$model_conf[self::USE_DETAIL].' AS use_details',
					$model_conf[self::USE_VOLUME].' AS used_volume',
					$model_conf[self::VOLUME_UNIT].' AS aliquot_volume_unit',
					$model_conf[self::USE_DATETIME].' AS use_datetime',
					$model_conf[self::USE_BY].' AS used_by',
					$model_conf[self::CREATED],
					$model_conf[self::DETAIL_URL].' AS detail_url',
					$model_conf[self::SAMPLE_MASTER_ID].' AS sample_master_id',
					$model_conf[self::COLLECTION_ID].' AS collection_id'
				)
			));
			
			foreach($tmp_data as $result_unit){
				$current = array();
				foreach($result_unit as $fields){
					$current += $fields;
				}
				$data[]['ViewAliquotUse'] = $current;
			}
		}
		return $data;
	}

}

?>
