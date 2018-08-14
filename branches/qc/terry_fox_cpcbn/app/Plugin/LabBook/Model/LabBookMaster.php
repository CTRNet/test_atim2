<?php

/**
 * Class LabBookMaster
 */
class LabBookMaster extends LabBookAppModel
{

    public $belongsTo = array(
        'LabBookControl' => array(
            'className' => 'Labbook.LabBookControl',
            'foreignKey' => 'lab_book_control_id'
        )
    );

    /**
     *
     * @param array $variables
     * @return array|bool
     */
    public function summary($variables = array())
    {
        $return = false;
        
        if (isset($variables['LabBookMaster.id'])) {
            $result = $this->find('first', array(
                'conditions' => array(
                    'LabBookMaster.id' => $variables['LabBookMaster.id']
                )
            ));
            
            $return = array(
                'menu' => array(
                    null,
                    $result['LabBookMaster']['code']
                ),
                'title' => array(
                    null,
                    $result['LabBookMaster']['code']
                ),
                'data' => $result,
                'structure alias' => 'labbookmasters'
            );
        }
        
        return $return;
    }

    /**
     *
     * @param null $labBookControlId
     * @return array
     */
    public function getLabBookPermissibleValuesFromId($labBookControlId = null)
    {
        $result = array(
            '' => ''
        );
        
        $conditions = array();
        if (! is_null($labBookControlId)) {
            $conditions['LabBookMaster.lab_book_control_id'] = $labBookControlId;
        }
        $availableBooks = $this->find('all', array(
            'conditions' => $conditions,
            'order' => 'LabBookMaster.created DESC'
        ));
        foreach ($availableBooks as $book) {
            $result[$book['LabBookMaster']['id']] = $book['LabBookMaster']['code'];
        }
        
        return $result;
    }

    /**
     * Sync data with a lab book.
     *
     * @param array $data The data to synchronize. Direct data and data array both supported
     * @param array $models The models to go through
     * @param string $labBookCode The lab book code to synch with
     * @param int|string $expectedCtrlId If not null, will validate that the lab book code control id match the expected one.
     * @return mixed|null
     */
    public function syncData(array &$data, array $models, $labBookCode, $expectedCtrlId = '-1')
    {
        $result = null;
        $labBook = $this->find('first', array(
            'conditions' => array(
                'LabBookMaster.code' => $labBookCode
            )
        ));
        if (empty($labBook)) {
            $result = __('invalid lab book code');
        } elseif (empty($expectedCtrlId)) {
            $result = __('no lab book can be applied to the current item(s)');
        } elseif ($expectedCtrlId != '-1' && $labBook['LabBookMaster']['lab_book_control_id'] != $expectedCtrlId) {
            $result = __('the selected lab book cannot be applied to the current item(s)');
        } else {
            $result = $labBook['LabBookMaster']['id'];
            if (! empty($data) && ! empty($models)) {
                $extract = null;
                if (isset($data[$models[0]])) {
                    $data = array(
                        $data
                    );
                    $extract = true;
                } else {
                    $extract = false;
                }
                if ($extract || (isset($data[0]) && isset($data[0][$models[0]]))) {
                    // proceed
                    $fields = $this->getFields($labBook['LabBookMaster']['lab_book_control_id']);
                    foreach ($data as &$unit) {
                        foreach ($models as $model) {
                            foreach ($fields as $field) {
                                if (isset($unit[$model]) && isset($unit[$model][$field])) {
                                    $unit[$model][$field] = $labBook['LabBookDetail'][$field];
                                }
                            }
                        }
                    }
                } else {
                    // data to sync not found
                    AppController::getInstance()->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                if ($extract) {
                    $data = $data[0];
                }
            }
        }
        return $result;
    }

    /**
     *
     * @param string $code A lab book code to seek
     * @return int the lab book id matching the code if it exists, false otherwise
     */
    public function getIdFromCode($code)
    {
        $lb = $this->find('list', array(
            'fields' => array(
                'LabBookMaster.id'
            ),
            'conditions' => array(
                'LabBookMaster.code' => $code
            )
        ));
        return empty($lb) ? false : array_pop($lb);
    }

    /**
     *
     * @param $labBookMasterId
     * @return array
     */
    public function allowLabBookDeletion($labBookMasterId)
    {
        $derivativeDetailModel = AppModel::getInstance("InventoryManagement", "DerivativeDetail", true);
        $nbrDerivatives = $derivativeDetailModel->find('count', array(
            'conditions' => array(
                'DerivativeDetail.lab_book_master_id' => $labBookMasterId
            )
        ));
        if ($nbrDerivatives > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'deleted lab book is linked to a derivative'
            );
        }
        
        $realiquotingModel = AppModel::getInstance("InventoryManagement", "Realiquoting", true);
        $nbrRealiquotings = $realiquotingModel->find('count', array(
            'conditions' => array(
                'Realiquoting.lab_book_master_id' => $labBookMasterId
            )
        ));
        if ($nbrRealiquotings > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'deleted lab book is linked to a realiquoted aliquot'
            );
        }
        
