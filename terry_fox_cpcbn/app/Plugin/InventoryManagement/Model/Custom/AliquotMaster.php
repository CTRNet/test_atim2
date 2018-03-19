<?php

class AliquotMasterCustom extends AliquotMaster
{

    var $useTable = 'aliquot_masters';

    var $name = 'AliquotMaster';

    public function regenerateAliquotBarcode()
    {
        $query = "UPDATE aliquot_masters SET barcode = id WHERE barcode LIKE '' OR barcode IS NULL";
        $this->tryCatchQuery($query);
        $this->tryCatchQuery(str_replace('aliquot_masters', 'aliquot_masters_revs', $query));
        // The Barcode values of AliquotView will be updated by AppModel::releaseBatchViewsUpdateLock(); call in AliquotMaster.add() and AliquotMaster.realiquot() function
    }

    public function beforeSave($options = array())
    {
        $retVal = parent::beforeSave($options);
        
        if (array_key_exists('AliquotDetail', $this->data) && array_key_exists('qc_tf_core_nature_site', $this->data['AliquotDetail'])) {
            // Set core aliquot label
            $this->data['AliquotMaster']['aliquot_label'] = substr(strtoupper(strlen($this->data['AliquotDetail']['qc_tf_core_nature_revised']) ? $this->data['AliquotDetail']['qc_tf_core_nature_revised'] : (strlen($this->data['AliquotDetail']['qc_tf_core_nature_site']) ? $this->data['AliquotDetail']['qc_tf_core_nature_site'] : 'U')), 0, 1);
            $this->addWritableField(array(
                'aliquot_label'
            ));
        }
        
        return $retVal;
    }

    public function generateDefaultAliquotLabel($viewData)
    {
        // Parameters check: Verify parameters have been set
        if (empty($viewData))
            AppController::getInstance()->redirect('/pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        
        $defaultAliquotLabel = '';
        if ($viewData['sample_type'] == 'dna') {
            if ($viewData['participant_identifier']) {
                $defaultAliquotLabel = $viewData['participant_identifier'] . '-';
            }
            $defaultAliquotLabel .= 'DNA-';
        } elseif ($viewData['sample_type'] == 'rna') {
            if ($viewData['participant_identifier']) {
                $defaultAliquotLabel = $viewData['participant_identifier'] . '-';
            }
            $defaultAliquotLabel .= 'RNA-';
        }
        
        return $defaultAliquotLabel;
    }

    public function afterFind($results, $primary = false)
    {
        $results = parent::afterFind($results);
        
        if (isset($results[0]['AliquotMaster'])) {
            // Get user and bank information
            // NOTE: Will Use data returned by ViewAliquot.afterFind() function
            // Process data
            $ViewAliquotModel = null;
            foreach ($results as &$result) {
                // Manage confidential information and create the aliquot information label to display
                // NOTE: Will Use data returned by ViewAliquot.afterFind() function
                if (array_key_exists('aliquot_label', $result['AliquotMaster'])) {
                    $aliquotViewData = null;
                    if (! isset($result['ViewAliquot'])) {
                        if (! $ViewAliquotModel)
                            $ViewAliquotModel = AppModel::getInstance("InventoryManagement", "ViewAliquot", true);
                        $aliquotViewData = $ViewAliquotModel->find('first', array(
                            'conditions' => array(
                                'ViewAliquot.aliquot_master_id' => $result['AliquotMaster']['id']
                            ),
                            'recursive' => -1
                        ));
                    } else {
                        $aliquotViewData = array(
                            'ViewAliquot' => $result['ViewAliquot']
                        );
                    }
                    if (isset($result['AliquotMaster']['aliquot_label']))
                        $result['AliquotMaster']['aliquot_label'] = $aliquotViewData['ViewAliquot']['aliquot_label'];
                    if (isset($aliquotViewData['ViewAliquot']['qc_tf_generated_label_for_display']))
                        $result['AliquotMaster']['qc_tf_generated_label_for_display'] = $aliquotViewData['ViewAliquot']['qc_tf_generated_label_for_display'];
                }
            }
        } elseif (isset($results['AliquotMaster'])) {
            pr('TODO afterFind ViewAliquot');
            pr($results);
            exit();
        }
        return $results;
    }
}