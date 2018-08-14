<?php

class StorageMasterCustom extends StorageMaster
{

    var $useTable = 'storage_masters';

    var $name = 'StorageMaster';

    public function summary($variables = array())
    {
        $return = false;
        
        if (isset($variables['StorageMaster.id'])) {
            $result = $this->find('first', array(
                'conditions' => array(
                    'StorageMaster.id' => $variables['StorageMaster.id']
                )
            ));
            $title = __($result['StorageControl']['storage_type']) . ' : ' . $result['StorageMaster']['short_label'];
            
            if ($_SESSION['Auth']['User']['group_id'] == '1') {
                $title = 'TMA ' . $result['StorageMaster']['qc_tf_tma_name'];
            } else {
                $GroupModel = AppModel::getInstance("", "Group", true);
                $groupData = $GroupModel->findById($_SESSION['Auth']['User']['group_id']);
                $userBankId = $groupData['Group']['bank_id'];
                if ($result['StorageMaster']['qc_tf_bank_id'] == $userBankId) {
                    $title = 'TMA ' . $result['StorageMaster']['qc_tf_tma_name'];
                }
            }
            
            if ($result['StorageControl']['is_tma_block'] && AppController::getInstance()->Session->read('flag_show_confidential')) {
                $title = 'TMA ' . $result['StorageMaster']['qc_tf_tma_name'];
            }
            
            $return = array(
                'menu' => array(
                    null,
                    ($title . ' [' . $result['StorageMaster']['code'] . ']')
                ),
                'title' => array(
                    null,
                    ($title . ' [' . $result['StorageMaster']['code'] . ']')
                ),
                'data' => $result,
                'structure alias' => 'storagemasters'
            );
        }
        
        return $return;
    }

    public function getLabel(array $childrenArray, $typeKey, $labelKey)
    {
        if (isset($childrenArray[$typeKey]['qc_tf_generated_label_for_display'])) {
            return $childrenArray[$typeKey]['qc_tf_generated_label_for_display'];
        }
        return $childrenArray[$typeKey][$labelKey];
    }

    public function beforeFind($queryData)
    {
        if (isset($_SESSION['Auth']) && ($_SESSION['Auth']['User']['group_id'] != '1') && is_array($queryData['conditions']) && (AppModel::isFieldUsedAsCondition("StorageMaster.qc_tf_tma_label_site", $queryData['conditions']) || AppModel::isFieldUsedAsCondition("StorageMaster.qc_tf_tma_name", $queryData['conditions']))) {
            AppController::addWarningMsg(__('your search will be limited to your bank'));
            $GroupModel = AppModel::getInstance("", "Group", true);
            $groupData = $GroupModel->findById($_SESSION['Auth']['User']['group_id']);
            $userBankId = $groupData['Group']['bank_id'];
            $queryData['conditions'][] = array(
                "StorageMaster.qc_tf_bank_id" => $userBankId
            );
        }
        return $queryData;
    }

    public function afterFind($results, $primary = false)
    {
        $results = parent::afterFind($results);
        
        // Manage confidential information and build a storage information label gathering many data like bank, etc for TMA
        if (isset($results[0]['StorageMaster'])) {
            // Get user and bank information
            $userBankId = '-1';
            if (isset($_SESSION['Auth']) && $_SESSION['Auth']['User']['group_id'] == '1') {
                $userBankId = 'all';
            } else {
                $GroupModel = AppModel::getInstance("", "Group", true);
                $groupData = $GroupModel->findById($_SESSION['Auth']['User']['group_id']);
                if ($groupData)
                    $userBankId = $groupData['Group']['bank_id'];
            }
            $BankModel = AppModel::getInstance("Administrate", "Bank", true);
            $bankList = $BankModel->getBankPermissibleValuesForControls();
            // Process data
            foreach ($results as &$result) {
                // Manage confidential information
                $setToConfidential = ($userBankId != 'all' && (! isset($result['StorageMaster']['qc_tf_bank_id']) || $result['StorageMaster']['qc_tf_bank_id'] != $userBankId)) ? true : false;
                if ($setToConfidential) {
                    if (isset($result['StorageMaster']['qc_tf_bank_id']))
                        $result['StorageMaster']['qc_tf_bank_id'] = CONFIDENTIAL_MARKER;
                    if (isset($result['StorageMaster']['qc_tf_tma_label_site']))
                        $result['StorageMaster']['qc_tf_tma_label_site'] = CONFIDENTIAL_MARKER;
                    if (isset($result['StorageMaster']['qc_tf_tma_name']))
                        $result['StorageMaster']['qc_tf_tma_name'] = CONFIDENTIAL_MARKER;
                }
                // Create the storage information label to display
                if (isset($result['StorageMaster']['short_label'])) {
                    $result['StorageMaster']['qc_tf_generated_label_for_display'] = $result['StorageMaster']['short_label'];
                    if (isset($result['StorageMaster']['qc_tf_tma_name'])) {
                        if ($userBankId == 'all') {
                            $result['StorageMaster']['qc_tf_generated_label_for_display'] = $result['StorageMaster']['qc_tf_tma_name'] . " [" . $result['StorageMaster']['short_label'] . "]" . (isset($result['StorageMaster']['qc_tf_bank_id']) ? ' (' . $bankList[$result['StorageMaster']['qc_tf_bank_id']] . ')' : '');
                        } elseif ($result['StorageMaster']['qc_tf_bank_id'] == $userBankId) {
                            $result['StorageMaster']['qc_tf_generated_label_for_display'] = $result['StorageMaster']['qc_tf_tma_label_site'];
                        }
                    }
                    $result['StorageMaster']['qc_tf_generated_selection_label_precision_for_display'] = ($result['StorageMaster']['qc_tf_generated_label_for_display'] == $result['StorageMaster']['short_label']) ? '' : '|| ' . $result['StorageMaster']['qc_tf_generated_label_for_display'];
                } else {
                    $result['StorageMaster']['qc_tf_generated_label_for_display'] = '';
                    $result['StorageMaster']['qc_tf_generated_selection_label_precision_for_display'] = '';
                }
            }
        } elseif (isset($results['StorageMaster'])) {
            pr('TODO afterFind storage');
            pr($results);
            exit();
        }
        
        return $results;
    }

    public function validates($options = array())
    {
        $validateRes = parent::validates($options);
        if (array_key_exists('qc_tf_tma_label_site', $this->data['StorageMaster'])) {
            if (strlen($this->data['StorageMaster']['qc_tf_tma_label_site']) && ! $this->data['StorageMaster']['qc_tf_bank_id']) {
                $this->validationErrors['qc_tf_bank_id'][] = __('a bank has to be selected');
                $validateRes = false;
            }
        }
        return $validateRes;
    }
}