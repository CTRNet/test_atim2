<?php 

$joins[] = array('table' => 'study_summaries', 'alias' => 'StudySummary', 'type' => 'LEFT', 'conditions' => array('Collection.chus_default_collection_study_summary_id = StudySummary.id'));
