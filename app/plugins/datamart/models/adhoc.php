<?php

class Adhoc extends DataMartAppModel {
	
	var $name = 'Adhoc';
	var $useTable = 'datamart_adhoc';
	
   /*
    var $hasMany = array(
		'AdhocFavourite' =>
			array(
				'className'   => 'AdhocFavourite',
				 'foreignKey'  => 'adhoc_id',
				 'dependent'   => true
			),
		'AdhocSaved' =>
			array(
				'className'   => 'AdhocSaved',
				 'foreignKey'  => 'adhoc_id',
				 'dependent'   => true
			)
	);
	*/
				  
	var $validate = array();
	
}

?>