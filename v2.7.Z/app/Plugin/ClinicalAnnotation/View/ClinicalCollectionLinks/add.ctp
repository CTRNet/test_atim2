<?php
// Collection-------------
$structureLinks = array(
    'top' => '/ClinicalAnnotation/ClinicalCollectionLinks/add/' . $atimMenuVariables['Participant.id'] . '/',
    'radiolist' => array(
        'Collection.id' => '%%Collection.id%%'
    ),
    'bottom' => array(
        'cancel' => '/ClinicalAnnotation/ClinicalCollectionLinks/listall/' . $atimMenuVariables['Participant.id'] . '/'
    )
);
$structureSettings = array(
    'form_bottom' => false,
    'form_inputs' => false,
    'actions' => false,
    'pagination' => false,
    'header' => __('collection to link', null)
);
$structureOverride = array();

$finalOptions = array(
    'settings' => $structureSettings,
    'links' => $structureLinks,
    'override' => $structureOverride,
    'extras' => array(
        'start' => '<input type="radio" id="collection_new" name="data[Collection][id]" value="" data-json="' . htmlentities('{"id" : "' . $collectionId . '"}') . '"/>' . __('new collection') . '<div id="collection_frame"></div>
			<div class="loading">' . __('loading') . '</div>',
        'end' => '<span class="button"><a id="collection_search" href="#">' . __('search') . '</a></span>'
    )
);

// CUSTOM CODE
$hookLink = $this->Structures->hook('collection_detail');
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($emptyStructure, $finalOptions);

require ('add_edit.php');
?>

<div id="popup" class="std_popup question"></div>

<script>
var ccl = true;
var treeView = true;
</script>