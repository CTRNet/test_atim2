<?php

// -------------------------------------------------------------------------------
// Generate block, slide and core aliquot label
// -------------------------------------------------------------------------------
$linkedCollectionIds = array();
$tmpCollectionIds = $this->AliquotMaster->find('all', array(
    'conditions' => array(
        'AliquotMaster.id' => explode(",", $parentAliquotsIds)
    ),
    'fields' => 'DISTINCT collection_id',
    'recursive' => - 1
));
foreach ($tmpCollectionIds as $aliquotsCollectionId)
    $linkedCollectionIds[] = $aliquotsCollectionId['AliquotMaster']['collection_id'];