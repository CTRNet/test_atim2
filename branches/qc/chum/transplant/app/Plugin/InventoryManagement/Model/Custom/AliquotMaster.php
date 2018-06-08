<?php

class AliquotMasterCustom extends AliquotMaster
{

    var $useTable = 'aliquot_masters';

    var $name = 'AliquotMaster';

    public function summary($variables = array())
    {
        $return = false;
        
        if (isset($variables['Collection.id']) && isset($variables['SampleMaster.id']) && isset($variables['AliquotMaster.id'])) {
            
            // TODO: Kidney transplant customisation
            if (Configure::read('chum_atim_conf') == 'KIDNEY_TRANSLPANT') {
                return parent::summary($variables);
            }
            
            $result = $this->find('first', array(
                'conditions' => array(
                    'AliquotMaster.collection_id' => $variables['Collection.id'],
                    'AliquotMaster.sample_master_id' => $variables['SampleMaster.id'],
                    'AliquotMaster.id' => $variables['AliquotMaster.id']
                )
            ));
            if (! isset($result['AliquotMaster']['storage_coord_y'])) {
                $result['AliquotMaster']['storage_coord_y'] = "";
            }
            $return = array(
                'menu' => array(
                    null,
                    __($result['AliquotControl']['aliquot_type'], true) . ' : ' . $result['AliquotMaster']['aliquot_label']
                ),
                'title' => array(
                    null,
                    __($result['AliquotControl']['aliquot_type'], true) . ' : ' . $result['AliquotMaster']['aliquot_label']
                ),
                'data' => $result,
                'structure alias' => 'aliquot_masters'
            );
        }
        
        return $return;
    }

