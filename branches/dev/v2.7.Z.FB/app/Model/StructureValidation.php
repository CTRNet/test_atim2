<?php

/**
 * Class StructureValidation
 */
class StructureValidation extends AppModel
{

    public $name = 'StructureValidation';
    
    public function validatesFormBuilder($data, $metaData, $options = array()) {
        
        parent::validates($options);
    }
}