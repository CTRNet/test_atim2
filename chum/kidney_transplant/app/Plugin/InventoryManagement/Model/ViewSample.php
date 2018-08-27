<?php

/**
 * Class ViewSample
 */
class ViewSample extends InventoryManagementAppModel
{

    public $primaryKey = 'sample_master_id';

    public $baseModel = "SampleMaster";

    public $basePlugin = 'InventoryManagement';

    public $actsAs = array(
        'MinMax',
        'OrderByTranslate' => array(
            'sample_type',
            'sample_category',
            'initial_specimen_sample_type',
            'parent_sample_type'
        )
    );

    public $belongsTo = array(
        'SampleControl' => array(
            'className' => 'InventoryManagement.SampleControl',
            'foreignKey' => 'sample_control_id',
            'type' => 'INNER'
        ),
        'SampleMaster' => array(
            'className' => 'InventoryManagement.SampleMaster',
            'foreignKey' => 'sample_master_id',
            'type' => 'INNER'
        )
    );

    public $hasOne = array(
        'SpecimenDetail' => array(
            'className' => 'InventoryManagement.SpecimenDetail',
            'foreignKey' => 'sample_master_id',
            'dependent' => true
        ),
        'DerivativeDetail' => array(
            'className' => 'InventoryManagement.DerivativeDetail',
            'foreignKey' => 'sample_master_id',
            'dependent' => true
        )
    );

    public static $tableQuery = '
		SELECT SampleMaster.id AS sample_master_id,
		SampleMaster.parent_id AS parent_id,
		SampleMaster.initial_specimen_sample_id,
		SampleMaster.collection_id AS collection_id,
		
		Collection.bank_id, 
		Collection.sop_master_id, 
		Collection.participant_id, 
		Collection.collection_protocol_id AS collection_protocol_id,
		
		Participant.participant_identifier, 
		
		Collection.acquisition_label,
		
		SpecimenSampleControl.sample_type AS initial_specimen_sample_type,
		SpecimenSampleMaster.sample_control_id AS initial_specimen_sample_control_id,
		ParentSampleControl.sample_type AS parent_sample_type,
		ParentSampleMaster.sample_control_id AS parent_sample_control_id,
		SampleControl.sample_type,
		SampleMaster.sample_control_id,
		SampleMaster.sample_code,
		SampleControl.sample_category,
		
		IF(SpecimenDetail.reception_datetime IS NULL, NULL,
		 IF(Collection.collection_datetime IS NULL, -1,
		 IF(Collection.collection_datetime_accuracy != "c" OR SpecimenDetail.reception_datetime_accuracy != "c", -2,
		 IF(Collection.collection_datetime > SpecimenDetail.reception_datetime, -3,
		 TIMESTAMPDIFF(MINUTE, Collection.collection_datetime, SpecimenDetail.reception_datetime))))) AS coll_to_rec_spent_time_msg,
		 
		IF(DerivativeDetail.creation_datetime IS NULL, NULL,
		 IF(Collection.collection_datetime IS NULL, -1,
		 IF(Collection.collection_datetime_accuracy != "c" OR DerivativeDetail.creation_datetime_accuracy != "c", -2,
		 IF(Collection.collection_datetime > DerivativeDetail.creation_datetime, -3,
		 TIMESTAMPDIFF(MINUTE, Collection.collection_datetime, DerivativeDetail.creation_datetime))))) AS coll_to_creation_spent_time_msg 
		
		FROM sample_masters AS SampleMaster
		INNER JOIN sample_controls as SampleControl ON SampleMaster.sample_control_id=SampleControl.id
		INNER JOIN collections AS Collection ON Collection.id = SampleMaster.collection_id AND Collection.deleted != 1
		LEFT JOIN specimen_details AS SpecimenDetail ON SpecimenDetail.sample_master_id=SampleMaster.id
		LEFT JOIN derivative_details AS DerivativeDetail ON DerivativeDetail.sample_master_id=SampleMaster.id
		LEFT JOIN sample_masters AS SpecimenSampleMaster ON SampleMaster.initial_specimen_sample_id = SpecimenSampleMaster.id AND SpecimenSampleMaster.deleted != 1
		LEFT JOIN sample_controls AS SpecimenSampleControl ON SpecimenSampleMaster.sample_control_id = SpecimenSampleControl.id
		LEFT JOIN sample_masters AS ParentSampleMaster ON SampleMaster.parent_id = ParentSampleMaster.id AND ParentSampleMaster.deleted != 1
		LEFT JOIN sample_controls AS ParentSampleControl ON ParentSampleMaster.sample_control_id = ParentSampleControl.id
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted != 1
		WHERE SampleMaster.deleted != 1 %%WHERE%%';

    public $fieldsReplace = null;

    public static $minValueFields = array(
        'coll_to_creation_spent_time_msg',
        'coll_to_rec_spent_time_msg'
    );

    /**
     * ViewSample constructor.
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
                'coll_to_creation_spent_time_msg' => array(
                    'msg' => array(
                        - 1 => __('collection date missing'),
                        - 2 => __('spent time cannot be calculated on inaccurate dates'),
                        - 3 => __('the collection date is after the derivative creation date')
                    ),
                    'type' => 'spentTime'
                ),
                'coll_to_rec_spent_time_msg' => array(
                    'msg' => array(
                        - 1 => __('collection date missing'),
                        - 2 => __('spent time cannot be calculated on inaccurate dates'),
                        - 3 => __('the collection date is after the specimen reception date')
                    ),
                    'type' => 'spentTime'
                )
            );
        }
        return parent::__construct($id, $table, $ds, $baseModelName, $detailTable, $previousModel);
    }
}