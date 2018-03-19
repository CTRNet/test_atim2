<?php

class TmaSlideCustom extends TmaSlide
{

    var $useTable = 'tma_slides';

    var $name = 'TmaSlide';

    private $sectionIdsCheck = array();
    // used for validations
    public function afterFind($results, $primary = false)
    {
        $results = parent::afterFind($results);
        
        if (isset($results[0]['TmaSlide'])) {
            // Get user and bank information
            $userBankId = '-1';
            if ($_SESSION['Auth']['User']['group_id'] == '1') {
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
            $StorageMasterModel = null;
            $blocksFromStorageMasterIds = array();
            foreach ($results as &$result) {
                // Manage confidential information
                $blockData = null;
                $tmaBlockStorageMasterId = $result['TmaSlide']['tma_block_storage_master_id'];
                if (! isset($blocksFromStorageMasterIds[$tmaBlockStorageMasterId])) {
                    // First time a slide of this block is listed
                    // Use StorageMaster.afterFind() function to add Block.qc_tf_generated_label_for_display
                    if (! $StorageMasterModel)
                        $StorageMasterModel = AppModel::getInstance("StorageLayout", "StorageMaster", true);
                    $blockData = $StorageMasterModel->find('first', array(
                        'conditions' => array(
                            'StorageMaster.id' => $tmaBlockStorageMasterId
                        )
                    ));
                    $blocksFromStorageMasterIds[$tmaBlockStorageMasterId] = $blockData['StorageMaster'];
                }
                $result['Block'] = $blocksFromStorageMasterIds[$tmaBlockStorageMasterId];
                $setToConfidential = ($userBankId != 'all' && (! isset($result['Block']['qc_tf_bank_id']) || $result['Block']['qc_tf_bank_id'] != $userBankId)) ? true : false;
                if ($setToConfidential) {
                    if (isset($result['Block']['qc_tf_bank_id']))
                        $result['Block']['qc_tf_bank_id'] = CONFIDENTIAL_MARKER;
                    if (isset($result['Block']['qc_tf_tma_label_site']))
                        $result['Block']['qc_tf_tma_label_site'] = CONFIDENTIAL_MARKER;
                    if (isset($result['Block']['qc_tf_tma_name']))
                        $result['Block']['qc_tf_tma_name'] = CONFIDENTIAL_MARKER;
                }
                // Create the TMASLide information label to display
                if (isset($result['TmaSlide']['barcode'])) {
                    $result['TmaSlide']['qc_tf_generated_label_for_display'] = $result['TmaSlide']['barcode'];
                    if (isset($result['Block']['short_label'])) {
                        $result['TmaSlide']['qc_tf_generated_label_for_display'] = $result['Block']['short_label'] . ' (' . $result['TmaSlide']['barcode'] . ')';
                        if (isset($result['Block']['qc_tf_tma_name'])) {
                            if ($userBankId == 'all') {
                                $result['TmaSlide']['qc_tf_generated_label_for_display'] = $result['Block']['qc_tf_tma_name'] . ' Sect#' . $result['TmaSlide']['qc_tf_cpcbn_section_id'] . (isset($result['Block']['qc_tf_bank_id']) ? ' (' . $bankList[$result['Block']['qc_tf_bank_id']] . ')' : '');
                            } elseif ($result['Block']['qc_tf_bank_id'] == $userBankId) {
                                $result['TmaSlide']['qc_tf_generated_label_for_display'] = $result['Block']['qc_tf_tma_label_site'] . ' Sect#' . $result['TmaSlide']['qc_tf_cpcbn_section_id'];
                            }
                        }
                    }
                }
            }
        } elseif (isset($results['TmaSlide'])) {
            pr('TODO afterFind tma slide');
            pr($results);
            exit();
        }
        
        return $results;
    }

    public function validates($options = array())
    {
        parent::validates($options);
        
        // Check tma slide section id (id unique per block)
        if (isset($this->data['TmaSlide']['qc_tf_cpcbn_section_id'])) {
            $qcTfCpcbnSectionId = $this->data['TmaSlide']['qc_tf_cpcbn_section_id'];
            $tmaBlockStorageMasterId = null;
            if (isset($this->data['TmaSlide']['tma_block_storage_master_id'])) {
                $tmaBlockStorageMasterId = $this->data['TmaSlide']['tma_block_storage_master_id'];
            } elseif (isset($this->data['TmaSlide']['id'])) {
                $tmpSlide = $this->find('first', array(
                    'conditions' => array(
                        'TmaSlide.id' => $this->data['TmaSlide']['id']
                    ),
                    'fields' => array(
                        'TmaSlide.tma_block_storage_master_id'
                    ),
                    'recursive' => -1
                ));
                if ($tmpSlide) {
                    $tmaBlockStorageMasterId = $tmpSlide['TmaSlide']['tma_block_storage_master_id'];
                }
            }
            if (! $tmaBlockStorageMasterId)
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                
                // Check duplicated id for the same block into submited record
            if (! strlen($qcTfCpcbnSectionId)) {
                // Not studied
            } elseif (isset($this->sectionIdsCheck[$tmaBlockStorageMasterId . '-' . $qcTfCpcbnSectionId])) {
                $this->validationErrors['qc_tf_cpcbn_section_id'][] = str_replace('%s', $qcTfCpcbnSectionId, __('you can not record section id [%s] twice'));
            } else {
                $this->sectionIdsCheck[$tmaBlockStorageMasterId . '-' . $qcTfCpcbnSectionId] = '';
            }
            
            // Check duplicated id for the same block into db
            $criteria = array(
                'TmaSlide.tma_block_storage_master_id' => $tmaBlockStorageMasterId,
                'TmaSlide.qc_tf_cpcbn_section_id' => $qcTfCpcbnSectionId
            );
            $slidesHavingDuplicatedId = $this->find('all', array(
                'conditions' => $criteria,
                'recursive' => - 1
            ));
            ;
            if (! empty($slidesHavingDuplicatedId)) {
                foreach ($slidesHavingDuplicatedId as $duplicate) {
                    if ((! array_key_exists('id', $this->data['TmaSlide'])) || ($duplicate['TmaSlide']['id'] != $this->data['TmaSlide']['id'])) {
                        $this->validationErrors['qc_tf_cpcbn_section_id'][] = str_replace('%s', $qcTfCpcbnSectionId, __('the section id [%s] has already been recorded'));
                    }
                }
            }
        }
        
        return empty($this->validationErrors);
    }
}