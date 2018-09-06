<?php
if (isset($defaultStructureOverride)) {
    foreach ($defaultStructureOverride as $keyDefaultValue => $defaultValue) {
        if (! array_key_exists($keyDefaultValue, $finalOptions['override'])) {
            $finalOptions['override'][$keyDefaultValue] = $defaultValue;
        }
    }
}