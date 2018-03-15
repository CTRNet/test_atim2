<?php
$structureLinks = array(
    'top' => '/rtbform/rtbforms/edit/' . $atimMenuVariables['Rtbform.id'],
    'bottom' => array(
        'cancel' => '/rtbform/rtbforms/profile/' . $atimMenuVariables['Rtbform.id']
    )
);

$this->Structures->build($atimStructure, array(
    'links' => $structureLinks
));