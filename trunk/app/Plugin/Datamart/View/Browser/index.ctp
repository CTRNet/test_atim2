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
    "index" => array(
        'detail' => "/Datamart/Browser/browse/%%BrowsingIndex.root_node_id%%",
        'edit' => "/Datamart/Browser/edit/%%BrowsingIndex.id%%",
        'save' => array(
            'link' => "/Datamart/Browser/save/%%BrowsingIndex.id%%",
            'icon' => 'disk'
        ),
        'delete' => "/Datamart/Browser/delete/%%BrowsingIndex.id%%"
    ),
    "bottom" => array(
        "new" => "/Datamart/Browser/browse/"
    )
);

$settings = array(
    'header' => array(
        'title' => __('temporary browsing'),
        'description' => __('unsaved browsing trees that are automatically deleted when there are more than %d', $tmpBrowsingLimit)
    ),
    'form_bottom' => false,
    'actions' => false,
    'pagination' => false
);

$this->Structures->build($atimStructure, array(
    'data' => $tmpBrowsing,
    'type' => 'index',
    'links' => $structureLinks,
    'settings' => $settings
));

$settings = array(
    'header' => array(
        'title' => __('saved browsing'),
        'description' => __('saved browsing trees')
    ),
    'form_top' => false
);
unset($structureLinks['index']['save']);
$this->Structures->build($atimStructure, array(
    'data' => $this->request->data,
    'type' => 'index',
    'links' => $structureLinks,
    'settings' => $settings
));