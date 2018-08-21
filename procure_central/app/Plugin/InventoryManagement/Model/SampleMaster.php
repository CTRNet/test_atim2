<?php

/**
 * Class SampleMaster
 */
class SampleMaster extends InventoryManagementAppModel
{

    public static $derivativesDropdown = array();

    public $actsAs = array(
        'MinMax'
    );

    public $belongsTo = array(
        'SampleControl' => array(
            'className' => 'InventoryManagement.SampleControl',
            'foreignKey' => 'sample_control_id',
            'type' => 'INNER'
        ),
        'Collection' => array(
            'className' => 'InventoryManagement.Collection',
            'foreignKey' => 'collection_id',
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
        ),
        'ViewSample' => array(
            'className' => 'InventoryManagement.ViewSample',
            'foreignKey' => 'sample_master_id',
            'dependent' => true
        )
    );

    public $hasMany = array(
        'AliquotMaster' => array(
            'className' => 'InventoryManagement.AliquotMaster',
            'foreignKey' => 'sample_master_id'
        )
    );

    public static $aliquotMasterModel = null;

    public static $joinSampleControlOnDup = array(
        'table' => 'sample_controls',
        'alias' => 'SampleControl',
        'type' => 'LEFT',
        'conditions' => array(
            'sample_masters_dup.sample_control_id =SampleControl.id'
        )
    );

    public $registeredView = array(
        'InventoryManagement.ViewSample' => array(
            'SampleMaster.id',
            'ParentSampleMaster.id',
            'SpecimenSampleMaster.id'
        ),
        'InventoryManagement.ViewAliquot' => array(
            'SampleMaster.id',
            'ParentSampleMaster.id',
            'SpecimenSampleMaster.id'
        ),
        'InventoryManagement.ViewAliquotUse' => array(
            'SampleMaster.id',
            'SampleMaster2.id'
        )
    );

    /**
     *
     * @param array $variables
     * @return array|bool
     */
    public function specimenSummary($variables = array())
    {
        $return = false;
        
        if (isset($variables['Collection.id']) && isset($variables['SampleMaster.initial_specimen_sample_id'])) {
            // Get specimen data
            $criteria = array(
                'SampleMaster.collection_id' => $variables['Collection.id'],
                'SampleMaster.id' => $variables['SampleMaster.initial_specimen_sample_id']
            );
            $this->unbindModel(array(
                'hasMany' => array(
                    'AliquotMaster'
                )
            ));
            $specimenData = $this->find('first', array(
                'conditions' => $criteria,
                'recursive' => 0
            ));
            
            $samplePrecision = '';
            if (array_key_exists('blood_type', $specimenData['SampleDetail']) && $specimenData['SampleDetail']['blood_type']) {
                $query = array(
                    'recursive' => 2,
                    'conditions' => array(
                        'StructureValueDomain.domain_name' => 'blood_type'
                    )
                );
                App::uses("StructureValueDomain", 'Model');
                $structureValueDomainModel = new StructureValueDomain();
                $bloodTypesList = $structureValueDomainModel->find('first', $query);
                if (isset($bloodTypesList['StructurePermissibleValue'])) {
                    foreach ($bloodTypesList['StructurePermissibleValue'] as $newType)
                        if ($newType['value'] == $specimenData['SampleDetail']['blood_type'])
                            $samplePrecision = ' - ' . __($newType['language_alias']);
                }
            }
            
            // Set summary
            $return = array(
                'menu' => array(
                    null,
                    __($specimenData['SampleControl']['sample_type']) . $samplePrecision . ' : ' . $specimenData['SampleMaster']['sample_code']
                ),
                'title' => array(
                    null,
                    __($specimenData['SampleControl']['sample_type']) . ' : ' . $specimenData['SampleMaster']['sample_code']
                ),
                'data' => $specimenData,
                'structure alias' => 'sample_masters'
            );
        }
        
        return $return;
    }

    /**
     *
     * @param array $variables
     * @return array|bool
     */
    public function derivativeSummary($variables = array())
    {
        $return = false;
        
        if (isset($variables['Collection.id']) && isset($variables['SampleMaster.initial_specimen_sample_id']) && isset($variables['SampleMaster.id'])) {
            // Get derivative data
            $criteria = array(
                'SampleMaster.collection_id' => $variables['Collection.id'],
                'SampleMaster.id' => $variables['SampleMaster.id']
            );
            $this->unbindModel(array(
                'hasMany' => array(
                    'AliquotMaster'
                )
            ));
            $derivativeData = $this->find('first', array(
                'conditions' => $criteria,
                'recursive' => 0
            ));
            
            // Set summary
            $return = array(
                'menu' => array(
                    null,
                    __($derivativeData['SampleControl']['sample_type']) . ' : ' . $derivativeData['SampleMaster']['sample_code']
                ),
                'title' => array(
                    null,
                    __($derivativeData['SampleControl']['sample_type']) . ' : ' . $derivativeData['SampleMaster']['sample_code']
                ),
                'data' => $derivativeData,
                'structure alias' => 'sample_masters'
            );
        }
        
        return $return;
    }

