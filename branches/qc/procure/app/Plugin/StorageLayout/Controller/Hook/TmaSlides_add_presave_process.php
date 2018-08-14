<?php
foreach ($tmaSlidesToCreate as &$tmpSlide) {
    $tmpSlide['TmaSlide']['procure_created_by_bank'] = Configure::read('procure_bank_id');
}
$this->TmaSlide->addWritableField(array(
    'procure_created_by_bank'
));