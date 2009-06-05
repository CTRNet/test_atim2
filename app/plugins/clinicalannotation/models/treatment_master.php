<?php

class TreatmentMaster extends ClinicalAnnotationAppModel
{
	var $useTable = 'tx_masters';
    var $actAs = array('MasterDetail');
}

?>