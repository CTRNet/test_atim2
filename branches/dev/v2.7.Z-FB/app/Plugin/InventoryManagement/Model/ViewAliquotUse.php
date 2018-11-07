<?php

/**
 * Class ViewAliquotUse
 */
class ViewAliquotUse extends InventoryManagementAppModel
{

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

    const STUDY_SUMMARY_ID = 17;

    const STUDY_TITLE = 18;

    public $baseModel = "AliquotInternalUse";

    public $basePlugin = 'InventoryManagement';
    
    // Don't put extra delete != 1 check on joined tables or this might result in deletion issues.
    public static $tableCreateQuery = "CREATE TABLE view_aliquot_uses (
		  id int(20) NOT NULL,
		  aliquot_master_id int NOT NULL,
		  use_definition varchar(50) DEFAULT NULL,
		  use_code varchar(250) DEFAULT NULL,
		  use_details VARchar(250) DEFAULT NULL,
		  used_volume decimal(10,5) DEFAULT NULL,
		  aliquot_volume_unit varchar(20) DEFAULT NULL,
		  use_datetime datetime DEFAULT NULL,
		  use_datetime_accuracy char(1) DEFAULT NULL,
		  duration int(6) DEFAULT NULL,
		  duration_unit VARCHAR(250) DEFAULT NULL,
		  used_by VARCHAR(50) DEFAULT NULL,
		  created datetime DEFAULT NULL,
		  detail_url varchar(250) DEFAULT NULL,
		  sample_master_id int(11) NOT NULL,
		  collection_id int(11) NOT NULL,
		  study_summary_id int(11) DEFAULT NULL,
		  study_summary_title varchar(45) DEFAULT NULL
		)";

    public static $tableQuery = "SELECT CONCAT(AliquotInternalUse.id,6) AS id,
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
		SampleMaster.collection_id AS collection_id,
		StudySummary.id AS study_summary_id,
		StudySummary.title AS study_title
		FROM aliquot_internal_uses AS AliquotInternalUse
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = AliquotInternalUse.aliquot_master_id
		JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		LEFT JOIN study_summaries AS StudySummary ON StudySummary.id = AliquotInternalUse.study_summary_id AND StudySummary.deleted != 1
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
		NULL AS `duration`,
		'' AS `duration_unit`,
		DerivativeDetail.creation_by AS used_by,
		SourceAliquot.created AS created,
		CONCAT('/InventoryManagement/SampleMasters/detail/',SampleMaster.collection_id,'/',SampleMaster.id) AS detail_url,
		SampleMaster2.id AS sample_master_id,
		SampleMaster2.collection_id AS collection_id,
		NULL AS study_summary_id,
		'' AS study_title
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
		NULL AS duration,
		'' AS duration_unit,
		Realiquoting.realiquoted_by AS used_by,
		Realiquoting.created AS created,
		CONCAT('/InventoryManagement/AliquotMasters/detail/',AliquotMasterChild.collection_id,'/',AliquotMasterChild.sample_master_id,'/',AliquotMasterChild.id) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id,
		NULL AS study_summary_id,
		'' AS study_title
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
		NULL AS duration,
		'' AS duration_unit,
		QualityCtrl.run_by AS used_by,
		QualityCtrl.created AS created,
		CONCAT('/InventoryManagement/QualityCtrls/detail/',AliquotMaster.collection_id,'/',AliquotMaster.sample_master_id,'/',QualityCtrl.id) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id,
		NULL AS study_summary_id,
		'' AS study_title
		FROM quality_ctrls AS QualityCtrl
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = QualityCtrl.aliquot_master_id
		JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		WHERE QualityCtrl.deleted <> 1 %%WHERE%%
	
		UNION ALL
		
		SELECT CONCAT(OrderItem.id, 4) AS id,
		AliquotMaster.id AS aliquot_master_id,
		IF(OrderItem.shipment_id, 'aliquot shipment', 'order preparation') AS use_definition,
		IF(OrderItem.shipment_id, Shipment.shipment_code, Order.order_number) AS use_code,
		'' AS use_details,
		NULL AS used_volume,
		'' AS aliquot_volume_unit,
		IF(OrderItem.shipment_id, Shipment.datetime_shipped, OrderItem.date_added) AS use_datetime,
		IF(OrderItem.shipment_id, Shipment.datetime_shipped_accuracy, IF(OrderItem.date_added_accuracy = 'c', 'h', OrderItem.date_added_accuracy)) AS use_datetime_accuracy,
		NULL AS duration,
		'' AS duration_unit,
		IF(OrderItem.shipment_id, Shipment.shipped_by, OrderItem.added_by) AS used_by,
		IF(OrderItem.shipment_id, Shipment.created, OrderItem.created) AS created,
		IF(OrderItem.shipment_id,
				CONCAT('/Order/Shipments/detail/',OrderItem.order_id,'/',OrderItem.shipment_id),
				IF(OrderItem.order_line_id,
						CONCAT('/Order/OrderLines/detail/',OrderItem.order_id,'/',OrderItem.order_line_id),
						CONCAT('/Order/Orders/detail/',OrderItem.order_id))
		) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id,
		IF(OrderLine.study_summary_id, OrderLine.study_summary_id, Order.default_study_summary_id) AS study_summary_id,
		IF(OrderLine.study_summary_id, OrderLineStudySummary.title, OrderStudySummary.title) AS study_title
		FROM order_items OrderItem
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = OrderItem.aliquot_master_id
		LEFT JOIN shipments AS Shipment ON Shipment.id = OrderItem.shipment_id
		JOIN sample_masters SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		LEFT JOIN order_lines AS OrderLine ON  OrderLine.id = OrderItem.order_line_id
		LEFT JOIN study_summaries AS OrderLineStudySummary ON OrderLineStudySummary.id = OrderLine.study_summary_id AND OrderLineStudySummary.deleted != 1
		JOIN `orders` AS `Order` ON  Order.id = OrderItem.order_id
		LEFT JOIN study_summaries AS OrderStudySummary ON OrderStudySummary.id = Order.default_study_summary_id AND OrderStudySummary.deleted != 1
		WHERE OrderItem.deleted <> 1 %%WHERE%%
		
		UNION ALL
		
		SELECT CONCAT(OrderItem.id, 7) AS id,
		AliquotMaster.id AS aliquot_master_id,
		'shipped aliquot return' AS use_definition,
		Shipment.shipment_code AS use_code,
		'' AS use_details,
		NULL AS used_volume,
		'' AS aliquot_volume_unit,
		OrderItem.date_returned AS use_datetime,
		IF(OrderItem.date_returned_accuracy = 'c', 'h', OrderItem.date_returned_accuracy) AS use_datetime_accuracy,
		NULL AS duration,
		'' AS duration_unit,
		OrderItem.reception_by AS used_by,
		OrderItem.modified AS created,
		CONCAT('/Order/Shipments/detail/',OrderItem.order_id,'/',OrderItem.shipment_id) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id,
		IF(OrderLine.study_summary_id, OrderLine.study_summary_id, Order.default_study_summary_id) AS study_summary_id,
		IF(OrderLine.study_summary_id, OrderLineStudySummary.title, OrderStudySummary.title) AS study_title
		FROM order_items OrderItem
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = OrderItem.aliquot_master_id
		JOIN shipments AS Shipment ON Shipment.id = OrderItem.shipment_id
		JOIN sample_masters SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		LEFT JOIN order_lines AS OrderLine ON  OrderLine.id = OrderItem.order_line_id
		LEFT JOIN study_summaries AS OrderLineStudySummary ON OrderLineStudySummary.id = OrderLine.study_summary_id AND OrderLineStudySummary.deleted != 1
		JOIN `orders` AS `Order` ON  Order.id = OrderItem.order_id
		LEFT JOIN study_summaries AS OrderStudySummary ON OrderStudySummary.id = Order.default_study_summary_id AND OrderStudySummary.deleted != 1
		WHERE OrderItem.deleted <> 1 AND OrderItem.status = 'shipped & returned' %%WHERE%%
		
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
		NULL AS duration,
		'' AS duration_unit,
		'' AS used_by,
		AliquotReviewMaster.created AS created,
		CONCAT('/InventoryManagement/SpecimenReviews/detail/',AliquotMaster.collection_id,'/',AliquotMaster.sample_master_id,'/',SpecimenReviewMaster.id) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id,
		NULL AS study_summary_id,
		'' AS study_title
		FROM aliquot_review_masters AS AliquotReviewMaster
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = AliquotReviewMaster.aliquot_master_id
		JOIN specimen_review_masters AS SpecimenReviewMaster ON SpecimenReviewMaster.id = AliquotReviewMaster.specimen_review_master_id
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		WHERE AliquotReviewMaster.deleted <> 1 %%WHERE%%";

    /**
     *
     * @return array
     */
    public function getUseDefinitions()
    {
        $result = array(
            'aliquot shipment' => __('aliquot shipment'),
            'shipped aliquot return' => __('shipped aliquot return'),
            'order preparation' => __('order preparation'),
            'quality control' => __('quality control'),
            'internal use' => __('internal use'),
            'realiquoted to' => __('realiquoted to'),
            'specimen review' => __('specimen review')
        );
        
        // Add custom uses
        $lang = Configure::read('Config.language') == "eng" ? "en" : "fr";
        $structurePermissibleValuesCustom = AppModel::getInstance('', 'StructurePermissibleValuesCustom', true);
        $useAndEventTypes = $structurePermissibleValuesCustom->find('all', array(
            'conditions' => array(
                'StructurePermissibleValuesCustomControl.name' => 'aliquot use and event types'
            )
        ));
        foreach ($useAndEventTypes as $newType)
            $result[$newType['StructurePermissibleValuesCustom']['value']] = strlen($newType['StructurePermissibleValuesCustom'][$lang]) ? $newType['StructurePermissibleValuesCustom'][$lang] : $newType['StructurePermissibleValuesCustom']['value'];
            
            // Develop sample derivative creation
        $this->SampleControl = AppModel::getInstance("InventoryManagement", "SampleControl", true);
        $sampleControls = $this->SampleControl->getSampleTypePermissibleValuesFromId();
        foreach ($sampleControls as $samplControlId => $sampleType) {
            $result['sample derivative creation#' . $samplControlId] = __('sample derivative creation#') . $sampleType;
        }
        
        natcasesort($result);
        
        return $result;
    }
    
    // must respect concat(id, #) order
    private $models = array(
        'SourceAliquot',
        'Realiquoting',
        'QualityCtrl',
        'OrderItem',
        'AliquotReviewMaster',
        'AliquotInternalUse',
        'OrderItem'
    );

    /**
     *
     * @param $data
     * @return array
     */
    public function getPkeyAndModelToCheck($data)
    {
        $pkey = null;
        $model = null;
        if (preg_match('/^([0-9]+)([0-9])$/', current(current($data)), $matches)) {
            $pkey = $matches[1];
            $modelId = $matches[2];
            if ($modelId < 8 && $modelId > 0) {
                $model = $this->models[$modelId - 1];
            } else {
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
        } else {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        return array(
            'pkey' => $pkey,
            'base_model' => $model
        );
    }
}