<?php

class MissingTranslation extends AppModel
{

    public $name = 'MissingTranslation';

    public $validate = array(
        'id' => array(
            'rule' => 'isUnique',
            'message' => ''
        )
    );

    public $check_writable_fields = false;
}