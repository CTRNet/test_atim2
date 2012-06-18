<?php
$this->set('event_controls', $event_controls);
if($event_control_id){
	AppController::addInfoMsg(__('filter', true).': '.__($filter_data['EventControl']['disease_site'], true).' - '.__($filter_data['EventControl']['event_type'], true));
}