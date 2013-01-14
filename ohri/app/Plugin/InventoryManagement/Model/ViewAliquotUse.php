<?php

class ViewAliquotUse extends InventoryManagementAppModel {
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
	const USE_DATETIME_ACCU = 14;
	const DURATION = 15;
	const DURATION_UNIT = 16;

	var $base_model = "AliquotInternalUse";
	var $base_plugin = 'InventoryManagement';
	var $useTable = false;
	
	//Don't put extra delete != 1 check on joined tables or this might result in deletion issues.
	static $table_create_query = "CREATE TABLE view_aliquot_uses (
		  id varchar(20) NOT NULL,
		  aliquot_master_id int NOT NULL,
		  use_definition varchar(50) NOT NULL DEFAULT '',
		  use_code varchar(50) NOT NULL DEFAULT '',
		  use_details VARchar(250) NOT NULL DEFAULT '',
		  used_volume decimal(10,5) DEFAULT NULL,
		  aliquot_volume_unit varchar(20) DEFAULT NULL,
		  use_datetime datetime DEFAULT NULL,
		  use_datetime_accuracy char(1) NOT NULL DEFAULT '',
		  duration VARCHAR(250) NOT NULL DEFAULT '',
		  duration_unit VARCHAR(250) NOT NULL DEFAULT '',
		  used_by VARCHAR(50) DEFAULT NULL,
		  created datetime NOT NULL,
		  detail_url varchar(250) NOT NULL DEFAULT '',
		  sample_master_id int(11) NOT NULL,
		  collection_id int(11) NOT NULL,
			
