<?php

/**
 * Class StructureFormat
 */
class StructureFormat extends AppModel
{

    public $name = 'StructureFormat';

    public $belongsTo = array(
        'StructureField'
    );
}