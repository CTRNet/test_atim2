<?php

class ViewStorageMasterCustom extends ViewStorageMaster
{

    var $name = 'ViewStorageMaster';

    public function beforeFind($queryData)
    {
        if (isset($_SESSION['Auth']) && ($_SESSION['Auth']['User']['group_id'] != '1') && is_array($queryData['conditions']) && (AppModel::isFieldUsedAsCondition("ViewStorageMaster.qc_tf_tma_label_site", $queryData['conditions']) || AppModel::isFieldUsedAsCondition("ViewStorageMaster.qc_tf_tma_name", $queryData['conditions']))) {
            AppController::addWarningMsg(__('your search will be limited to your bank'));
            $GroupModel = AppModel::getInstance("", "Group", true);
            $groupData = $GroupModel->findById($_SESSION['Auth']['User']['group_id']);
            $userBankId = $groupData['Group']['bank_id'];
            $queryData['conditions'][] = array(
                "ViewStorageMaster.qc_tf_bank_id" => $userBankId
            );
        }
        return $queryData;
    }

    public function afterFind($results, $primary = false)
    {
        $results = parent::afterFind($results);
        
        if (isset($results[0]['ViewStorageMaster'])) {
            // Get user and bank information
            // NOTE: Will Use data returned by StorageMaster.afterFind() function
            // Process data
            $StorageMasterModel = null;
            foreach ($results as &$result) {
                // Manage confidential information and create the storage information label to display
                // NOTE: Will Use data returned by StorageMaster.afterFind() function
                $storageMasterData = null;
                if (isset($result['ViewStorageMaster']['id'])) {
                    if (! isset($result['StorageMaster'])) {
                        if (! $StorageMasterModel)
                            $StorageMasterModel = AppModel::getInstance("StorageLayout", "StorageMaster", true);
                        $storageMasterData = $StorageMasterModel->find('first', array(
                            'conditions' => array(
                                'StorageMaster.id' => $result['StorageMaster']['id']
                            ),
                            'recursive' => -1
                        ));
                    } else {
                        $storageMasterData = array(
                            'StorageMaster' => $result['StorageMaster']
                        );
                    }
                }
                if ($storageMasterData) {
                    if (isset($result['ViewStorageMaster']['qc_tf_bank_id']))
                        $result['ViewStorageMaster']['qc_tf_bank_id'] = $storageMasterData['StorageMaster']['qc_tf_bank_id'];
                    if (isset($result['ViewStorageMaster']['qc_tf_tma_label_site']))
                        $result['ViewStorageMaster']['qc_tf_tma_label_site'] = $storageMasterData['StorageMaster']['qc_tf_tma_label_site'];
                    ;
                    if (isset($result['ViewStorageMaster']['qc_tf_tma_name']))
                        $result['ViewStorageMaster']['qc_tf_tma_name'] = $storageMasterData['StorageMaster']['qc_tf_tma_name'];
                    ;
                    if (isset($result['ViewStorageMaster']['short_label'])) {
                        $result['ViewStorageMaster']['qc_tf_generated_label_for_display'] = $storageMasterData['StorageMaster']['qc_tf_generated_label_for_display'];
                    }
                }
            }
        } elseif (isset($results['ViewStorageMaster'])) {
            pr('TODO afterFind ViewStorageMaster');
            pr($results);
            exit();
        }
        
        return $results;
    }
}