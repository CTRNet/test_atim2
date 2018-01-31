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
            
            $aliquotPrecision = '';
            if (array_key_exists('block_type', $result['AliquotDetail']) && $result['AliquotDetail']['block_type']) {
                $query = array(
                    'recursive' => 2,
                    'conditions' => array(
                        'StructureValueDomain.domain_name' => 'block_type'
                    )
                );
                App::uses("StructureValueDomain", 'Model');
                $structureValueDomainModel = new StructureValueDomain();
                $bloodTypesList = $structureValueDomainModel->find('first', $query);
                if (isset($bloodTypesList['StructurePermissibleValue'])) {
                    foreach ($bloodTypesList['StructurePermissibleValue'] as $newType)
                        if ($newType['value'] == $result['AliquotDetail']['block_type'])
                            $aliquotPrecision = ' - ' . __($newType['language_alias']);
                }
            }
            
            $return = array(
                'menu' => array(
                    null,
                    __($result['AliquotControl']['aliquot_type']) . $aliquotPrecision . ' : ' . $result['AliquotMaster']['aliquot_label']
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

    public function generateDefaultAliquotLabel($sampleMasterId, $aliquotControlData)
    {
        // Parameters check: Verify parameters have been set
        if (empty($sampleMasterId) || empty($aliquotControlData))
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            
            // Get Sample Data
        $sampleMasterModel = AppModel::getInstance('InventoryManagement', 'SampleMaster', true);
        $sampleMasterModel->unbindModel(array(
            'hasMany' => array(
                'AliquotMaster'
            ),
            'belongsTo' => array(
                'Collection'
            )
        ));
        $sampleData = $sampleMasterModel->redirectIfNonExistent($sampleMasterId, __METHOD__, __LINE__, true);
        if (empty($sampleData)) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $sampleLabel = null;
        $aliquotCreationDate = null;
        if ($sampleData['SampleControl']['sample_category'] == 'specimen') {
            $sampleLabel = $this->createSpecimenSampleLabel($sampleData['SampleMaster']['collection_id'], $sampleMasterId, $sampleData);
            $aliquotCreationDate = $sampleData['SpecimenDetail']['reception_datetime'];
            
            switch ($sampleData['SampleControl']['sample_type']) {
                case 'blood':
                    break;
                case 'tissue':
                    $sampleLabel .= ' -' . (($aliquotControlData['AliquotControl']['aliquot_type'] == 'block') ? 'OCT' : 'SF');
                    break;
                default:
                    // Type is unknown
                    AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
        } elseif ($sampleData['SampleControl']['sample_category'] == 'derivative') {
            $initialSpecimenLabel = $this->createSpecimenSampleLabel($sampleData['SampleMaster']['collection_id'], $sampleData['SampleMaster']['initial_specimen_sample_id']);
            $sampleTypeCode = ''; // $sampleData['SampleControl']['sample_type_code'];//TODO, sample_type_code has been removed from 2.4.0
            
            switch ($sampleData['SampleControl']['sample_type']) {
                case 'pbmc':
                    $sampleTypeCode = 'PBMC';
                    break;
                case 'plasma':
                    $sampleTypeCode = 'PLS';
                    break;
                case 'serum':
                    $sampleTypeCode = 'SER';
                    break;
                case 'tissue suspension':
                    $sampleTypeCode = 'T-SUSP';
                    break;
                case 'dna':
                    $sampleTypeCode = 'DNA';
                    break;
                case 'rna':
                    $sampleTypeCode = 'RNA';
                    break;
                default:
                    // Type is unknown
                    AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            $sampleLabel = $sampleTypeCode . ' ' . $initialSpecimenLabel;
            $aliquotCreationDate = $sampleData['DerivativeDetail']['creation_datetime'];
        } else {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        return $sampleLabel . (empty($aliquotCreationDate) ? '' : ' ' . substr($aliquotCreationDate, 0, strpos($aliquotCreationDate, " ")));
    }

    public function createSpecimenSampleLabel($collectionId, $specimenSampleMasterId, $specimenData = null)
    {
        $newSampleLabel = null;
        
        // Parameters check: Verify parameters have been set
        if (empty($collectionId) || empty($specimenSampleMasterId)) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        if (is_null($specimenData)) {
            // Get Specimen Data
            $sampleMasterModel = AppModel::getInstance('InventoryManagement', 'SampleMaster', true);
            $sampleMasterModel->unbindModel(array(
                'hasMany' => array(
                    'AliquotMaster'
                ),
                'belongsTo' => array(
                    'Collection'
                )
            ));
            $specimenData = $sampleMasterModel->find('first', array(
                'conditions' => array(
                    'SampleMaster.collection_id' => $collectionId,
                    'SampleMaster.id' => $specimenSampleMasterId
                )
            ));
            if (empty($specimenData)) {
                AppController::getInstance()->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
        }
        
        if (! isset($specimenData['SpecimenDetail'])) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Build label
        if (! array_key_exists('qc_hb_sample_code', $specimenData['SpecimenDetail'])) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        $specimenTypeCode = (empty($specimenData['SpecimenDetail']['qc_hb_sample_code'])) ? 'n/a' : $specimenData['SpecimenDetail']['qc_hb_sample_code'];
        
        $ViewCollection = AppModel::getInstance('InventoryManagement', 'ViewCollection', true);
        $viewCollection = $ViewCollection->find('first', array(
            'conditions' => array(
                'ViewCollection.collection_id' => $collectionId
            )
        ));
        if (empty($viewCollection)) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        $bankParticipantIdentifier = empty($viewCollection['ViewCollection']['participant_identifier']) ? 'n/a' : $viewCollection['ViewCollection']['participant_identifier'];
        
        $newSampleLabel = $specimenTypeCode . ' - ' . $bankParticipantIdentifier;
        switch ($specimenData['SampleControl']['sample_type']) {
            // Specimen
            case 'blood':
                if (! array_key_exists('blood_type', $specimenData['SampleDetail'])) {
                    AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                $newSampleLabel .= (empty($specimenData['SampleDetail']['blood_type']) ? ' n/a' : ' ' . $specimenData['SampleDetail']['blood_type']);
                break;
            
            case 'tissue':
                break;
            
            default:
                // Type is unknown
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        return $newSampleLabel;
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