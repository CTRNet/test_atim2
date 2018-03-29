<?php

$chemoRegimens = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
    'Chemotherapy : Regimen list'
));
$chemoRegimens = array_merge($chemoRegimens['defined'], $chemoRegimens['previously_defined']);
$chemoRegimens[''] = '';

$principalSurgeries = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
    'Surgery: Principal surgery'
));
$principalSurgeries = array_merge($principalSurgeries['defined'], $principalSurgeries['previously_defined']);
$principalSurgeries[''] = '';

$recurrenceLocalizations = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
    'Follow-up : Recurrence localization'
));
$recurrenceLocalizations = array_merge($recurrenceLocalizations['defined'], $recurrenceLocalizations['previously_defined']);
$recurrenceLocalizations[''] = '';
