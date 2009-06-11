<?php

class TreatmentMaster extends ClinicalannotationAppModel {
	var $useTable = 'tx_masters';
    var $actAs = array('MasterDetail');
}

?>