        return array(
            'allow_deletion' => true,
            'msg' => ''
        );
    }

    /**
     *
     * @param $labBookMasterId
     * @return mixed
     */
    public function getLabBookDerivativesList($labBookMasterId)
    {
        $sampleMasterModel = AppModel::getInstance("InventoryManagement", "SampleMaster", true);
        
        $sampleMasterModel->unbindModel(array(
            'hasMany' => array(
                'AliquotMaster'
            ),
            'hasOne' => array(
                'SpecimenDetail'
            ),
            'belongsTo' => array(
                'SampleControl'
            )
        ));
        $sampleMasterModel->bindModel(array(
            'belongsTo' => array(
                'GeneratedParentSample' => array(
                    'className' => 'InventoryManagement.SampleMaster',
                    'foreignKey' => 'parent_id'
                )
            )
        ));
        
        return $sampleMasterModel->find('all', array(
            'conditions' => array(
                'DerivativeDetail.lab_book_master_id' => $labBookMasterId
            )
        ));
    }

    /**
     *
     * @param $labBookMasterId
     * @return mixed
     */
    public function getLabBookRealiquotingsList($labBookMasterId)
    {
        $sampleMasterModel = AppModel::getInstance("InventoryManagement", "SampleMaster", true);
        $realiquotingModel = AppModel::getInstance("InventoryManagement", "Realiquoting", true);
        
        $sampleMasterIdsData = $realiquotingModel->find('all', array(
            'conditions' => array(
                'Realiquoting.lab_book_master_id' => $labBookMasterId
            ),
            'fields' => array(
                'AliquotMaster.sample_master_id'
            ),
            'group' => array(
                'AliquotMaster.sample_master_id'
            )
        ));
        $sampleMasterModel->unbindModel(array(
            'hasMany' => array(
                'AliquotMaster'
            ),
            'hasOne' => array(
                'SpecimenDetail',
                'DerivativeDetail'
            ),
            'belongsTo' => array(
                'SampleControl'
            )
        ));
        $sampleMasterIds = array();
        foreach ($sampleMasterIdsData as $sampleIdData) {
            $sampleMasterIds[] = $sampleIdData['AliquotMaster']['sample_master_id'];
        }
        
        $sampleMasterFromIds = $sampleMasterModel->atimList(array(
            'conditions' => array(
                'SampleMaster.id' => $sampleMasterIds
            )
        ));
        $realiquotingModelsList = $realiquotingModel->find('all', array(
            'conditions' => array(
                'Realiquoting.lab_book_master_id' => $labBookMasterId
            )
        ));
        foreach ($realiquotingModelsList as $key => $realiquotingModelData) {
            if (! isset($sampleMasterFromIds[$realiquotingModelData['AliquotMaster']['sample_master_id']])) {
                AppController::getInstance()->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            $realiquotingModelsList[$key] = array_merge($sampleMasterFromIds[$realiquotingModelData['AliquotMaster']['sample_master_id']], $realiquotingModelData);
        }
        
        return $realiquotingModelsList;
    }

    /**
     *
     * @param $labBookMasterId
     * @param null $labBookDetail
     */
    public function synchLabbookRecords($labBookMasterId, $labBookDetail = null)
    {
        $sampleMasterModel = AppModel::getInstance("InventoryManagement", "SampleMaster", true);
        $realiquotingModel = AppModel::getInstance("InventoryManagement", "Realiquoting", true);
        $derivativeDetailModel = AppModel::getInstance("InventoryManagement", "DerivativeDetail", true);
        
        if (empty($labBookDetail)) {
            $labBook = $this->getOrRedirect($labBookMasterId);
            $labBookDetail = $labBook['LabBookDetail'];
        }
        
        unset($labBookDetail['id']);
        unset($labBookDetail['lab_book_master_id']);
        unset($labBookDetail['created']);
        unset($labBookDetail['created_by']);
        unset($labBookDetail['modified']);
        unset($labBookDetail['modified_by']);
        unset($labBookDetail['deleted']);
        unset($labBookDetail['deleted_date']);
        
        // 1 - Derivatives
        
        $sampleMasterModel->unbindModel(array(
            'hasMany' => array(
                'AliquotMaster'
            ),
            'hasOne' => array(
                'SpecimenDetail'
            ),
            'belongsTo' => array(
                'Collection'
            )
        ));
        $derivativesList = $sampleMasterModel->find('all', array(
            'conditions' => array(
                'DerivativeDetail.lab_book_master_id' => $labBookMasterId,
                'DerivativeDetail.sync_with_lab_book' => '1'
            )
        ));
        
        foreach ($derivativesList as $sampleToUpdate) {
            $sampleMasterModel->id = $sampleToUpdate['SampleMaster']['id'];
            if (! $sampleMasterModel->save(array(
                'SampleMaster' => $labBookDetail,
                'SampleDetail' => $labBookDetail
            ), false)) {
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            
            $derivativeDetailModel->id = $sampleToUpdate['DerivativeDetail']['id'];
            if (! $derivativeDetailModel->save(array(
                'DerivativeDetail' => $labBookDetail
            ), false)) {
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
        }
        
        // 2 - Realiquoting
        
        $realiquotingModelsList = $realiquotingModel->find('all', array(
            'conditions' => array(
                'Realiquoting.lab_book_master_id' => $labBookMasterId,
                'Realiquoting.sync_with_lab_book' => '1'
            )
        ));
        foreach ($realiquotingModelsList as $realiquotingModelToUpdate) {
            $realiquotingModel->id = $realiquotingModelToUpdate['Realiquoting']['id'];
            if (! $realiquotingModel->save(array(
                'Realiquoting' => $labBookDetail
            ), false)) {
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
        }
    }
}