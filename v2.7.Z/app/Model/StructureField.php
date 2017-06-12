<?php

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
    public function findPermissibleValue($plugin = NULL, $model = NULL, $fieldAndValue = array())
    {
        $return = NULL;
        
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
                $return = NULL;
        }
        
        return $return;
    }
}