<?php

class ViewAliquotUseCustom extends ViewAliquotUse {
	var $base_model = "AliquotUse";
	var $useTable = 'view_aliquot_uses';
	
	function __construct(){
		parent::__construct();
		
		if(isset(self::$models_details["Realiquoting"])) self::$models_details["Realiquoting"][self::USE_CODE] = "CONCAT(AliquotMasterChildren.aliquot_label,' (',AliquotMasterChildren.barcode,')')";
	}
}

?>
