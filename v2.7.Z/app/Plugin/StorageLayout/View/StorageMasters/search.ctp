<?php
$settings = array(
    'return' => true
);

if (isset($isAjax) && ! $fromLayoutPage) {
    $settings['actions'] = false;
}

$structureLinks = array(
    'index' => array(
        'detail' => '/StorageLayout/StorageMasters/detail/%%StorageMaster.id%%'
    ),
    'bottom' => array(
        'add' => $addLinks,
        'tree view' => '/StorageLayout/StorageMasters/contentTreeView'
    )
);

if ($fromLayoutPage) {
    unset($structureLinks['bottom']);
    $structureLinks['bottom'] = array(
        'cancel' => 'javascript:searchBack();'
    );
    $settings['pagination'] = false;
}

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'index',
    'links' => $structureLinks,
    'settings' => $settings
);

if (isset($overflow)) {
    $this->Shell->validationHtml(); // clear validations
    $finalAtimStructure = $emptyStructure;
}

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$form = $this->Structures->build($finalAtimStructure, $finalOptions);

if (isset($overflow)) {
    $form = '<ul class="error">
				<li>' . __("the query returned too many results") . '. ' . __("try refining the search parameters") . '</li>
			</ul>' . $form;
}
if (isset($isAjax)) {
    $this->layout = 'json';
    $this->json = array(
        'page' => $form,
        'new_search_id' => AppController::getNewSearchId()
    );
} else {
    echo $form;
}