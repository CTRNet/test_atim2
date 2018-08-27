<?php
$structureLinks = array(
    'top' => '/ClinicalAnnotation/ClinicalCollectionLinks/edit/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['Collection.id'],
    'radiolist' => array(
        'Collection.id' => '%%Collection.id%%'
    )
);
$structureSettings = array(
    'form_bottom' => false,
    'form_inputs' => false,
    'actions' => false,
    'pagination' => false
);

// ************** 1- COLLECTION **************

$finalAtimStructure = $atimStructureCollectionDetail;
$finalOptions = array(
    'type' => 'index',
    'data' => array(
        $collectionData
    ),
    'settings' => $structureSettings,
    'links' => $structureLinks
);

// CUSTOM CODE
$hookLink = $this->Structures->hook('collection_detail');
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);

require ('add_edit.php');
?>
<script>
var treeView = true;
</script>