<?php

class ViewAliquotUseCustom extends ViewAliquotUse {

	var $useTable = 'view_aliquot_uses';	
	var $name = 'ViewAliquotUse';	
	
	function __construct(){
		$need_to_do_models_details = self::$models_details == null;
		parent::__construct();
		if($need_to_do_models_details){
			if(!class_exists('AliquotMaster', false)){
				AppModel::getInstance('InventoryManagement', 'AliquotMaster');
			}
			self::$models_details = array(
				"SourceAliquot" => array(
					self::PLUGIN			=> "InventoryManagement",
					self::JOINS				=> array(
												AliquotMaster::joinOnAliquotDup('SourceAliquot.aliquot_master_id'),
												AliquotMaster::$join_aliquot_control_on_dup,
												array('table' => 'sample_masters', 'alias' => 'sample_derivative', 'type' => 'INNER', 'conditions' => array('SourceAliquot.sample_master_id = sample_derivative.id')),
												array('table' => 'derivative_details', 'alias' => 'DerivativeDetail', 'type' => 'INNER', 'conditions' => array('sample_derivative.id = DerivativeDetail.sample_master_id')),
												array('table' => 'sample_masters', 'alias' => 'sample_source', 'type' => 'INNER', 'conditions' => array('aliquot_masters_dup.sample_master_id = sample_source.id'))),
					self::SOURCE_ID			=> 'CONCAT(SourceAliquot.id, 1)',
					self::USE_DEFINITION	=> '"sample derivative creation"',
					self::USE_CODE			=> 'SampleMaster.sample_code',
					self::USE_DETAIL		=> '""',
					self::USE_VOLUME		=> 'SourceAliquot.used_volume',
					self::VOLUME_UNIT		=> 'AliquotControl.volume_unit',
					self::USE_DATETIME		=> 'DerivativeDetail.creation_datetime',
					self::USE_DATETIME_ACCU	=> 'DerivativeDetail.creation_datetime_accuracy',
					self::USE_BY			=> 'DerivativeDetail.creation_by',
					self::CREATED			=> 'SourceAliquot.created',
					self::DETAIL_URL		=> 'CONCAT("/InventoryManagement/SampleMasters/detail/",sample_derivative.collection_id ,"/",sample_derivative.id)',
					self::SAMPLE_MASTER_ID	=> 'sample_source.id',
					self::COLLECTION_ID		=> 'sample_source.collection_id'
				), "Realiquoting" => array(
					self::PLUGIN			=> "InventoryManagement",
					self::JOINS				=> array(
												AliquotMaster::joinOnAliquotDup('Realiquoting.parent_aliquot_master_id'),
												AliquotMaster::$join_aliquot_control_on_dup,
												array('table' => 'sample_masters', 'alias' => 'SampleMaster', 'type' => 'INNER', 'conditions' => array('aliquot_masters_dup.sample_master_id = SampleMaster.id'))),
					self::SOURCE_ID			=> 'CONCAT(Realiquoting.id, 2)',
					self::USE_DEFINITION	=> '"realiquoted to"',
					self::USE_CODE			=> "CONCAT(AliquotMasterChildren.aliquot_label, ' (', AliquotMasterChildren.barcode, ')')", //'AliquotMasterChildren.barcode',
					self::USE_DETAIL		=> '""',
					self::USE_VOLUME		=> 'Realiquoting.parent_used_volume',
					self::VOLUME_UNIT		=> 'AliquotControl.volume_unit',
					self::USE_DATETIME		=> 'Realiquoting.realiquoting_datetime',
					self::USE_DATETIME_ACCU	=> 'Realiquoting.realiquoting_datetime_accuracy',
					self::USE_BY			=> 'Realiquoting.realiquoted_by',
					self::CREATED			=> 'Realiquoting.created',
					self::DETAIL_URL		=> 'CONCAT("/InventoryManagement/AliquotMasters/detail/",AliquotMasterChildren.collection_id,"/",AliquotMasterChildren.sample_master_id,"/",AliquotMasterChildren.id)',
					self::SAMPLE_MASTER_ID	=> 'SampleMaster.id',
					self::COLLECTION_ID		=> 'SampleMaster.collection_id'
				), "QualityCtrl" => array(
					self::PLUGIN			=> "InventoryManagement",
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
					self::USE_DATETIME_ACCU	=> 'QualityCtrl.date_accuracy',
					self::USE_BY			=> 'QualityCtrl.run_by',
					self::CREATED			=> 'QualityCtrl.created',
					self::DETAIL_URL		=> 'CONCAT("/InventoryManagement/QualityCtrls/detail/",AliquotMaster.collection_id,"/",AliquotMaster.sample_master_id,"/",QualityCtrl.id)',
					self::SAMPLE_MASTER_ID	=> 'SampleMaster.id',
					self::COLLECTION_ID		=> 'SampleMaster.collection_id'
				), "OrderItem" => array(
					self::PLUGIN			=> "Order",
					self::JOINS				=> array(
												AliquotMaster::joinOnAliquotDup('OrderItem.aliquot_master_id'),
												AliquotMaster::$join_aliquot_control_on_dup,
												array('table' => 'sample_masters' ,'alias' => 'SampleMaster', 'type' => 'INNER', 'conditions' => array('aliquot_masters_dup.sample_master_id = SampleMaster.id', 'OrderItem.shipment_id IS NOT NULL'))),
					self::SOURCE_ID			=> 'CONCAT(OrderItem.id, 4)',
					self::USE_DEFINITION	=> '"aliquot shipment"',
					self::USE_CODE			=> 'Shipment.shipment_code',
					self::USE_DETAIL		=> '""',
					self::USE_VOLUME		=> '""',
					self::VOLUME_UNIT		=> '""',
					self::USE_DATETIME		=> 'Shipment.datetime_shipped',
					self::USE_DATETIME_ACCU	=> 'Shipment.datetime_shipped_accuracy',
					self::USE_BY			=> 'Shipment.shipped_by',
					self::CREATED			=> 'Shipment.created',
					self::DETAIL_URL		=> 'CONCAT("/Order/Shipments/detail/",Shipment.order_id,"/",Shipment.id)',
					self::SAMPLE_MASTER_ID	=> 'SampleMaster.id',
					self::COLLECTION_ID		=> 'SampleMaster.collection_id'
				), "AliquotReviewMaster" => array(
					self::PLUGIN			=> "InventoryManagement",
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
					self::USE_DATETIME_ACCU	=> 'SpecimenReviewMaster.review_date_accuracy',
					self::USE_BY			=> '""',
					self::CREATED			=> 'AliquotReviewMaster.created',
					self::DETAIL_URL		=> 'CONCAT("/InventoryManagement/SpecimenReviews/detail/",AliquotMaster.collection_id,"/",AliquotMaster.sample_master_id,"/",SpecimenReviewMaster.id)',
					self::SAMPLE_MASTER_ID	=> 'SampleMaster.id',
					self::COLLECTION_ID		=> 'SampleMaster.collection_id'
				), "AliquotInternalUse" => array(
					self::PLUGIN			=> "InventoryManagement",
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
					self::USE_DATETIME_ACCU	=> 'AliquotInternalUse.use_datetime_accuracy',
					self::USE_BY			=> 'AliquotInternalUse.used_by',
					self::CREATED			=> 'AliquotInternalUse.created',
					self::DETAIL_URL		=> 'CONCAT("/InventoryManagement/AliquotMasters/detailAliquotInternalUse/",AliquotMaster.id,"/",AliquotInternalUse.id)',
					self::SAMPLE_MASTER_ID	=> 'SampleMaster.id',
					self::COLLECTION_ID		=> 'SampleMaster.collection_id'
				)
			);
		}
	}
}
