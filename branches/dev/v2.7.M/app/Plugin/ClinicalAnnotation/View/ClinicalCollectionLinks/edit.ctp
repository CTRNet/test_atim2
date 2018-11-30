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