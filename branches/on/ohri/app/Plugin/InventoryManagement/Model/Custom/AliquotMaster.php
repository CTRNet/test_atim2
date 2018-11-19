<?php

class AliquotMasterCustom extends AliquotMaster
{

    var $useTable = 'aliquot_masters';

    var $name = 'AliquotMaster';

    public function summary($variables = array())
    {
        $return = false;
        
        if (isset($variables['Collection.id']) && isset($variables['SampleMaster.id']) && isset($variables['AliquotMaster.id'])) {
            
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
                    __($result['AliquotControl']['aliquot_type']) . ' : ' . $result['AliquotMaster']['aliquot_label']
                ),
                'title' => array(
                    null,
                    __($result['AliquotControl']['aliquot_type']) . ' : ' . $result['AliquotMaster']['aliquot_label']
                ),
                'data' => $result,
                'structure alias' => 'aliquot_masters'
            );
        }
        
        return $return;
    }

    public function getDefaultLabel($viewSampleData, $aliquotControlId, $isRealiquoting = false)
    {
        $initalData = array();
        
        if (in_array($viewSampleData['sample_type'], array(
            'ascite supernatant',
            'ascite cell',
            'cell culture',
            'tissue'
        ))) {
            
            // Participant participant_id and Bank Number
            $bankNumber = empty($viewSampleData['misc_identifier_value']) ? 'n/a' : $viewSampleData['misc_identifier_value'];
            $participantId = empty($viewSampleData['participant_id']) ? null : $viewSampleData['participant_id'];
            
            // Get aliquot already created
            $aliquotControlData = $this->AliquotControl->findById($aliquotControlId);
            $criteria = array(
                'ViewAliquot.sample_control_id' => $viewSampleData['sample_control_id'],
                'ViewAliquot.aliquot_control_id' => $aliquotControlData['AliquotControl']['id']
            );
            if (empty($participantId)) {
                $criteria['ViewAliquot.collection_id'] = $viewSampleData['collection_id'];
            } else {
                $criteria['ViewAliquot.participant_id'] = $participantId;
            }
            $existingAliquotsList = $this->ViewAliquot->find('all', array(
                'conditions' => $criteria
            ));
            
            switch ($viewSampleData['sample_type']) {
                
                case 'ascite supernatant':
                    $initalData[0]['AliquotMaster']['aliquot_label'] = $bankNumber . ' S' . (sizeof($existingAliquotsList) + 1);
                    $initalData[0]['AliquotMaster']['initial_volume'] = '15';
                    
                    break;
                
                case 'ascite cell':
                    $ids = array();
                    foreach ($existingAliquotsList as $newAliq) {
                        $ids[] = $newAliq['ViewAliquot']['aliquot_master_id'];
                    }
                    
                    $flashFrozenCount = 0;
                    $dmsoCount = 0;
                    if (! empty($existingAliquotsList)) {
                        $aliquotsDetails = $this->find('all', array(
                            'conditions' => array(
                                'AliquotMaster.id' => $ids
                            )
                        ));
                        foreach ($aliquotsDetails as $tmpAl) {
                            if (isset($tmpAl['AliquotDetail']['ohri_storage_method']) && $tmpAl['AliquotDetail']['ohri_storage_method'] == 'flash frozen') {
                                $flashFrozenCount ++;
                            } elseif (isset($tmpAl['AliquotDetail']['ohri_storage_solution']) && $tmpAl['AliquotDetail']['ohri_storage_solution'] == 'dmso') {
                                $dmsoCount ++;
                            }
                        }
                    }
                    
                    $initalData[0]['AliquotMaster']['initial_volume'] = '1';
                    $initalData[1] = $initalData[0];
                    
                    $initalData[0]['AliquotDetail']['ohri_storage_method'] = 'flash frozen';
                    $initalData[0]['AliquotMaster']['aliquot_label'] = $bankNumber . ' A' . ($flashFrozenCount + 1);
                    
                    $initalData[1]['AliquotDetail']['ohri_storage_solution'] = 'dmso';
                    $initalData[1]['AliquotMaster']['aliquot_label'] = $bankNumber . ' C' . ($dmsoCount + 1);
                    break;
                
                case 'cell culture':
                    $initalData[0]['AliquotMaster']['initial_volume'] = '1';
                    break;
                
                case 'tissue':
                    if ($aliquotControlData['AliquotControl']['aliquot_type'] == 'block') {
                        $initalData[0]['AliquotMaster']['aliquot_label'] = $bankNumber . ' B' . (sizeof($existingAliquotsList) + 1);
                        $initalData[0]['AliquotDetail']['block_type'] = 'paraffin';
                    } elseif ($aliquotControlData['AliquotControl']['aliquot_type'] == 'tube') {
                        $initalData[0]['AliquotMaster']['aliquot_label'] = $bankNumber . ' T' . (sizeof($existingAliquotsList) + 1);
                        $initalData[0]['AliquotDetail']['ohri_storage_method'] = 'flash frozen';
                    }
                    break;
                
                default:
            }
        }
        
        return $initalData;
    }

    public function regenerateAliquotBarcode()
    {
        $aliquotsToUpdate = $this->find('all', array(
            'conditions' => array(
                "AliquotMaster.barcode IS NULL OR AliquotMaster.barcode LIKE ''"
            ),
            'fields' => array(
                'AliquotMaster.id'
            )
        ));
        foreach ($aliquotsToUpdate as $newAliquot) {
            $newAliquotId = $newAliquot['AliquotMaster']['id'];
            $aliquotData = array(
                'AliquotMaster' => array(
                    'barcode' => $newAliquotId
                ),
                'AliquotDetail' => array()
            );
            
            $this->id = $newAliquotId;
            $this->data = null;
            $this->addWritableField(array(
                'barcode'
            ));
            $this->save($aliquotData, false);
        }
    }
}