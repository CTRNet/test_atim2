<?php

/**
 * Class BatchSet
 */
class BatchSet extends DatamartAppModel
{

    public $useTable = 'datamart_batch_sets';

    public $belongsTo = array(
        'DatamartStructure' => array(
            'className' => 'Datamart.DatamartStructure',
            'foreignKey' => 'datamart_structure_id'
        )
    );

    public $hasMany = array(
        'BatchId' => array(
            'className' => 'Datamart.BatchId',
            'conditions' => '',
            'order' => '',
            'limit' => '',
            'foreignKey' => 'set_id',
            'dependent' => true,
            'exclusive' => false
        )
    );

    /**
     *
     * @param array $variables
     * @return array
     */
    public function summary($variables = array())
    {
        $return = array(
            'menu' => array(
                null
            )
        );
        
        if (isset($variables['BatchSet.id'])) {
            if (isset($variables['BatchSet.temporary_batchset']) && $variables['BatchSet.temporary_batchset']) {
                $return['menu'] = array(
                    null,
                    __('temporary batch set')
                );
            } elseif (! empty($variables['BatchSet.id'])) {
                $batchsetData = $this->find('first', array(
                    'conditions' => array(
                        'BatchSet.id' => $variables['BatchSet.id']
                    )
                ));
                $batchsetData['BatchSet']['model'] = $batchsetData['DatamartStructure']['model'];
                if (! empty($batchsetData)) {
                    $return['title'] = array(
                        null,
                        __('batchset information', null)
                    );
                    $return['menu'] = array(
                        null,
                        $batchsetData['BatchSet']['title']
                    );
                    $return['structure alias'] = 'querytool_batch_set';
                    $return['data'] = $batchsetData;
                }
            }
        }
        
        return $return;
    }

    /**
     *
     * @deprecated : Use a standard find and then call isUserAuthorizedToRw
     * @param $batchSetId
     * @return array|null
     */
    public function getBatchSet($batchSetId)
    {
        $conditions = array(
            'BatchSet.id' => $batchSetId,
            
            'OR' => array(
                'BatchSet.group_id' => $_SESSION['Auth']['User']['group_id'],
                'BatchSet.user_id' => $_SESSION['Auth']['User']['id']
            )
        );
        $batchSet = $this->find('first', array(
            'conditions' => $conditions
        ));
        return ($batchSet);
    }

    /**
     *
     * @param string $plugin
     * @param string $model
     * @param string $datamartStructureId
     * @param int $ignoreId Id to ignore (usually, we do not want a batch set to be compatible to itself)
     * @return array Compatible Batch sets
     */
    public function getCompatibleBatchSets($plugin, $model, $datamartStructureId, $ignoreId = null)
    {
        $datamartStructure = AppModel::getInstance("Datamart", "DatamartStructure", true);
        if (is_numeric($datamartStructureId)) {
            $data = $datamartStructure->findById($datamartStructureId);
            if ($model == $data['DatamartStructure']['control_master_model']) {
                $model = array(
                    $model,
                    $data['DatamartStructure']['model']
                );
            } elseif ($model == $data['DatamartStructure']['model'] && strlen($data['DatamartStructure']['control_master_model']) > 0) {
                $model = array(
                    $model,
                    $data['DatamartStructure']['control_master_model']
                );
            }
        } else {
            $data = $datamartStructure->find('first', array(
                'conditions' => array(
                    'OR' => array(
                        'DatamartStructure.model' => $model,
                        'DatamartStructure.control_master_model' => $model
                    )
                )
            ));
            if (! empty($data)) {
                $datamartStructureId = $data['DatamartStructure']['id'];
                if ($model == $data['DatamartStructure']['control_master_model']) {
                    $model = array(
                        $model,
                        $data['DatamartStructure']['model']
                    );
                } elseif ($model == $data['DatamartStructure']['model'] && strlen($data['DatamartStructure']['control_master_model']) > 0) {
                    $model = array(
                        $model,
                        $data['DatamartStructure']['control_master_model']
                    );
                }
            }
        }
        $availableBatchsetsConditions = array(
            'BatchSet.datamart_structure_id' => $datamartStructureId,
            'OR' => array(
                'BatchSet.user_id' => $_SESSION['Auth']['User']['id'],
                array(
                    'BatchSet.group_id' => $_SESSION['Auth']['User']['group_id'],
                    'BatchSet.sharing_status' => 'group'
                ),
                'BatchSet.sharing_status' => 'all'
            ),
            'BatchSet.flag_tmp' => false
        );
        if ($ignoreId != null) {
            $availableBatchsetsConditions["BatchSet.id Not"] = $ignoreId;
        }
        
        return $this->find('all', array(
            'conditions' => $availableBatchsetsConditions
        ));
    }

