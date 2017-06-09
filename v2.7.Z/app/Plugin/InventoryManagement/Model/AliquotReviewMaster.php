<?php

class AliquotReviewMaster extends InventoryManagementAppModel
{

    public $belongsTo = array(
        'AliquotMaster' => array(
            'className' => 'InventoryManagement.AliquotMaster',
            'foreignKey' => 'aliquot_master_id'
        ),
        'AliquotReviewControl' => array(
            'className' => 'InventoryManagement.AliquotReviewControl',
            'foreignKey' => 'aliquot_review_control_id'
        ),
        'SpecimenReviewMaster' => array(
            'className' => 'InventoryManagement.SpecimenReviewMaster',
            'foreignKey' => 'specimen_review_master_id'
        )
    );

    public $registeredView = array(
        'InventoryManagement.ViewAliquotUse' => array(
            'AliquotReviewMaster.id'
        )
    );

    /**
     * Get permissible values array gathering all existing aliquots that could be used for review.
     *
     * @author N. Luc
     * @since 2010-05-26
     *        @updated N. Luc
     */
    function getAliquotListForReview($sampleMasterId = null, $specificAliquotType = null)
    {
        $result = array(
            '' => ''
        );
        
        if (! empty($sampleMasterId)) {
            if (! isset($this->AliquotMaster)) {
                $this->AliquotMaster = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
            }
            
            $conditions = array(
                'AliquotMaster.sample_master_id' => $sampleMasterId
            );
            if (! empty($specificAliquotType)) {
                $conditions['AliquotControl.aliquot_type'] = explode(',', $specificAliquotType);
            }
            
            foreach ($this->AliquotMaster->find('all', array(
                'conditions' => $conditions,
                'order' => 'AliquotMaster.barcode ASC',
                'recursive' => '0'
            )) as $newAliquot) {
                $result[$newAliquot['AliquotMaster']['id']] = $this->generateLabelOfReviewedAliquot($newAliquot['AliquotMaster']['id'], $newAliquot);
            }
        }
        
        return $result;
    }

    function generateLabelOfReviewedAliquot($aliquotMasterId, $aliquotData = null)
    {
        if (! ($aliquotData && isset($aliquotData['AliquotMaster']))) {
            if (! isset($this->AliquotMaster)) {
                $this->AliquotMaster = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
            }
            $aliquotData = $this->AliquotMaster->getOrRedirect($aliquotMasterId);
        }
        return $aliquotData['AliquotMaster']['barcode'];
    }

    function afterFind($results, $primary = false)
    {
        $results = parent::afterFind($results);
        foreach ($results as &$newReview) {
            $newReview['Generated']['reviewed_aliquot_label_for_display'] = (isset($newReview['AliquotMaster']) && $newReview['AliquotMaster']['id']) ? $this->generateLabelOfReviewedAliquot($newReview['AliquotMaster']['id'], $newReview) : '';
        }
        return $results;
    }
}