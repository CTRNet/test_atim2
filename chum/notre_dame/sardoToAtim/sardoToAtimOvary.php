<?php
require_once 'sardoToAtim.php';

SardoToAtim::$columns = array(
	'Nom'								=> 1,
	'Pr�nom'							=> 2,
	'No de dossier'						=> 3,
	'No banque de tissus'				=> 4,
	'No patient SARDO'					=> 5,
	'Date de naissance'					=> 6,
	'Age actuel'						=> 7,
	'Date du diagnostic'				=> 8,
	'Age au diagnostic'					=> 9,
	'No DX SARDO'						=> 10,
	'Topographie'						=> 11,
	'Lat�ralit�'						=> 12,
	'Morphologie'						=> 13,
	'M�nopause'							=> 14,
	'Ann�e m�nopause'					=> 15,
	'TNM G'								=> 16,
	'TNM pT'							=> 17,
	'TNM pN'							=> 18,
	'TNM pM'							=> 19,
	'TNM pathologique'					=> 20,
	'FIGO'								=> 21,
	'BIOP+ 1 Tx00'						=> 22,
	'BIOP+ 1 Tx00 - date'				=> 23,
	'CYTO+ 1 Tx00'						=> 24,
	'CYTO+ 1 Tx00 - date'				=> 25,
	'CHIR 1 Tx00'						=> 26,
	'CHIR 1 Tx00 - date'				=> 27,
	'CHIMIO 1 Tx00'						=> 28,
	'CHIMIO 1 Tx00 - d�but'				=> 29,
	'CHIMIO pr�CHIR Tx00'				=> 30,
	'CHIM pr�CHIR Tx00 - date'			=> 31,
	'Toute HORM Tx00'					=> 32,
	'CA-125 p�ri-DX - date'				=> 33,
	'CA-125 p�ri-DX'					=> 34,
	'CA-125 pr�CHIR Tx00 - dat'			=> 35,
	'CA-125 pr�CHIR Tx00'				=> 36,
	'Dernier CA-125 - date'				=> 37,
	'Dernier CA-125'					=> 38,
	'Ovaire droit - blocs'				=> 39,
	'Ovaire gauche - blocs'				=> 40,
	'Maladie r�siduelle'				=> 41,
	'Pr01 - date'						=> 42,
	'D�lai DX-Pr01 (M)'					=> 43,
	'D�lai DX-Pr01 (J)'					=> 44,
	'Pr01 - sites'						=> 45,
	'Date dernier contact'				=> 46,
	'Date du d�c�s'						=> 47,
	'Cause de d�c�s'					=> 48,
	'Censure (0 = vivant, 1 = mort)'	=> 49,
	'Survie (mois)' 					=> 50
);

SardoToAtim::$bank_identifier_ctrl_ids_column_name = 'No banque de tissus';
SardoToAtim::$hospital_identifier_ctrl_ids_column_name = 'No de dossier';

$xls_reader->read('/Users/francois-michellheureux/Documents/CTRNet/sardo/data/2011-11-15 Export ovaire complet.XLS');
$cells = $xls_reader->sheets[0]['cells'];

SardoToAtim::basicChecks($cells);
