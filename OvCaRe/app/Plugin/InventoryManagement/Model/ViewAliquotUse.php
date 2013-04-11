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
	
	//Don't put extra delete != 1 check on joined tables or this might result in deletion issues.
	static $table_create_query = "CREATE TABLE view_aliquot_uses (
		  id varchar(20) NOT NULL,
		  aliquot_master_id int NOT NULL,
		  use_definition varchar(50) NOT NULL DEFAULT '',
		  use_code varchar(250) NOT NULL DEFAULT '',
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
		  collection_id int(11) NOT NULL
			
		)";

	static $table_query =
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
		CONCAT('/InventoryManagement/AliquotMasters/detailAliquotInternalUse/',AliquotMaster.id,'/',AliquotInternalUse.id) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id
		FROM aliquot_internal_uses AS AliquotInternalUse
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = AliquotInternalUse.aliquot_master_id
		JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		WHERE AliquotInternalUse.deleted <> 1 %%WHERE%%
	
		UNION ALL
	
		SELECT CONCAT(SourceAliquot.id,1) AS `id`,
		AliquotMaster.id AS aliquot_master_id,
		CONCAT('sample derivative creation#', SampleMaster.sample_control_id) AS use_definition,
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
		CONCAT('/InventoryManagement/SampleMasters/detail/',SampleMaster.collection_id,'/',SampleMaster.id) AS detail_url,
		SampleMaster2.id AS sample_master_id,
		SampleMaster2.collection_id AS collection_id
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
		CONCAT('/InventoryManagement/AliquotMasters/detail/',AliquotMasterChild.collection_id,'/',AliquotMasterChild.sample_master_id,'/',AliquotMasterChild.id) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id
		FROM realiquotings AS Realiquoting
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = Realiquoting.parent_aliquot_master_id
		JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
		JOIN aliquot_masters AS AliquotMasterChild ON AliquotMasterChild.id = Realiquoting.child_aliquot_master_id
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		WHERE Realiquoting.deleted <> 1 %%WHERE%%
	
		UNION ALL
	
		SELECT CONCAT(QualityCtrl.id,3) AS id,
		AliquotMaster.id AS aliquot_master_id,
		'quality control' AS use_definition,
		QualityCtrl.qc_code AS use_code,
		'' AS use_details,
		QualityCtrl.used_volume AS used_volume,
		AliquotControl.volume_unit AS aliquot_volume_unit,
		QualityCtrl.date AS use_datetime,
		QualityCtrl.date_accuracy AS use_datetime_accuracy,
		'' AS duration,
		'' AS duration_unit,
		QualityCtrl.run_by AS used_by,
		QualityCtrl.created AS created,
		CONCAT('/InventoryManagement/QualityCtrls/detail/',AliquotMaster.collection_id,'/',AliquotMaster.sample_master_id,'/',QualityCtrl.id) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id
		FROM quality_ctrls AS QualityCtrl
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = QualityCtrl.aliquot_master_id
		JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		WHERE QualityCtrl.deleted <> 1 %%WHERE%%
	
		UNION ALL
	
		SELECT CONCAT(OrderItem.id,4) AS id,
		AliquotMaster.id AS aliquot_master_id,
		'aliquot shipment' AS use_definition,
		Shipment.shipment_code AS use_code,
		'' AS use_details,
		NULL AS used_volume,
		'' AS aliquot_volume_unit,
		Shipment.datetime_shipped AS use_datetime,
		Shipment.datetime_shipped_accuracy AS use_datetime_accuracy,
		'' AS duration,
		'' AS duration_unit,
		Shipment.shipped_by AS used_by,
		Shipment.created AS created,
		CONCAT('/Order/Shipments/detail/',Shipment.order_id,'/',Shipment.id) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id
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
		NULL AS used_volume,
		'' AS aliquot_volume_unit,
		SpecimenReviewMaster.review_date AS use_datetime,
		SpecimenReviewMaster.review_date_accuracy AS use_datetime_accuracy,
		'' AS duration,
		'' AS duration_unit,
		'' AS used_by,
		AliquotReviewMaster.created AS created,
		CONCAT('/InventoryManagement/SpecimenReviews/detail/',AliquotMaster.collection_id,'/',AliquotMaster.sample_master_id,'/',SpecimenReviewMaster.id) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id
		FROM aliquot_review_masters AS AliquotReviewMaster
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = AliquotReviewMaster.aliquot_master_id
		JOIN specimen_review_masters AS SpecimenReviewMaster ON SpecimenReviewMaster.id = AliquotReviewMaster.specimen_review_master_id
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		WHERE AliquotReviewMaster.deleted <> 1 %%WHERE%%";


	function getUseDefinitions() {
		$result = array(
				'aliquot shipment'	=> __('aliquot shipment'),
				'quality control'	=> __('quality control'),
				'internal use'	=> __('internal use'),
				'realiquoted to'	=> __('realiquoted to'),
				'specimen review'	=> __('specimen review'));

		// Add custom uses
		$lang = Configure::read('Config.language') == "eng" ? "en" : "fr";
		$StructurePermissibleValuesCustom = AppModel::getInstance('', 'StructurePermissibleValuesCustom', true);
		$use_and_event_types = $StructurePermissibleValuesCustom->find('all', array('conditions' => array('StructurePermissibleValuesCustomControl.name' => 'aliquot use and event types')));
		foreach($use_and_event_types as $new_type) $result[$new_type['StructurePermissibleValuesCustom']['value']] = strlen($new_type['StructurePermissibleValuesCustom'][$lang])? $new_type['StructurePermissibleValuesCustom'][$lang] : $new_type['StructurePermissibleValuesCustom']['value'];
		
		// Develop sample derivative creation
		$this->SampleControl = AppModel::getInstance("InventoryManagement", "SampleControl", true);
		$sample_controls = $this->SampleControl->getSampleTypePermissibleValuesFromId();
		foreach($sample_controls as $sampl_control_id => $sample_type) {
			$result['sample derivative creation#'.$sampl_control_id] = __('sample derivative creation#').$sample_type;
		}
		
		natcasesort($result);

		return $result;
	}
	
	//must respect concat(id, #) order
	private $models = array('SourceAliquot', 'Realiquoting', 'QualityCtrl', 'OrderItem', 'AliquotReviewMaster', 'AliquotInternalUse');
	
	function getPkeyAndModelToCheck($data){
		$pkey = null;
		$model = null;
		if(preg_match('/^([0-9]+)([0-9])$/', current(current($data)), $matches )){
			$pkey = $matches[1];
			$model_id = $matches[2];
			if($model_id < 7 && $model_id > 0){
				$model = $this->models[$model_id - 1];
			}else{
				AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
		}else{
			AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		return array('pkey' => $pkey, 'base_model' => $model);
	}

}