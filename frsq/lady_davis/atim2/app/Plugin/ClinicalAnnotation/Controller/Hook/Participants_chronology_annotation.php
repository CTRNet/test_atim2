<?php
if (isset($annotation['EventDetail']['response'])) {
    $chronolgyDataAnnotation['chronology_details'] = isset($imageResponseValues[$annotation['EventDetail']['response']]) ? $imageResponseValues[$annotation['EventDetail']['response']] : $annotation['EventDetail']['response'];
}