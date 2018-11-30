<?php
 /**
 *
 * ATiM - Advanced Tissue Management Application
 * Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 *
 * Licensed under GNU General Public License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @author        Canadian Tissue Repository Network <info@ctrnet.ca>
 * @copyright     Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 * @link          http://www.ctrnet.ca
 * @since         ATiM v 2
 * @license       http://www.gnu.org/licenses  GNU General Public License
 */
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