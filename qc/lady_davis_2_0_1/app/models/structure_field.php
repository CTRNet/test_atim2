<?php

class StructureField extends AppModel {

	var $name = 'StructureField';

	var $hasMany = array(
		'StructureValidation'
	);
	
	/*
	var $hasOne = array(
		'StructureValueDomain'	=> array(
			'className'		=> 'StructureValueDomain',
			'foreignKey'	=>	false,
			'finderQuery'	=> '
				SELECT 
					StructureValueDomain.* 
				FROM 
					structure_fields AS StructureField, 
					structure_value_domains AS StructureValueDomain 
				WHERE 
					StructureField.id={$__cakeID__$} 
					AND StructureField.structure_value_domain=StructureValueDomain.domain_name
			'
		)
	);
	*/
	
	var $belongsTo = array(
		'StructureValueDomain'	=> array(
			'className'		=> 'StructureValueDomain',
			'foreignKey'	=>	'structure_value_domain'
		)
	);
	
	
	// when building SUMMARIES, function used to look up, translate, and return translated VALUE
	function findPermissibleValue( $plugin=NULL, $model=NULL, $field_and_value=array() ) {
		
		$return = NULL;
		
		if ( count($field_and_value) ) {
			
			$field	= $field_and_value[1];
			$value	= $field_and_value[0];
			
			if ( $value ) {
				
				$conditions = array();
				$conditions['StructureField.field']							= $field;
				if ( $model ) $conditions['StructureField.model']		= $model;
				if ( $plugin ) $conditions['StructureField.plugin']	= $plugin;
				
				$results = $this->find('first',array( 'conditions'=>$conditions, 'limit'=>1, 'recursive'=>3 ));
				
				$return = $results;
				
				if ( $results && isset($results['StructureValueDomain']) && isset($results['StructureValueDomain']['StructurePermissibleValue']) ) {
					foreach ( $results['StructureValueDomain']['StructurePermissibleValue'] as $option ) {
						if ( $option['value']==$value ) $return = __($option['language_alias'],true);
					}
				}
				
			}
			
			if ( !$return ) $return = NULL;
			
		}
		
		return $return;
	}
	
}

?>