    /**
     * Verifies if a user can read/write a batchset.
     * If it fails, the browser
     * will be redirected to a flash screen.
     *
     * @param array $batchset The batchset data
     * @param boolean $mustBeUnlocked If true, the batchset must be unlocked to authorize access.
     * @return bool
     */
    public function isUserAuthorizedToRw(array $batchset, $mustBeUnlocked)
    {
        if (empty($batchset) || (! (array_key_exists('user_id', $batchset['BatchSet']) && array_key_exists('group_id', $batchset['BatchSet']) && array_key_exists('sharing_status', $batchset['BatchSet'])))) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        $allowed = null;
        switch ($batchset['BatchSet']['sharing_status']) {
            case 'user':
                $allowed = $batchset['BatchSet']['user_id'] == $_SESSION['Auth']['User']['id'];
                break;
            case 'group':
                $allowed = $batchset['BatchSet']['group_id'] == $_SESSION['Auth']['User']['group_id'];
                break;
            case 'bank':
                $allowed = $batchset['BatchSet']['group_id'] == $_SESSION['Auth']['User']['group_id'];
                if (! $allowed) {
                    $userBankId = $_SESSION['Auth']['User']['Group']['bank_id'];
                    $userBankGroupIds = array(
                        '-1'
                    );
                    if ($userBankId) {
                        $bankModel = AppModel::getInstance('Administrate', 'Bank', true);
                        $tmpBankGroupIds = $bankModel->getBankGroupIds($userBankId);
                        if ($tmpBankGroupIds) {
                            $userBankGroupIds = $tmpBankGroupIds;
                        }
                    }
                    $allowed = in_array($_SESSION['Auth']['User']['group_id'], $userBankGroupIds);
                }
                break;
            case 'all':
                $allowed = true;
                break;
            default:
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        if (! $allowed) {
            AppController::getInstance()->atimFlashError(__('you are not allowed to work on this batchset'), 'javascript:history.back()');
            return false;
        }
        
        if ($mustBeUnlocked && $batchset['BatchSet']['locked']) {
            AppController::getInstance()->atimFlashError(__('this batchset is locked'), 'javascript:history.back()');
            return false;
        }
        
        return true;
    }

    /**
     * Completes batch set data arrays by adding query_type, model and flag_use_query_results values.
     *
     * @param array $dataArray
     * @internal param $ array &$dataArray* array &$dataArray
     */
    public function completeData(array &$dataArray)
    {
        $datamartStructureModel = AppModel::getInstance('Datamart', 'DatamartStructure', true);
        foreach ($dataArray as $key => &$data) {
            $data['BatchSet']['count_of_BatchId'] = sizeof($data['BatchId']);
            if ($data['BatchSet']['datamart_structure_id']) {
                $id = $data['BatchSet']['datamart_structure_id'];
                if (! isset($datamartStructures[$id])) {
                    $tmp = $datamartStructureModel->findById($id);
                    $datamartStructures[$id] = $tmp['DatamartStructure']['model'];
                }
                $data['BatchSet']['model'] = $datamartStructures[$id];
            }
            $data['0']['query_type'] = __('generic');
        }
    }

    /**
     *
     * @param array $batchSetData
     * @param array $ids
     */
    public function saveWithIds(array $batchSetData, array $ids)
    {
        $batchIdModel = AppModel::getInstance('Datamart', 'BatchId', true);
        $prevCheckMode = $batchIdModel->checkWritableFields;
        $batchIdModel->checkWritableFields = false;
        $bt = debug_backtrace();
        
        $controller = AppController::getInstance();
        $batchSetData['BatchSet']['user_id'] = $controller->Session->read('Auth.User.id');
        $batchSetData['BatchSet']['group_id'] = $controller->Session->read('Auth.User.group_id');
        $batchSetData['BatchSet']['sharing_status'] = 'user';
        $this->checkWritableFields = false;
        if (! $this->save($batchSetData)) {
            $this->redirect('/Pages/err_plugin_system_error?method=' . $bt[1]['function'] . ',line=' . $bt[1]['line'], null, true);
        }
        
        $batchSetId = $this->getLastInsertId();
        $batchIds = array();
        foreach ($ids as $id) {
            $batchIds[] = array(
                'set_id' => $batchSetId,
                'lookup_id' => $id
            );
        }
        
        if (! $batchIdModel->saveAll($batchIds)) {
            $this->redirect('/Pages/err_plugin_system_error?Bmethod=' . $bt[1]['function'] . ',line=' . $bt[1]['line'], null, true);
        }
        $batchIdModel->checkWritableFields = $prevCheckMode;
    }

    /**
     *
     * @param $batchSetId
     * @return bool
     */
    public function allowToUnlock($batchSetId)
    {
        $conditions = array(
            'BatchSet.id' => $batchSetId
        );
        $batchSet = $this->find('first', array(
            'conditions' => $conditions,
            'recursive' => - 1
        ));
        if (empty($batchSet))
            $this->redirect('/Pages/err_plugin_system_error?Bmethod=' . $bt[1]['function'] . ',line=' . $bt[1]['line'], null, true);
        if ($batchSet['BatchSet']['locked']) {
            if ($_SESSION['Auth']['User']['group_id'] == 1)
                return true;
            switch ($batchSet['BatchSet']['sharing_status']) {
                case 'user':
                    return ($batchSet['BatchSet']['user_id'] == $_SESSION['Auth']['User']['id']);
                    break;
                case 'group':
                    return ($batchSet['BatchSet']['group_id'] == $_SESSION['Auth']['User']['group_id']);
                    break;
                case 'all':
                    return true;
                    break;
                default:
                    $this->redirect('/Pages/err_plugin_system_error?Bmethod=' . $bt[1]['function'] . ',line=' . $bt[1]['line'], null, true);
            }
        }
        return false;
    }

    /**
     * Builds a label to help user to identify a batch set
     *
     * @param array $batchSetData data of the batch set
     * @return string The label
     */
    public function getBatchSetLabel($batchSetData)
    {
        return $batchSetData['title'];
    }
}