		  aliquot_internal_use_id int(10) UNSIGNED DEFAULT NULL UNIQUE,
		  source_aliquot_id int(10) UNSIGNED DEFAULT NULL UNIQUE,
		  realiquoting_id int(10) UNSIGNED DEFAULT NULL UNIQUE,
		  quality_control_id int(10) UNSIGNED DEFAULT NULL UNIQUE,
		  order_item_id int(10) UNSIGNED DEFAULT NULL UNIQUE,
		  aliquot_review_master_id int(10) UNSIGNED DEFAULT NULL UNIQUE
		)";

	static $table_query =
		//This must be the first table, otherwise creation based on '' AS pwet makes pwet a CHAR(0) 
		"SELECT CONCAT(AliquotInternalUse.id,6) AS id,
		AliquotMaster.id AS aliquot_master_id,
		AliquotInternalUse.type AS use_definition,
		AliquotInternalUse.use_code AS use_code,
		AliquotInternalUse.use_details AS use_details,
		AliquotInternalUse.used_volume AS used_volume,
		AliquotControl.volume_unit AS aliquot_volume_unit,
		AliquotInternalUse.use_datetime AS use_datetime,
		AliquotInternalUse.use_datetime_accuracy AS use_datetime_accuracy,
		AliquotInternalUse.duration AS duration,
		AliquotInternalUse.duration_unit AS duration_unit,
		AliquotInternalUse.used_by AS used_by,
		AliquotInternalUse.created AS created,
		CONCAT('/inventorymanagement/aliquot_masters/detailAliquotInternalUse/',AliquotMaster.id,'/',AliquotInternalUse.id) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id,
		AliquotInternalUse.id AS aliquot_internal_use_id,
		NULL AS source_aliquot_id,
		NULL AS realiquoting_id,
		NULL AS quality_ctrl_id,
		NULL AS order_item_id,
		NULL AS aliquot_review_master_id
		FROM aliquot_internal_uses AS AliquotInternalUse
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = AliquotInternalUse.aliquot_master_id
		JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		WHERE AliquotInternalUse.deleted <> 1 %%WHERE%%
	
		UNION ALL
	
		SELECT CONCAT(SourceAliquot.id,1) AS `id`,
		AliquotMaster.id AS aliquot_master_id,
		'sample derivative creation' AS use_definition,
		SampleMaster.sample_code AS use_code,
		'' AS `use_details`,
		SourceAliquot.used_volume AS used_volume,
		AliquotControl.volume_unit AS aliquot_volume_unit,
		DerivativeDetail.creation_datetime AS use_datetime,
		DerivativeDetail.creation_datetime_accuracy AS use_datetime_accuracy,
		'' AS `duration`,
		'' AS `duration_unit`,
		DerivativeDetail.creation_by AS used_by,
		SourceAliquot.created AS created,
		CONCAT('inventorymanagement/aliquot_masters/listAllSourceAliquots/',SampleMaster.collection_id,'/',SampleMaster.id) AS detail_url,
		SampleMaster2.id AS sample_master_id,
		SampleMaster2.collection_id AS collection_id,
		NULL AS aliquot_internal_use_id,
		SourceAliquot.id AS source_aliquot_id,
		NULL AS realiquoting_id,
		NULL AS quality_ctrl_id,
		NULL AS order_item_id,
		NULL AS aliquot_review_master_id
		FROM source_aliquots AS SourceAliquot
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = SourceAliquot.sample_master_id
		JOIN derivative_details AS DerivativeDetail ON SampleMaster.id = DerivativeDetail.sample_master_id
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = SourceAliquot.aliquot_master_id
		JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
		JOIN sample_masters SampleMaster2 ON SampleMaster2.id = AliquotMaster.sample_master_id
		WHERE SourceAliquot.deleted <> 1 %%WHERE%%
	
		UNION ALL
	
		SELECT CONCAT(Realiquoting.id ,2) AS id,
		AliquotMaster.id AS aliquot_master_id,
		'realiquoted to' AS use_definition,
		AliquotMasterChild.barcode AS use_code,
		'' AS use_details,
		Realiquoting.parent_used_volume AS used_volume,
		AliquotControl.volume_unit AS aliquot_volume_unit,
		Realiquoting.realiquoting_datetime AS use_datetime,
		Realiquoting.realiquoting_datetime_accuracy AS use_datetime_accuracy,
		'' AS duration,
		'' AS duration_unit,
		Realiquoting.realiquoted_by AS used_by,
		Realiquoting.created AS created,
		CONCAT('/inventorymanagement/aliquot_masters/listAllRealiquotedParents/',AliquotMasterChild.collection_id,'/',AliquotMasterChild.sample_master_id,'/',AliquotMasterChild.id) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id,
		NULL AS aliquot_internal_use_id,
		NULL AS source_aliquot_id,
		Realiquoting.id AS realiquoting_id,
		NULL AS quality_ctrl_id,
		NULL AS order_item_id,
		NULL AS aliquot_review_master_id
		FROM realiquotings AS Realiquoting
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = Realiquoting.parent_aliquot_master_id
		JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
		JOIN aliquot_masters AS AliquotMasterChild ON AliquotMasterChild.id = Realiquoting.child_aliquot_master_id
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		WHERE Realiquoting.deleted <> 1 %%WHERE%%
	
		UNION ALL
	
		SELECT CONCAT(QualityControl.id,3) AS id,
		AliquotMaster.id AS aliquot_master_id,
		'quality control' AS use_definition,
		QualityControl.qc_code AS use_code,
		'' AS use_details,
		QualityControl.used_volume AS used_volume,
		AliquotControl.volume_unit AS aliquot_volume_unit,
		QualityControl.date AS use_datetime,
		QualityControl.date_accuracy AS use_datetime_accuracy,
		'' AS duration,
		'' AS duration_unit,
		QualityControl.run_by AS used_by,
		QualityControl.created AS created,
		concat('/inventorymanagement/quality_ctrls/detail/',AliquotMaster.collection_id,'/',AliquotMaster.sample_master_id,'/',QualityControl.id) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id,
		NULL AS aliquot_internal_use_id,
		NULL AS source_aliquot_id,
		NULL AS realiquoting_id,
		QualityControl.id AS quality_control_id,
		NULL AS order_item_id,
		NULL AS aliquot_review_master_id
		FROM quality_ctrls AS QualityControl
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = QualityControl.aliquot_master_id
		JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		WHERE QualityControl.deleted <> 1 %%WHERE%%
	
		UNION ALL
	
		SELECT CONCAT(OrderItem.id,4) AS id,
		AliquotMaster.id AS aliquot_master_id,
		'aliquot shipment' AS use_definition,
		Shipment.shipment_code AS use_code,
		'' AS use_details,
		'' AS used_volume,
		'' AS aliquot_volume_unit,
		Shipment.datetime_shipped AS use_datetime,
		Shipment.datetime_shipped_accuracy AS use_datetime_accuracy,
		'' AS duration,
		'' AS duration_unit,
		Shipment.shipped_by AS used_by,
		Shipment.created AS created,
		CONCAT('/order/shipments/detail/',Shipment.order_id,'/',Shipment.id) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id,
		NULL AS aliquot_internal_use_id,
		NULL AS source_aliquot_id,
		NULL AS realiquoting_id,
		NULL AS quality_ctrl_id,
		OrderItem.id AS order_item_id,
		NULL AS aliquot_review_master_id
		FROM order_items OrderItem
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = OrderItem.aliquot_master_id
		JOIN shipments AS Shipment ON Shipment.id = OrderItem.shipment_id
		JOIN sample_masters SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		WHERE OrderItem.deleted <> 1 %%WHERE%%
	
		UNION ALL
	
		SELECT CONCAT(AliquotReviewMaster.id,5) AS id,
		AliquotMaster.id AS aliquot_master_id,
		'specimen review' AS use_definition,
		SpecimenReviewMaster.review_code AS use_code,
		'' AS use_details,
		'' AS used_volume,
		'' AS aliquot_volume_unit,
		SpecimenReviewMaster.review_date AS use_datetime,
		SpecimenReviewMaster.review_date_accuracy AS use_datetime_accuracy,
		'' AS duration,
		'' AS duration_unit,
		'' AS used_by,
		AliquotReviewMaster.created AS created,
		CONCAT('/inventorymanagement/specimen_reviews/detail/',AliquotMaster.collection_id,'/',AliquotMaster.sample_master_id,'/',SpecimenReviewMaster.id) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id,
		NULL AS aliquot_internal_use_id,
		NULL AS source_aliquot_id,
		NULL AS realiquoting_id,
		NULL AS quality_ctrl_id,
		NULL AS order_item_id,
		AliquotReviewMaster.id AS aliquot_review_master_id
		FROM aliquot_review_masters AS AliquotReviewMaster
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = AliquotReviewMaster.aliquot_master_id
		JOIN specimen_review_masters AS SpecimenReviewMaster ON SpecimenReviewMaster.id = AliquotReviewMaster.specimen_review_master_id
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		WHERE AliquotReviewMaster.deleted <> 1 %%WHERE%%";

	static protected $models_details = null;

	function __construct(){
		parent::__construct();
		if(self::$models_details == null){
			if(!class_exists('AliquotMaster', false)){
				AppModel::getInstance('InventoryManagement', 'AliquotMaster', true);
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
							self::DURATION			=> '""',
							self::DURATION_UNIT			=> '""',
							self::USE_BY			=> 'DerivativeDetail.creation_by',
							self::CREATED			=> 'SourceAliquot.created',
							self::DETAIL_URL		=> 'CONCAT("/InventoryManagement/SampleMasters/detail/",sample_derivative.collection_id ,"/",sample_derivative.id)',
							self::SAMPLE_MASTER_ID	=> 'sample_source.id',
							self::COLLECTION_ID		=> 'sample_source.collection_id'),
						
					"Realiquoting" => array(
							self::PLUGIN			=> "InventoryManagement",
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
							self::USE_DATETIME_ACCU	=> 'Realiquoting.realiquoting_datetime_accuracy',
							self::DURATION			=> '""',
							self::DURATION_UNIT			=> '""',
							self::USE_BY			=> 'Realiquoting.realiquoted_by',
							self::CREATED			=> 'Realiquoting.created',
							self::DETAIL_URL		=> 'CONCAT("/InventoryManagement/AliquotMasters/detail/",AliquotMasterChildren.collection_id,"/",AliquotMasterChildren.sample_master_id,"/",AliquotMasterChildren.id)',
							self::SAMPLE_MASTER_ID	=> 'SampleMaster.id',
							self::COLLECTION_ID		=> 'SampleMaster.collection_id'),

					"QualityCtrl" => array(
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
							self::DURATION			=> '""',
							self::DURATION_UNIT			=> '""',
							self::USE_DATETIME		=> 'QualityCtrl.date',
							self::USE_DATETIME_ACCU	=> 'QualityCtrl.date_accuracy',
							self::USE_BY			=> 'QualityCtrl.run_by',
							self::CREATED			=> 'QualityCtrl.created',
							self::DETAIL_URL		=> 'CONCAT("/InventoryManagement/QualityCtrls/detail/",AliquotMaster.collection_id,"/",AliquotMaster.sample_master_id,"/",QualityCtrl.id)',
							self::SAMPLE_MASTER_ID	=> 'SampleMaster.id',
							self::COLLECTION_ID		=> 'SampleMaster.collection_id'),
						
					"OrderItem" => array(
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
							self::DURATION			=> '""',
							self::DURATION_UNIT			=> '""',
							self::USE_BY			=> 'Shipment.shipped_by',
							self::CREATED			=> 'Shipment.created',
							self::DETAIL_URL		=> 'CONCAT("/Order/Shipments/detail/",Shipment.order_id,"/",Shipment.id)',
							self::SAMPLE_MASTER_ID	=> 'SampleMaster.id',
							self::COLLECTION_ID		=> 'SampleMaster.collection_id'),
						
					"AliquotReviewMaster" => array(
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
							self::DURATION			=> '""',
							self::DURATION_UNIT			=> '""',
							self::USE_BY			=> '""',
							self::CREATED			=> 'AliquotReviewMaster.created',
							self::DETAIL_URL		=> 'CONCAT("/InventoryManagement/SpecimenReviews/detail/",AliquotMaster.collection_id,"/",AliquotMaster.sample_master_id,"/",SpecimenReviewMaster.id)',
							self::SAMPLE_MASTER_ID	=> 'SampleMaster.id',
							self::COLLECTION_ID		=> 'SampleMaster.collection_id'),
						
					"AliquotInternalUse" => array(
							self::PLUGIN			=> "InventoryManagement",
							self::JOINS				=> array(
									AliquotMaster::joinOnAliquotDup('AliquotInternalUse.aliquot_master_id'),
									AliquotMaster::$join_aliquot_control_on_dup,
									array('table' => 'sample_masters' ,'alias' => 'SampleMaster', 'type' => 'INNER', 'conditions' => array('aliquot_masters_dup.sample_master_id = SampleMaster.id'))),
							self::SOURCE_ID			=> 'CONCAT(AliquotInternalUse.id, 6)',
							self::USE_DEFINITION	=> 'AliquotInternalUse.type',
							self::USE_CODE			=> 'AliquotInternalUse.use_code',
							self::USE_DETAIL		=> 'AliquotInternalUse.use_details',
							self::USE_VOLUME		=> 'AliquotInternalUse.used_volume',
							self::VOLUME_UNIT		=> 'AliquotControl.volume_unit',
							self::USE_DATETIME		=> 'AliquotInternalUse.use_datetime',
							self::USE_DATETIME_ACCU	=> 'AliquotInternalUse.use_datetime_accuracy',
							self::DURATION			=> 'AliquotInternalUse.duration',
							self::DURATION_UNIT		=> 'AliquotInternalUse.duration_unit',
							self::USE_BY			=> 'AliquotInternalUse.used_by',
							self::CREATED			=> 'AliquotInternalUse.created',
							self::DETAIL_URL		=> 'CONCAT("/InventoryManagement/AliquotMasters/detailAliquotInternalUse/",AliquotMaster.id,"/",AliquotInternalUse.id)',
							self::SAMPLE_MASTER_ID	=> 'SampleMaster.id',
							self::COLLECTION_ID		=> 'SampleMaster.collection_id'
					)
			);
		}
	}

	function findFastFromAliquotMasterId($aliquot_master_id){

		$data = array();
		foreach(self::$models_details as $model_name => $model_conf){
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
							$model_conf[self::USE_DATETIME_ACCU].' AS use_datetime_accuracy',
							$model_conf[self::DURATION].' AS duration',
							$model_conf[self::DURATION_UNIT].' AS duration_unit',
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

	function getUseDefinitions() {
		$result = array(
				'aliquot shipment'	=> __('aliquot shipment'),
				'quality control'	=> __('quality control'),
				'internal use'	=> __('internal use'),
				'sample derivative creation'	=> __('sample derivative creation'),
				'realiquoted to'	=> __('realiquoted to'),
				'specimen review'	=> __('specimen review'));

		$lang = Configure::read('Config.language') == "eng" ? "en" : "fr";

		$StructurePermissibleValuesCustom = AppModel::getInstance('', 'StructurePermissibleValuesCustom', true);
		$use_and_event_types = $StructurePermissibleValuesCustom->find('all', array('conditions' => array('StructurePermissibleValuesCustomControl.name' => 'aliquot use and event types')));

		foreach($use_and_event_types as $new_type) $result[$new_type['StructurePermissibleValuesCustom']['value']] = strlen($new_type['StructurePermissibleValuesCustom'][$lang])? $new_type['StructurePermissibleValuesCustom'][$lang] : $new_type['StructurePermissibleValuesCustom']['value'];
		asort($result);

		return $result;
	}

}

?>
