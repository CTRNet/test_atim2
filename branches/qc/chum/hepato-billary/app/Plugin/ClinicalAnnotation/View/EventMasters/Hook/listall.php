<?php
if (isset($summaryEventButton)) {
    foreach ($summaryEventButton as $newButton)
        $finalOptions['links']['bottom'][$newButton['title']] = array(
            'link' => $newButton['link'],
            'icon' => 'add'
        );
}

if ($atimMenuVariables['EventMaster.event_group'] == 'scores' && isset($controlsForSubformDisplay) && ! empty($controlsForSubformDisplay)) {
    $tmpControlsForSubformDisplay = array(
        'fong score' => null,
        'child pugh score (classic)' => null
    );
    foreach ($controlsForSubformDisplay as $newControl)
        $tmpControlsForSubformDisplay[$newControl['EventControl']['event_type']] = $newControl;
    $controlsForSubformDisplay = $tmpControlsForSubformDisplay;
}