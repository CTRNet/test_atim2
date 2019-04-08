<?php
/** **********************************************************************
 * CUSM-CIM Project.
 * ***********************************************************************
 *
 * InventoryManagement plugin custom code
 *
 * Class ViewAliquotUseCustom
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-02-21
 */

class ViewAliquotUseCustom extends ViewAliquotUse
{
    const CUSM_CIM_DATETIME_REMOVE_FROM_STORAGE = 19;
    const CUSM_CIM_TIME_PACKAGED = 19;
    
    var $baseModel = "AliquotInternalUse";

    var $useTable = 'view_aliquot_uses';

    var $name = 'ViewAliquotUse';

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
		  cusm_cim_datetime_remove_from_storage datetime DEFAULT NULL,   
		  cusm_cim_datetime_remove_from_storage_accuracy char(1) DEFAULT NULL,
		  cusm_cim_time_packaged time DEFAULT NULL,
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
		AliquotInternalUse.cusm_cim_datetime_remove_from_storage AS cusm_cim_datetime_remove_from_storage,
        AliquotInternalUse.cusm_cim_datetime_remove_from_storage_accuracy AS cusm_cim_datetime_remove_from_storage_accuracy,
        AliquotInternalUse.cusm_cim_time_packaged AS cusm_cim_time_packaged,
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
		LEFT JOIN study_summaries AS StudySummary ON StudySummary.id = AliquotMaster.study_summary_id AND StudySummary.deleted != 1
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
		NULL AS cusm_cim_datetime_remove_from_storage,
        NULL AS cusm_cim_datetime_remove_from_storage_accuracy,
        NULL AS cusm_cim_time_packaged,
        NULL AS `duration`,
		'' AS `duration_unit`,
		DerivativeDetail.creation_by AS used_by,
		SourceAliquot.created AS created,
		CONCAT('/InventoryManagement/SampleMasters/detail/',SampleMaster.collection_id,'/',SampleMaster.id) AS detail_url,
		SampleMaster2.id AS sample_master_id,
		SampleMaster2.collection_id AS collection_id,
		StudySummary.id AS study_summary_id,
		StudySummary.title AS study_title
		FROM source_aliquots AS SourceAliquot
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = SourceAliquot.sample_master_id
		JOIN derivative_details AS DerivativeDetail ON SampleMaster.id = DerivativeDetail.sample_master_id
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = SourceAliquot.aliquot_master_id
		JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
		JOIN sample_masters SampleMaster2 ON SampleMaster2.id = AliquotMaster.sample_master_id
		LEFT JOIN study_summaries AS StudySummary ON StudySummary.id = AliquotMaster.study_summary_id AND StudySummary.deleted != 1
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
		NULL AS cusm_cim_datetime_remove_from_storage,
        NULL AS cusm_cim_datetime_remove_from_storage_accuracy,
        NULL AS cusm_cim_time_packaged,
        NULL AS duration,
		'' AS duration_unit,
		Realiquoting.realiquoted_by AS used_by,
		Realiquoting.created AS created,
		CONCAT('/InventoryManagement/AliquotMasters/detail/',AliquotMasterChild.collection_id,'/',AliquotMasterChild.sample_master_id,'/',AliquotMasterChild.id) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id,
		StudySummary.id AS study_summary_id,
		StudySummary.title AS study_title
		FROM realiquotings AS Realiquoting
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = Realiquoting.parent_aliquot_master_id
		JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
		JOIN aliquot_masters AS AliquotMasterChild ON AliquotMasterChild.id = Realiquoting.child_aliquot_master_id
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		LEFT JOIN study_summaries AS StudySummary ON StudySummary.id = AliquotMaster.study_summary_id AND StudySummary.deleted != 1
		WHERE Realiquoting.deleted <> 1 %%WHERE%%";
    
    
    
    /**
     * Get all use type available for search. 
     * Override function to hidde unused type.
     * 
     * @return array
     */
    public function getUseDefinitions()
    {
        $result = array(
            'realiquoted to' => __('realiquoted to')
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
    
}