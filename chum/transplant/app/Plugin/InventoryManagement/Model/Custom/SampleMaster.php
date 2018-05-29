<?php

class SampleMasterCustom extends SampleMaster
{

    var $useTable = 'sample_masters';

    var $name = 'SampleMaster';

    public function specimenSummary($variables = array())
    {
        $return = false;
        
        if (isset($variables['Collection.id']) && isset($variables['SampleMaster.initial_specimen_sample_id'])) {
            
            // TODO: Kidney transplant customisation
            if (Configure::read('chum_atim_conf') == 'KIDNEY_TRANSLPANT') {
                return parent::specimenSummary($variables);
            }
            
            // Get specimen data
            $criteria = array(
                'SampleMaster.collection_id' => $variables['Collection.id'],
                'SampleMaster.id' => $variables['SampleMaster.initial_specimen_sample_id']
            );
            $specimenData = $this->find('first', array(
                'conditions' => $criteria
            ));
            
            // Set summary
            $return = array(
                'menu' => array(
                    null,
                    __($specimenData['SampleControl']['sample_type'], true) . ' : ' . $specimenData['SampleMaster']['qc_nd_sample_label']
                ),
                'title' => array(
                    null,
                    __($specimenData['SampleControl']['sample_type'], true) . ' : ' . $specimenData['SampleMaster']['qc_nd_sample_label']
                ),
                'data' => $specimenData,
                'structure alias' => 'sample_masters_for_search_result'
            );
        }
        
        return $return;
    }

    public function derivativeSummary($variables = array())
    {
        $return = false;
        
        if (isset($variables['Collection.id']) && isset($variables['SampleMaster.initial_specimen_sample_id']) && isset($variables['SampleMaster.id'])) {
            
            // TODO: Kidney transplant customisation
            if (Configure::read('chum_atim_conf') == 'KIDNEY_TRANSLPANT') {
                return parent::derivativeSummary($variables);
            }
            
            // Get derivative data
            $criteria = array(
                'SampleMaster.collection_id' => $variables['Collection.id'],
                'SampleMaster.id' => $variables['SampleMaster.id']
            );
            $derivativeData = $this->find('first', array(
                'conditions' => $criteria
            ));
            
            // Set summary
            $return = array(
                'menu' => array(
                    null,
                    __($derivativeData['SampleControl']['sample_type'], true) . ' : ' . $derivativeData['SampleMaster']['qc_nd_sample_label']
                ),
                'title' => array(
                    null,
                    __($derivativeData['SampleControl']['sample_type'], true) . ' : ' . $derivativeData['SampleMaster']['qc_nd_sample_label']
                ),
                'data' => $derivativeData,
                'structure alias' => 'sample_masters_for_search_result'
            );
        }
        
        return $return;
    }

