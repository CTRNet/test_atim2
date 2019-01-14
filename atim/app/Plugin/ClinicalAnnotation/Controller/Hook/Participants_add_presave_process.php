<?php
$endDate = $this->request->data['Participant']['date_of_death'];
echo $endDate;

$startDate = $this->request->data['Participant']['date_of_birth'];
echo $startDate;

$startYear = $startDate['year'];
echo $startYear;

$endYear = $endDate['year'];
echo $endYear;

$diffInYrs = ($endYear - $startYear);
echo $diffInYrs;

if ($diffInYrs > 0) {
    $this->request->data['Participant']['time_to_death'] = $diffInYrs;
}