    /**
     *
     * @return array
     */
    public function getParentSampleDropdown()
    {
        return array();
    }

    /**
     *
     * @return array
     */
    public function getDerivativesDropdown()
    {
        return self::$derivativesDropdown;
    }

    /**
     *
     * @param array $sampleMasterIds The sample master ids whom child existence will be verified
     * @return array The sample master ids having a child
     */
    public function hasChild(array $sampleMasterIds)
    {
        // fetch the sample ids having samples as child
        $derivativesResult = array_unique(array_filter($this->find('list', array(
            'fields' => array(
                "SampleMaster.parent_id"
            ),
            'conditions' => array(
                'SampleMaster.parent_id' => $sampleMasterIds
            )
        ))));
        // fetch the aliquots ids having the remaining samples as parent
        // we can fetch the realiquots too because they imply the presence of a direct child
        $sampleMasterIds = array_diff($sampleMasterIds, $derivativesResult);
        $aliquotMaster = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
        $aliquotResult = array_filter($aliquotMaster->find('list', array(
            'fields' => array(
                'AliquotMaster.sample_master_id'
            ),
            'conditions' => array(
                'AliquotMaster.sample_master_id' => $sampleMasterIds
            )
        )));
        // fetch the sample quality control not linked to a tested aliquot
        $sampleMasterIds = array_diff($sampleMasterIds, $aliquotResult);
        $qualityCtrl = AppModel::getInstance("InventoryManagement", "QualityCtrl", true);
        $qualityCtrlResult = array_filter($qualityCtrl->find('list', array(
            'fields' => array(
                'QualityCtrl.sample_master_id'
            ),
            'conditions' => array(
                'QualityCtrl.sample_master_id' => $sampleMasterIds,
                'QualityCtrl.aliquot_master_id IS NULL'
            )
        )));
        // fetch the sample specimen review not linked to a tested aliquot
        $sampleMasterIds = array_diff($sampleMasterIds, $qualityCtrlResult);
        $specimenReviewMaster = AppModel::getInstance("InventoryManagement", "SpecimenReviewMaster", true);
        $specimenReviewMasterResult = array_filter($specimenReviewMaster->find('list', array(
            'fields' => array(
                'SpecimenReviewMaster.sample_master_id'
            ),
            'conditions' => array(
                'SpecimenReviewMaster.sample_master_id' => $sampleMasterIds
            )
        )));
        return array_unique(array_merge($derivativesResult, $aliquotResult, $qualityCtrlResult, $specimenReviewMasterResult));
    }

    /**
     * Validates a lab book.
     * Update the lab_book_master_id if it's ok.
     *
     * @param array $data The data to work with
     * @param LabBookMaster $labBook Any LabBookMaster object (it's assumed the caller is already using one)
     * @param int $labBookCtrlId The lab_book_ctrl_id that is allowed
     * @param boolean $sync If true, will synch with the lab book when it's valid
     * @return An empty string on success, an error string on failure.
     */
    public function validateLabBook(array &$data, $labBook, $labBookCtrlId, $sync)
    {
        $msg = "";
        // set lab_book_master_id to null by default to erase previous labbook in edit mode if required
        $data['DerivativeDetail']['lab_book_master_id'] = '';
        
        if (array_key_exists('lab_book_master_code', $data['DerivativeDetail']) && strlen($data['DerivativeDetail']['lab_book_master_code']) > 0) {
            $result = $labBook->syncData($data, $sync ? array(
                'DerivativeDetail'
            ) : array(), $data['DerivativeDetail']['lab_book_master_code'], $labBookCtrlId);
            if (is_numeric($result)) {
                // went well, we have the lab book id as a result
                $data['DerivativeDetail']['lab_book_master_id'] = $result;
            } else {
                // error
                $msg = $result;
            }
        } elseif ((array_key_exists('sync_with_lab_book', $data['DerivativeDetail']) && $this->data['DerivativeDetail']['sync_with_lab_book']) || (isset($data[0]['sync_with_lab_book_now']) && $data[0]['sync_with_lab_book_now'])) {
            $msg = __('to synchronize with a lab book, you need to define a lab book to use');
        }
        
        return $msg;
    }

    /**
     * Create Sample code of a created sample.
     *
     *
     * @param $sampleMasterId Id of the created sample.
     * @param $sampleMasterData Array that contains sample master data of the created sample.
     * @param $sampleControlData Array that contains sample control data of the created sample.
     *       
     * @return The sample code of the created sample.
     *        
     * @author N. Luc
     * @since 2007-06-20
     * @deprecated
     *
     */
    public function createCode($sampleMasterId, $sampleMasterData, $sampleControlData)
    {
        AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        $sampleCode = $sampleControlData['SampleControl']['sample_type_code'] . ' - ' . $sampleMasterId;
        return $sampleCode;
    }

