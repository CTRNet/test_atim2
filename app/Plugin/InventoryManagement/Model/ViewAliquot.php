<?php
 /**
 *
 * ATiM - Advanced Tissue Management Application
 * Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 *
 * Licensed under GNU General Public License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @author        Canadian Tissue Repository Network <info@ctrnet.ca>
 * @copyright     Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 * @link          http://www.ctrnet.ca
 * @since         ATiM v 2
 * @license       http://www.gnu.org/licenses  GNU General Public License
 */

/**
 * Class ViewAliquot
 */
class ViewAliquot extends InventoryManagementAppModel
{

    public $primaryKey = 'aliquot_master_id';

    public $baseModel = "AliquotMaster";

    public $basePlugin = 'InventoryManagement';

    public $actsAs = array(
        'MinMax',
        'OrderByTranslate' => array(
            'initial_specimen_sample_type',
            'parent_sample_type',
            'sample_type',
            'aliquot_type'
        )
    );

    public $belongsTo = array(
        'AliquotControl' => array(
            'className' => 'InventoryManagement.AliquotControl',
            'foreignKey' => 'aliquot_control_id',
            'type' => 'INNER'
        ),
        'AliquotMaster' => array(
            'className' => 'InventoryManagement.AliquotMaster',
            'foreignKey' => 'aliquot_master_id',
            'type' => 'INNER'
        ),
        'Collection' => array(
            'className' => 'InventoryManagement.Collection',
            'foreignKey' => 'collection_id',
            'type' => 'INNER'
        ),
        'SampleMaster' => array(
            'className' => 'InventoryManagement.SampleMaster',
            'foreignKey' => 'sample_master_id',
            'type' => 'INNER'
        ),
        'StorageMaster' => array(
            'className' => 'StorageLayout.StorageMaster',
            'foreignKey' => 'storage_master_id'
        )
    );

    public static $tableQuery = 'SELECT 
			AliquotMaster.id AS aliquot_master_id,
			AliquotMaster.sample_master_id AS sample_master_id,
			AliquotMaster.collection_id AS collection_id, 
			Collection.bank_id, 
			AliquotMaster.storage_master_id AS storage_master_id,
			Collection.participant_id, 
			
			Participant.participant_identifier, 
			
			Collection.acquisition_label, 
            Collection.collection_protocol_id AS collection_protocol_id,
			
			SpecimenSampleControl.sample_type AS initial_specimen_sample_type,
			SpecimenSampleMaster.sample_control_id AS initial_specimen_sample_control_id,
			ParentSampleControl.sample_type AS parent_sample_type,
			ParentSampleMaster.sample_control_id AS parent_sample_control_id,
			SampleControl.sample_type,
			SampleMaster.sample_control_id,
			
			AliquotMaster.barcode,
			AliquotMaster.aliquot_label,
			AliquotControl.aliquot_type,
			AliquotMaster.aliquot_control_id,
			AliquotMaster.in_stock,
			AliquotMaster.in_stock_detail,
			StudySummary.title AS study_summary_title,
			StudySummary.id AS study_summary_id,
			
			StorageMaster.code,
			StorageMaster.selection_label,
			AliquotMaster.storage_coord_x,
			AliquotMaster.storage_coord_y,
			
			StorageMaster.temperature,
			StorageMaster.temp_unit,
			
			AliquotMaster.created,
			
			IF(AliquotMaster.storage_datetime IS NULL, NULL,
			 IF(Collection.collection_datetime IS NULL, -1,
			 IF(Collection.collection_datetime_accuracy != "c" OR AliquotMaster.storage_datetime_accuracy != "c", -2,
			 IF(Collection.collection_datetime > AliquotMaster.storage_datetime, -3,
			 TIMESTAMPDIFF(MINUTE, Collection.collection_datetime, AliquotMaster.storage_datetime))))) AS coll_to_stor_spent_time_msg,
			IF(AliquotMaster.storage_datetime IS NULL, NULL,
			 IF(SpecimenDetail.reception_datetime IS NULL, -1,
			 IF(SpecimenDetail.reception_datetime_accuracy != "c" OR AliquotMaster.storage_datetime_accuracy != "c", -2,
			 IF(SpecimenDetail.reception_datetime > AliquotMaster.storage_datetime, -3,
			 TIMESTAMPDIFF(MINUTE, SpecimenDetail.reception_datetime, AliquotMaster.storage_datetime))))) AS rec_to_stor_spent_time_msg,
			IF(AliquotMaster.storage_datetime IS NULL, NULL,
			 IF(DerivativeDetail.creation_datetime IS NULL, -1,
			 IF(DerivativeDetail.creation_datetime_accuracy != "c" OR AliquotMaster.storage_datetime_accuracy != "c", -2,
			 IF(DerivativeDetail.creation_datetime > AliquotMaster.storage_datetime, -3,
			 TIMESTAMPDIFF(MINUTE, DerivativeDetail.creation_datetime, AliquotMaster.storage_datetime))))) AS creat_to_stor_spent_time_msg,
			 
