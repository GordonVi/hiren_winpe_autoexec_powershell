<?php

header("Content-Type: text/plain");

// print_r($_POST);

if ($_POST['serial']) {
	if ($_POST['list']) {

		$filename = $_POST['serial'].".txt";
		$data_to_write = $_POST['list'];

		file_put_contents($filename, $data_to_write);
		echo "File Written: ".$filename;

	}
}?>
