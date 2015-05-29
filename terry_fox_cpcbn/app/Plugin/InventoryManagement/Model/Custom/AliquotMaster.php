<?php
class AliquotMasterCustom extends AliquotMaster {

	var $useTable = 'aliquot_masters';	
	var $name = 'AliquotMaster';
	
	function regenerateAliquotBarcode() {
		$query = "UPDATE aliquot_masters SET barcode = id WHERE barcode LIKE '' OR barcode IS NULL";
		$this->tryCatchQuery($query);
		$this->tryCatchQuery(str_replace('aliquot_masters', 'aliquot_masters_revs', $query));
		//The Barcode values of AliquotView will be updated by AppModel::releaseBatchViewsUpdateLock(); call in AliquotMaster.add() and AliquotMaster.realiquot() function
	}
	
	function afterFind($results, $primary = false){
		$results = parent::afterFind($results);
		//Generate the aliquot label
		if(isset($results[0]['AliquotMaster']['aliquot_label'])) {
			foreach($results as &$result) {
				$result['AliquotMaster']['aliquot_label'] = isset($result['ViewAliquot'])? $result['ViewAliquot']['aliquot_label'] : 'U';
			}		
		} else if(isset($results['AliquotMaster']['aliquot_label'])){
			pr('TODO afterFind ViewAliquot');
			pr($results);
			exit;
		}
		return $results;
	}
}

?>
