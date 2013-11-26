<?php
	
	$joins[] = array('table' => 'misc_identifiers', 'alias' => 'MiscIdentifier', 'type' => 'LEFT', 'conditions'=> array('Collection.uhn_misc_identifier_id = MiscIdentifier.id'));
