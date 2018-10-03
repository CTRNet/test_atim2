<?php

// --------------------------------------------------------------------------------
// Set default value
// --------------------------------------------------------------------------------
if (empty($this->request->data)) {
    $this->set('defaultLanguage', 'english');
    $this->set('defaultSex', 'f');
}