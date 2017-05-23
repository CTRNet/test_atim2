<?php

class ProtocolExtendControl extends ProtocolAppModel {

   var $master_form_alias = 'protocol_extend_masters';

   	function afterFind($results, $primary = false) {
   		return $this->applyMasterFormAlias($results, $primary);
   	}
}

?>