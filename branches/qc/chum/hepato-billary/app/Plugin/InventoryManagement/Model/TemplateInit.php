<?php

/**
 * Class TemplateInit
 */
class TemplateInit extends InventoryManagementAppModel
{

    public $useTable = false;

    /**
     *
     * @param array $options
     * @return bool
     */
    public function validates($options = array())
    {
        $this->_schema = array();
        $result = parent::validates($options);
        
        // Note that a model validate array is empty if it's not created at the controller array
        // eg.: SpecimenDetail is created via the "uses" array, so the validation rules are defined.
        // Otherwise, on has to add it before setting the structures (which in turn sets the validation).
        // eg.: AppController::getInstance()->AliquotMaster = AppModel::getInstance('InventoryManagement', 'AliquotMaster'); would make AliquotMaster ready to recieve validation rules
        $modelsNames = array(
            'SpecimenDetail',
            'DerivativeDetail',
            'SampleMaster',
            'AliquotMaster'
        );
        // Set a default control id to fix bug #3226 : Unable to use field with MasterModel in template_init_structure
        $this->data['TemplateInit']['SampleMaster']['sample_control_id'] = 1;
        $this->data['TemplateInit']['AliquotMaster']['aliquot_control_id'] = 1;
        foreach ($modelsNames as $modelName) {
            if (array_key_exists($modelName, $this->data['TemplateInit'])) {
                $model = AppModel::getInstance('InventoryManagement', $modelName);
                $model->set(array(
                    $modelName => $this->data['TemplateInit'][$modelName]
                ));
                $result = $model->validates() ? $result : false;
                $this->validationErrors = array_merge($model->validationErrors, $this->validationErrors);
                $this->data['TemplateInit'][$modelName] = $model->data[$modelName];
            }
        }
        // Set a default control id to fix bug #3638 : Unable to use field 'Reception Date in Pathology' in tempalte init
        $modelsNames = array(
            array(
                'SampleMaster',
                'SampleDetail',
                'sample_control_id',
                AppModel::getInstance('InventoryManagement', 'SampleMaster')
            ),
            array(
                'AliquotMaster',
                'AliquotDetail',
                'aliquot_control_id',
                AppModel::getInstance('InventoryManagement', 'AliquotMaster')
            )
        );
        $detailFieldsControlIdsForValidation = $this->getTemplatetDetailFieldsControlIds();
        foreach ($modelsNames as $detailModelData) {
            list ($masterModelName, $detailModelName, $controlIdName, $model) = $detailModelData;
            if (array_key_exists($detailModelName, $this->data['TemplateInit'])) {
                foreach ($this->data['TemplateInit'][$detailModelName] as $fieldName => $fieldData) {
                    $tmpControlId = 1;
                    if ($detailFieldsControlIdsForValidation[$detailModelName][$fieldName] && sizeof($detailFieldsControlIdsForValidation[$detailModelName][$fieldName]) == 1) {
                        $tmpArray = $detailFieldsControlIdsForValidation[$detailModelName][$fieldName];
                        $tmpControlId = array_shift($tmpArray);
                    } elseif (is_array($fieldData)) {
                        $result = false;
                        // The tablename of the date/datetime field is either missing or could be assigned to multi-tables
                        $this->validationErrors[$fieldName][] = __('template init error please contact your administrator');
                    }
                    $model->set(array(
                        $masterModelName => array(
                            $controlIdName => $tmpControlId
                        ),
                        $detailModelName => array(
                            $fieldName => $fieldData
                        )
                    ));
                    $result = $model->validates() ? $result : false;
                    $this->validationErrors = array_merge($model->validationErrors, $this->validationErrors);
                    $this->data['TemplateInit'][$detailModelName][$fieldName] = $model->data[$detailModelName][$fieldName];
                    if (isset($model->data[$detailModelName][$fieldName . '_accuracy'])) {
                        $this->data['TemplateInit'][$detailModelName][$fieldName . '_accuracy'] = $model->data[$detailModelName][$fieldName . '_accuracy'];
                    }
                }
            }
        }
        
        // adjust accuracy
        $this->data['TemplateInit'] = Set::flatten($this->data['TemplateInit']);
        foreach ($this->data['TemplateInit'] as $key => &$value) {
            if (isset($this->data['TemplateInit'][$key . '_accuracy'])) {
                switch ($this->data['TemplateInit'][$key . '_accuracy']) {
                    case 'i':
                        $value = substr($value, 0, 13);
                        break;
                    case 'h':
                        $value = substr($value, 0, 10);
                        break;
                    case 'd':
                        $value = substr($value, 0, 7);
                        break;
                    case 'm':
                        $value = substr($value, 0, 4);
                        break;
                    case 'y':
                        $value = '±' . substr($value, 0, 4);
                        break;
                    default:
                        break;
                }
                
                // no more use for that field
                unset($this->data['TemplateInit'][$key . '_accuracy']);
            }
        }
        unset($value);
        
        $output = array();
        foreach ($this->data['TemplateInit'] as $key => $value) {
            $output = Set::insert($output, $key, $value);
        }
        $this->data['TemplateInit'] = $output;
        
        return $result;
    }

    /**
     *
     * @return array
     */
    public function getTemplatetDetailFieldsControlIds()
    {
        $sampleControlModel = AppModel::getInstance('InventoryManagement', 'SampleControl');
        $aliquotControlModel = AppModel::getInstance('InventoryManagement', 'AliquotControl');
        $templateInitStructure = AppController::getInstance()->Structures->get('form', 'template_init_structure');
        $detailFieldsControlIdsForValidation = array();
        foreach ($templateInitStructure['Sfs'] as $newStructureField) {
            if (in_array($newStructureField['model'], array(
                'SampleDetail',
                'AliquotDetail'
            ))) {
                if ($newStructureField['tablename']) {
                    if (! isset($detailFieldsControlIdsForValidation[$newStructureField['model']][$newStructureField['field']]) || ! array_key_exists($newStructureField['tablename'], $detailFieldsControlIdsForValidation[$newStructureField['model']][$newStructureField['field']])) {
                        if ($newStructureField['model'] == 'SampleDetail') {
                            $sampleControl = $sampleControlModel->find('first', array(
                                'conditions' => array(
                                    'SampleControl.detail_tablename' => $newStructureField['tablename']
                                )
                            ));
                            if ($sampleControl) {
                                $detailFieldsControlIdsForValidation[$newStructureField['model']][$newStructureField['field']][$newStructureField['tablename']] = $sampleControl['SampleControl']['id'];
                            }
                        } else {
                            $aliquotControl = $aliquotControlModel->find('first', array(
                                'conditions' => array(
                                    'AliquotControl.detail_tablename' => $newStructureField['tablename']
                                )
                            ));
                            if ($aliquotControl) {
                                $detailFieldsControlIdsForValidation[$newStructureField['model']][$newStructureField['field']][$newStructureField['tablename']] = $aliquotControl['SampleControl']['id'];
                            }
                        }
                    }
                }
            }
        }
        return $detailFieldsControlIdsForValidation;
    }
}