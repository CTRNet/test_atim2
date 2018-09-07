<?php

class DrugCustom extends Drug
{

    var $useTable = 'drugs';

    var $name = 'Drug';

    private $testedDrugs = array();

    public function getDrugDataAndCodeForDisplay($drugData)
    {
        
        // -- NOTE ----------------------------------------------------------------
        //
        // This function is linked to a function of the Drug controller
        // called autocompleteDrug()
        // and to functions of the Drug model
        // getDrugIdFromDrugDataAndCode().
        //
        // When you override the getDrugDataAndCodeForDisplay() function,
        // check if you need to override these functions.
        //
        // ------------------------------------------------------------------------
        $formattedData = '';
        if ((! empty($drugData)) && isset($drugData['Drug']['id']) && (! empty($drugData['Drug']['id']))) {
            if (! isset($this->drugDataAndCodeForDisplayAlreadySet[$drugData['Drug']['id']])) {
                if (! isset($drugData['Drug']['generic_name'])) {
                    $drugData = $this->find('first', array(
                        'conditions' => array(
                            'Drug.id' => ($drugData['Drug']['id'])
                        )
                    ));
                }
                if (isset($newTx['Drug']['procure_study']) && $newTx['Drug']['procure_study']) {
                    $newTx['Drug']['generic_name'] .= ' (' . __('experimental treatment') . ')';
                }
                $this->drugDataAndCodeForDisplayAlreadySet[$drugData['Drug']['id']] = $drugData['Drug']['generic_name'] . ($drugData['Drug']['procure_study'] ? ' (' . __('experimental treatment') . ')' : '') . " [" . $drugData['Drug']['id'] . ']';
            }
            $formattedData = $this->drugDataAndCodeForDisplayAlreadySet[$drugData['Drug']['id']];
        }
        return $formattedData;
    }

    public function getDrugIdFromDrugDataAndCode($drugDataAndCode)
    {
        
        // -- NOTE ----------------------------------------------------------------
        //
        // This function is linked to a function of the Drug controller
        // called autocompleteDrug()
        // and to function of the Drug model
        // getDrugDataAndCodeForDisplay().
        //
        // When you override the getDrugIdFromDrugDataAndCode() function,
        // check if you need to override these functions.
        //
        // ------------------------------------------------------------------------
        if (! isset($this->drugTitlesAlreadyChecked[$drugDataAndCode])) {
            $matches = array();
            $selectedDrugs = array();
            if (preg_match("/(.+)\[([0-9]+)\]$/", str_replace(' (' . __('experimental treatment') . ')', '', $drugDataAndCode), $matches) > 0) {
                // Auto complete tool has been used
                $selectedDrugs = $this->find('all', array(
                    'conditions' => array(
                        "Drug.generic_name LIKE " => '%' .trim($matches[1]) . '%',
                        'Drug.id' => $matches[2]
                    )
                ));
            } else {
                // consider $drugDataAndCode contains just drug title
                $term = str_replace(array(
                    "\\",
                    '%',
                    '_'
                ), array(
                    "\\\\",
                    '\%',
                    '\_'
                ), $drugDataAndCode);
                $terms = array();
                foreach (explode(' ', $term) as $keyWord)
                    $terms["Drug.generic_name LIKE "] = '%' . $keyWord . '%';
                $conditions = array(
                    'AND' => $terms
                );
                $selectedDrugs = $this->find('all', array(
                    'conditions' => $conditions
                ));
            }
            if (sizeof($selectedDrugs) == 1) {
                $this->drugTitlesAlreadyChecked[$drugDataAndCode] = array(
                    'Drug' => $selectedDrugs[0]['Drug']
                );
            } elseif (sizeof($selectedDrugs) > 1) {
                $this->drugTitlesAlreadyChecked[$drugDataAndCode] = array(
                    'error' => str_replace('%s', $drugDataAndCode, __('more than one drug matches the following data [%s]'))
                );
            } else {
                $this->drugTitlesAlreadyChecked[$drugDataAndCode] = array(
                    'error' => str_replace('%s', $drugDataAndCode, __('no drug matches the following data [%s]'))
                );
            }
        }
        return $this->drugTitlesAlreadyChecked[$drugDataAndCode];
    }

    public function allowDeletion($drugId)
    {
        $TreatmentMaster = AppModel::getInstance("ClinicalAnnotation", "TreatmentMaster", true);
        $returnedNbr = $TreatmentMaster->find('count', array(
            'conditions' => array(
                'TreatmentMaster.procure_drug_id' => $drugId
            ),
            'recursive' => 1
        ));
        if ($returnedNbr > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'drug is defined as a component of at least one participant treatment'
            );
        }
        
        return parent::allowDeletion($drugId);
    }

    public function validates($options = array())
    {
        if (isset($this->data['Drug']['generic_name'])) {
            $this->data['Drug']['generic_name'] = trim($this->data['Drug']['generic_name']);
            $this->checkDuplicatedDrug($this->data);
        }
        return parent::validates($options);
    }

    public function checkDuplicatedDrug($drugData)
    {
        
        // check data structure
        $tmpArrToCheck = array_values($drugData);
        if ((! is_array($drugData)) || (is_array($tmpArrToCheck) && isset($tmpArrToCheck[0]['Drug']))) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        $genericName = $drugData['Drug']['generic_name'];
        $procureStudy = $drugData['Drug']['procure_study'];
        $keyDrug = "$genericName [$procureStudy]";
            
            // Check duplicated drug into submited record
        if (! strlen($genericName)) {
            // Not studied
        } elseif (isset($this->testedDrugs[$keyDrug])) {
            $this->validationErrors['generic_name'][] = str_replace('%s', $genericName . ($procureStudy ? ' (' . __('experimental treatment') . ')' : ''), __('you can not record drug [%s] twice'));
        } else {
            $this->testedDrugs[$keyDrug] = '';
        }
        
        // Check duplicated barcode into db
        $criteria = array(
            'Drug.generic_name' => $genericName,
            'Drug.procure_study' => $procureStudy
        );
        $drugsHavingDuplicatedName = $this->find('all', array(
            'conditions' => $criteria,
            'recursive' => - 1
        ));
        ;
        if (! empty($drugsHavingDuplicatedName)) {
            foreach ($drugsHavingDuplicatedName as $duplicate) {
                if ((! array_key_exists('id', $drugData['Drug'])) || ($duplicate['Drug']['id'] != $drugData['Drug']['id'])) {
                    $this->validationErrors['generic_name'][] = str_replace('%s', $genericName . ($procureStudy ? ' (' . __('experimental treatment') . ')' : ''), __('the drug [%s] has already been recorded'));
                }
            }
        }
    }
}