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
if (isset($nodeId) && $nodeId != 0) {
    echo Browser::getPrintableTree($nodeId, isset($mergedIds) ? $mergedIds : array(), $this->request->webroot);
}
// use add as type to avoid advanced search usage
$settings = array(
    'header' => $header
);
$links['bottom']['new'] = '/Datamart/Browser/browse/';
$links['top'] = $top;

$extras = array();
if (isset($nodeId)) {
    $extras['end'] = $this->Form->input('node.id', array(
        'type' => 'hidden',
        'value' => $nodeId
    ));
}
if (isset($advancedStructure) || isset($countersStructureFields)) {
    $settings['form_bottom'] = false;
    $settings['actions'] = false;
}

$this->Structures->build($atimStructure, array(
    'type' => 'search',
    'links' => $links,
    'data' => array(),
    'settings' => $settings,
    'extras' => isset($advancedStructure) ? '' : $extras
));

unset($settings['header']);

if (isset($advancedStructure)) {
    $settings['form_bottom'] = ! isset($countersStructureFields);
    $settings['actions'] = ! isset($countersStructureFields);
    $settings['language_heading'] = __('special parameters');
    
    $this->Structures->build($advancedStructure, array(
        'type' => 'search',
        'links' => $links,
        'data' => array(),
        'settings' => $settings,
        'extras' => $extras
    ));
}

if (isset($countersStructureFields)) {
    $settings['language_heading'] = __('counters');
    $settings['form_bottom'] = true;
    $settings['actions'] = true;
    $this->Structures->build($countersStructureFields, array(
        'type' => 'search',
        'links' => $links,
        'data' => array(),
        'settings' => $settings,
        'extras' => $extras
    ));
}