<?php

// Sfs stands for Structure Format Simplified

/**
 * Class Sfs
 */
class Sfs extends AppModel
{

    public $useTable = 'view_structure_formats_simplified';

    public $name = 'Sfs';

    public $hasMany = array(
        // fetched manually in model/structure
        'StructureValidation' => array(
            'foreignKey' => 'structure_field_id'
        )
    );

    public $belongsTo = array(
        'StructureValueDomain' => array(
            'className' => 'StructureValueDomain',
            'foreignKey' => 'structure_value_domain'
        )
    );
}