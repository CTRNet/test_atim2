<?php
class MiscIdentifierCustom extends MiscIdentifier{
	var $name 		= "MiscIdentifier";
	var $useTable 	= "misc_identifiers";
	
	function allowMiscIdentifierDeletion(array $misc_identifier_data){
		$result = null;
		if($misc_identifier_data['MiscIdentifier']['misc_identifier_control_id'] == 9){
			$result = array(
				'allow_deletion'	=> false, 
				'msg' 				=> __('the collection identifier cannot be deleted', true)
			);
		}else{
			$result = array(
				'allow_deletion'	=> true, 
				'msg' 				=> ''
			);
		}
		return $result;
	}
}