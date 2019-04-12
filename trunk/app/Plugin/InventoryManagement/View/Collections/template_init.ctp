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
ob_start();

$structureBuildOptions = array(
    'type' => 'edit',
    'links' => array(
        'top' => '/InventoryManagement/Collections/templateInit/' . $collectionId . '/' . $templateId
    ),
    'settings' => empty($templateInitStructure['Sfs']) ? array() : array(
        'header' => __('default values')
    ),
    'extras' => $this->Form->input('template_init_id', array(
        'type' => 'hidden',
        'value' => $templateInitId,
        'id' => false
    ))
);

$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($templateInitStructure, $structureBuildOptions);

$display = ob_get_contents();
ob_end_clean();
$display = ob_get_contents() . $display;
$this->layout = 'json';
$this->json = array(
    'goToNext' => isset($goToNext),
    'page' => $display
);