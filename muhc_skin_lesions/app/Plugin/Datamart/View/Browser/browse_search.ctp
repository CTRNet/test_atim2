<?php
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