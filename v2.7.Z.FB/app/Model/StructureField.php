<?php

/**
 * Class StructureField
 */
class StructureField extends AppModel
{

    public $name = 'StructureField';

    public $hasMany = array(
        'StructureValidation'
    );

    /*
     * var $hasOne = array(
     * 'StructureValueDomain' => array(
     * 'className' => 'StructureValueDomain',
     * 'foreignKey' => false,
     * 'finderQuery' => '
     * SELECT
     * StructureValueDomain.*
     * FROM
     * structure_fields AS StructureField,
     * structure_value_domains AS StructureValueDomain
     * WHERE
     * StructureField.id={$__cakeID__$}
     * AND StructureField.structure_value_domain=StructureValueDomain.domain_name
     * '
     * )
     * );
     */
    public $belongsTo = array(
        'StructureValueDomain' => array(
            'className' => 'StructureValueDomain',
            'foreignKey' => 'structure_value_domain'
        )
    );
    
    // when building SUMMARIES, function used to look up, translate, and return translated VALUE
    
    /**
     *
     * @param null $plugin
     * @param null $model
     * @param array $fieldAndValue
     * @return array|mixed|null
     */
    public function findPermissibleValue($plugin = null, $model = null, $fieldAndValue = array())
    {
        $return = null;
        
        if (count($fieldAndValue)) {
            
            $field = $fieldAndValue[1];
            $value = $fieldAndValue[0];
            
            if ($value) {
                
                $conditions = array();
                $conditions['StructureField.field'] = $field;
                if ($model)
                    $conditions['StructureField.model'] = $model;
                if ($plugin)
                    $conditions['StructureField.plugin'] = $plugin;
                
                $results = $this->find('first', array(
                    'conditions' => $conditions,
                    'limit' => 1,
                    'recursive' => 3
                ));
                
                $return = $results;
                
                if ($results && isset($results['StructureValueDomain'])) {
                    if (! empty($results['StructureValueDomain']['StructurePermissibleValue'])) {
                        foreach ($results['StructureValueDomain']['StructurePermissibleValue'] as $option) {
                            if ($option['value'] == $value)
                                $return = __($option['language_alias']);
                        }
                    } elseif (! empty($results['StructureValueDomain']['source'])) {
                        $pullDown = StructuresComponent::getPulldownFromSource($results['StructureValueDomain']['source']);
                        foreach ($pullDown as $option) {
                            if ($option['value'] == $value)
                                $return = $option['default'];
                        }
                    }
                }
            }
            
            if (! $return)
                $return = null;
        }
        
        return $return;
    }
    
    public function validatesFormBuilder($options = array(), &$errors = array()) 
    {
        if (empty($errors)){
            $errors = array("common" => array());
        }
        if (isset($options["prefix-common"])) {
            $dataCommon = isset($this->data[$options["prefix-common"]]) ? $this->data[$options["prefix-common"]] : array();
            $valid = true;
            $validationErrors = [];
            $index = 0;
            foreach ($dataCommon as $key => $value) {
                if (is_numeric($key)) {
                    $this->set($value);
                    $isValid = parent::validates($options);

                    $valid &= $isValid;

                    $errors["common"][$index] = (isset($errors["common"][$index]))?$errors["common"][$index]:array();
                    foreach ($this->validationErrors as $field => $errs) {
                        $errors["common"][$index][] = $field;
                    }
                    $this->validationErrors = array_merge($validationErrors, $this->validationErrors);
                    $validationErrors = $this->validationErrors;
                    $index++;
                }
            }
            unset($options["prefix-common"]);
        }
        return $valid;
    }
    
    public function setDataBeforeSaveFB(&$data, $options = array())
    {
        $valueDomainData = json_decode($data["valueDomainData"], true);
        if (isset($options["prefix-common"])) {
            $dataCommon = isset($data[$options["prefix-common"]]) ? $data[$options["prefix-common"]] : array();
            $index = 0;
            foreach ($dataCommon as $key => &$value) {
                if (is_numeric($key)) {
                    $value['FunctionManagement']['is_structure_value_domain'] = "";
                    if ($value['StructureField']['type']=='select'){
                        if (isset($valueDomainData[$index]['value']) && !empty($valueDomainData[$index]['value'])){
                            $value['StructureField']['structure_value_domain'] = $valueDomainData[$index]['id'];
                            $value['StructureField']['structure_value_domain_value'] = $valueDomainData[$index]['value'];
//                            $this->removeWritableField(array("is_structure_value_domain"));
                            $value['FunctionManagement']['is_structure_value_domain'] = "OK";
                        }
                    }else{
                        if (isset($valueDomainData[$index]['value']) && !empty($valueDomainData[$index]['value'])){
                            AppController::addWarningMsg(__("just for the list data type can have the value list"));
                        }
                        $value['StructureField']['structure_value_domain'] = null;
//                        $this->removeWritableField(array("is_structure_value_domain"));
                        $value['FunctionManagement']['is_structure_value_domain'] = "OK";
                    }
                }
                $index++;
            }
            unset ($data["valueDomainData"]);
            $data[$options["prefix-common"]] = $dataCommon;
        }
    }

}