			IF(LENGTH(AliquotMaster.notes) > 0, "y", "n") AS has_notes
			
			FROM aliquot_masters AS AliquotMaster
			INNER JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
			INNER JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id AND SampleMaster.deleted != 1
			INNER JOIN sample_controls AS SampleControl ON SampleMaster.sample_control_id = SampleControl.id
			INNER JOIN collections AS Collection ON Collection.id = SampleMaster.collection_id AND Collection.deleted != 1
			LEFT JOIN sample_masters AS SpecimenSampleMaster ON SampleMaster.initial_specimen_sample_id = SpecimenSampleMaster.id AND SpecimenSampleMaster.deleted != 1
			LEFT JOIN sample_controls AS SpecimenSampleControl ON SpecimenSampleMaster.sample_control_id = SpecimenSampleControl.id
			LEFT JOIN sample_masters AS ParentSampleMaster ON SampleMaster.parent_id = ParentSampleMaster.id AND ParentSampleMaster.deleted != 1
			LEFT JOIN sample_controls AS ParentSampleControl ON ParentSampleMaster.sample_control_id=ParentSampleControl.id
			LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted != 1
			LEFT JOIN storage_masters AS StorageMaster ON StorageMaster.id = AliquotMaster.storage_master_id AND StorageMaster.deleted != 1
			LEFT JOIN specimen_details AS SpecimenDetail ON AliquotMaster.sample_master_id=SpecimenDetail.sample_master_id
			LEFT JOIN derivative_details AS DerivativeDetail ON AliquotMaster.sample_master_id=DerivativeDetail.sample_master_id
			LEFT JOIN study_summaries AS StudySummary ON StudySummary.id = AliquotMaster.study_summary_id AND StudySummary.deleted != 1
			WHERE AliquotMaster.deleted != 1 %%WHERE%%';

    public static $minValueFields = array(
        'coll_to_stor_spent_time_msg',
        'rec_to_stor_spent_time_msg',
        'creat_to_stor_spent_time_msg'
    );

    /**
     * ViewAliquot constructor.
     *
     * @param bool $id
     * @param null $table
     * @param null $ds
     * @param null $baseModelName
     * @param null $detailTable
     * @param null $previousModel
     */
    public function __construct($id = false, $table = null, $ds = null, $baseModelName = null, $detailTable = null, $previousModel = null)
    {
        if ($this->fieldsReplace == null) {
            $this->fieldsReplace = array(
                'coll_to_stor_spent_time_msg' => array(
                    'msg' => array(
                        - 1 => __('collection date missing'),
                        - 2 => __('spent time cannot be calculated on inaccurate dates'),
                        - 3 => __('the collection date is after the storage date')
                    ),
                    'type' => 'spentTime'
                ),
                'rec_to_stor_spent_time_msg' => array(
                    'msg' => array(
                        - 1 => __('reception date missing'),
                        - 2 => __('spent time cannot be calculated on inaccurate dates'),
                        - 3 => __('the reception date is after the storage date')
                    ),
                    'type' => 'spentTime'
                ),
                'creat_to_stor_spent_time_msg' => array(
                    'msg' => array(
                        - 1 => __('creation date missing'),
                        - 2 => __('spent time cannot be calculated on inaccurate dates'),
                        - 3 => __('the creation date is after the storage date')
                    ),
                    'type' => 'spentTime'
                )
            );
        }
        return parent::__construct($id, $table, $ds, $baseModelName, $detailTable, $previousModel);
    }
}