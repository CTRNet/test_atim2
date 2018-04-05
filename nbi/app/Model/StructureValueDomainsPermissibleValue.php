<?php

/**
 * Class StructureValueDomainsPermissibleValue
 */
class StructureValueDomainsPermissibleValue extends AppModel
{

    public $name = 'StructureValueDomainsPermissibleValue';

    public $belongsTo = array(
        'StructurePermissibleValue' => array(
            'className' => 'StructurePermissibleValue',
            'foreignKey' => 'structure_permissible_value_id'
        )
    );
}