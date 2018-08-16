<?php
if (! $collectionId && ! $copySource) {
    $this->atimFlashError(__('a created collection should be linked to a participant'), "javascript:history.back();", 5);
    return;
}