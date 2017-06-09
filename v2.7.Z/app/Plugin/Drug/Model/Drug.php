<?php

class Drug extends DrugAppModel
{

    public $name = 'Drug';

    public $useTable = 'drugs';

    public $drugTitlesAlreadyChecked = array();

    public $drugDataAndCodeForDisplayAlreadySet = array();

    function summary($variables = array())
    {
        $return = false;
        
        if (isset($variables['Drug.id'])) {
            
            $result = $this->find('first', array(
                'conditions' => array(
                    'Drug.id' => $variables['Drug.id']
                )
            ));
            
            $return = array(
                'menu' => array(
                    NULL,
                    $result['Drug']['generic_name']
                ),
                'title' => array(
                    NULL,
                    $result['Drug']['generic_name']
                ),
                'data' => $result,
                'structure alias' => 'drugs'
            );
        }
        
        return $return;
    }

    /**
     * Get permissible values array gathering all existing drugs.
     *
     * @author N. Luc
     * @since 2010-05-26
     *        @updated N. Luc
     */
    function getDrugPermissibleValues()
    {
        $result = array();
        foreach ($this->find('all', array(
            'order' => array(
                'Drug.generic_name'
            )
        )) as $drug) {
            $result[$drug["Drug"]["id"]] = $drug["Drug"]["generic_name"];
        }
        return $result;
    }

    /**
     * Check if a record can be deleted.
     *
     * @param $drugId Id
     *            of the studied record.
     *            
     * @return Return results as array:
     *         ['allow_deletion'] = true/false
     *         ['msg'] = message to display when previous field equals false
     *        
     * @author N. Luc
     * @since 2007-10-16
     */
    function allowDeletion($drugId)
    {
        $TreatmentExtendMaster = AppModel::getInstance("ClinicalAnnotation", "TreatmentExtendMaster", true);
        $returnedNbr = $TreatmentExtendMaster->find('count', array(
            'conditions' => array(
                'TreatmentExtendMaster.drug_id' => $drugId
            ),
            'recursive' => '1'
        ));
        if ($returnedNbr > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'drug is defined as a component of at least one participant treatment'
            );
        }
        
        $ProtocolExtendMaster = AppModel::getInstance("Protocol", "ProtocolExtendMaster", true);
        $returnedNbr = $ProtocolExtendMaster->find('count', array(
            'conditions' => array(
                'ProtocolExtendMaster.drug_id' => $drugId
            ),
            'recursive' => '1'
        ));
        if ($returnedNbr > 0) {
            return array(
                'allow_deletion' => false,
                'msg' => 'drug is defined as a component of at least one protocol'
            );
        }
        
        return array(
            'allow_deletion' => true,
            'msg' => ''
        );
    }

    function getDrugDataAndCodeForDisplay($drugData)
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
                $this->drugDataAndCodeForDisplayAlreadySet[$drugData['Drug']['id']] = $drugData['Drug']['generic_name'] . ' [' . $drugData['Drug']['id'] . ']';
            }
            $formattedData = $this->drugDataAndCodeForDisplayAlreadySet[$drugData['Drug']['id']];
        }
        return $formattedData;
    }

    function getDrugIdFromDrugDataAndCode($drugDataAndCode)
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
            if (preg_match("/(.+)\[([0-9]+)\]$/", $drugDataAndCode, $matches) > 0) {
                // Auto complete tool has been used
                $selectedDrugs = $this->find('all', array(
                    'conditions' => array(
                        "Drug.generic_name LIKE '%" . trim($matches[1]) . "%'",
                        'Drug.id' => $matches[2]
                    )
                ));
            } else {
                // consider $drugDataAndCode contains just drug title
                $term = str_replace('_', '\_', str_replace('%', '\%', $drugDataAndCode));
                $terms = array();
                foreach (explode(' ', $term) as $keyWord)
                    $terms[] = "Drug.generic_name LIKE '%" . $keyWord . "%'";
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
}