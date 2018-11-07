<?php
$settings = array(
    'return' => true
);
if (isset($isCclAjax)) {
    $structureLinks = array(
        'radiolist' => array(
            "Collection.id" => "%%ViewCollection.collection_id%%"
        )
    );
    $finalOptions = array(
        'type' => 'index',
        'data' => $this->request->data,
        'links' => $structureLinks,
        'settings' => array(
            'pagination' => false,
            'actions' => false,
            'return' => true
        )
    );
    if (isset($overflow)) {
        ?>
<ul class="error">
	<li><?php echo(__("the query returned too many results").". ".__("try refining the search parameters")); ?>.</li>
</ul>
<?php
    }
} else {
    if (isset($isAjax)) {
        $settings['actions'] = false;
    } else {
        $settings['header'] = array(
            'title' => __('search type', null) . ': ' . __('collections', null),
            'description' => __("more information about the types of samples and aliquots are available %s here", $helpUrl)
        );
    }
    include ('search_links_n_options.php');
}

$finalAtimStructure = $atimStructure;

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

$form = $this->Structures->build($finalAtimStructure, $finalOptions);
if (isset($isAjax) && ! isset($isCclAjax)) {
    $this->layout = 'json';
    $this->json = array(
        'page' => $form,
        'new_search_id' => AppController::getNewSearchId()
    );
} else {
    echo $form;
}