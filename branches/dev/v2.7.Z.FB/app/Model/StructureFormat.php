<?php

/**
 * Class StructureFormat
 */
class StructureFormat extends AppModel
{

    public $name = 'StructureFormat';

    public $belongsTo = array(
        'StructureField'
    );
    
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

}