<?php

class CollectionCustom extends Collection
{

    var $name = 'Collection';

    var $useTable = 'collections';

    public function getSpecimenTypePrecision($dataEntry = false, $predefinedSpecimenType = null)
    {
        $lang = Configure::read('Config.language') == "eng" ? "en" : "fr";
        $StructurePermissibleValuesCustom = AppModel::getInstance('', 'StructurePermissibleValuesCustom', true);
        
        $typesToAdd = array(
            'tissue' => 'Tissue',
            'blood' => 'Blood'
        );
        if (! is_null($predefinedSpecimenType)) {
            if (! array_key_exists($predefinedSpecimenType, $typesToAdd))
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            $typesToAdd = array(
                $predefinedSpecimenType => $typesToAdd[$predefinedSpecimenType]
            );
        }
        
        $result = array(
            '' => ''
        );
        foreach ($typesToAdd as $newTypeLowerCase => $newType) {
            $conditions = array(
                'StructurePermissibleValuesCustomControl.name' => 'Collection : ' . $newType . ' type precision'
            );
            if ($dataEntry)
                $conditions['StructurePermissibleValuesCustom.use_as_input'] = '1';
            $allValues = $StructurePermissibleValuesCustom->find('all', array(
                'conditions' => $conditions
            ));
            foreach ($allValues as $newValue) {
                $result[$newTypeLowerCase . '||' . $newValue['StructurePermissibleValuesCustom']['value']] = __($newTypeLowerCase) . ' : ' . (strlen($newValue['StructurePermissibleValuesCustom'][$lang]) ? $newValue['StructurePermissibleValuesCustom'][$lang] : $newValue['StructurePermissibleValuesCustom']['value']);
            }
        }
        asort($result);
        return $result;
    }

    public function validates($options = array())
    {
        parent::validates($options);
        
        if ((! array_key_exists('deleted', $this->data['Collection']) || ! $this->data['Collection']['deleted']) && (array_key_exists('qc_lady_follow_up', $this->data['Collection']) || array_key_exists('qc_lady_pre_op', $this->data['Collection']) || array_key_exists('qc_lady_banking_nbr', $this->data['Collection']) || array_key_exists('qc_lady_visit', $this->data['Collection']))) {
            $custErrorDetected = false;
            $qcLadySpecimenType = substr($this->data['Collection']['qc_lady_specimen_type_precision'], 0, strpos($this->data['Collection']['qc_lady_specimen_type_precision'], '||'));
            switch ($qcLadySpecimenType) {
                case 'tissue':
                    if (strlen($this->data['Collection']['qc_lady_follow_up'] . $this->data['Collection']['qc_lady_pre_op'] . $this->data['Collection']['qc_lady_banking_nbr']))
                        $custErrorDetected = true;
                    break;
                case 'blood':
                    if (strlen($this->data['Collection']['qc_lady_visit']))
                        $custErrorDetected = true;
                    break;
                default:
                    $this->validationErrors['qc_lady_specimen_type_precision'][] = __('value is required');
            }
            if ($custErrorDetected)
                $this->validationErrors['qc_lady_specimen_type_precision'][] = str_replace('%s', __($qcLadySpecimenType), __('the fields you are completing cannot be used for a collection having %s type'));
        }
        
        return empty($this->validationErrors);
    }
}