    public function createSampleLabel($collectionId, $sampleData, $bankParticipantIdentifier = null, $initialSpecimenLabel = null)
    {
        // Check parameters
        if (empty($collectionId) || empty($sampleData) || (! isset($sampleData['SampleMaster'])) || (! isset($sampleData['SampleControl']))) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $prevId = $this->id;
            
        // TODO: Kidney transplant customisation
        if (Configure::read('chum_atim_conf') == 'KIDNEY_TRANSLPANT') {
            return '';
        }
        
        // ** Set Data **
        
        $sampleCategory = null;
        if (array_key_exists('sample_category', $sampleData['SampleControl'])) {
            $sampleCategory = $sampleData['SampleControl']['sample_category'];
        } elseif (array_key_exists('SpecimenDetail', $sampleData)) {
            $sampleCategory = 'specimen';
        } elseif (array_key_exists('DerivativeDetail', $sampleData)) {
            $sampleCategory = 'derivative';
        }
        
        if (is_null($sampleCategory) || ! array_key_exists('sample_type', $sampleData['SampleControl']) || ! array_key_exists('qc_nd_sample_type_code', $sampleData['SampleControl'])) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        $sampleType = $sampleData['SampleControl']['sample_type'];
        $qcNdSampleTypeCode = $sampleData['SampleControl']['qc_nd_sample_type_code'];
        
        $specimenTypeCode = null;
        $specimenSequenceNumber = null;
        
        if ($sampleCategory == 'specimen') {
            if (! isset($sampleData['SpecimenDetail']) || ! array_key_exists('type_code', $sampleData['SpecimenDetail']) || ! array_key_exists('sequence_number', $sampleData['SpecimenDetail'])) {
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            
            $specimenTypeCode = (empty($sampleData['SpecimenDetail']['type_code'])) ? 'n/a' : $sampleData['SpecimenDetail']['type_code'];
            $specimenSequenceNumber = $sampleData['SpecimenDetail']['sequence_number'];
            $specimenSequenceNumber = (empty($specimenSequenceNumber) && (strcmp($specimenSequenceNumber, '0') != 0)) ? '' : '(' . $specimenSequenceNumber . ')';
        }
        
        if (is_null($initialSpecimenLabel) && (strcmp($sampleCategory, 'derivative') == 0)) {
            // Search initial specimen label
            if (! array_key_exists('initial_specimen_sample_id', $sampleData['SampleMaster'])) {
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            
            $this->contain();
            $tmpInitialSpecimenSampleData = $this->getOrRedirect($sampleData['SampleMaster']['initial_specimen_sample_id']);
            $initialSpecimenLabel = $tmpInitialSpecimenSampleData['SampleMaster']['qc_nd_sample_label'];
        }
        
        if (is_null($bankParticipantIdentifier) && ((strcmp($sampleCategory, 'specimen') == 0) || (strcmp($sampleType, 'cell culture') == 0))) {
            // Sample is a specimen and $bankParticipantIdentifier is unknown: Get $bankParticipantIdentifier
            $viewCollection = AppModel::getInstance('InventoryManagement', 'ViewCollection', true);
            $viewCollection = $viewCollection->getOrRedirect($collectionId);
            $bankParticipantIdentifier = $viewCollection['ViewCollection']['identifier_value'];
        }
        $bankParticipantIdentifier = empty($bankParticipantIdentifier) ? 'n/a' : $bankParticipantIdentifier;
        
        // ** Create sample label **
        
        $newSampleLabel = '';
        
        switch ($sampleType) {
            // Specimen
            case 'urine':
            case 'ascite':
            case 'peritoneal wash':
            case 'cystic fluid':
            case 'other fluid':
            case 'pleural fluid':
            case 'pericardial fluid':
            case 'nail':
            case 'saliva':
            case 'stool':
            case 'vaginal swab':
                $newSampleLabel = $specimenTypeCode . ' - ' . $bankParticipantIdentifier . (empty($specimenSequenceNumber) ? '' : ' ' . $specimenSequenceNumber);
                break;
            
            case 'blood':
                if (! array_key_exists('blood_type', $sampleData['SampleDetail'])) {
                    AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                $newSampleLabel = $specimenTypeCode . ' - ' . $bankParticipantIdentifier . (empty($specimenSequenceNumber) ? '' : ' ' . $specimenSequenceNumber) . (empty($sampleData['SampleDetail']['blood_type']) ? ' n/a' : ' ' . $sampleData['SampleDetail']['blood_type']);
                break;
            
            case 'tissue':
                if (! array_key_exists('labo_laterality', $sampleData['SampleDetail'])) {
                    AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                $newSampleLabel = $specimenTypeCode . ' - ' . $bankParticipantIdentifier . (empty($sampleData['SampleDetail']['labo_laterality']) ? ' n/a' : ' ' . $sampleData['SampleDetail']['labo_laterality']) . (empty($specimenSequenceNumber) ? '' : ' ' . $specimenSequenceNumber);
                break;
            
            // Derivative
            case 'ascite cell':
            case 'ascite supernatant':
            case 'blood cell':
            case 'pbmc':
            case 'b cell':
            case 'concentrated urine':
            case 'centrifuged urine':
            case 'amplified dna':
            case 'amplified rna':
            case 'purified rna':
            case 'tissue lysate':
            case 'tissue suspension':
            case 'peritoneal wash cell':
            case 'peritoneal wash supernatant':
            case 'cystic fluid cell':
            case 'cystic fluid supernatant':
            case 'other fluid cell':
            case 'other fluid supernatant':
            case 'plasma':
            case 'serum':
            case 'xenograft':
            case 'pleural fluid cell':
            case 'pleural fluid supernatant':
            case 'pericardial fluid cell':
            case 'pericardial fluid supernatant':
            case 'tumor infiltrating lymphocyte':
            case 'stool supernatant':
            case 'stool pellet':
            case 'stool dna extr. super.':
                $newSampleLabel = $qcNdSampleTypeCode . ' ' . $initialSpecimenLabel;
                break;
            
            case 'cell culture':
                if (! array_key_exists('qc_culture_population', $sampleData['SampleDetail'])) {
                    AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                
                if (! empty($sampleData['SampleDetail']['qc_culture_population'])) {
                    $initialSpecimenLabel = str_replace((' - ' . $bankParticipantIdentifier), (' - ' . $bankParticipantIdentifier . '.' . $sampleData['SampleDetail']['qc_culture_population']), $initialSpecimenLabel);
                }
                if (! array_key_exists('cell_passage_number', $sampleData['SampleDetail'])) {
                    AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                
                $newSampleLabel = $qcNdSampleTypeCode . ' ' . $initialSpecimenLabel . ((empty($sampleData['SampleDetail']['cell_passage_number']) && (strcmp($sampleData['SampleDetail']['cell_passage_number'], '0') != 0)) ? '' : ' P' . $sampleData['SampleDetail']['cell_passage_number']);
                break;
            
            case 'dna':
            case 'rna':
                if (! array_key_exists('source_cell_passage_number', $sampleData['SampleDetail'])) {
                    AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                
                $newSampleLabel = $qcNdSampleTypeCode . ' ' . $initialSpecimenLabel;
                
                if (is_numeric($sampleData['SampleMaster']['parent_id'])) {
                    $parentElement = $this->findById($sampleData['SampleMaster']['parent_id']);
                    if (isset($parentElement['SampleDetail']['qc_culture_population']) && is_numeric($parentElement['SampleDetail']['qc_culture_population'])) {
                        $newSampleLabel .= "." . $parentElement['SampleDetail']['qc_culture_population'];
                    }
                }
                
                if (is_numeric($sampleData['SampleDetail']['source_cell_passage_number'])) {
                    $newSampleLabel .= ' P' . $sampleData['SampleDetail']['source_cell_passage_number'];
                }
                
                break;
            
            default:
                // Type is unknown
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__ . 'type=' . $sampleType, null, true);
        }
        
        $this->id = $prevId;
        
        return $newSampleLabel;
    }

    private function validateLabTypeCodeAndLaterality(&$dataToValidate)
    {
        $processValidates = true;  
        
        // TODO: Kidney transplant customisation
        if (Configure::read('chum_atim_conf') == 'KIDNEY_TRANSLPANT') {
            return $processValidates;
        }
        
        if ((isset($dataToValidate['SampleControl']['sample_category']) && $dataToValidate['SampleControl']['sample_category'] === 'specimen') || (! isset($dataToValidate['SampleControl']['sample_category']) && array_key_exists('SpecimenDetail', $dataToValidate))) {
            // Load model to control data
            $labTypeLateralityMatch = AppModel::getInstance('InventoryManagement', 'LabTypeLateralityMatch', true);
            
            // Get Data
            if (! array_key_exists('sample_type', $dataToValidate['SampleControl']) || ! array_key_exists('SpecimenDetail', $dataToValidate) || ! array_key_exists('type_code', $dataToValidate['SpecimenDetail'])) {
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            $tmpSpecimenType = $dataToValidate['SampleControl']['sample_type'];
            $tmpSelectedTypeCode = $dataToValidate['SpecimenDetail']['type_code'];
            
            if ($tmpSpecimenType == 'tissue') {
                // ** Validate Tissue Specimen + Set tissue additional data **
                
                if (! array_key_exists('labo_laterality', $dataToValidate['SampleDetail'])) {
                    AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                $tmpLaboLaterality = $dataToValidate['SampleDetail']['labo_laterality'];
                
                $tissueSource = '';
                $nature = '';
                $laterality = '';
                
                if (! (empty($tmpSelectedTypeCode) && empty($tmpLaboLaterality))) {
                    // Search LabTypeLateralityMatch record
                    $criteria = array();
                    $criteria['LabTypeLateralityMatch.sample_type_matching'] = $tmpSpecimenType;
                    $criteria['LabTypeLateralityMatch.selected_type_code'] = $tmpSelectedTypeCode;
                    $criteria['LabTypeLateralityMatch.selected_labo_laterality'] = $tmpLaboLaterality;
                    
                    $matchingRecords = $labTypeLateralityMatch->find('all', array(
                        'conditions' => $criteria
                    ));
                    
                    if (empty($matchingRecords)) {
                        // The selected type code and labo laterality combination not currently supported by the laboratory
                        $processValidates = false;
                        $this->validationErrors['labo_laterality'][] = 'the selected type code and labo laterality combination is not supported';
                        $this->validationErrors['type_code'][] = 'the selected type code and labo laterality combination is not supported';
                    } elseif (count($matchingRecords) > 1) {
                        // Only one row should be defined in model 'LabTypeLateralityMatch'
                        // for this specific combination sample_type_matching.selected_type_code.selected_labo_laterality
                        AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    } else {
                        // Set automatically tissue source, nature and laterality
                        $tissueSource = $matchingRecords[0]['LabTypeLateralityMatch']['tissue_source_matching'];
                        $nature = $matchingRecords[0]['LabTypeLateralityMatch']['nature_matching'];
                        $laterality = $matchingRecords[0]['LabTypeLateralityMatch']['laterality_matching'];
                    }
                }
                
                // Set tissue additional data
                $dataToValidate['SampleDetail']['tissue_source'] = $tissueSource;
                $dataToValidate['SampleDetail']['tissue_nature'] = $nature;
                $dataToValidate['SampleDetail']['tissue_laterality'] = $laterality;
            } else {
                // ** Validate All Specimen Except Tissue **
                
                if (! empty($tmpSelectedTypeCode)) {
                    // Type code has been selected: Check this one matches sample type
                    
                    $criteria = array();
                    $criteria['LabTypeLateralityMatch.sample_type_matching'] = $tmpSpecimenType;
                    $criteria['LabTypeLateralityMatch.selected_type_code'] = $tmpSelectedTypeCode;
                    $criteria['LabTypeLateralityMatch.selected_labo_laterality'] = '';
                    
                    $matchingRecords = $labTypeLateralityMatch->find('all', array(
                        'conditions' => $criteria
                    ));
                    
                    if (empty($matchingRecords)) {
                        // The selected type code and labo laterality combination is not currently supported by the laboratory
                        $processValidates = false;
                        $this->validationErrors[] = 'the selected type code does not match sample type';
                    } elseif (count($matchingRecords) > 1) {
                        // Only one row should be defined in model 'LabTypeLateralityMatch'
                        // for this specific combination sample_type_matching.selected_type_code.selected_labo_laterality
                        AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    }
                }
            }
        }
        
        return $processValidates;
    }

    public function formatParentSampleDataForDisplay($parentSampleData)
    {
        $formattedData = array();
        if (! empty($parentSampleData)) {
            if (isset($parentSampleData['SampleMaster'])) {
                $formattedData[$parentSampleData['SampleMaster']['id']] = $parentSampleData['SampleMaster']['qc_nd_sample_label'] . ' [' . __($parentSampleData['SampleControl']['sample_type'], true) . ']';
            } elseif (isset($parentSampleData[0]['ViewSample'])) {
                foreach ($parentSampleData as $newParent) {
                    $formattedData[$newParent['ViewSample']['sample_master_id']] = $newParent['ViewSample']['qc_nd_sample_label'] . ' [' . __($newParent['ViewSample']['sample_type'], true) . ']';
                }
            }
        }
        return $formattedData;
    }

    public function validates($options = array())
    {
        $result = parent::validates($options);
        
        // --------------------------------------------------------------------------------
        // Check selected type code for all specimen plus set read only fields for tissue
        // (tissue source, nature, laterality)
        // --------------------------------------------------------------------------------
        if (! $this->validateLabTypeCodeAndLaterality($this->data)) {
            $result = false;
        }
        
        return $result;
    }
}