    /**
     * Check if a sample can be deleted.
     *
     * @param $sampleMasterId Id of the studied sample.
     *       
     * @return Return results as array:
     *         ['allow_deletion'] = true/false
     *         ['msg'] = message to display when previous field equals false
     *        
     * @author N. Luc
     * @since 2007-10-16
     */
    public function allowDeletion($sampleMasterId)
    {
        // Check sample has no chidlren
        $returnedNbr = $this->find('count', array(
            'conditions' => array(
                'SampleMaster.parent_id' => $sampleMasterId
            ),
            'recursive' => - 1
        ));
        if ($returnedNbr > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'derivative exists for the deleted sample'
            );
        }
        
        // Check sample is not linked to aliquot
        $aliquotMasterModel = AppModel::getInstance("InventoryManagement", "AliquotMaster", true);
        $returnedNbr = $aliquotMasterModel->find('count', array(
            'conditions' => array(
                'AliquotMaster.sample_master_id' => $sampleMasterId
            ),
            'recursive' => - 1
        ));
        if ($returnedNbr > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'aliquot exists for the deleted sample'
            );
        }
        
        // Verify this sample has not been used.
        // Note: Not necessary because we can not delete a sample aliquot
        // when this one has been used at least once.
        
        // Verify that no parent sample aliquot is attached to the sample list
        // 'used aliquot' that allows to display all source aliquots used to create
        // the studied sample.
        // $sourceAliquotModel = AppModel::getInstance("InventoryManagement", "SourceAliquot", true);
        // $returnedNbr = $sourceAliquotModel->find('count', array('conditions' => array('SourceAliquot.sample_master_id' => $sampleMasterId), 'recursive' => -1));
        // if($returnedNbr > 0) {
        // return array('allow_deletion' => false, 'msg' => 'an aliquot of the parent sample is defined as source aliquot');
        // }
        
        // Check sample is not linked to qc
        $qualityCtrlModel = AppModel::getInstance("InventoryManagement", "QualityCtrl", true);
        $returnedNbr = $qualityCtrlModel->find('count', array(
            'conditions' => array(
                'QualityCtrl.sample_master_id' => $sampleMasterId
            ),
            'recursive' => - 1
        ));
        if ($returnedNbr > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'quality control exists for the deleted sample'
            );
        }
        
        // Check sample has not been linked to review
        $specimenReviewMasterModel = AppModel::getInstance("InventoryManagement", "SpecimenReviewMaster", true);
        $returnedNbr = $specimenReviewMasterModel->find('count', array(
            'conditions' => array(
                'SpecimenReviewMaster.sample_master_id' => $sampleMasterId
            ),
            'recursive' => - 1
        ));
        if ($returnedNbr > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'review exists for the deleted sample'
            );
        }
        
        return array(
            'allow_deletion' => true,
            'msg' => ''
        );
    }

    /**
     * Format parent sample data array for display.
     *
     * @param $parentSampleData Parent sample data
     *       
     * @return Parent sample list into array having following structure:
     *         array($parentSampleMasterId => $sampleTitleBuiltByFunction)
     *        
     * @author N. Luc
     * @since 2009-09-11
     */
    public function formatParentSampleDataForDisplay($parentSampleData)
    {
        $formattedData = array();
        if (! empty($parentSampleData)) {
            if (isset($parentSampleData['SampleMaster'])) {
                $formattedData[$parentSampleData['SampleMaster']['id']] = $parentSampleData['SampleMaster']['sample_code'] . ' [' . __($parentSampleData['SampleControl']['sample_type'], true) . ']';
            } elseif (isset($parentSampleData[0]['ViewSample'])) {
                foreach ($parentSampleData as $newParent) {
                    $formattedData[$newParent['ViewSample']['sample_master_id']] = $newParent['ViewSample']['sample_code'] . ' [' . __($newParent['ViewSample']['sample_type'], true) . ']';
                }
            }
        }
        return $formattedData;
    }

    /**
     *
     * @param $modelId
     * @param bool $cascade
     * @return bool
     */
    public function atimDelete($modelId, $cascade = true)
    {
        if (parent::atimDelete($modelId, $cascade)) {
            // delete source_aliquots
            
            $sourceAliquotModel = AppModel::getInstance('InventoryManagement', 'SourceAliquot', true);
            $aliquotMaster = AppModel::getInstance('InventoryManagement', 'AliquotMaster', true);
            
            $sourceAliquots = $sourceAliquotModel->find('all', array(
                'conditions' => array(
                    'SourceAliquot.sample_master_id' => $modelId
                )
            ));
            $sources = array();
            foreach ($sourceAliquots as $newSource) {
                $sources[] = $newSource['SourceAliquot']['aliquot_master_id'];
                $sourceAliquotModel->atimDelete($newSource['SourceAliquot']['id']);
            }
            $sources = array_unique($sources);
            foreach ($sources as $sourceId) {
                $aliquotMaster->updateAliquotVolume($sourceId);
            }
            return true;
        }
        return false;
    }

    /**
     *
     * @param $onField
     * @return array
     */
    public static function joinOnSampleDup($onField)
    {
        return array(
            'table' => 'sample_masters',
            'alias' => 'sample_masters_dup',
            'type' => 'LEFT',
            'conditions' => array(
                $onField . ' = sample_masters_dup.id'
            )
        );
    }
}