    public function generateDefaultAliquotLabel($viewSample, $aliquotControlData)
    {
        // TODO: Kidney transplant customisation
        if (Configure::read('chum_atim_conf') == 'KIDNEY_TRANSLPANT') {
            return $viewSample['ViewSample']['acquisition_label'];
        }
        
        // Parameters check: Verify parameters have been set
        if (empty($viewSample) || empty($aliquotControlData))
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        
        $defaultAliquotLabel = '';
        if ($viewSample['ViewSample']['bank_id'] == 4) {
            // *** Prostate Bank ***
            $idenitfierValue = empty($viewSample['ViewSample']['identifier_value']) ? '?' : $viewSample['ViewSample']['identifier_value'];
            $visitLabel = empty($viewSample['ViewSample']['visit_label']) ? '?' : $viewSample['ViewSample']['visit_label'];
            $label = '-?';
            switch ($viewSample['ViewSample']['sample_type'] . '-' . $aliquotControlData['AliquotControl']['aliquot_type']) {
                case 'blood-tube':
                    $this->SampleMaster = AppModel::getInstance('InventoryManagement', 'SampleMaster', true);
                    $sampleData = $this->SampleMaster->find('first', array(
                        'conditions' => array(
                            'SampleMaster.id' => $viewSample['ViewSample']['sample_master_id']
                        ),
                        'recursive' => 0
                    ));
                    if ($sampleData) {
                        switch ($sampleData['SampleDetail']['blood_type']) {
                            case 'gel SST':
                                $label = '-SRB';
                                break;
                            case 'paxgene':
                                $label = '-RNB';
                                break;
                            case 'EDTA':
                                $label = '-EDB';
                                break;
                        }
                    }
                    break;
                case 'blood-whatman paper':
                    $label = '-WHT';
                    break;
                case 'serum-tube':
                    $label = '-SER';
                    break;
                case 'plasma-tube':
                    $label = '-PLA';
                    break;
                case 'pbmc-tube':
                case 'blood cell-tube':
                    $label = '-BFC';
                    break;
                case 'urine-cup':
                case 'urine-tube':
                    $label = '-URI';
                    break;
                case 'centrifuged urine-tube':
                    $label = '-URN';
                    break;
                case 'tissue-block':
                    $label = '-FRZ';
                    break;
                case 'rna-tube':
                    $label = '-RNA';
                    break;
                case 'dna-tube':
                    $label = '-DNA';
                    break;
            }
            $defaultAliquotLabel = $idenitfierValue . ' ' . $visitLabel . ' ' . $label;
            
        } elseif ($viewSample['ViewSample']['bank_id'] == 8) {
            
            // *** Autopsy Bank ***
            
            $this->Collection = AppModel::getInstance('InventoryManagement', 'Collection', true);
            $tmpColData = $this->Collection->find('first', array(
                'conditions' => array(
                    'id' => $viewSample['ViewSample']['collection_id']
                ),
                'recursive' => -1
            ));
            $collectionDateTime = (! empty($tmpColData['Collection']['collection_datetime']) && preg_match('/^[0-9]{2}([0-9]{2})\-[0-9]{2}\-[0-9]{2}/', $tmpColData['Collection']['collection_datetime'], $matches)) ? $matches['1'] : '?';
            $idenitfierValue = empty($viewSample['ViewSample']['identifier_value']) ? '?' : substr($viewSample['ViewSample']['identifier_value'], 3, 3);
            $qcNdSampleLabel = (! empty($viewSample['ViewSample']['qc_nd_sample_label']) && preg_match('/A\-([A-Z]+)/', $viewSample['ViewSample']['qc_nd_sample_label'], $matches)) ? $matches['1'] : '?';
            $defaultAliquotLabel = $collectionDateTime . $idenitfierValue . $qcNdSampleLabel;
            
        } elseif ($viewSample['ViewSample']['bank_id'] == 10) {
            
            // *** Pulmonary Bank ***
            
            $this->Collection = AppModel::getInstance('InventoryManagement', 'Collection', true);
            $tmpColData = $this->Collection->find('first', array(
                'conditions' => array(
                    'id' => $viewSample['ViewSample']['collection_id']
                ),
                'recursive' => - 1
            ));
            
            $collectionDateTime = empty($tmpColData['Collection']['collection_datetime'])? '?' : substr($tmpColData['Collection']['collection_datetime'], 0, 10);
            $idenitfierValue = empty($viewSample['ViewSample']['identifier_value']) ? '?' : $viewSample['ViewSample']['identifier_value'];
            
            $label = '?';
            switch ($viewSample['ViewSample']['sample_type'] . '-' . $aliquotControlData['AliquotControl']['aliquot_type']) {
                case 'serum-tube':
                    $label = 'Serum';
                    break;
                case 'plasma-tube':
                    $label = 'Plasma';
                    break;
                case 'pbmc-tube':
                    $label = 'Buffycoat';
                    break;
                case 'blood cell-tube':
                    $label = 'Buffycoat';
                    break;
                case 'tissue-tube':
                    $label = substr($viewSample['ViewSample']['qc_nd_sample_label'], 0, strpos($viewSample['ViewSample']['qc_nd_sample_label'], ' '));
                    break;
            }
            $defaultAliquotLabel = $idenitfierValue . ' ' . $label . '-? ' . $collectionDateTime;
                    
        } else {
            
            // *** Other Bank ***
            
            // Set date for aliquot label
            $aliquotCreationDate = '';
            if ($viewSample['ViewSample']['sample_category'] == 'specimen') {
                // Specimen Aliquot
                if (! isset($this->SpecimenDetail)) {
                    $this->SpecimenDetail = AppModel::getInstance('InventoryManagement', 'SpecimenDetail', true);
                }
                $specimenDetail = $this->SpecimenDetail->getOrRedirect($viewSample['ViewSample']['sample_master_id']);
                
                $aliquotCreationDate = $specimenDetail['SpecimenDetail']['reception_datetime'];
            } else {
                // Derviative Aliquot
                if (! isset($this->DerivativeDetail)) {
                    $this->DerivativeDetail = AppModel::getInstance('InventoryManagement', 'DerivativeDetail', true);
                }
                
                $derivativeDetail = $this->DerivativeDetail->getOrRedirect($viewSample['ViewSample']['sample_master_id']);
                
                $aliquotCreationDate = $derivativeDetail['DerivativeDetail']['creation_datetime'];
            }
            
            $defaultAliquotLabel = (empty($viewSample['ViewSample']['qc_nd_sample_label']) ? 'n/a' : $viewSample['ViewSample']['qc_nd_sample_label']) . (empty($aliquotCreationDate) ? '' : ' ' . substr($aliquotCreationDate, 0, strpos($aliquotCreationDate, " ")));
        }
        
        return $defaultAliquotLabel;
    }

    public function regenerateAliquotBarcode()
    {
        $queryToUpdate = "UPDATE aliquot_masters SET barcode = id WHERE barcode IS NULL OR barcode LIKE '';";
        $this->tryCatchQuery($queryToUpdate);
        $this->tryCatchQuery(str_replace("aliquot_masters", "aliquot_masters_revs", $queryToUpdate));
    }
}